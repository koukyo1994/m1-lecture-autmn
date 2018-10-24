import numpy as np
import matplotlib.pyplot as plt


def chi_square(size):
    X1 = np.random.normal(0.0, 1.0, (size, ))
    X2 = np.random.normal(0.0, 1.0, (size, ))
    return X1**2 + X2**2


def t_dist(size):
    X = np.random.normal(0.0, 1.0, (size, ))
    Y = chi_square(size)
    return np.divide(X, np.sqrt(Y / 2 + 1e-7))


def avg(t):
    avgs = []
    for i in range(t.size):
        if i == 0:
            avgs.append(t[i])
        else:
            avgs.append((avgs[i - 1] + t[i]) / (i + 1))
    return np.array(avgs)


if __name__ == "__main__":
    t = t_dist(10000)
    avgs = avg(t)
    x = np.arange(1, 10001)
    plt.plot(x, avgs)
    plt.xlabel("$n$")
    plt.ylabel("$\overline{X}_{n}$")
    plt.grid(True)
    plt.savefig("t_dist_strong_law.eps")
