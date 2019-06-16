fs=44100;
W=linspace(0,pi,3000);
F=(W/(2*pi))*fs;

%Banda pasante
figure(1)
plot(F,20*log10(blackmanmodulo));
hold on
plot(F,20*log10(hammingmodulo));
plot(F,20*log10(kaimodulo));
plot(F,20*log10(rectmodulo));
legend('Blackman','Hamming','Kaiser', 'Rectangular');
%title('Pasaaltos con ventana de Blackman');
xlabel('Frecuencia [Hz]');
ylabel('Magnitud [dB]');
v=[0,fs/2,-150,30];
axis(v);
grid on

hold off
%Banda atenuada
figure(2)
plot(F,blackmanfase);
hold on
plot(F,hammingfase);
plot(F,kaifase);
plot(F,rectfase);
legend('Blackman','Hamming','Kaiser', 'Rectangular');
%title('Pasaaltos con ventana de Blackman');
xlabel('Frecuencia [Hz]');
ylabel('Fase [grados]');
v=[0,fs/2,-10,10];
axis(v);
grid
