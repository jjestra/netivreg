# -*- coding: utf-8 -*-
"""
G3SLS Estimation of Peer Effects
"""

__author__ = """ Juan Estrada  juan.jose.estrada.sosa@emory.edu
                 Pablo Estrada pablo.estrada@emory.edu """

import numpy as np
from scipy import sparse as sp
from scipy.linalg import block_diag
import pandas as pd

__all__ = ["G3SLS"]


class G3SLS():

    """
    G3SLS estimation of peer effects and exogenous social effects in a
    linear-in-means model that allows for endogenous network formation.
    It requires the existence of a predetermined adjacency matrix (W0),
    which has to be conditionally independent of the error term in the
    structural equation.
    >>> y ~ Wy + WX + X + 1 + e

    Parameters
    ----------
    dta          : pandas.core.frame.DataFrame
    name_y       : string
                   Name of the outcome variable
    name_x       : list of strings
                   Names of independent variables
    name_xs      : list of strings
                   Names of contextual effects variables
                   If empty, use all variables from name_x in name_xs
    W            : sparse matrix
                   Adjacency matrix object
    W0           : sparse matrix
                   Predetermined adjacency matrix object
    dim          : string
                   Name of dimension for which the sample is repeated
    tr           : boolean
                   if True, estimate transformed model (I-W0)
                   if False, don't use tranformation
    cluster      : string
                   if name_string, use cluster standard errors
                   if None, dom't use cluster standard errors

    Attributes
    ----------
    params       : array
                   (k+1)x+1 array of G3SLS coefficients
    cov          : array
                   Variance covariance matrix
    """

    def __init__(self,
                 name_y, name_x, W, W0, dta,
                 dim=None, cluster=None, name_xs=[], tr=False):

        # 0. Organize matrices
        n_cluster = None if cluster is None else dta[cluster].nunique()
        g_cluster = None if cluster is None else dta[cluster].factorize()[0]
        name_xs = name_x if len(name_xs) == 0 else name_xs
        m = 1 if dim is None else dta[dim].nunique()
        N = dta.shape[0]
        n = N // m
        I = sp.identity(N)
        one = np.ones((N, 1))
        y = dta[[name_y]].values
        X = dta[name_x].values
        Xs = dta[name_xs].values
        W = sp.kron(sp.identity(m), W) if m > 1 else W
        W0 = sp.kron(sp.identity(m), W0) if m > 1 else W0
        Wy = (I-W0) @ W @ y if tr else W @ y
        WX = (I-W0) @ W @ Xs if tr else W @ Xs
        W0y = (I-W0) @ W0 @ y if tr else W0 @ y
        W0X = (I-W0) @ W0 @ Xs if tr else W0 @ Xs
        W02X = (I-W0) @ W0 @ W0 @ Xs if tr else W0 @ W0 @ Xs
        ks = Xs.shape[1]

        # 1. Projection of WS on W0S
        WS = np.hstack((Wy, WX))
        W0S = np.hstack((W0y, W0X))
        Q1 = W0S.T @ W0S
        Q1_inv = sinv(Q1)
        Pi = Q1_inv @ W0S.T @ WS

        # Variance-covariance matrix
        U = WS - W0S@Pi
        omega1 = (U.T @ U) / (N-ks-1)
        VPi = np.kron(omega1, Q1_inv)

        # 2. 2SLS Estimator
        X = X if tr else np.hstack((X, one))
        D = np.hstack((Wy, WX, X))
        D0 = np.hstack((W0y, W0X, X))
        Z = np.hstack((W02X, W0X, X))
        k = X.shape[1]
        K = D.shape[1]

        Qz_inv = sinv(Z.T @ Z)
        Q2 = D0.T @ Z @ Qz_inv @ Z.T @ D0
        Q2_inv = sinv(Q2)
        b_st = Q2_inv @ D0.T @ Z @ Qz_inv @ Z.T @ y
        theta_2sls = sinv(Pi) @ b_st[:ks+1]
        b_2sls = np.vstack((theta_2sls, b_st[ks+1:]))

        # Variance-covariance matrix
        v_st = y - D@b_2sls
        e_st = (np.identity(N) - W0S@Q1_inv@W0S.T) @ U @ b_2sls[:ks+1] + v_st
        if cluster is None:
            omega2 = Z.T @ np.diag(e_st.reshape(-1)**2) @ Z
            Qomega2 = D0.T @ Z @ Qz_inv @ omega2 @ Qz_inv @ Z.T @ D0
            scale = N / (N - K)
            V_2sls = scale * Q2_inv @ Qomega2 @ Q2_inv
        else:
            Ze = Z * e_st
            Ze_sum = pd.DataFrame(Ze).set_index(g_cluster).sum(level=0)
            Ze_sum = np.array(Ze_sum)
            omega2 = Ze_sum.T @ Ze_sum
            Qomega2 = D0.T @ Z @ Qz_inv @ omega2 @ Qz_inv @ Z.T @ D0
            scale = n / (n - 1) * (N - 1) / (N - K)
            V_2sls = scale * Q2_inv @ Qomega2 @ Q2_inv.T

        # Calculate optimal instrument E[W0y|X,W0]
        Pimat = block_diag(Pi, np.identity(k))
        A = W0 @ sinv(I - (np.dot(Pi[0], theta_2sls)[0] * W0))
        B = np.hstack((W0X, X)) @ Pimat[1:, ] @ b_2sls
        Ey = A @ B
        Zt = np.hstack((Ey, W0X, X)) @ Pimat
        Dt = D0 @ Pimat

        # 3. Generalized 2SLS estimator
        Q3 = Zt.T @ Dt
        Q3_inv = sinv(Q3)
        b_g2sls = Q3_inv @ Zt.T @ y

        # Variance-covariance matrix
        v = y - D@b_g2sls
        e = (np.identity(N) - W0S@Q1_inv@W0S.T) @ U @ b_g2sls[:ks+1] + v
        if cluster is None:
            omega3 = np.diag(e.reshape(-1)**2)
            scale = N / (N - Zt.shape[1])
            V_g2sls = scale * Q3_inv @ (Zt.T @ omega3 @ Zt) @ Q3_inv.T
        else:
            Ze = Zt * e
            Ze_sum = pd.DataFrame(Ze).set_index(g_cluster).sum(level=0)
            Ze_sum = np.array(Ze_sum)
            omega3 = Ze_sum.T @ Ze_sum
            scale = n / (n - 1) * (N - 1) / (N - Zt.shape[1])
            V_g2sls = scale * Q3_inv @ omega3 @ Q3_inv.T

        # 4. Diagnostics and Statistics
        dof = N - K
        R = np.identity(K) if tr else np.identity(K-1)
        b_wald = b_g2sls if tr else b_g2sls[:-1]
        V_wald = V_g2sls if tr else V_g2sls[:-1, :-1]
        wald = ((R @ b_wald).T
                @ sinv(R @ V_wald @ R.T)
                @ (R @ b_wald))
        # tss = sum((y - y.mean())**2)
        ess = sum((D@b_g2sls - y.mean())**2)
        rss = sum(v**2)
        rmse = np.sqrt(rss/N)
        # r2 = 1 - (rss/tss)
        r2 = np.corrcoef(D@b_g2sls, y, rowvar=False)[0, 1] ** 2
        r2_a = 1 - (1-r2)*(N-1)/(N-K+1)

        b_wald_2s = b_2sls if tr else b_2sls[:-1]
        V_wald_2s = V_2sls if tr else V_2sls[:-1, :-1]
        wald_2s = ((R @ b_wald_2s).T
                   @ sinv(R @ V_wald_2s @ R.T)
                   @ (R @ b_wald_2s))
        # ess_2s = sum((D@b_2sls - y.mean())**2)
        rss_2s = sum(v_st**2)
        rmse_2s = np.sqrt(rss_2s/N)
        r2_2s = np.corrcoef(D@b_2sls, y, rowvar=False)[0, 1] ** 2
        r2_a_2s = 1 - (1-r2_2s)*(N-1)/(N-K+1)

        # Name of variables
        var = [name_y] + name_x
        var_s = [name_y] + name_xs
        # Include names of 2SLS regression
        Wy_var = ["W_y: " + var_s[0]]
        Wx_var = ["W_x: " + va for va in var_s[1:]]
        Wvar = Wy_var + Wx_var
        Xvar = ["X: " + va for va in var[1:]]
        varlist2 = Wvar + Xvar if tr else Wvar + Xvar + ["X: _cons"]
        # Include names of projection matrix
        varlist1 = []
        for va1 in var_s:
            for va2 in var_s:
                varlist1.append('W_' + str(va1) + ': W0_' + str(va2))

        self.params_1s = Pi.reshape(len(varlist1), 1)
        self.cov_1s = VPi
        self.varlist_1s = varlist1
        self.params_2s = b_2sls
        self.cov_2s = V_2sls
        self.params = b_g2sls
        self.cov = V_g2sls
        self.sd = np.sqrt(np.diag(V_g2sls))
        self.varlist = varlist2
        self.N = N
        self.df_r = dof
        self.df_m = K
        self.rank = V_g2sls.shape[0]
        self.wald = wald
        self.rss = rss
        self.mss = ess
        self.rmse = rmse
        self.r2 = r2
        self.r2_a = r2_a
        self.wald_2s = wald_2s
        self.rss_2s = rss_2s
        self.rmse_2s = rmse_2s
        self.r2_2s = r2_2s
        self.r2_a_2s = r2_a_2s
        self.WS = WS
        self.W0S = W0S
        self.D = D
        self.D0 = D0
        self.Z = Z
        self.Zt = Zt
        self.y = y
        self.resid_sum = sum(v) / N
        self.N_clust = n_cluster


def sinv(A):
    """
    Find inverse of matrix A using numpy.linalg.solve
    Helpful for large matrices
    """
    if sp.issparse(A):
        n = A.shape[0]
        Ai = sp.linalg.spsolve(A.tocsc(), sp.eye(n, format='csc'))
    else:
        try:
            n = A.shape[0]
            Ai = np.linalg.solve(A, np.identity(n))
        except np.linalg.LinAlgError as err:
            if 'Singular matrix' in str(err):
                Ai = np.linalg.pinv(A)
            else:
                raise
    return Ai
