function wk=hamming(N)
%Hallo la ventana de hamming

for n=0:(N-1)/2
wk(n+1)=.54+.46*cos((2*pi*n)/(N-1));
end
wk=[wk(((N-1)/2)+1:-1:2) wk]';