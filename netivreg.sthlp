{smcl}
{* *! v1.0.0 Pablo Estrada 17jan2022}{...}
{cmd:help netivreg}
{hline}


{marker title}{...}
{title:Title}

{p2colset 5 17 19 2}{...}
{p2col :{hi:netivreg} {hline 2}}Network Instrumental-Variables Regression{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:netivreg} {it:estimator} {depvar}
{it:{help varlist:varlist1}} {cmd:(}{it:W} {cmd:=} {it:W0}{cmd:)}
[{cmd:,} {it:options}]

{synoptset 22}{...}
{synopthdr:estimator}
{synoptline}
{synopt:{opt gmm}}generalized method of moments (GMM){p_end}
{synopt:{opt g3sls}}generalized three-stage least squares (G3SLS){p_end}
{synoptline}

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opt wx(varlist2)}}list of variables to be included as contextual effects
    {it: WX}. By default, it includes all the variables from
    {it:{help varlist:varlist1}}{p_end}
{synopt :{opt id(varname)}}variable to match covariates with network data.
    Default {it:varname} is id.{p_end}

{syntab :GMM}
{synopt :{opt wz(varlist3)}}list of variables used as instruments for
    {it: varlist2}{p_end}
{synopt :{opt maxp(#)}}max p-exponent of the exogenous matrix {it:W0^(p)} to
    include in the set of instruments, default 2{p_end}
{synopt :{opt wmat:rix(wmtype)}}{it:wmtype} may be {opt identity},
    {opt instrument}, or by default {opt optimal}{p_end}
{synopt :{opt kernel(type)}}kernel function to calculate network HAC variance
    estimator. May be {opt th} for Tukey-Hanning, {opt truncated}, or by
    default {opt parzen}{p_end}
{synopt :{opt cons(#)}}constant to calculate rule of thumb of bandwidth, or by
    default 1.8{p_end}

{syntab :G3SLS}
{synopt :{opt first}}report first-stage results of the linear projection
of {it:W} on {it:W0}{p_end}
{synopt :{opt second}}report second-stage results{p_end}
{synopt :{opt tr:ansformed(varname)}}estimate the linear-in-means model with the
transformed variables multiplied by {it:(I - W0)}{p_end}
{synopt :{opt cl:uster(varname)}}{it:varname} identifies the group{p_end}


{marker descriptions}{...}
{title:Description}

{pstd}{cmd:netivreg} fits a linear-in-means regression of
{it:depvar} on {it:varlist} and social interaction network {it:W},
using the exogenous network {it:W0} as instrument of the endogenous
network {it:W}.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:use} http://www.this_is_the_link.dta{p_end}
{phang2}{cmd:frame create W}{p_end}
{phang2}{cmd:frame edges: use} http://www.edgelist.dta{p_end}
{phang2}{cmd:frame create W0}{p_end}
{phang2}{cmd:frame edges0: use} http://www.edgelist_0.dta{p_end}

{pstd}Fit a linear-in-means regression using G2SLS estimator{p_end}
{phang2}{cmd:netivreg g3sls articles editor (W = W)}{p_end}

{pstd}Fit a linear-in-means regression using G3SLS estimator{p_end}
{phang2}{cmd:netivreg g3sls articles editor (W = W0)}{p_end}

{pstd}Fit a linear-in-means regression using GMM estimator{p_end}
{phang2}{cmd:netivreg gmm articles editor (W = W0)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}{cmd:netivreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(r2)}}R-squared if the equation has a constant{p_end}
{synopt:{cmd:e(r2_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:netivreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(exogr)}}exogenous regressor{p_end}
{synopt:{cmd:e(instd)}}instrumented variable{p_end}
{synopt:{cmd:e(insts)}}instruments{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(first)}}first-stage regression results{p_end}
{synopt:{cmd:e(second)}}second-stage regression results{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{phang}Estrada et al. 2020. netivreg: Estimation of Peer Effects in
Endogenous Social Networks.
 {it:Stata Journal} {browse "http://www.stata-journal.com/article.html?article=st0173":9: 439-453}.{p_end}


{marker authors}{...}
{title:Authors}

{pstd}Pablo Estrada{p_end}
{pstd}Emory University{p_end}
{pstd}Atlanta, USA{p_end}
{pstd}pablo.estrada@emory.edu{p_end}

{pstd}Juan Estrada{p_end}
{pstd}Emory University{p_end}
{pstd}Atlanta, USA{p_end}
{pstd}jjestra@emory.edu{p_end}

{pstd}Kim Huynh{p_end}
{pstd}Bank of Canada{p_end}
{pstd}Ottawa, Canada{p_end}
{pstd}kim@huynh.tv{p_end}

{pstd}David Jacho-Chávez{p_end}
{pstd}Emory University{p_end}
{pstd}Atlanta, USA{p_end}
{pstd}djachocha@emory.edu{p_end}

{pstd}Leonardo Sánchez-Aragón{p_end}
{pstd}ESPOL University{p_end}
{pstd}Guayaquil, Ecuador{p_end}
{pstd}lfsanche@espol.edu.ec{p_end}


{title:Also see}

{p 7 14 2}Help:  {helpb netivreg}, {helpb est},
{helpb postest}, {helpb regress}{p_end}
