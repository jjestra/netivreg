## Code for the article "```netivreg```: _Estimation of Peer Effects in Endogenous Social Networks_"

The command ```netivreg```  implements the Generalized Three-Stage Least Squares (G3SLS) estimator developed in
[**Estrada (2022)**, '_Causal Inference in Multilayered Networks_,' Ph.D. Dissertation](https://etd.library.emory.edu/concern/etds/3r074w158) and the Generalized Method of Moments (GMM) estimator in [**Chan, T. J., J. Estrada, K. P. Huynh, D. T. Jacho-Chávez, C. T. Lam, and L. Sánchez-Aragón (in press)** '_On the Estimation of Social Effects with Observational Network Data and Random Assignment_,' Journal of Econometric Methods](https://www.degruyter.com/journal/key/jem/html) for the endogenous linear-in-means model. 
The two procedures utilize full observability of a two-layered multiplex network data structure using Stata's new multiframes capabilities 
and Python integration (version 16 or above). 

Authors: 

>[**Pablo Estrada**](https://pabloestrada.io/)  
>_Emory University_, Atlanta, GA, USA  
>
>[**Juan Estrada**](https://www.juanestrada.info/)  
> _Analysis Group Economic Consulting_, Washington, DC, USA  
>
>[**Kim Huynh**](https://kphuynh.pages.iu.edu/)  
>_Bank of Canada_, Ottawa, Ontario, Canada  
>
>[**David Jacho-Chávez**](https://www.davidjachochavez.org/)  
>Emory University_, Atlanta, GA, USA  
>
>[**Leonardo Sánchez-Aragón**](https://leonardosanchezaragon.netlify.app/)  
>_ESPOL University_, Guayaquil, Guayas, Ecuador  

## Requirements

[Stata 16.0](https://www.stata.com/) or above, and [Python 3.9](https://www.python.org/) or above are needed as well as the following Python packages,

| Python Package | Version |
| ----------- | ----------- |
| [networkX](https://networkx.org/) | 3.2.x |
| [numpy](https://numpy.org/) | 1.26.x |
| [pandas](https://pandas.pydata.org/) | 2.2.x |
| [scikit-learn](https://scikit-learn.org/) | 1.5.x |
| [scipy](https://scipy.org/) | 1.13.x |


## Step-by-Step Installation Guide for `netivreg`

1. **Install Python via Anaconda:**  

   Download and install [Anaconda](https://www.anaconda.com/download/success) on your computer, which comes with Python 3.9 or higher. The Anaconda distribution is highly recommended to ensure compatibility with `netivreg`.


2. **Set the Python version in Stata:**  
   
   After installing Python locally on your computer, you need to link it to your local Stata installation. Open Stata and use the following command to set the Python version:
   ```stata
   python set exec <location>\bin\python3.9, permanently
    ```
   Replace `<location>` with the actual path to your local Python installation, typically found within the Anaconda folder.


3. **Create a Python environment for netivreg:**
   
   To ensure backward compatibility and avoid version conflicts, we recommend you create a dedicated environment for `netivreg` with the required Python packages. Do this by first,    openning the Anaconda prompt and run the following command:

   ```bash
   conda create -n netivreg_env python=3.9 pip networkx=3.2 numpy=1.26 pandas=2.2 scikit-learn=1.5 scipy=1.13
   ```

   This command creates a conda environment named ```netivreg_env``` with Python 3.9 and the necessary packages with the compatible versions.


4. **Copy `netivreg` files to the Stata ado folder:**
   
   - Locate the ```netivreg.ado``` and ```netivreg.sthlp``` files in the stata_package folder within this repository.
   - Copy these files to the ```ado/base/n``` folder in your local Stata installation directory. This folder is automatically created during Stata's installation.


5. **Copy Python Files to the Stata ado/base/py Folder:**

   - Locate the folder named ```netivreg``` in the stata_package folder within this repository. It contains Python files necessary to run Generalized Three-Stage Least Squares and the Generalized Method of Moments estimators.
   - This ```netivreg``` folder contains: ```__init__.py```, ```g3sls.py``` and ```gmm.py```. 
   - Copy the entire ```netivreg``` folder to the ```ado/base/py``` directory in your local Stata installation folder.


## Additional resources

For Windows users, please refer to the following instructional video [here](https://www.youtube.com/watch?v=u_zt9QbGTTA&feature=youtu.be).



## Tips
To recover the location path of the environment `netivreg_env`, the user can run the following command in the command prompt,

```
conda env list
```

## Usage 

In the output folder within this repository, there is a do-file named `output.do` that replicates the tables from the manuscript '`netivreg`: _Estimation of Peer Effects in Endogenous Social Networks_' using the datasets found in the `data` folder in this repository.

