## Code for the article "```netivreg```: _Estimation of Peer Effects in Endogenous Social Networks_"

The command ```netivreg```  implements the Generalized Three-Stage Least Squares (G3SLS) estimator developed in
```Estrada (2022)``` and the Generalized Method of Moments (GMM) estimator in ```Chan et al. (in press)``` for the endogenous linear-in-means model. 
The two procedures utilize full observability of a two-layered multiplex network data structure using Stata's new multiframes capabilities 
and Python integration (version 16 and above). Applications of the command include simulated data and three years' worth of 
data on peer-reviewed articles published in top general interest journals in Economics.

[**Pablo Estrada**](https://pabloestrada.io/)  
_Emory University_, Atlanta, GA, USA  

[**Juan Estrada**](https://www.juanestrada.info/)  
 _Analysis Group Econoic COnsultaing_, Washington, DC, USA  

[**Kim Huynh**](https://kphuynh.pages.iu.edu/)  
_Bank of Canada_, Ottawa, Ontario, Canada  

[**David Jacho-Chávez**](https://www.davidjachochavez.org/)  
Emory University_, Atlanta, GA, USA  

[**Leonardo Sánchez-Aragón**](https://leonardosanchezaragon.netlify.app/)  
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


## Step-by-Step Installation Guide for `netivreg`

1. **Install Python via Anaconda:**  
   Download and install [Anaconda](https://www.anaconda.com/download/success), which comes with Python 3.9 or higher. The Anaconda distribution is highly recommended to ensure compatibility with `netivreg`.

2. **Set the Python Version in Stata:**  
   After installing Python, you need to link it to Stata. Open Stata and use the following command to set the Python version:
   ```stata
   python set exec <location>\bin\python3.9
    ```
   Replace <location> with the actual path to your Python installation, typically found within the Anaconda folder.

3. **Create a Python Environment for netivreg:**
   To ensure backward compatibility and avoid version conflicts, create a dedicated environment for netivreg with the required Python packages. 
   Open a command prompt and run the following command:

   ```bash
   conda create -n netivreg_env python=3.9 pip networkx=3.2 numpy=1.26 pandas=2.2 scikit-learn=1.5 scipy=1.13
   ```

   This command creates a conda environment named ```netivreg_env``` with Python 3.9 and the necessary packages.

4. **Copy netivreg Files to the Stata Ado Folder:**
 - Locate the ```netivreg.ado``` and ```netivreg.sthlp``` files from the stata_package folder.
 - Copy these files to the ```ado/base/n``` folder in your Stata installation directory. This folder is automatically created when Stata is installed.

5 . **Copy Python Files to the Stata ado/base/py Folder:**
 - Find the folder named ```netivreg``` (this folder contains Python files necessary to run the command).
 - Copy the entire netivreg folder to the ```ado/base/py``` directory in your Stata installation folder.




The user is strongly encouraged to create a virtual environment with the required Python packages versions. For example, on Windows, the user can open a command prompt and create a conda environment using Anaconda as follows,

```
conda create -n netivreg_env python=3.9 pip networkx=3.2 numpy=1.26 pandas=2.2 scikit-learn=1.5 scipy=1.13
```

Then, to recover the location path of the environment `netivreg_env`, the user can run the following command in the command prompt,

```
conda env list
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
