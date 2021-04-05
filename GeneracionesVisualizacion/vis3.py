# -*- coding: utf-8 -*-
"""
Created on Wed Mar 24 16:05:00 2021

@author: sanch
"""

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


dfDip=pd.read_csv("totGenDip.csv",encoding="utf-8-sig")
dfDip=dfDip.sort_values(by=["NumeroDiputados"],ascending=False)

fig,ax=plt.subplots(figsize=(10, 7))

sns.set_style("whitegrid")
sns.set_palette("RdBu")

g=sns.catplot(x="Generacion",y="NumeroDiputados",data=dfDip,kind="bar")
plt.show()
g.fig.suptitle("¿Qué generación controla la Cámara de Diputados?")
g.savefig('dipGensTotal.png', dpi=300)




