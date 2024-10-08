## Code for the article "```netivreg```: _Estimation of Peer Effects in Endogenous Social Networks_"

The command ```netivreg```  implements the Generalized Three-Stage Least Squares (G3SLS) estimator developed in
```Estrada (2022)``` and the Generalized Method of Moments (GMM) estimator in ```Chan et al. (inpress)``` for the endogenous linear-in-means model. 
The two procedures utilize full observability of a two-layered multiplex network data structure using Stata's new multiframes capabilities 
and Python integration (version 16 and above). Applications of the command include simulated data and three years' worth of 
data on peer-reviewed articles published in top general interest journals in Economics.

[**Pablo Estrada**](https://pabloestrada.io/)  
_Emory University_, Atlanta, GA, USA  

[**Juan Estrada**](https://www.juanestrada.info/)  
 _Analysis Group Econoic COnsultaing_, Washington, DC, USA  

[**Kim Huynh**](https://kphuynh.pages.iu.edu/)  
_Bank of Canada_, Ottawa, Ontario, Canada  

[**David Jacho-Chavez**](https://www.davidjachochavez.org/)  
Emory University_, Atlanta, GA, USA  

[**Leonardo Sanchez-Aragon**](https://leonardosanchezaragon.netlify.app/)  
_ESPOL University_, Guayaquil, Guayas, Ecuador  

## Requirements

[Stata 16.0](https://www.stata.com/) and [Python 3.9](https://www.python.org/) or above are needed as well as the following Python packages,

| Python Package | Version |
| ----------- | ----------- |
| [networkX](https://networkx.org/) | 3.2.x |
| [numpy](https://numpy.org/) | 1.26.x |
| [pandas](https://pandas.pydata.org/) | 2.2.x |
| [scikit-learn](https://scikit-learn.org/) | 1.5.x |
| [scipy](https://scipy.org/) | 1.13.x |

The user is strongly encouraged to create a virtual environment with the required Python packages versions. For example, on Windows, the user can open a command prompt and create a conda environment using Anaconda as follows,

```
conda create -n netivreg_env python=3.9 pip networkx=3.2 numpy=1.26 pandas=2.2 scikit-learn=1.5 scipy=1.13
```

Then, to recover the location path of the environment `netivreg_env`, the user can run the following command in the command prompt,

```
conda env list
```

After creating the environment and obtaining its location, the user has to point Stata to the `netivreg_env` environment by running the following command in Stata,

```
python set exec <location>\bin\python3.9
```

where `<location>` could be `C:\Users\user\Anaconda3\envs\netivreg_env`. Alternatively, the user can point to the environment permanently by instead running the following command in Stata,

```
python set exec <location>\bin\python3.9, permanently
```

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
