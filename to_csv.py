import pandas as pd
from os import walk

f = []
for (_, __, filenames) in walk('tram'):
    f.extend(filenames)
    break

for f_ in f:
    print(f_)
    data_xls = pd.read_excel('tram/'+f_, 'Arkusz1', index_col=None)
    data_xls.to_csv('tram_csv/'+f_[:len(f_)-4]+'csv', encoding='utf-8')

print(f)