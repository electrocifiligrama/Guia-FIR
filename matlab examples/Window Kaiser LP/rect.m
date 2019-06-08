function wk=rect(N)
%Hallo la ventana de kaiser

for n=0:(N-1)/2
wk(n+1)=1;
end
wk=[wk(((N-1)/2)+1:-1:2) wk]';
