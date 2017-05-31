import matplotlib.pyplot as plt
import numpy as np
from os import walk, listdir
import pandas as pd
from time import time

def read_tram(tram_file='tram/tramwaje.xlsx'):

    df = pd.io.parsers.read_csv(tram_file)
    # df = pd.read_excel(tram_file)
    return df

f = []
for (_, __, filenames) in walk('tram_csv'):
    f.extend(filenames)
    break


#files = listdir('2017_goog_drv')

t1 = time()
trams = pd.DataFrame() #
for f_ in f:
    trams = trams.append(read_tram('tram_csv/'+f_))
    #trams = read_tram('tram_csv/' + f_)


print(time()-t1) # 2 min / csv => 5s

lines = np.sort(trams['FirstLine'].unique())

lowFloor = []
for line in lines:
    trams_line = trams[trams.FirstLine == line]
    print(f_)
    print(trams_line.shape[0])
    lf = trams_line[trams_line.LowFloor == 1].shape[0] / trams_line.shape[0] * 100
    lowFloor.append(lf)


x_ax = range(1, len(lines)+1)
plt.rcParams["figure.figsize"] = 8, 5
plt.bar(x_ax, lowFloor, align='center', color='c')
plt.title("Udział pojazdów niskopodłogowych")
plt.xlabel('Linia')
plt.ylabel('% tramwajów niskopodłogowych')
plt.xticks(x_ax, lines)
plt.savefig("niskopodlogowe.png")
plt.show()

