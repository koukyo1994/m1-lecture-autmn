import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


def chi_square(size):
    X1 = np.random.normal(0.0, 1.0, (size, ))
    X2 = np.random.normal(0.0, 1.0, (size, ))
    return X1**2 + X2**2


def chi_avg(chi):
    return chi.mean()


if __name__ == "__main__":
    color = ["r", "g", "b", "y", "k", "orange"]
    plt.figure()
    plt.ylabel("frequency")
    for i, c in enumerate(color):
        avg = [chi_avg(chi_square(i + 1)) for _ in range(10000)]
        sns.distplot(avg, color=c, label=f"n={i+1}")
    plt.legend()
    plt.savefig("chi_square_ultimate.eps")
