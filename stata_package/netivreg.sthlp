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


{phang}Anaconda Software Distribution. 2020. Anaconda Documentation. {browse "https://docs.anaconda.com/":https://docs.anaconda.com/}.{p_end}

{phang}Auerbach, E. 2022. Identification and estimation of a partially linear regression model using network data. {it:Econometrica} 90(1): 347–365.{p_end}

{phang}Bramoullé, Y., H. Djebbari, and B. Fortin. 2009. Identification of Peer Effects through Social Networks. {it:Journal of Econometrics} 150(1): 41–55.{p_end}

{phang}Cerulli, G. 2017. Identification and Estimation of Treatment Effects in the Presence of (Correlated) Neighborhood Interactions: Model and Stata Implementation via Ntreatreg. {it:The Stata Journal} 17(4): 803–833.{p_end}

{phang}Chan, T. J., J. Estrada, K. P. Huynh, D. T. Jacho-Chávez, C. T. Lam, and L. Sánchez-Aragón. In press. Estimating Social Effects with Randomized and Observational Network Data. {it:Journal of Econometric Methods}.{p_end}

{phang}De Paula, A., S. Richards-Shubik, and E. Tamer. 2018. Identifying preferences in networks with bounded degree. {it:Econometrica} 86(1): 263–288.{p_end}

{phang}Erdös, P., and A. Rényi. 1959. On Random Graphs. {it:Publicationes Mathematicae (Debrecen)} 6: 290–297.{p_end}

{phang}Estrada, J. 2022. Causal Inference in Multilayered Networks. PhD thesis, Emory University. {browse "https://etd.library.emory.edu/concern/etds/3r074w158":https://etd.library.emory.edu/concern/etds/3r074w158}.{p_end}

{phang}Goldsmith-Pinkham, P., and G. W. Imbens. 2013. Social Networks and the Identification of Peer Effects. {it:Journal of Business and Economic Statistics} 31(3): 253–264.{p_end}

{phang}Graham, B. S. 2017. An Econometric Model of Network Formation With Degree Heterogeneity. {it:Econometrica} 85(4): 1033–1063.{p_end}

{phang}Graham, B. S., and A. Pelican. 2020. Testing for externalities in network formation using simulation. In {it:The Econometric Analysis of Network Data}, ed. B. Graham and Aureo de Paula, 63–82. Academic Press.{p_end}

{phang}Hagberg, A., P. Swart, and D. S. Chult. 2008. Exploring Network Structure, Dynamics, and Function using NetworkX. Technical report, Los Alamos National Lab.(LANL), Los Alamos, NM (United States).{p_end}

{phang}Ho, A. T. Y., K. P. Huynh, D. T. Jacho-Chávez, and D. Rojas. 2021. Data Science in Stata 16: Frames, Lasso, and Python Integration. {it:Journal of Statistical Software} 98(1): 1–9.{p_end}

{phang}Jackson, M. O., B. W. Rogers, and Y. Zenou. 2017. The Economic Consequences of Social-Network Structure. {it
of Economic Literature} 55(1): 49–95.{p_end}

{phang}Johnsson, I., and H. R. Moon. 2021. Estimation of Peer Effects in Endogenous Social Networks: Control Function Approach. {it
Review of Economics and Statistics} 103(2): 328–345.{p_end}

{phang}Kojevnikov, D., V. Marmer, and K. Song. 2021. Limit theorems for network dependent random variables. {it
of Econometrics} 222(2): 882–908.{p_end}

{phang}Manski, C. F. 1993. Identification of Endogenous Social Effects: The Reflection Problem. {it
of Economic Studies} 60(3): 531–542.{p_end}

{phang}McKinney, W., et al. 2010. Data Structures for Statistical Computing in Python. In {it
of the 9th Python in Science Conference}. Vol. 445, 51–56. Austin, TX.{p_end}

{phang}Oliphant, T. E. 2006. {it
Guide to NumPy}. Vol. 1. Trelgol Publishing USA.{p_end}

{phang}Pedregosa, F., G. Varoquaux, A. Gramfort, V. Michel, B. Thirion, O. Grisel, M. Blondel, P. Prettenhofer, R. Weiss, V. Dubourg, et al. 2011. Scikit-learn: Machine Learning in Python. {it
of Machine Learning Research} 12(Oct): 2825–2830.{p_end}

{phang}Qu, X., and L. F. Lee. 2015. Estimating a Spatial Autoregressive Model with an Endogenous Spatial Weight Matrix. {it
of Econometrics} 184(2): 209–232.{p_end}

{phang}Van Rossum, G., and F. L. Drake. 2009. {it
3 Reference Manual}. Scotts Valley, CA: CreateSpace.{p_end}

{phang}Virtanen, P., R. Gommers, T. E. Oliphant, M. Haberland, T. Reddy, D. Cournapeau, E. Burovski, P. Peterson, W. Weckesser, J. Bright, S. J. van der Walt, M. Brett, J. Wilson, K. Jarrod Millman, N. Mayorov, A. R. J. Nelson, E. Jones, R. Kern, E. Larson, C. Carey, I. Polat, Y. Feng, E. W. Moore, J. VanderPlas, D. Laxalde, J. Perktold, R. Cimrman, I. Henriksen, E. A. Quintero, C. R. Harris, A. M. Archibald, A. H. Ribeiro, F. Pedregosa, P. van Mulbregt, and Contributors. 2020. SciPy 1.0: Fundamental Algorithms for Scientific Computing in Python. {it
Methods}.{p_end}


{marker authors}{...}
{title:Authors}

{pstd}Pablo Estrada{p_end}
{pstd}Emory University{p_end}
{pstd}Atlanta, USA{p_end}
{pstd}pablo.estrada@emory.edu{p_end}

{pstd}Juan Estrada{p_end}
{pstd}Analysis Group Economic Consulting{p_end}
{pstd}Washington, DC, USA{p_end}
{pstd}juan.estrada@analysisgroup.com{p_end}

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

{p 7 14 2}{helpb regress}, {helpb est},
{helpb postest} {p_end}
