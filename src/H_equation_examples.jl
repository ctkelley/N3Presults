"""

H_equation_examples

Julia functions for the examples in

Newton's Method in Three Precisions
"""
#
# H-equation test 1: Float 64 and Float32 Jacobian vs MP(32,16) MPArray
#
function htest1(n = 32, c = 0.999; tol = 1.e-8, paper = false)
    maxnl = 10
    FV = zeros(n)
    JV64 = zeros(n, n)
    JV = zeros(Float32, n, n)
    JV16 = zeros(Float16, n, n)
    JVMP = MPArray(JV)
    JVMPH = MPHArray(JV)
    x0 = ones(n)
    hdata = heqinit(x0, c)
    nout64 = nsol(
        heqf!,
        x0,
        FV,
        JV64,
        heqJ!;
        rtol = tol,
        atol = tol,
        pdata = hdata,
        sham = 1,
        jfact = lu!,
        maxit = maxnl,
    )
    nout = nsol(
        heqf!,
        x0,
        FV,
        JV,
        heqJ!;
        rtol = tol,
        atol = tol,
        pdata = hdata,
        sham = 1,
        jfact = lu!,
        maxit = maxnl,
    )
    nout16 = nsol(
        heqf!,
        x0,
        FV,
        JV16,
        heqJ!;
        rtol = tol,
        atol = tol,
        pdata = hdata,
        sham = 1,
        jfact = hlu!,
        maxit = maxnl,
    )
    heavy = false
    if heavy
        mpnout = nsol(
            heqf!,
            x0,
            FV,
            JVMPH,
            jheqmp!;
            rtol = tol,
            atol = tol,
            pdata = hdata,
            sham = 1,
            jfact = mphlu!,
            maxit = maxnl,
        )
    else
        mpnout = nsol(
            heqf!,
            x0,
            FV,
            JVMP,
            jheqmp!;
            rtol = tol,
            atol = tol,
            pdata = hdata,
            sham = 1,
            jfact = mplu!,
            maxit = maxnl,
        )
    end
    mphnout = nsol(
        heqf!,
        x0,
        FV,
        JVMPH,
        jheqmph!;
        rtol = tol,
        atol = tol,
        pdata = hdata,
        sham = 1,
        jfact = mpglu!,
        maxit = maxnl,
    )
    #
    hout64 = nout64.history
    hout = nout.history
    hout16 = nout16.history
    houtmp = mpnout.history
    houtmph = mphnout.history
    Plot_Me(hout64, hout, hout16, houtmp, houtmph, paper, n, c)
    Tabulate_Me(hout64, hout, hout16, houtmp, houtmph, maxnl; TeX = true, figures = 3)
    print_stats(nout64, nout, nout16, mpnout, mphnout)
end

function store_basics(n = 32, c = 0.999, tol = 1.e-8, maxnl = 20)
    FV = zeros(n)
    JV64 = zeros(n, n)
    JV = zeros(Float32, n, n)
    JV16 = zeros(Float16, n, n)
    x0 = ones(n)
    hdata = heqinit(x0, c)
    nout64 = nsol(
        heqf!,
        x0,
        FV,
        JV64,
        heqJ!;
        rtol = tol,
        atol = tol,
        pdata = hdata,
        sham = 1,
        jfact = lu!,
        maxit = maxnl,
    )
    fname = Fname(c, n, "F64")
    writempdata(fname, nout64.history)
    l64 = length(nout64.history)
    nout = nsol(
        heqf!,
        x0,
        FV,
        JV,
        heqJ!;
        rtol = tol,
        atol = tol,
        pdata = hdata,
        sham = 1,
        jfact = lu!,
        maxit = maxnl,
    )
    fname = Fname(c, n, "F32")
    writempdata(fname, nout.history)
    l32 = length(nout.history)
    nout16 = nsol(
        heqf!,
        x0,
        FV,
        JV16,
        heqJ!;
        rtol = tol,
        atol = tol,
        pdata = hdata,
        sham = 1,
        jfact = lu!,
        maxit = maxnl,
    )
    fname = Fname(c, n, "F16")
    writempdata(fname, nout16.history)
    l16 = length(nout16.history)
    larray = [l64, l32, l16]
    fname = Fname(c, n, "Sizes")
    writetmpdata(fname, larray)
end

function Tabulate_Me(hout64, hout, hout16, houtmp, houtmph, maxnl; TeX = true, figures = 3)
    Lmax = maxnl + 1
    showtime = zeros(Lmax, 5)
    showtime .*= NaN
    n64 = length(hout64)
    n32 = length(hout)
    n16 = length(hout16)
    lmp = length(houtmp)
    lmph = length(houtmph)
    showtime[1:n64, 1] .= hout64
    showtime[1:n32, 2] .= hout
    showtime[1:n16, 3] .= hout16
    showtime[1:lmp, 4] .= houtmp
    showtime[1:lmph, 5] .= houtmph
    for ic = 1:5
        showtime[:, ic] ./= showtime[1, ic]
    end
    headers = ["F64", "F32", "F16", "IR 32-16", "IR-GM"]
    printhist(showtime, headers; TeX = TeX, figures = figures)
end

function jheqmp!(JVMP, FV, x, hdata)
    JV = JVMP.AH
    JL = JVMP.AL
    JV = heqJ!(JV, FV, x, hdata)
    TH = eltype(JVMP)
    TL = eltype(JL)
    JL .= TL.(JV)
    return JVMP
end

function jheqmph!(JVMPH, FV, x, hdata)
    JV = JVMPH.AH
    JL = JVMPH.AL
    JV = heqJ!(JV, FV, x, hdata)
    TH = eltype(JVMPH)
    TL = eltype(JL)
    JL .= TL.(JV)
    return JVMPH
end

function Plot_Me(hout64, hout, hout16, houtmp, houtmph, paper, n, c)
    n64 = length(hout64)
    n32 = length(hout)
    n16 = length(hout16)
    lmp = length(houtmp)
    lmph = length(houtmph)
    x64 = 0:1:n64-1
    x32 = 0:1:n32-1
    x16 = 0:1:n16-1
    xmp = 0:1:lmp-1
    xmph = 0:1:lmph-1
    semilogy(
        x64,
        hout64 / hout64[1],
        "k-",
        x32,
        hout / hout[1],
        "ko",
        xmp,
        houtmp / houtmp[1],
        "k--",
        x16,
        hout16 / hout16[1],
        "k-.",
        xmph,
        houtmph ./ houtmph[1],
        "k-o",
    )
    (xmin, xmax, ymin, ymax) = axis()
    axis([0.0, xmax, ymin, ymax])
    itick = ceil(xmax / 5.0)
    xticks(0:itick:xmax)
    legend(["double", "single", "IR32-16", "half", "IR-GM"])
    paper || title("Two and three precisions, N=$n, c=$c")
end

function print_stats(nout64, nout, nout16, mpnout, mphnout)
    sol = nout.solution
    sol64 = nout64.solution
    sol16 = nout16.solution
    solmp = mpnout.solution
    solmph = mphnout.solution
    hist = nout.history
    hist64 = nout64.history
    hist16 = nout16.history
    histmp = mpnout.history
    histmph = mphnout.history
    del = [norm(sol - solmp, Inf) norm(sol - solmph, Inf) norm(sol - sol16, Inf)]
    delh = norm(hist - histmph, Inf)
    lens = [length(hist64) length(hist) length(hist16) length(histmp) length(histmph)]
    println(del)
    println(lens)
    println(delh)
end
