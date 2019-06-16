hold off
close all

% Especificaciones: high pass con:
fs=44100 ;
fp=1e3;
fa=2e3;
Ap=2;
Aa=20;

%'Calculo de alfa y N'

deltaa=10^(-.05*Aa);
deltap=(10^(.05*Ap)-1)/(10^(.05*Ap)+1);
delta=min([deltaa,deltap]);
Aa=-20*log10(delta);			           %nuevo

if Aa<= 21
 alfa=0
else  if Aa<=50
        alfa=.5842*(Aa-21)^0.4+0.07886*(Aa-21)
      else
        alfa=.1102*(Aa-8.7)
		end
end

if Aa<= 21
 D=.9222;
else
 D=(Aa-7.95)/14.36;
end

N=fs*D/(fa-fp)+1;
N=ceil(N);

%==========================================================================

if(N/2-fix(N/2)==0)  %Fuerzo N Impar
 N=N+1;
end

%==========================================================================

%Normalizamos respecto de fs

fp=fp/fs;
fa=fa/fs;
fc=(fp+fa)/2;	 %frecuencia de corte normalizada respecto de fs


%===========================Construccion de la h(n)====================================
n=1:(N-1)/2;
h(n)=-2*fc*(sin(2*pi*fc*n)./(2*pi*fc*n)); % h(n) for Lowpass
h=[ h(((N-1)/2 ):-1:1) 1-2*fc h];          % La hacemos causal 
%==========================================================================
% Multiplicamos por la ventana rectangular

h=h.*rect(N)';


%=================Normalizamos la respuesta en frecuencia del filtro en banda pasante=====================================

F0dB=6000;                       % F0dB es la frecuencia donde la ganancia del filtro debe ser unitaria ( 0 dB) esto es la banda pasante del filtro
Zo=exp(-1j*2*pi*F0dB*1/fs);    % Z=e-jWT
gain = abs(polyval(h,Zo));    % mod H(ejWT) evaluado en F0dB que es la ganancia actual del filtro en esa frecuencia
h = h/gain;                   % Normalizamos la h de esta manera los coeficentes del filtro no superan la unidad 
%====================================================================================================================


%==============================grafica h(n)====================
%c=size(h);
%n=1:c(2);
%[xx,yy]=bar(n,h);
%plot(xx,yy);
%stem(h);
%================================================================


W=linspace(0,pi,3000);		%genera un vector de 3000 puntos e
a=1;																																									
%jw
[H,W]=freqz(h,a,W);   		%calculo el vector H(ejwt) 	%h es el denominador, a el numerador (a=1 en un FIR)
F=(W/(2*pi))*fs;			%cambio de escala en el eje x de manera que Ws=1
  		  			


modulo=abs(H);
fase=angle(H);


%Banda pasante
figure(1)
plot(F,20*log10(modulo));
title('Pasaaltos con ventana rectangular');
xlabel('Frecuencia [Hz]');
ylabel('Magnitud [dB]');
v=[0,fs/2,-50,10];
axis(v);
grid on

%Banda atenuada
figure(2)
plot(F,fase);
title('Pasaaltos con ventana rectangular');
xlabel('Frecuencia [Hz]');
ylabel('Fase [grados]');
v=[0,fs/2,-10,10];
axis(v);
grid




%Salvo coeficientes (h(n)) para el DSP56300
h=h';
ntaps=length(h)

fid = fopen('coef.txt','w');

    fprintf(fid,'coef\tequ\t*\r\n');
    fprintf(fid,'\r\n');
    fprintf(fid,'\t\t\tdc\t%0.9f \r\n',h);
    fprintf(fid,'\r\n');
    fprintf(fid,'\r\n');
    fprintf(fid,'ntaps\tequ\t%u \r\n',ntaps);

fprintf(fid,'\r\n');

fclose(fid);

% Compile 
!asm filtro  % compile and link 
!lnk filtro  % executable code is filtro.cld


