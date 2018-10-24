import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


def chi_square(size):
    X1 = np.random.normal(0.0, 1.0, (size, ))
    X2 = np.random.normal(0.0, 1.0, (size, ))
    return X1**2 + X2**2


def t_dist(size):
    X = np.random.normal(0.0, 1.0, (size, ))
    Y = chi_square(size)
    return np.divide(X, np.sqrt(Y / 2 + 1e-7))


def avg(t):
    return t.mean()


if __name__ == "__main__":
    color = ["r", "g", "b", "y", "k", "orange"]
    plt.figure()
    plt.ylabel("frequency")
    for i, c in enumerate(color):
        avgs = np.array([avg(t_dist(i + 1)) for _ in range(10000)])
        mean = avgs.mean()
        normalized = ((avgs - mean) / (1.0 / np.sqrt(i + 1)))
        sns.distplot(normalized, color=c, label=f"n={i+1}")
    plt.legend()
    plt.xlim(-10, 10)
    plt.savefig("t_dist_ultimate.eps")
