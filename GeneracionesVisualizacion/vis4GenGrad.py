# -*- coding: utf-8 -*-
"""
Created on Thu Apr  8 17:04:23 2021

@author: sanch
"""
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

df=pd.read_csv("totDip.csv",encoding="utf-8-sig")

def graficaGenPart(titulo,colores,nombre):
    
    wSil=" FechaNacimiento >='1928-01-01' & FechaNacimiento <='1945-12-31' "
    genSilenciosa=df.query(wSil)
    print("Generación silenciosa (1928 a 1945)")
    print(genSilenciosa.count())
    res1=genSilenciosa.groupby("UltimoGradoEstudios").size()
    
    total=res1.to_frame()
    total = total.reset_index()
    
    wBoomers=" FechaNacimiento >='1946-01-01' and FechaNacimiento <'1964-12-31'  "
    genBoomer=df.query(wBoomers)
    print("Generación Boomers (1946 a 1964)")
    print(genBoomer.count())
    res2=genBoomer.groupby("UltimoGradoEstudios").size()
    total=pd.merge(total,res2.to_frame(),on="UltimoGradoEstudios",how="outer")
    
    wX=" FechaNacimiento >='1965-01-01' and FechaNacimiento < '1980-01-31'  "
    genX=df.query(wX)
    print("Generacion X (1965 a 1980)")
    print(genX.count())
    res3=genX.groupby("UltimoGradoEstudios").size()
    total=pd.merge(total,res3.to_frame(),on="UltimoGradoEstudios",how="outer")
    
    wMill=" FechaNacimiento >='1981-01-01' and FechaNacimiento < '1996-01-31'  "
    genMillenial=df.query(wMill)
    print("Generacion Millenials (1981 a 1996)")
    print(genMillenial.count())
    res4=genMillenial.groupby("UltimoGradoEstudios").size()
    total=pd.merge(total,res4.to_frame(),on="UltimoGradoEstudios",how="outer")
    
    
    total.columns=["UltimoGradoEstudios","Silenciosa","Boomers","GenX","Millenials"]
    total=total.replace(np.nan, 0)
    total["Total"]=total.sum(axis=1)
    total=total.sort_values(by=["Total"],ascending=False)
    
    # plt.rcParams["font.family"] = "corbel"
    # plt.rcParams["font.size"] = 15
    # fig, ax = plt.subplots(figsize=(10, 7))
    
    # ax.barh(total["UltimoGradoEstudios"],total["Silenciosa"],
    #         color=colores[0],
    #         label="Generación Silenciosa (1928 a 1945)")
    # ax.barh(total["UltimoGradoEstudios"],total["Boomers"],
    #         left=total["Silenciosa"],
    #         color=colores[1],
    #         label="Boomers (1946 a 1965)")
    # ax.barh(total["UltimoGradoEstudios"],total["GenX"],
    #         left=total["Silenciosa"]+total["Boomers"],
    #         color=colores[2],
    #         label="Generación X (1966 a 1980)")
    # ax.barh(total["UltimoGradoEstudios"],total["Millenials"],
    #         left=total["Silenciosa"]+total["Boomers"]+total["GenX"],
    #         color=colores[3],
    #         label="Millenials (1981 a 1996)")
    # ax.set_ylabel("UltimoGradoEstudios")
    # ax.set_xlabel("Número de legisladores")
    # ax.set_title(titulo)
    # ax.legend()
    # plt.show()
    # fig.savefig(nombre+'.png', dpi=300)
    return total

coloresDip=["tomato","mediumvioletred","slateblue","teal"]
tituloDip="¿Qué generación controla la Camará de Diputados? Grado maximo de estudios"
totalDip=graficaGenPart(tituloDip,coloresDip,"diputadosGenGradMax")

export_csv = totalDip.to_csv ("ultGrad2018.csv",index = None, header=True, encoding="utf-8-sig")
