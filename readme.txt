NOTE:  readme.txt template -- do not remove empty entries, but you may
                              add entries for additional authors
------------------------------------------------------------------------------

Package name:   <leave blank>

DOI:  <leave blank>

Title:  netivreg: Estimation of Peer Efects in Endogenous Social Networks 

Author 1 name: Pablo Estrada
Author 1 from: Emory University, Atlanta, GA, USA 
Author 1 email: pestrad@emory.edu 

Author 2 name: Juan Estrada 
Author 2 from: Emory University, Atlanta, GA, USA 
Author 2 email: jjestra@emory.edu

Author 3 name: Kim Huynh 
Author 3 from: Bank of Canada, Ottawa, Ontario, Canada 
Author 3 email: kim@huynh.tv

Author 4 name: David Jacho-Chavez 
Author 4 from: Emory University, Atlanta, GA, USA 
Author 4 email: djachocha@emory.edu

Author 5 name: Leonardo Sanchez-Aragon 
Author 5 from: ESPOL University, Guayaquil, Guayas, Ecuador 
Author 5 email: lfsanche@espol.edu.ec

Help keywords: netivreg

Files list and folders structure:

	- data (folder): contains all data required to run the examples in the manuscript. The files include articles.dta, data_sim.dta, edges.dta, edges0.dta, W_sim.dta and W0_sim.dta.

	- netivreg(folder): contains the Python script with the Generalized Three-Stage Least Squares and the Generalized Method of Moments estimators. The files include __init__.py, g3sls.py and gmm.py. 

The other files in the code folder include:

 	- The do file with the Stata code to run the examples in the manuscript called manuscript_output.do

	- The ado file with the netivreg Stata code called netivreg.ado 

	- The help file called netivreg.sthlp. 

The order of the folders is essential to running the manuscript_output.do script, so please keep the structure in the code folder. 

After downloading the code, change the global path in the manuscript_output.do for the local path where you saved the code folder.  

Notes: Stata 16.0 and Python 3.7 or above are needed as well as the Python packages networkX, numpy, pandas, scikit-learn, scipy.
