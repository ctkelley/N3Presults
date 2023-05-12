"""
H_equation_examples

Julia functions for the examples in

Newton's Method in Three Precisions
"""
#
# H-equation test 1: Float32 Jacobian vs MP(32,16) MPArray
#
function htest1(n=32, c=.999)
FV=zeros(n);
JV=zeros(Float32,n,n);
JVD=zeros(Float64,n,n);
JV16=zeros(Float16,n,n);
JVMP=MPArray(JV);
JVMPD=MPArray(JVD);
x0=ones(n);
tol=1.e-8
dohalf=false
hdata = heqinit(x0, c);
nout=nsol(heqf!, x0, FV, JV, heqJ!;
          rtol=tol, atol=tol, pdata = hdata, sham = 1, jfact=lu!)
nout16=nsol(heqf!, x0, FV, JV16, heqJ!;
          rtol=tol, atol=tol, pdata = hdata, sham = 1, jfact=lu!)
mpnout=nsol(heqf!, x0, FV, JVMP, jheqmp!;
          rtol=tol, atol=tol, pdata = hdata, sham = 1, jfact=mplu!)
#
n32=length(nout.history)
x32=0:n32-1
n16=length(nout16.history)
x16=0:n16-1
lmp=length(mpnout.history)
xmp=0:lmp-1
semilogy(x32,nout.history,"k-",xmp,mpnout.history,"k--",
         x16,nout16.history,"k-.")
legend(["F32","IR32-16","F16"])
title("Single and half, IR, N=$n, c=$c")
end

function jheqmp!(JVMP, FV, x, hdata)
JV=JVMP.AH
JL=JVMP.AL
JV = heqJ!(JV, FV, x, hdata)
TH=eltype(JVMP)
TH == Float32 ? TL = Float16 : TL = Float32
JL .= TL.(JV)
return JVMP
end

