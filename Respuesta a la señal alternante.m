clc; clear;

% Parámetros
R = 2.2e3;     % ?
L = 10e-6;     % H
C = 100e-9;    % F

% Modelo espacio-estado
A = [-R/L, -1/L;
      1/C,   0];
B = [1/L; 0];
Cmat = [1, 0;     % i = x1
         0, 1];   % vC = x2
Dmat = zeros(2,1);

sys = ss(A, B, Cmat, Dmat);    % crea el sistema

% Tiempo de simulación
dt    = 1e-5;    % 10 ?s, suficiente para capturar la dinámica lenta
T_end = 0.1;     % 100 ms (5 conmutaciones de 20ms)
t     = (0:dt:T_end)';

% Entrada ±12 V cada 10 ms (onda cuadrada)
u = 12 * square(2*pi*(1/0.02)*t);  

% Simulación con solver interno
[y,~,~] = lsim(sys, u, t);

% Extraer señales
iL  = y(:,1);    % corriente
vC  = y(:,2);    % tensión en C
vIn = u;         % tensión de entrada

% Graficar
figure(1);
plot(t, vIn, 'k');
title('v_{in}(t) = ±12 V cada 10 ms');
xlabel('t [s]'); ylabel('V [V]');
grid on;

figure(2);
subplot(3,1,1)
plot(t, iL, 'r')
title('i(t): Corriente en I_L');
xlabel('t [s]'); ylabel('i [A]');
grid on

subplot(3,1,2)
plot(t, vC, 'b')
title('v_C(t): Tensión en el condensador');
xlabel('t [s]'); ylabel('v_C [V]');
grid on

subplot(3,1,3)
plot(t, vIn, 'm')
title('v_{in}(t): Tensión de entrada');
xlabel('t [s]'); ylabel('v_{in} [V]');
grid on

