import numpy as np
from scipy.integrate import odeint
import matplotlib.pyplot as plt

# Parámetros del circuito
R = 220    # Ω
L = 0.5    # H
C = 2.2e-6 # F

# Matrices del sistema
A = np.array([[-R/L, -1/L],
              [1/C,    0 ]])
B = np.array([1/L, 0])
C = np.array([R, 0])  # Salida: v_R = R * i_L

# Función de entrada (±12V cada 10ms)
def entrada(t):
    periodo = 0.02  # Período total de 20ms (10ms alto + 10ms bajo)
    return 12 * np.sign(np.sin(2 * np.pi * t / periodo))

# Ecuaciones diferenciales
def modelo(x, t):
    u = entrada(t)
    dxdt = A @ x + B * u
    return dxdt

# Tiempo de simulación (0 a 0.1 segundos con paso de 1μs)
t = np.arange(0, 0.1, 1e-6)
x0 = [0, 0]  # Condiciones iniciales: i_L=0, v_C=0

# Resolver ecuaciones
solucion = odeint(modelo, x0, t)

# Extraer resultados
i_L = solucion[:, 0]    # Corriente en el inductor
v_C = solucion[:, 1]    # Tensión en el capacitor
v_R = C @ solucion.T    # Tensión en la resistencia (salida)

# Graficar
plt.figure(figsize=(10, 6))
plt.plot(t, v_R, 'b', label='$v_R(t)$ (V)')
plt.plot(t, v_C, 'r', label='$v_C(t)$ (V)')
plt.xlabel('Tiempo (s)')
plt.ylabel('Amplitud')
plt.title('Respuesta del Circuito RLC con Salida en $v_R(t)$')
plt.legend()
plt.grid(True)
plt.show()