
clear all
close all
fs=48000;
order=500;


%Specificacions 

F=[1000 1200 3800 4000  5000 5200  7800  8000  9000  9200 ]; % Band edges
A=[1    0    1     0    1    0   ];  % Ideal Gain 
W=[.3, .01, 0.6,   0.1,.3,   0.01 ]; % Weight

%Design
[n,fo,mo,w] = firpmord(F ,A ,W , fs)   %Calcula el orden minimo necesario
h = firpm(n+1,fo,mo,w);                %Calcula h(n)
 

%Plot frecuency response

W=linspace(0,pi,3000);		%genera un vector de 3000 puntos en W
a=1;																																									
																						%																						jw
[H,W]=freqz(h,a,W);   		%calculo el vector H(ejwt)
							%h es el denominador, a el numerador (a=1 en un FIR)
F=(W/(2*pi))*fs;			%cambio de escala en el eje x de manera que Ws=1
  		  			
modulo=abs(H);
fase=angle(H);

plot(F,20*log10(modulo));
xlabel('Frecuencia [Hz]');
ylabel('Magnitud [dB]');
grid on


gain = abs(polyval(h,1));
h = h/gain;
gain

%Salvo coeficientes (h(n))
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

!asm filtro  % compile and link 
!lnk filtro  % executable code is filtro.cld


