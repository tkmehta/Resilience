import matplotlib.pyplot as mp
import numpy as np
import datetime

ALPHA_RANGE=11
alphaValues = [(a * 0.1) for a in range(0,ALPHA_RANGE)]

recoveryTime5k = [ [10.5, 10.1, 9.7, 9.4, 9.94, 10.40, 11.89, 12.23, 12.78, 13.19, 13.46], 
[13.41, 13.39, 13.33, 13.395, 13.42, 13.47, 13.59, 13.74, 14.06, 14.34, 15.1], 
[67.51771763665175, 67.30372962675884, 68.20164943946357, 69.39125987575916, 70.35831585055158, 72.38402735847404, 74.9872, 79.78755354473324, 83.61967444317916, 86.68875287998237, 89.98608881548687]]

recoveryTime10k = [ [17.87, 17.2, 16.8, 16.4, 16.98, 17.52, 18.23, 18.92, 19.61, 20.24, 21.08],
[21.39, 20.63, 19.72, 20.53, 21.66, 22.57, 23.34, 24.29, 25.72, 26.72, 27.92],
[106.5940463671969, 105.45571169884802, 107.61785352209284, 112.00277562911025, 118.60938785903679, 119.90154110901209, 122.65081770162676, 130.03082111038333, 133.07053905083208, 134.45143289500254, 136.21687099105034]
]
recoveryTime20k = [ [21.49, 20.39, 19.48, 18.31, 19.24, 20.29, 21.39, 22.54, 23.68, 24.94, 26.01], 
[25.37, 24.12, 23.34, 24.37, 25.64, 26.83, 27.94, 29.1, 30.3, 31.84, 32.89], 
[122.63349998705368, 116.8683853954721, 118.34089847250301, 125.24846163576997, 130.54052043024416, 136.3855394163159, 135.77396079458995, 137.94094006923083, 146.85066990338598, 147.4648868900078, 149.76868694328758] ]

recoveryTime40k = [ [22.86, 22.24, 21.78, 21.21, 21.84, 22.50, 23.14, 23.82, 24.48, 26.2, 27.44], 
[27.14, 26.36, 25.18, 25.92, 26.73, 27.52, 28.12, 29.07, 30.89, 31.47, 32.97], 
[125.32942054882379, 115.91619143443098, 121.09839147428573, 121.18864733837009, 127.5976081828346, 133.04475040006557, 144.67002358989404, 153.06983076293372, 159.67778300811224, 168.6424251050558, 170.62758049320013]]


mp.rc('text', usetex=True)
mp.rc('font', family='serif')
    
graph = mp.figure()
graph.show()
ax = graph.add_subplot(111)

alphaValues = np.array(alphaValues)

ax.plot(alphaValues, np.array(recoveryTime5k[0]), c='b',marker="^",ls='--',label=r'$n = 5000$')
ax.plot(alphaValues, np.array(recoveryTime10k[0]),c='g',marker=(8,2,0),ls='--',label=r'$n = 10000$')
ax.plot(alphaValues, np.array(recoveryTime20k[0]),c='k',ls='-',label=r'$n = 20000$')
ax.plot(alphaValues, np.array(recoveryTime40k[0]),c='r',marker="v",ls='-',label=r'$n = 40000$')
mp.title(r"$k = 1$", size=15)
mp.xlabel(r'$\rho$ Value', size=12)
mp.ylabel('Average Recovery Time', size=12)
mp.legend(loc=2)
mp.savefig('Plots/k1' + ' ' + str(datetime.datetime.now()) + '.jpg')
mp.close()

graph = mp.figure()
graph.show()
ax = graph.add_subplot(111)

ax.plot(alphaValues, np.array(recoveryTime5k[1]), c='b',marker="^",ls='--',label=r'$n = 5000$')
ax.plot(alphaValues, np.array(recoveryTime10k[1]),c='g',marker=(8,2,0),ls='--',label=r'$n = 10000$')
ax.plot(alphaValues, np.array(recoveryTime20k[1]),c='k',ls='-',label=r'$n = 20000$')
ax.plot(alphaValues, np.array(recoveryTime40k[1]),c='r',marker="v",ls='-',label=r'$n = 40000$')
mp.title(r"$k = 3$", size=15)
mp.xlabel(r'$\rho$ Value', size=12)
mp.ylabel('Average Recovery Time', size=12)
mp.legend(loc=2)
mp.savefig('Plots/k3' + ' ' + str(datetime.datetime.now()) + '.jpg')
mp.close()

graph = mp.figure()
graph.show()
ax = graph.add_subplot(111)

ax.plot(alphaValues, np.array(recoveryTime5k[2]), c='b',marker="^",ls='--',label=r'$n = 5000$')
ax.plot(alphaValues, np.array(recoveryTime10k[2]),c='g',marker=(8,2,0),ls='--',label=r'$n = 10000$')
ax.plot(alphaValues, np.array(recoveryTime20k[2]),c='k',ls='-',label=r'$n = 20000$')
ax.plot(alphaValues, np.array(recoveryTime40k[2]),c='r',marker="v",ls='-',label=r'$n = 40000$')
mp.title(r"$k = 5$", size=15)
mp.xlabel(r'$\rho$ Value', size=12)
mp.ylabel('Average Recovery Time', size=12)
mp.legend(loc=2)
mp.savefig('Plots/k5' + ' ' + str(datetime.datetime.now()) + '.jpg')
mp.close()
