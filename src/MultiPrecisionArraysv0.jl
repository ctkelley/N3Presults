#
# This is MPArrays.jl
# The package has data structures and algorithms to manage several
# variations on iterative refinement.
#

include("Structs4MP/MPLight.jl")
include("Structs4MP/MPHeavy.jl")
include("Factorizations/Factorizations.jl")
include("Factorizations/hlu!.jl")
include("Factorizations/mplu!.jl")

MPIRArray = Union{MPArray,MPHArray}

#MPLArray = Union{MPArray,MPEArray}

MPFact = Union{MPLFact,MPLEFact,MPHFact}

on_the_fly(x::MPArray) = false
on_the_fly(x::MPEArray) = true
on_the_fly(x::MPLFact) = false
on_the_fly(x::MPLEFact) = true
on_the_fly(x::MPHFact) = true

MPLFacts = Union{MPLFact,MPLEFact}

import Base.eltype
function eltype(MP::MPArray)
    TP = eltype(MP.AH)
    return TP
end

function eltype(MPH::MPHArray)
    TP = eltype(MPH.AH)
    return TP
end

import Base.\
function \(AF::MPLFact, b; verbose = false, reporting = false)
    xi = mpgesl2(AF, b; verbose = verbose, reporting = reporting)
    return xi
end

function \(AF::MPLEFact, b; verbose = false, reporting = false)
    xi = mpgesl2(AF, b; verbose = verbose, reporting = reporting)
    return xi
end

function \(AF::MPHFact, b; verbose = false, reporting = false)
    xi = mpgesl2(AF, b; verbose = verbose, reporting = reporting)
    return xi
end

function \(AF::MPGHFact, b; verbose = false, reporting = false)
    xi = mpgmir(AF, b; verbose = verbose, reporting = reporting)
    return xi
end

#
# hlu and hlu! are hacks of the Julia generic_lu source. I've used
# Polyester.jl to thread them and done some tweaking. On
# my Mac M2 Pro with 8 performace cores I'm seeing a 10x speedup
# over where I was before and seem to be using the hardware support
# for half precision as well as I can. I am still 5x slower than
# the LAPACK double precision LU, so there's a factor of 20 out there
# somewhere.
#
export hlu!
export hlu
#
# I'm exporting the multiprecision factorizations so you can pass
# them to nonlinear solvers and eigen solvers.
#
export mplu!
export mphlu!
export mpglu!
export mpqr!
export mpcholesky!
#
# The solvers are mpgesl2 (iterative refinement) and mpgmir (IR-GMRES).
# I'm not working on more than that right now. I have overloaded
# \ with these so you should not have to call them directly unless
# you are looking at iteration statistics
#
export mpgesl2
export mpgmir
#
# Each MPArray data structure comes with a structure to store a factorization.
# The differences are whether one does on-the-fly interprecision transfers
# of not. For plain IR, I think the answer is clear (NO) and you should
# MPArray and MPLFact instead of MPEArray and MPLEFact. The factorization
# structures shoule be invisible to most people and I may stop exporting
# them. 
#
# Ffor IR-GMRES, it's more subtle. The cost of Heavy IR with MPHArray
# and MPGHFact is an extra
# high precision matrix. If you can afford the storage and communication
# burden, it's a good thing to do. If you can't, on-the-fly is your
# only option.
#
export MPArray
export MPLArray
export MPHArray
#
#
#
export MPLFact
export MPGHFact
#
#
#
export MPEArray
export MPFArray
export MPHFact
export MPLEFact
export MPhatv
export MPhptv
#
# The data structres for statistics are almost surely not 
# interesting to anyone but me. I will document how one can
# use the solvers to get the stats sooner or later.
#
export MPGStats
export MPIRStats

include("Solvers/mpgmir.jl")
include("Solvers/mpgesl2.jl")
include("Solvers/IRTriangle.jl")
include("Structs4MP/MPStats.jl")
