## Code for the article "```netivreg```: _Estimation of Peer Effects in Endogenous Social Networks_"

The Stata command ```netivreg``` implements the Generalized Three-Stage Least Squares (G3SLS) estimator developed in Estrada et al. (2020, “_On the Identification and Estimation of Endogenous Peer Effects in Multiplex Networks_”) and the Generalized Method of Moments (GMM) estimator in Chan et al. (2022, “_On the Estimation of Social Effects with Observational Network Data and Random Assignment_”)

Author 1 name: [**Pablo Estrada**](https://pabloestradac.github.io/)  
Author 1 from: _Emory University_, Atlanta, GA, USA  

Author 2 name: [**Juan Estrada**](https://www.juanestrada.info/)  
Author 2 from: _Emory University_, Atlanta, GA, USA  

Author 3 name: [**Kim Huynh**](https://kphuynh.pages.iu.edu/)  
Author 3 from: _Bank of Canada_, Ottawa, Ontario, Canada  

Author 4 name: [**David Jacho-Chavez**](https://www.davidjachochavez.org/)  
Author 4 from: _Emory University_, Atlanta, GA, USA  

Author 5 name: [**Leonardo Sanchez-Aragon**](https://leonardosanchezaragon.netlify.app/)  
Author 5 from: _ESPOL University_, Guayaquil, Guayas, Ecuador  

## Requirements

[Stata 16.0](https://www.stata.com/) and [Python 3.7](https://www.python.org/) or above are needed as well as the Python packages [networkX](https://networkx.org/), [numpy](https://numpy.org/), [pandas](https://pandas.pydata.org/), [scikit-learn](https://scikit-learn.org/), and [scipy](https://scipy.org/).

## Usage 

Files list and folders structure:

- data (folder): contains all data required to run the examples in the manuscript. The files include ```articles.dta```, ```data_sim.dta```, ```edges.dta```, ```edges0.dta```, ```W_sim.dta``` and ```W0_sim.dta```.

- netivreg (folder): contains the Python scripts with the Generalized Three-Stage Least Squares and the Generalized Method of Moments estimators. The files include ```__init__.py```, ```g3sls.py``` and ```gmm.py```. 

The other files in the repository include:

- The do file with the Stata code to run the examples in the manuscript called ```manuscript_output.do```.

- The ado file with the netivreg Stata code called ```netivreg.ado```. 

- The help file called ```netivreg.sthlp```. 

The order of the folders is essential to running the ```manuscript_output.do``` script, so please keep the structure in the code folder. 

After downloading the code, change the global path in the ```manuscript_output.do``` to the local path where you saved locally the code folder.  

Before running the do file, add the ```netivreg.ado``` to your Stata ado folder.
