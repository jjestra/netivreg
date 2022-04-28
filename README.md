## Code for the article "netivreg: Estimation of Peer Effects in Endogenous Social Networks"

The command ```netivreg``` implements the Generalized Three-Stage Least Squares (G3SLS) estimator developed in Estrada et al. (2020, “On the Identification and Estimation of Endogenous Peer Effects in Multiplex Networks”) and the Generalized Method of Moments (GMM) estimator in Chan et al. (2022, “On the Estimation of Social Effects with Observational Network Data and Random Assignment”)

Author 1 name: [Pablo Estrada](https://pabloestradac.github.io/)  
Author 1 from: Emory University, Atlanta, GA, USA  
Author 1 email: pestrad@emory.edu  

Author 2 name: [Juan Estrada](https://www.juanestrada.info/)
Author 2 from: Emory University, Atlanta, GA, USA 
Author 2 email: jjestra@emory.edu

Author 3 name: [Kim Huynh](https://kphuynh.pages.iu.edu/)
Author 3 from: Bank of Canada, Ottawa, Ontario, Canada 
Author 3 email: kim@huynh.tv

Author 4 name: [David Jacho-Chavez](https://www.davidjachochavez.org/)
Author 4 from: Emory University, Atlanta, GA, USA 
Author 4 email: djachocha@emory.edu

Author 5 name: [Leonardo Sanchez-Aragon](https://leonardosanchezaragon.netlify.app/)
Author 5 from: ESPOL University, Guayaquil, Guayas, Ecuador 
Author 5 email: lfsanche@espol.edu.ec

## Usage 

Files list and folders structure:

- data (folder): contains all data required to run the examples in the manuscript. The files include ```articles.dta```, ```data_sim.dta```, ```edges.dta```, ```edges0.dta```, ```W_sim.dta``` and ```W0_sim.dta```.

- netivreg (folder): contains the Python scripts with the Generalized Three-Stage Least Squares and the Generalized Method of Moments estimators. The files include ```__init__.py```, ```g3sls.py``` and ```gmm.py```. 

The other files in the repository include:

- The do file with the Stata code to run the examples in the manuscript called ```manuscript_output.do```.

- The ado file with the netivreg Stata code called ```netivreg.ado```. 

- The help file called ```netivreg.sthlp```. 

The order of the folders is essential to running the manuscript_output.do script, so please keep the structure in the code folder. 

After downloading the code, change the global path in the manuscript_output.do for the local path where you saved the code folder.  

Before running the do file, add the netivreg.ado to your Stata ado folder.

Notes: Stata 16.0 and Python 3.7 or above are needed as well as the Python packages networkX, numpy, pandas, scikit-learn, scipy.
