clear all
set more off, permanently

global path `"C:\Users\pestrad\Desktop"'

*-- Load Nodes Simulated Data
sjlog using `"$path/netivregOUT1"', replace
use data/data_sim.dta
format y_endo y_exo x1 x2 x3 x4 %9.3f
list in 1/5, table 
sjlog close, replace

*-- Load W Simulated Data
clear
sjlog using `"$path/netivregOUT2"', replace
use data/W_sim.dta
list in 113/117, table 
sjlog close, replace

*-- Load W0 Simulated Data
clear
sjlog using `"$path/netivregOUT3"', replace
use data/W0_sim.dta
list in 113/117, table 
sjlog close, replace

*-- netivreg: Exogenous (G2SLS)
sjlog using `"$path/netivregOUT4"', replace
use data/data_sim.dta
frame create edges
frame edges: use data/W_sim.dta
netivreg g3sls y_exo x1 x2 x3 x4 (edges = edges) 
sjlog close, replace

*-- netivreg: Exogenous (G3SLS)
sjlog using `"$path/netivregOUT6"', replace
frame create edges0
frame edges0: use data/W0_sim.dta
netivreg g3sls y_exo x1 x2 x3 x4 (edges = edges0) 
sjlog close, replace

*-- netivreg: Exogenous (GMM)
sjlog using `"$path/netivregOUT5"', replace
netivreg gmm y_exo x1 x2 x3 x4 (edges = edges0) 
sjlog close, replace

*-- netivreg: Endogenous (G3SLS)
sjlog using `"$path/netivregOUT8"', replace
netivreg g3sls y_endo x1 x2 x3 x4 (edges = edges0)
sjlog close, replace

*-- netivreg: Endogenous (GMM)
sjlog using `"$path/netivregOUT7"', replace
netivreg gmm y_endo x1 x2 x3 x4 (edges = edges0)
sjlog close, replace

*-- netivreg: Endogenous (G3SLS) first
sjlog using `"$path/netivregOUT9"', replace
netivreg g3sls y_endo x1 x2 x3 x4 (edges = edges0), first
sjlog close, replace

*-- netivreg: Endogenous (G3SLS) second
sjlog using `"$path/netivregOUT10"', replace
netivreg g3sls y_endo x1 x2 x3 x4 (edges = edges0), second
sjlog close, replace

*-- netivreg: Endogenous (G3SLS) with W = W
sjlog using `"$path/netivregOUT10_extra"', replace
netivreg g3sls y_endo x1 x2 x3 x4 (edges = edges)
sjlog close, replace


*-- Data description
sjlog using `"$path/netivregOUT11"', replace
use data/articles.dta
describe
sjlog close, replace

*-- Summary Statistics I
sjlog using `"$path/netivregOUT12"', replace
gen citations = exp(lcitations)
tabulate journal year, summarize(citations)
sjlog close, replace

*-- Summary Statistics II
sjlog using `"$path/netivregOUT13"', replace
summarize editor diff_gender isolated n_pages n_authors n_references
sjlog close, replace

frame reset

*-- Frame edges & edges0
sjlog using `"$path/netivregOUT14"', replace
frame create edges
frame edges: use data/edges.dta
frame edges: list in 1/5, table 
frame create edges0
frame edges0: use data/edges0.dta
frame edges0: list in 1/5, table
sjlog close, replace

use data/articles.dta

tabulate journal, g(journal)
tabulate year, g(year)

*-- Estimation G3SLS
sjlog using `"$path/netivregOUT16"', replace
netivreg g3sls lcitations editor diff_gender n_pages n_authors n_references isolated journal2-journal4 year2-year3 (edges = edges0), wx(editor diff_gender) cluster(c_coauthor)
sjlog close, replace

*-- Estimation GMM
sjlog using `"$path/netivregOUT15"', replace
netivreg gmm lcitations editor diff_gender n_pages n_authors n_references isolated journal2-journal4 year2-year3 (edges = edges0), wx(editor diff_gender) wz(editor diff_gender n_pages n_authors n_references isolated) maxp(4)
sjlog close, replace



