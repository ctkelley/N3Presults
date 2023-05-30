"""
Two_precision_examples()

Julia functions for the two precision examples in

Newton's Method in Three Precision
"""
function Two_precision_examples(n=4096*2, c=.999; tol=1.e-8)
FV=zeros(n);
JVD=zeros(Float64,n,n);
JV=zeros(Float32,n,n);
JV16=zeros(Float16,n,n);
x0=ones(n)
hdata=heqinit(x0,c)
nout=nsol(heqf!, x0, FV, JVD, heqJ!;
          rtol=tol, atol=tol, pdata = hdata, sham = 1, jfact=lu!, maxit=maxnl)
nout32=nsol(heqf!, x0, FV, JV, heqJ!;
          rtol=tol, atol=tol, pdata = hdata, sham = 1, jfact=lu!, maxit=maxnl)
nout16=nsol(heqf!, x0, FV, JV16, heqJ!;
          rtol=tol, atol=tol, pdata = hdata, sham = 1, jfact=lu!, maxit=maxnl)

end
