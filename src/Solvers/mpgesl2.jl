"""
mpgesl2(AF::MPFact, b; reporting=false, verbose=true)

Use a multi-precision factorization to solve a linear system with
plain vanilla iterative refinement.
"""
function mpgesl2(AF::MPFact, b; reporting = false, verbose = true)
    #
    # What kind of problem are we dealing with?
    #
    mpdebug = false
    normtype = Inf
    TB = eltype(b)
    MPStats = getStats(AF)
    TL = MPStats.TL
    TH = MPStats.TH
    r = AF.residual
    #
    # TFact is the precision of the factors
    #
    TFact = MPStats.TFact
    #
    # Are the precisions consistent? If not, I have a bug somewhere.
    # Otherwise, set the tolerance on the iteration to 100*eps
    #
    (TH == TB) || error("inconsistent precisions")
    tolf = eps(TH)*TH.(100.0)
    #
    # Keep the records and accumulate the statistics. 
    #
    Meth = MPStats.Meth
    verbose && println(
        Meth,
        ": High precision = $TH, Low precision = $TL, Factorization storage precision = $TFact",
    )
    #
    # Showtime!
    #
    AD = AF.AH
    bnrm = norm(b, normtype)
    bsc = b
    AFS = AF.AF
    bS = TFact.(bsc)
    #
    # Initialize the iteration. I initialize to zero. That makes the
    # iteration count the same as the high precision matvec and the 
    # triangular sovles
    #
    x = zeros(TB, size(b))
    #
    # Initial residual
    #
#    r = copy(b)
    r .= b
    tol = tolf * bnrm
    rs = bS
#
#
    rhist = Vector{Float64}()
    rnrm = norm(r, normtype)
    rnrmx = rnrm * TB(1.1)
    oneb = TB(1.0)
    itc = 0
    #
    # Put initial residual norm into the history and iterate.
    #
    push!(rhist, rnrm)
    while (rnrm > tol) && (rnrm < rnrmx)
        #
        # Scale the residual
        #
        r ./= rnrm
        #
        # Use the low-precision factorization
        #
        r .= IRTriangle!(AF, r, rs, verbose)
        #
        # Undo the scaling
        #
        r .*= rnrm
        #
        # Update the solution and residual
        #
        x .+= r
        mul!(r, AD, x)
        r .*= -oneb
        axpy!(oneb, bsc, r)
        rnrmx = rnrm
        rnrm = norm(r, normtype)
        itc += 1
        push!(rhist, rnrm)
        mpdebug && println("Iteration $itc: rnorm = $rnrm, tol = $tol")
        #
        # If the residual norm increased, complain.
        #
        complain_resid = (rnrm >= rnrmx) && (rnrm > 1.e3 * tol)
        complain_resid && println("IR Norm increased: $rnrm, $rnrmx, $tol")
    end
    verbose && println("Residual history = $rhist")
    if reporting
        return (rhist = rhist, sol = x, TH = TH, TL = TL, TFact = TFact)
    else
        return x
    end
end

function getTL(AF::MPFact)
    TL = eltype(AF.AL)
    if is_heavy(AF)
    TFact = eltype(AF.AStore)
    else
    TFact = eltype(AF.AL)
    end
    return (TL, TFact)
end

function getStats(AF)
    TH = eltype(AF.AH)
    (TL, TFact) = getTL(AF)
    MPStats = MPIRStats(TH, TL, TFact)
    return MPStats
end
