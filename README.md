## Code for the article "```netivreg```: _Estimation of Peer Effects in Endogenous Social Networks_"

The command ```netivreg```  implements the Generalized Three-Stage Least Squares (G3SLS) estimator developed in
[**Estrada (2022)**, '_Causal Inference in Multilayered Networks_,' Ph.D. Dissertation](https://etd.library.emory.edu/concern/etds/3r074w158) and the Generalized Method of Moments (GMM) estimator in [**Chan, T. J., J. Estrada, K. P. Huynh, D. T. Jacho-Chávez, C. T. Lam, and L. Sánchez-Aragón (2024)** '_On the Estimation of Social Effects with Observational Network Data and Random Assignment_,' Journal of Econometric Methods](https://doi.org/10.1515/jem-2023-0043) for the endogenous linear-in-means model. 
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
>_Emory University_, Atlanta, GA, USA  
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

   > Note: On Windows, Anaconda is typically installed in the `C:\Users\<username>\anaconda3` folder. 


2. **Create a Python environment for netivreg:**
   
   To ensure backward compatibility and avoid version conflicts, we recommend you create a dedicated environment for `netivreg` with the required Python packages. Do this by first, openning the Anaconda prompt and run the following command:

   ```bash
   conda create -n netivreg_env python=3.9 pip networkx=3.2 numpy=1.26 pandas=2.2 scikit-learn=1.5 scipy=1.13
   ```

   This command creates a conda environment named ```netivreg_env``` with Python 3.9 and the necessary packages with the compatible versions.

   > Note: On Windows, this environment is typically created within the `C:\Users\<username>\anaconda3\envs` folder.  Inside `envs`, a subfolder named `netivreg_env` will hold all files for this specific environment.

3. **Activate the Python environment for netivreg:**

   Run the following command on the Anaconda prompt:

   ```bash
   conda activate netivreg_env
   ```

4. **Directing Stata to use the crated Python environment:**  
   
   After completing steps 1–3 above, link Python to your local Stata installation. Open Stata and use the following command in the Stata command window to set the Python version:

   > Note: On Windows, one would write
   ```stata
   python set exec "C:\Users\<username>\anaconda3\envs\netivreg_env\python.exe" , permanently
   ```

   Replace `<username>` with your actual username in the path. This command tells Stata to use the specified Python executable within the Anaconda environment `netivreg_env`. Setting it permanently means Stata will remember this configuration for future sessions. Otherwise, you will need to set this address every time you would like to use the `netivreg` command.

## <span style="color:red">Manual</span> Installation:

5. **Copy `netivreg` files to the Stata ado folder:**
   
   - Locate the ```netivreg.ado``` and ```netivreg.sthlp``` files in the `Files` folder within this repository.
   - Copy these files to the ```/ado/plus/n``` folder in your local user installation directory. For example, on Windows, this path  would be  `C:/Users/<username>/ado/plus/n`. This folder is automatically created when you install any user-written Stata package.


6. **Copy Python Files to the Stata ado/plus/py Folder:**

   - Locate the `ado/plus/py` folder  in your local user installation directory. For example, `C:/Users/<username>/ado/plus/py` in Windows. If this folder does not exist, you can create it.
   - Inside the `ado/plus/py` folder, create a new folder named `netivreg`.
   - Locate the  ```__init__.py```, ```g3sls.py``` and ```gmm.py``` files  in the `Files` folder within this repository. 
   - Copy these files to the ```ado/plus/py/netivreg``` folder.

   **Alternative way to handle `py` filesp** (We thank Stata for making this suggestion)

   - Change the content of __init__.py to the following:

         __version__ = "1.0.0"
         from g3sls import *
         from gmm import *

         (Just removed `.` from the front of g3sls and gmm)
         
   - Rename __init__.py to netivreg.py.  
  
   - Copy the `netivreg.py`, `g3sls.py`, and `gmm.py` into the folder `ado/plus/py`. Now, you do not need to create the folder named `netivreg`. 
   

## How-To Video

For Windows users, please refer to the following instructional video

[![Watch the video](https://img.youtube.com/vi/LfUSOjjb9mw/maxresdefault.jpg)](https://www.youtube.com/watch?v=LfUSOjjb9mw)




## Tips
   - To recover the location path of the environment `netivreg_env`, the user can run the following command in the command prompt,

      ```bash
      conda env list
      ```

   - To desactive an environment, in your Aanconda Prompt run
      ```bash
      conda desactivate
      ```


## Usage 

In `Files` folder within this repository, there is a do-file named `manuscript_output.do` that replicates the tables from the manuscript '`netivreg`: _Estimation of Peer Effects in Endogenous Social Networks_' using the datasets found in the same `Files` folder in this repository.

