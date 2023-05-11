"""
N3Presults

This module has the code you need to reproduce the results in my paper
Newton's Method in Three Precisions

"""
module N3Presults


using PyPlot
using LinearAlgebra
using SparseArrays
using SIAMFANLEquations
using SIAMFANLEquations.TestProblems
using SIAMFANLEquations.Examples

# Functions
export htest1

# Files
include("MPArraysv0.jl")
include("H_equation_examples.jl")

end #module
