"""
N3Presults

This module has the code you need to reproduce the results in my paper
Newton's Method in Three Precisions

"""
module N3Presults


using Printf
using PyPlot
using LinearAlgebra
using SparseArrays
using SIAMFANLEquations
using SIAMFANLEquations.TestProblems
using SIAMFANLEquations.Examples

# Functions
export htest1
export heq2p
export store_basics
export readmpdata


# Files
include("MultiPrecisionArraysv0.jl")
include("H_equation_examples.jl")
#include("Two_precision_examples.jl")
# Tools
include("Tools/fprintTeX.jl")
include("Tools/printhist.jl")
include("Tools/Data_IO.jl")

end #module
