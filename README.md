# N3Presults: notebook for Newton's Method in Three Precisions
This Git repo supports my paper 

C. T. Kelley, [_Newton's Method in Three Precisions_](https://arxiv.org/abs/2307.16051), 2023

__Use the latest release of Julia (1.9.3) with this stuff!!!__ 

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
- Polyester

When you install these packages, espcially, SIAMFANLEquations you will also install many other packages. If you have not installed them already, that could take a bit of time.

## Running the codes
To run the notebook 

- clone this repositoory
- go to the directory for the clone __on your filesystem__
- start Julia
- Type ```notebook(;dir=pwd())``` at the julia prompt
- click on the notebook ```N3Presults.ipynb```
- The notebook should open. When it does click on ```cell``` and select the ```run all``` option.

## The tricky stuff.
To fully understand this material you'll need to understand how to use ```nsol.jl``` from [SIAMFANLEquations.jl](https://github.com/ctkelley/SIAMFANLEquations.jl). The solver is well documented in the 
[book](https://my.siam.org/Store/Product/viewproduct/?ProductId=44313635) and the 
[notebook](https://github.com/ctkelley/NotebookSIAMFANL).

I manage the coupling of iterative refinement and the nonlinear solver with a data structure ```MPArray```. I am building a package for this, but it will not be done in time for this paper. I've put a preliminary version in file ```src/MultiPrecisionArraysv0.jl``` that works for this repo. It is not completely documented nor have I made any final decsions on the user interface. The package repo is [MultiPrecisionArrays.jl](https://github.com/ctkelley/MultiPrecisionArrays.jl), but I have not registered it or announced it

The final runs for the paper were sith Julia 1.10-beta3. The tables in the notebooks were with 1.9.3. The iteration statistics are a bit different, but the bottom line results are the same. You may get other modestly different results with other operations systems or CPUs.

## Funding
This work was partially supported by
- US Department of Energy grant DE-NA003967 and
- National Science Foundation Grant DMS-1906446.

