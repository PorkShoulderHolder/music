import matplotlib.pylab as plt
import csv
import sys
import numpy as np

def moving_average(a, n=3) :
    ret = np.cumsum(a, dtype=float)
    ret[n:] = ret[n:] - ret[:-n]
    return ret[n - 1:] / n

with open(sys.argv[1]) as f:
    lines = filter(lambda x: len(x) > 0 and x[0].isdigit(), [l for l in csv.reader(f)])
    lines = [float(l[0]) for l in lines]
    print lines

    plt.plot(moving_average(np.array(lines), n=350))
    plt.show()
