"""
Two_precision_examples()

Julia functions for the two precision examples in

Newton's Method in Three Precision
"""
function heq2p(n=4096, c=.99; tol=1.e-8, paper=false)
FV=zeros(n);
JVD=zeros(Float64,n,n);
JV=zeros(Float32,n,n);
JV16=zeros(Float16,n,n);
maxnl=10
x0=ones(n)
hdata=heqinit(x0,c)
nout=nsol(heqf!, x0, FV, JVD, heqJ!;
          rtol=tol, atol=tol, pdata = hdata, sham = 1, jfact=lu!, maxit=maxnl)
hist64=nout.history/nout.history[1]
nout32=nsol(heqf!, x0, FV, JV, heqJ!;
          rtol=tol, atol=tol, pdata = hdata, sham = 1, jfact=lu!, maxit=maxnl)
hist32=nout32.history/nout32.history[1]
nout16=nsol(heqf!, x0, FV, JV16, heqJ!;
          rtol=tol, atol=tol, pdata = hdata, sham = 1, jfact=lu!, maxit=maxnl)
hist16=nout16.history/nout16.history[1]
plot_2_p(hist64, hist32, hist16, paper)
tab_2_p(hist64, hist32, hist16, paper)
end

function tab_2_p(hist64, hist32, hist16, paper)
psize16=length(hist16)
psize32=length(hist32)
psize64=length(hist64)
DataC=zeros(psize16,4)
DataC .= NaN
DataC[:,1]=collect(Int,0:psize16-1)
DataC[1:psize64,2].=hist64
DataC[1:psize32,3].=hist32
DataC[:,4].=hist16
headers=["n","64-64","64-32","64-16"]
formats = "%d & %9.5e & %9.5e & %9.5e"
fprintTeX(headers,formats,DataC)
end

function plot_2_p(hist64, hist32, hist16, paper)
fmtplot = ("k-", "k--", "k-.")
gxlabel = "Nonlinear Iterations"
gylabel = L"$|| F ||/||F_0||$"
ld=length(hist64); nd=0:1:ld-1
ld32=length(hist32); nd32=0:1:ld32-1
ld16=length(hist16); nd16=0:1:ld16-1
semilogy(nd,hist64,"k-",nd32,hist32,"k-.",nd16,hist16,"k--")
paper || title("Two precision Newton iterations")
legend(["double","single","half"])
(xmin, xmax, ymin, ymax) = axis()
axis([0.0, xmax, ymin, ymax])
itick=ceil(xmax/5.0)
xticks(0:1:xmax)
xlabel(gxlabel)
ylabel(gylabel)
end

function fprintTeX(headers, formats, data)
    (mr, mc) = size(data)
    @printf("\\begin{tabular}{")
    for i = 1:mc
        @printf("l")
    end
    @printf("} \n")
    for i = 1:mc-1
        @printf("%9s &", headers[i])
    end
    @printf("%9s \\\\ \n" , headers[mc])
    @printf("\\hline \n")
    #
    # I am not sure why @printf needs this, but it does.
    # See https://github.com/JuliaLang/julia/issues/4248
    #
    printf(fmt::String, args...) = @eval @printf($fmt, $(args...))
    #
    bigform = string(formats, "   \\\\ \n")
    for i = 1:mr
        printf(bigform, data[i, :]...)
    end
    @printf("\\hline \n")
    @printf("\\end{tabular} \n")
end

