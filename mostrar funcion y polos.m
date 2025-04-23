%% Parámetros del circuito
R = 2.2e3;      % Ohm
L = 10e-6;      % Henry
C = 100e-9;     % Farad
%% 1) Función de transferencia G(s) = Vc(s)/Vin(s)
num_fun = 1/(L*C);
den = [1, R/L, 1/(L*C)];
G   = tf(num_fun, den);
%% 2) Cálculo de polos
p_all = pole(G);          % vector de polos (siempre en ?)
reals = real(p_all);      
% Polo rápido: el que tiene la parte real más negativa
[~, idx_fast] = max(abs(reals));  
p1 = p_all(idx_fast);
% Polo lento: el que tiene la parte real menos negativa
[~, idx_slow] = min(abs(reals));  
p2 = p_all(idx_slow);
%% 3) Paso máximo de integración
% Tr = ln(0.95)/p1  (p1 es negativo, ln(0.95)<0 ? Tr>0)
Tr     = log(0.95) / p1;
tp_max = Tr / 10;        % paso 10 veces más rápido que din. rápida
%% 4) Tiempo mínimo de simulación
tau_slow = -1 / p2;      % constante asociada al polo lento
Tsim     = 5 * tau_slow; % simular al menos 5·?_slow
%% --- Extraer coeficientes de G(s) en forma de vectores ---
[num, den] = tfdata(G, 'v');  
%% --- Imprimir función de transferencia con formato ---
fprintf('\nFunción de transferencia G(s):\n\n');
fprintf('       %.0e\n',       num_fun);                        % Numerador escalar
fprintf('  --------------\n');                            
fprintf('  %.0e s^2 + %.1e s + %.0e\n\n', den(1), den(2), den(3));  % Denominador
%% --- Obtener polos y mostrarlos con fprintf ---
p = pole(G);                              % :contentReference[oaicite:0]{index=0}
fprintf('Polos de G(s):\n');
for k = 1:length(p)
    fprintf('  p(%d) = %.4e\n', k, p(k));
end

fprintf('Polo rápido p1 = %.3e ? Tr = %.3e s\n', p1, Tr);
fprintf('  -> Paso máximo tp_max = %.3e s\n\n', tp_max);
fprintf('Polo lento p2 = %.3e ? ?_slow = %.3e s\n', p2, tau_slow);
fprintf('  -> Tiempo mínimo de simulación Tsim = %.3e s\n', Tsim);

