function wk=blackman(N)
%Hallo la ventana de blackman

for n=0:(N-1)/2
wk(n+1)=0.42-0.5*cos((2*pi*n)/(N-1))+0.08*cos((4*pi*n)/(N-1));
end
wk=[wk(((N-1)/2)+1:-1:2) wk]';

