# -*- coding: utf-8 -*-
"""
Created on Sun Apr  4 14:57:19 2021

@author: sanch
"""

import pandas as pd

dfLegisFechasNac=pd.read_csv("legislatura2018.csv",encoding="utf-8")
dfDiputadosRel=pd.read_csv("dipReelecc.csv",encoding="utf-8")
dfFiltro=pd.read_csv("diputados2018.csv",encoding="utf-8")

dfTotal=pd.merge(dfLegisFechasNac,dfDiputadosRel,on="Nombre",how="outer")
#export_csv = dfTotal.to_csv ("totalReleccion.csv",index = None, header=True, encoding="utf-8-sig")


dfFiltroTotal=pd.merge(dfFiltro,dfTotal,on="Nombre")
export_csv = dfBdTotal.to_csv ("resFinal.csv",index = None, header=True, encoding="utf-8-sig")