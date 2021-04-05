# -*- coding: utf-8 -*-
"""
Created on Thu Mar 18 16:50:56 2021

@author: sanch
"""

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

df=pd.read_csv("totalReleccion.csv",encoding="utf-8-sig")


def graficaGenPart(titulo,colores,nombre):
    
    wSil=" FechaNacimiento >='1928-01-01' & FechaNacimiento <='1945-12-31' "
    genSilenciosa=df.query(wSil)
    print("Generacion silenciosa (1928 a 1945)")
    print(genSilenciosa.count())
    res1=genSilenciosa.groupby("Partido").size()
    
    total=res1.to_frame()
    total = total.reset_index()
    
    wBoomers=" FechaNacimiento >='1946-01-01' and FechaNacimiento <'1964-12-31'  "
    genBoomer=df.query(wBoomers)
    print("Generacion Boomers (1946 a 1964)")
    print(genBoomer.count())
    res2=genBoomer.groupby("Partido").size()
    total=pd.merge(total,res2.to_frame(),on="Partido",how="outer")
    
    wX=" FechaNacimiento >='1965-01-01' and FechaNacimiento < '1980-01-31'  "
    genX=df.query(wX)
    print("Generacion X (1965 a 1980)")
    print(genX.count())
    res3=genX.groupby("Partido").size()
    total=pd.merge(total,res3.to_frame(),on="Partido",how="outer")
    
    wMill=" FechaNacimiento >='1981-01-01' and FechaNacimiento < '1996-01-31'  "
    genMillenial=df.query(wMill)
    print("Generacion Millenials (1981 a 1996)")
    print(genMillenial.count())
    res4=genMillenial.groupby("Partido").size()
    total=pd.merge(total,res4.to_frame(),on="Partido",how="outer")
    
    
    total.columns=["Partido","Silenciosa","Boomers","GenX","Millenials"]
    total=total.replace(np.nan, 0)
    total["Total"]=total.sum(axis=1)
    total=total.sort_values(by=["Total"],ascending=False)
    
    plt.rcParams["font.family"] = "corbel"
    plt.rcParams["font.size"] = 15
    fig, ax = plt.subplots(figsize=(10, 7))
    
    ax.barh(total["Partido"],total["Silenciosa"],
            color=colores[0],
            label="Generación Silenciosa (1928 a 1945)")
    ax.barh(total["Partido"],total["Boomers"],
            left=total["Silenciosa"],
            color=colores[1],
            label="Boomers (1946 a 1965)")
    ax.barh(total["Partido"],total["GenX"],
            left=total["Silenciosa"]+total["Boomers"],
            color=colores[2],
            label="Generación X (1966 a 1980)")
    ax.barh(total["Partido"],total["Millenials"],
            left=total["Silenciosa"]+total["Boomers"]+total["GenX"],
            color=colores[3],
            label="Millenials (1981 a 1996)")
    ax.set_ylabel("Partido")
    ax.set_xlabel("Número de legisladores")
    ax.set_title(titulo)
    ax.legend()
    plt.show()
    fig.savefig(nombre+'.png', dpi=300)
    return total

def guardaCsv(nombreArch,df):
    df.to_csv (nombreArch+".csv",index = None, header=True, encoding="utf-8-sig")

coloresDip=["forestgreen","limegreen","seagreen","darkgreen"]
tituloDip="¿Qué generación controla la Camará de Diputados?"
totalDip=graficaGenPart(tituloDip,coloresDip,"diputadosGenPart")





