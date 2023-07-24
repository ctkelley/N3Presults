# N3Presults
This Git repo supports my paper __Newton's Method in Three Precisions__

C. T. Kelley, _Newton's Method in Three Precisions_, 2023


__Use the latest version of Julia with this stuff!!!__ 

The software is in Julia and I have included 
  - A Jupyter notebook
  - The codes for the examples in the paper
  - A copy of [talk on interprecision transfers](MPArrays_XSDK-MULTIPRECISION_June_15.pdf) for the XSDK-MULTIPRECISION series of seminars

You must know enough Julia to 
- install packages,
- run an IJulia notebook,
- and manage Github.
  
To run this notebook you will need to install these packages
- IJulia
- SIAMFANLEquations
- PyPlot

When you install SIAMFANLEquations you will also install many other packages. If you have not installed them already, that could take a bit of time.

To run the notebook 

- clone this repositoory
- go to the directory for the clone __on your filesystem__
- start Julia
- Type ```notebook(;dir=pwd())``` at the julia prompt
- click on the notebook ```N3Presults.ipynb```
- The notebook should open, when it does click on ```cell``` and select the ```run all``` option.
