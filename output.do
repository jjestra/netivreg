clear all
set more off, permanently


**# SIMULATED DATA

*-- Load Nodes Simulated Data
use data/data_sim.dta, clear
format y_endo y_exo x1 x2 x3 x4 %9.3f
list in 1/5, table 

*-- Load W Simulated Data
use data/W_sim.dta, clear
list in 113/117, table 

*-- Load W0 Simulated Data
use data/W0_sim.dta, clear
list in 113/117, table 

*-- netivreg: Exogenous
use data/data_sim.dta, clear
frame create edges
frame edges: use data/W_sim.dta
netivreg g3sls y_exo x1 x2 x3 x4 (edges = edges)
netivreg gmm y_exo x1 x2 x3 x4 (edges = edges)

*-- netivreg: Endogenous
frame create edges0
frame edges0: use data/W0_sim.dta
netivreg g3sls y_endo x1 x2 x3 x4 (edges = edges0)
netivreg gmm y_endo x1 x2 x3 x4 (edges = edges0)


**# ARTICLES DATA

*-- Frame edges & edges0
frames reset
frame create edges
frame edges: use data/edges.dta
frame create edges0
frame edges0: use data/edges0.dta

*-- Estimation
use data/articles.dta, clear
tabulate journal, g(journal)
tabulate year, g(year)

netivreg g3sls lcitations editor diff_gender n_pages n_authors n_references isolated journal2-journal4 year2-year3 (edges = edges0), wx(editor diff_gender) cluster(c_coauthor)

netivreg gmm lcitations editor diff_gender n_pages n_authors n_references isolated journal2-journal4 year2-year3 (edges = edges0), wx(editor diff_gender) wz(editor diff_gender n_pages n_authors n_references isolated) maxp(4)
