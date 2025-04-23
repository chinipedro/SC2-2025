clc
%% Parámetros del circuito
R = 2.2e3;      % Ohm
L = 10e-6;      % Henry
C = 100e-9;     % Farad

%% 1) Función de transferencia G(s) = Vc(s)/Vin(s)
num = 1/(L*C);
den = [1, R/L, 1/(L*C)];
G   = tf(num, den);

%% 2) Cálculo de polos
p_all = pole(G);
reals = real(p_all);
[~, idx_fast] = max(abs(reals));   p1 = p_all(idx_fast);
[~, idx_slow] = min(abs(reals));   p2 = p_all(idx_slow);

%% 3) Paso máximo de integración
Tr     = log(0.95) / p1;
tp_max = Tr / 10;

%% 4) Tiempo mínimo de simulación
tau_slow = -1 / p2;
Tsim     = 5 * tau_slow;

%% 5) Preparo integración manual para obtener estados
A = [-R/L, -1/L; 1/C, 0];
B = [1/L; 0];
Cmat = eye(2);    % Para extraer [i; vC]
Dmat = [0; 0];

t = 0:tp_max:Tsim;
u = 12 * sign(sin(2*pi*(1/0.02)*t));  % onda cuadrada ±12 V cada 10 ms

% Integro con Euler
x = [0; 0];
Il = zeros(size(t));
Vc = zeros(size(t));
for k = 1:length(t)-1
    x = x + (A*x + B*u(k)) * tp_max;
    Il(k+1) = x(1);
    Vc(k+1) = x(2);
end

%% 6) Gráficas completas
figure;

subplot(3,1,1);
plot(t, Il, 'b', 'LineWidth',1.2);
title('i(t): Corriente en el inductor');
xlabel('Tiempo [s]');
ylabel('i [A]');
grid on;

subplot(3,1,2);
plot(t, Vc, 'r', 'LineWidth',1.2);
title('v_C(t): Tensión en el condensador');
xlabel('Tiempo [s]');
ylabel('v_C [V]');
grid on;

subplot(3,1,3);
plot(t, u, 'k', 'LineWidth',1.2);
title('v_{in}(t): Tensión de entrada ±12 V cada 10 ms');
xlabel('Tiempo [s]');
ylabel('v_{in} [V]');
grid on;
