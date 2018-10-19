import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

if __name__ == "__main__":
    np.random.seed(1234)
    data = []
    for i in range(1, 11):
        size = [10000, i]
        x = np.random.normal(size=size)
        y = np.sum(np.square(x), axis=1)
        data.append(y)

    plt.figure(figsize=[10, 8])
    sns.distplot(data[0], kde_kws={"color": "k", "label": "dimension1"})
    sns.distplot(data[1], kde_kws={"color": "r", "label": "dimension2"})
    sns.distplot(data[2], kde_kws={"color": "g", "label": "dimension3"})
    sns.distplot(data[3], kde_kws={"color": "b", "label": "dimension4"})
    sns.distplot(data[4], kde_kws={"color": "y", "label": "dimension5"})
    sns.distplot(data[5], kde_kws={"color": "cyan", "label": "dimension6"})
    sns.distplot(data[6], kde_kws={"color": "purple", "label": "dimension7"})
    sns.distplot(data[7], kde_kws={"color": "orange", "label": "dimension8"})
    sns.distplot(data[8], kde_kws={"color": "gray", "label": "dimension9"})
    sns.distplot(data[9], kde_kws={"color": "brown", "label": "dimension10"})
    plt.title("Histogram of chi square distribution")
    plt.xlabel("value")
    plt.ylabel("freq")
    plt.savefig("hist.png")
