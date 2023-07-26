# N3Presults
This Git repo supports my paper __Newton's Method in Three Precisions__

C. T. Kelley, _Newton's Method in Three Precisions_, 2023

__Use the latest version of Julia with this stuff!!!__ 

## What's here

The software is in Julia and I have included 
  - A Jupyter notebook
  - The codes for the examples in the paper
  - A [pdf file of the notebook](N3Presults.pdf)
  - A copy of [talk on interprecision transfers](MPArrays_XSDK-MULTIPRECISION_June_15.pdf) for the XSDK-MULTIPRECISION series of seminars

## Prerequisites
You must know enough Julia to 
- install packages,
- run an IJulia notebook,
- and manage Github.

## Dependencies  
To run this notebook you will need to install these packages
- IJulia
- SIAMFANLEquations
- PyPlot

When you install SIAMFANLEquations you will also install many other packages. If you have not installed them already, that could take a bit of time.

## Running the codes
To run the notebook 

- clone this repositoory
- go to the directory for the clone __on your filesystem__
- start Julia
- Type ```notebook(;dir=pwd())``` at the julia prompt
- click on the notebook ```N3Presults.ipynb```
- The notebook should open, when it does click on ```cell``` and select the ```run all``` option.

## The tricky stuff.
To fully understand this material you'll need to understand how to use ```nsol.jl``` from [SIAMFANLEquations.jl](https://github.com/ctkelley/SIAMFANLEquations.jl). The solver is well documented in the 
[book](https://my.siam.org/Store/Product/viewproduct/?ProductId=44313635) and the 
[notebook](https://github.com/ctkelley/NotebookSIAMFANL).

I manage the coupling of iterative refinement and the nonlinear solver with a data structure ```MPArray```. I am building a package for this, but it will not be done in time for this paper. I've put a preliminary version in file ```src/MultiPrecisionArraysv0.jl``` that works for this repo. It is not completely documented nor have I made any final decsions on the user interface. The package repo is [MultiPrecisionArrays.jl](MultiPrecisionArrays.jl), but I have not registered it or announced it.

## Funding
This work was partially supported by
- US Department of Energy grant DE-NA003967 and
- National Science Foundation Grant DMS-1906446.

