capture program drop netivreg

*! netivreg v0.0.1 Pablo Estrada 18nov2019

program define netivreg, eclass
    version 16.0
    // First get the list of variables.
    local n 0
    local estimator : word 1 of `0'
  	local 0 : subinstr local 0 "`estimator'" ""
  	CheckEstimator `estimator'
  	local estimator `=s(estimator)'
    // obtains the first token from `0' and saves the rest back in `0'
    // because `0' is the macro containing what the user typed.
    gettoken lhs 0 : 0, parse(" ,[") match(paren)
    // IsStop checks that the variables are correct
    IsStop `lhs'
    if `s(stop)' {
        error 198
    }
    while `s(stop)'==0 {
        if "`paren'"=="(" {
            local n = `n' + 1
            if `n' > 1 {
                capture noi error 198
                di as error `"syntax is "(W = W0)""'
                exit 198
            }
            gettoken p lhs : lhs, parse(" =")
            while "`p'"!="=" {
                if "`p'"=="" {
                    capture noi error 198
                    di as error `"syntax is "(W = W0)""'
                    di as error `"the equal sign "=" is required"'
                    exit 198
                }
                local adjmat "`p'"   // Take adjmat
                gettoken p lhs : lhs, parse("=")
            }
            gettoken lhs: lhs, parse()   // Take out additional blank spaces
            local adjmat0 "`lhs'"   // Take adjmat0
        }
        else {
            local exog `exog' `lhs'
        }
        gettoken lhs 0 : 0, parse(" ,[") match(paren)
        IsStop `lhs'
    }
    local 0 `"`lhs' `0'"'

    tsunab exog : `exog'
    tokenize `exog'
    local lhs "`1'"
    local 1 " "
    local exog `*'


    // `lhs' contains depvar,
    // `exog' contains RHS exogenous variables,
    // `end1' contains RHS endogenous variables, and
    // `inst' contains the additional instruments

    // Now parse the remaining syntax
    local depvar `lhs'
    local exovar `exog'
    syntax [anything(name=0)] [if] [in], [WX(string) WZ(string) ID(string) ///
                                          TRansformed CLuster(string) ///
                                          FIRST SECOND ///
                                          WMATrix(string) KERNEL(string) ///
                                          MAXP(integer 2) CONS(real 1.8)]
    tempvar touse
    tempname b V Pi VarPi b2sls Var2sls

    mark `touse' `if' `in'
    qui count if `touse'


    python: calc_netivreg("`estimator'", ///
                          "`depvar'", "`exovar'", "`adjmat'", "`adjmat0'", ///
                          "`wx'", "`wz'", "`id'", ///
                          "`transformed'", "`cluster'", ///
                          "`wmatrix'", "`kernel'", `maxp', `cons')

    matrix `b' = r(b)'
    matrix `V' = r(V)
    if "`estimator'"=="g3sls" {
        matrix `Pi' = r(Pi)'
        matrix FPi = `Pi'   // to access in post estimation
        matrix `VarPi' = r(VarPi)
        matrix `b2sls' = r(b2sls)'
        matrix Fb2sls = `b2sls'   // to access in post estimation
        matrix `Var2sls' = r(Var2sls)
        }
    local N = N
    local df_m = df_m
    local df_r = df_r
    local rank = rank
    local chi2 = chi2
    local rss = rss
    local mss = mss
    local r2 = r2
    local r2_a = r2_a
    local rmse = rmse
    if "`estimator'"=="g3sls" {
        local chi2_2s = chi2_2s
        local rss_2s = rss_2s
        local r2_2s = r2_2s
        local r2_a_2s = r2_a_2s
        local rmse_2s = rmse_2s
        }
    if "`cluster'"!="" {
        local N_clust = N_clust
        local clustvar `cluster'
        }
    if "`first'"!="" {
        di
        di "Projection of W on W0"
        ereturn post `Pi' `VarPi', dof(`df_r')
        ereturn display
        di
        }
    if "`second'"!="" {
        di
        ereturn post `b2sls' `Var2sls', depname(`depvar') dof(`df_r')
        ereturn scalar N            = `N'
        ereturn scalar df_m         = `df_m'
        ereturn scalar df_r         = `df_r'
        ereturn scalar chi2         = `chi2_2s'
        ereturn scalar rss          = `rss_2s'
        ereturn scalar r2           = `r2_2s'
        ereturn scalar r2_a         = `r2_a_2s'
        ereturn scalar rmse         = `rmse_2s'
        if "`transformed'"!="" {
            ereturn local trvar       `transformed'
            }
        Disp_2s `"`noheader'"' `"`plus'"' `"`level'"' `"`nofooter'"' `"`ivreg2name'"' "`dispopt'"
        di
        }

    ereturn post `b' `V', depname(`depvar') dof(`df_r')
    ereturn scalar N            = `N'
    ereturn scalar df_m         = `df_m'
    ereturn scalar df_r         = `df_r'
    ereturn scalar rank         = `rank'
    ereturn scalar chi2         = `chi2'
    ereturn scalar rss          = `rss'
    ereturn scalar mss          = `mss'
    ereturn scalar r2           = `r2'
    ereturn scalar r2_a         = `r2_a'
    ereturn scalar rmse         = `rmse'
    ereturn local depvar          `lhs'
    ereturn local exogr           `exog'
    ereturn local estimator       `estimator'
    if "`transformed'"!="" {
        ereturn local trvar       `transformed'
        }
    if "`cluster'"!="" {
        ereturn scalar N_clust  = `N_clust'
        ereturn local clustvar    "`cluster'"
        }
    if "`wx'"!="" {
        ereturn local wx          "`wx'"
        }
    ereturn local  cmd            "netivreg"
    if "`estimator'"=="g3sls" {
        ereturn matrix first = FPi
        ereturn matrix second = Fb2sls
        }



    DispMain `"`noheader'"' `"`plus'"' `"`level'"' `"`nofooter'"' `"`ivreg2name'"' "`dispopt'"



end


version 16.0
python:

import numpy as np
import pandas as pd
import networkx as nx
from sklearn.preprocessing import normalize
from sfi import Data, Frame, Matrix, Scalar, Macro
import netivreg


def calc_netivreg(estimator, depvar, exovar, adjmat, adjmat0, wx, wz, id,
                  transformed, cluster,
                  wmatrix, kernel, maxp, cons):

    id = "id" if id == "" else id
    # Use the sfi Frame class to access data
    list_cols = set([id, depvar] + exovar.split(" "))
    if cluster != "": list_cols.add(cluster)
    if wx != "": list_cols = list_cols.union(wx.split(" "))
    if wz != "": list_cols = list_cols.union(wz.split(" "))
    nodes_list = Frame.connect("default").get(" ".join(list_cols))
    df_nodes = pd.DataFrame(nodes_list, columns=list_cols)

    # Use the sfi Frame class to access data
    edges_list = Frame.connect(adjmat).get()
    df_edges = pd.DataFrame(edges_list)
    edges_list0 = Frame.connect(adjmat0).get()
    df_edges0 = pd.DataFrame(edges_list0)

    # Create w
    G = nx.from_pandas_edgelist(df_edges, 0, 1, create_using=nx.DiGraph())
    W = nx.adjacency_matrix(G, nodelist=df_nodes[id].unique())
    W = normalize(W, norm='l1', axis=1)

    # Create w0
    G0 = nx.from_pandas_edgelist(df_edges0, 0, 1, create_using=nx.DiGraph())
    W0 = nx.adjacency_matrix(G0, nodelist=df_nodes[id].unique())
    W0 = normalize(W0, norm='l1', axis=1)

    if len(set(G.nodes()).difference(df_nodes[id])) > 0:
        print("Warning:", len(set(G.nodes()).difference(df_nodes[id])),
              "nodes from W matrix not in S matrix.")
    if len(set(G0.nodes()).difference(df_nodes[id])) > 0:
        print("Warning:", len(set(G0.nodes()).difference(df_nodes[id])),
              "nodes from W0 matrix not in S matrix.")

    wexovar = [] if wx == "" else wx.split(" ")
    winsvar = [] if wz == "" else wz.split(" ")
    tr_val = False if transformed == "" else True
    cluster_val = None if cluster == "" else cluster
    wmat_val = 'optimal' if wmatrix == "" else wmatrix
    kernel_val = 'parzen' if kernel == "" else kernel

    if estimator == "g3sls":
        results = netivreg.G3SLS(name_y=depvar,
                                 name_x=exovar.split(" "),
                                 name_xs=wexovar,
                                 W=W,
                                 W0=W0,
                                 dta=df_nodes,
                                 tr=tr_val, cluster=cluster_val)
    elif estimator == "gmm":
         results = netivreg.GMM(name_y=depvar,
                                name_x=exovar.split(" "),
                                name_xs=wexovar,
                                name_xins=winsvar,
                                W=W,
                                W0=W0,
                                dta=df_nodes,
                                wmatrix=wmat_val, kernel=kernel_val,
                                maxp=maxp, cons=cons)

    # MAIN
    Matrix.store("r(b)", results.params)
    Matrix.setRowNames("r(b)", results.varlist)
    vcov = results.cov
    vcov = np.tril(vcov) + np.triu(vcov.T, 1)
    Matrix.store("r(V)", vcov)
    Matrix.setRowNames("r(V)", results.varlist)
    Matrix.setColNames("r(V)", results.varlist)

    Scalar.setValue("N", results.N)
    Scalar.setValue("df_r", results.df_r)
    Scalar.setValue("df_m", results.df_m)
    Scalar.setValue("rank", results.rank)
    Scalar.setValue("chi2", results.wald)
    Scalar.setValue("rss", results.rss)
    Scalar.setValue("mss", results.mss)
    Scalar.setValue("rmse", results.rmse)
    Scalar.setValue("r2", results.r2)
    Scalar.setValue("r2_a", results.r2_a)

    if estimator == "g3sls":
        # FIRST
        Matrix.store("r(Pi)", results.params_1s)
        Matrix.setRowNames("r(Pi)", results.varlist_1s)
        vcov = results.cov_1s
        vcov = np.tril(vcov) + np.triu(vcov.T, 1)
        Matrix.store("r(VarPi)", vcov)
        Matrix.setRowNames("r(VarPi)", results.varlist_1s)
        Matrix.setColNames("r(VarPi)", results.varlist_1s)

        # SECOND
        Matrix.store("r(b2sls)", results.params_2s)
        Matrix.setRowNames("r(b2sls)", results.varlist)
        vcov = results.cov_2s
        vcov = np.tril(vcov) + np.triu(vcov.T, 1)
        Matrix.store("r(Var2sls)", vcov)
        Matrix.setRowNames("r(Var2sls)", results.varlist)
        Matrix.setColNames("r(Var2sls)", results.varlist)

        if cluster_val is not None:
            Scalar.setValue("N_clust", results.N_clust)
        Scalar.setValue("chi2_2s", results.wald_2s)
        Scalar.setValue("rss_2s", results.rss_2s)
        Scalar.setValue("rmse_2s", results.rmse_2s)
        Scalar.setValue("r2_2s", results.r2_2s)
        Scalar.setValue("r2_a_2s", results.r2_a_2s)

    Macro.setLocal('lm', 'This is a local macro')


end


*******************************************************************************
*******************************************************************************
* SUBROUTINES
*******************************************************************************
*******************************************************************************



// ************* Display main estimation output ************** //
// Borrowed from ivreg2.ado
program define DispMain, eclass
    args noheader transformed plus level nofooter helpfile dispopt
    version 11.2
di
* Line 1
    if "`e(estimator)'"=="g3sls" {
di "Network IV (G3SLS) Regression" _continue
        }
else if "`e(estimator)'"=="gmm" {
di "Network IV (GMM) Regression" _continue
    }
di in gr _col(55) "Number of obs = " in ye %8.0f e(N)
* Line 2
    if "`e(clustvar)'"!="" {
        local N_clust `e(N_clust)'
        local clustvar `e(clustvar)'
di in gr "Number of clusters (`clustvar') = " in ye %6.0f `N_clust' _continue
    }
di in gr _col(55) "Wald chi2(" in ye %1.0f e(df_m) in gr ")  = " in ye %8.2f e(chi2)
* Line 3
    if "`e(trvar)'"!="" {
di in gr "Transformed Model" _continue
        }
di in gr _col(55) "Prob > chi2   = " in ye %8.4f chi2tail(e(df_m),e(chi2))
* Line 4
di in gr _col(55) "R-squared     = " in ye %8.4f e(r2)
* Line 5
di in gr _col(55) "Root MSE      = " in ye %8.4g e(rmse)

* Display coefficients etc.
* Unfortunate but necessary hack here: to suppress message about cluster
*   adjustment of standard error, clear e(clustvar) and then reset it after display
    * local cluster `cluster'
    * ereturn local clustvar
    ereturn display, `plus' level(`level') `dispopt'

end


program define Disp_2s, eclass
    args noheader transformed plus level nofooter helpfile dispopt
    version 11.2
di
* Line 1
di "2SLS Regression" _continue
di in gr _col(55) "Number of obs = " in ye %8.0f e(N)
* Line 2
    if "`e(clustvar)'"!="" {
        local N_clust `e(N_clust)'
        local clustvar `e(clustvar)'
di in gr "Number of clusters (`clustvar') = " in ye %6.0f `N_clust' _continue
    }
di in gr _col(55) "Wald chi2(" in ye %1.0f e(df_m) in gr ")  = " in ye %8.2f e(chi2)
* Line 3
    if "`e(trvar)'"!="" {
di in gr "Transformed Model" _continue
        }
di in gr _col(55) "Prob > chi2   = " in ye %8.4f chi2tail(e(df_m),e(chi2))
* Line 4
di in gr _col(55) "R-squared     = " in ye %8.4f e(r2)
* Line 5
di in gr _col(55) "Root MSE      = " in ye %8.4g e(rmse)
* Display coefficients
    ereturn display, `plus' level(`level') `dispopt'

end



// Borrowed from ivreg.ado
program define IsStop, sclass
    if `"`0'"' == "[" {
        sret local stop 1
        exit
    }
    if `"`0'"' == "," {
        sret local stop 1
        exit
    }
    if `"`0'"' == "if" {
        sret local stop 1
        exit
    }
    if `"`0'"' == "in" {
        sret local stop 1
        exit
    }
    if `"`0'"' == "" {
        sret local stop 1
        exit
    }
    else {
        sret local stop 0
    }
end



// Borrowed from ivregress.ado
program CheckEstimator, sclass
	args input
	if "`input'" == "g3sls" {
		sreturn local estimator "g3sls"
		exit
	}
	if "`input'" == "gmm" {
		sreturn local estimator "gmm"
		exit
	}
	di as error "`input' not a valid estimator"
	exit 198
end
