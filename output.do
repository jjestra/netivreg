clear all
set more off, permanently

log using "netivregOUT", replace name("netivreg output log")

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

*-- netivreg: Exogenous (G2SLS)
use data/data_sim.dta
frame create edges
frame edges: use data/W_sim.dta
netivreg g3sls y_exo x1 x2 x3 x4 (edges = edges)

*-- netivreg: Exogenous (G3SLS)
frame create edges0
frame edges0: use data/W0_sim.dta
netivreg g3sls y_exo x1 x2 x3 x4 (edges = edges0) 

*-- netivreg: Exogenous (GMM)
netivreg gmm y_exo x1 x2 x3 x4 (edges = edges0) 

*-- netivreg: Endogenous (G3SLS)
netivreg g3sls y_endo x1 x2 x3 x4 (edges = edges0)

*-- netivreg: Endogenous (GMM)
netivreg gmm y_endo x1 x2 x3 x4 (edges = edges0)

*-- netivreg: Endogenous (G3SLS) first
netivreg g3sls y_endo x1 x2 x3 x4 (edges = edges0), first

*-- netivreg: Endogenous (G3SLS) second
netivreg g3sls y_endo x1 x2 x3 x4 (edges = edges0), second

*-- netivreg: Endogenous (G3SLS) with W = W
netivreg g3sls y_endo x1 x2 x3 x4 (edges = edges)


**# ARTICLES DATA

*-- Data description
use data/articles.dta
describe

*-- Summary Statistics I
gen citations = exp(lcitations)
tabulate journal year, summarize(citations)

*-- Summary Statistics II
summarize editor diff_gender isolated n_pages n_authors n_references

frame reset

*-- Frame edges & edges0
frame create edges
frame edges: use data/edges.dta
frame edges: list in 1/5, table 
frame create edges0
frame edges0: use data/edges0.dta
frame edges0: list in 1/5, table

use data/articles.dta

tabulate journal, g(journal)
tabulate year, g(year)

*-- Estimation G3SLS
netivreg g3sls lcitations editor diff_gender n_pages n_authors n_references isolated journal2-journal4 year2-year3 (edges = edges0), wx(editor diff_gender) cluster(c_coauthor)

*-- Estimation GMM
netivreg gmm lcitations editor diff_gender n_pages n_authors n_references isolated journal2-journal4 year2-year3 (edges = edges0), wx(editor diff_gender) wz(editor diff_gender n_pages n_authors n_references isolated) maxp(4)

log close
