import numpy as np


def read_data(path):
    with open(path, "r") as f:
        lines = f.readlines()
    lines = [x.replace("\n", "") for x in lines]
    data = np.array([[np.float(x.split(",")[0]),
                      np.float(x.split(",")[1])] for x in lines])
    return data


if __name__ == "__main__":
    base_path = "../../data/correlation"
    data1_path = f"{base_path}1.txt"
    data2_path = f"{base_path}2.txt"
    data3_path = f"{base_path}3.txt"
    data4_path = f"{base_path}4.txt"

    data1 = read_data(data1_path)
    data2 = read_data(data2_path)
    data3 = read_data(data3_path)
    data4 = read_data(data4_path)
    data = [data1, data2, data3, data4]

    for i, d in zip([1, 2, 3, 4], data):
        print(f"Correlation{i}: {np.corrcoef(d[:, 0], d[:, 1])[0, 1]:.5f}")
