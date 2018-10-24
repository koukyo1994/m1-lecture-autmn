import numpy as np
import matplotlib.pyplot as plt


def calc_chi_square(size):
    X1 = np.random.normal(0.0, 1.0, (size, ))
    X2 = np.random.normal(0.0, 1.0, (size, ))
    return X1**2 + X2**2


def calc_avg(y):
    avgs = []
    for i in range(y.size):
        if i == 0:
            avgs.append(y[i])
        else:
            avgs.append((avgs[i - 1] + y[i]) / (i + 1))
    return np.array(avgs)


if __name__ == "__main__":
    y = calc_chi_square(10000)
    avgs = calc_avg(y)
    x = np.arange(1, 10001)

    plt.plot(x, avgs)
    plt.xlabel("$n$")
    plt.ylabel("$\overline{X}_{n}$")
    plt.grid(True)
    plt.savefig("chi_square_strong_row.eps")
