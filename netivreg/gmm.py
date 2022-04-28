# -*- coding: utf-8 -*-
"""
GMM Estimation of Peer Effects
"""

__author__ = """ Juan Estrada  juan.jose.estrada.sosa@emory.edu
                 Pablo Estrada pablo.estrada@emory.edu """

import numpy as np
from scipy import sparse as sp
import networkx as nx


class GMM():

    """
    GMM estimation of peer effects and exogenous social effects in a
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
    name_xins    : list of strings
                   Names of instrument variables for contextual effects
                   If empty, use all variables from name_xs in name_xins
    W            : sparse matrix
                   Adjacency matrix object
    W0           : sparse matrix
                   Predetermined adjacency matrix object
    wmatrix      : 'identity', 'instrument', 'optimal', or ndarray
                   Specify weight matrix, default 'instrument'
    maxp         : integer
                   max p-exponent of the set of instruments W0^p X, default 2
    cons         : float
                   constant to calculate rule of thumb of bandwidth, default 2
    eps          : float
                   epsilon variable to calculate rule of thumb of bandwidth
                   default 0.05
    kernel       : 'parzen', 'truncated', or 'th'
                   Kernel function, default Parzen. (th = for Tukey-Hanning)

    Attributes
    ----------
    params       : array
                   (k+1)x+1 array of G3SLS coefficients
    cov          : array
                   Variance covariance matrix
    """

    def __init__(self,
                 name_y, name_x, W, W0, dta,
                 name_xs=[], name_xins=[], wmatrix='optimal',
                 maxp=2, cons=1.8, eps=0.05, kernel='parzen'):

        # 0. Oganize matrices
        name_xs = name_x if len(name_xs) == 0 else name_xs
        name_xins = name_xs if len(name_xins) == 0 else name_xins
        n = dta.shape[0]
        one = np.ones((n, 1))
        y = dta[[name_y]].values
        X = dta[name_x].values
        Xs = dta[name_xs].values
        Xins = dta[name_xins].values
        Wy = W @ y
        WX = W @ Xs
        D = np.hstack((Wy, WX, X, one))
        Z = np.hstack((X, one))
        for p in range(maxp):
            W0pX = np.linalg.matrix_power(W0.toarray(), p+1) @ Xins
            Z = np.hstack((W0pX, Z))
        kz = Z.shape[1]
        kd = D.shape[1]

        # 1. GMM estimator
        try:
            if wmatrix == 'identity':
                P = np.identity(kz)   # dimension of Z
            elif wmatrix == 'instrument' or wmatrix == 'optimal':
                P = sinv(Z.T @ Z)
            elif type(wmatrix) == np.ndarray:
                P = sinv(wmatrix)
        except Exception:
            print('Invalid weight matrix')
        Q = D.T @ Z @ P @ Z.T @ D
        Q_inv = sinv(Q)
        b_gmm = Q_inv @ D.T @ Z @ P @ Z.T @ y

        # 2. Variance-covariance matrix

        # Calculate network statistics required to calculate bw
        G = nx.from_numpy_matrix(W.toarray())
        Gsub = G.subgraph(max(nx.connected_components(G), key=len))
        diameter = nx.diameter(Gsub)
        sp = dict(nx.shortest_path_length(G))
        av_degree = sum(dict(G.degree()).values())/n
        bw = cons * (1/np.log(max(av_degree, (1+eps)))) * np.log(n)

        # Select kernel
        try:
            if kernel == 'parzen':
                kernel = parzen
            elif kernel == 'truncated':
                kernel = truncated
            elif kernel == 'th':
                kernel = th
        except Exception:
            print('Invalid kernel')

        # Calculate Omega
        Omega = np.zeros_like(np.outer(Z[0], Z[0]))
        for dist in range(diameter+1):
            Omega += kernel(dist/bw)*omegad(b_gmm, y, D, Z, sp, dist)

        # Calculate GMM variance covariance matrix
        Qh = Z.T @ D / n
        Qh_inv = sinv(Qh.T @ P @ Qh)
        scale = 1 / n
        V_gmm = scale * Qh_inv @ Qh.T @ P @ Omega @ P @ Qh @ Qh_inv

        if wmatrix == 'optimal':
            # Construct optimal weighting matrix
            P = sinv(Omega)
            Q = D.T @ Z @ P @ Z.T @ D
            Q_inv = sinv(Q)
            b_gmm = Q_inv @ D.T @ Z @ P @ Z.T @ y

            # Calculate optimal Omega
            Omega_op = np.zeros_like(np.outer(Z[0], Z[0]))
            for dist in range(diameter+1):
                Omega_op += kernel(dist/bw)*omegad(b_gmm, y, D, Z, sp, dist)

            # Calculate optimal GMM variance covariance matrix
            V_gmm = scale * sinv(Qh.T @ sinv(Omega_op) @ Qh)

        # 4. Diagnostics and Statistics
        dof = n - kd
        R = np.identity(kd-1)
        b_wald = b_gmm[:-1]
        V_wald = V_gmm[:-1, :-1]
        wald = ((R @ b_wald).T
                @ sinv(R @ V_wald @ R.T)
                @ (R @ b_wald))
        # tss = sum((y - y.mean())**2)
        v = y - D@b_gmm
        ess = sum((D@b_gmm - y.mean())**2)
        rss = sum(v**2)
        rmse = np.sqrt(rss/n)
        # r2 = 1 - (rss/tss)
        r2 = np.corrcoef(D@b_gmm, y, rowvar=False)[0, 1] ** 2
        r2_a = 1 - (1-r2)*(n-1)/(n-kd+1)
        # Name of variables
        var = [name_y] + name_x
        var_s = [name_y] + name_xs
        # Include names of GMM regression
        Wy_var = ["W_y: " + var_s[0]]
        Wx_var = ["W_x: " + va for va in var_s[1:]]
        Wvar = Wy_var + Wx_var
        Xvar = ["X: " + va for va in var[1:]]
        varlist2 = Wvar + Xvar + ["X: _cons"]

        self.params = b_gmm
        self.cov = V_gmm
        self.varlist = varlist2
        self.N = n
        self.df_r = dof
        self.df_m = kd
        self.rank = V_gmm.shape[0]
        self.wald = wald
        self.rss = rss
        self.mss = ess
        self.rmse = rmse
        self.r2 = r2
        self.r2_a = r2_a
        self.D = D
        self.Z = Z
        self.y = y
        self.resid_sum = sum(v) / n
        self.diameter = diameter
        self.bw = bw
        self.av_degree = av_degree


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


def omegad(coef, y, D, Z, short_path, dist):
    """
    Find Omega (covariance matrix) as a function of the distances

    Parameters
    ----------
    coef         : numpy array
                   parameters of one step GMM
    y            : numpy array
                   vector of outcomes
    D            : numpy array
                   matrix [Wy, WX, X, one]
    Z            : numpy array
                   matrix [W0^p X, WX, X, one]
    short_path   : iterator
                   iterator over (source, dictionary)
    dist         : integer
                   distance of neighbor j from node i

    Returns
    ----------
    omegadv       : array
    """
    n = y.shape[0]
    y_hat = D @ coef
    res = y - y_hat
    omegad = np.zeros_like(np.outer(Z[0], Z[0]))
    for i in range(n):
        # Find neighbors of node i at dist (shortest path)
        neighbors = [k for k, v in short_path[i].items() if v == dist]
        for j in neighbors:
            omegad += np.outer(Z[i]*res[i], Z[j]*res[j])
    omegadv = omegad/n
    return omegadv


def parzen(x):
    """Parzen Kernel"""
    if 0 <= abs(x) <= 1/2:
        w = 1-6*(x**2) + 6*(abs(x))**3
    elif 1/2 < abs(x) <= 1:
        w = 2*((1 - abs(x))**3)
    else:
        w = 0
    return w


def truncated(x):
    """Truncated Kernel"""
    return 1 if abs(x) <= 1 else 0


def th(x):
    """Tukey-Hanning Kernel"""
    return (1+np.cos(np.pi*x))/2 if abs(x) <= 1 else 0
