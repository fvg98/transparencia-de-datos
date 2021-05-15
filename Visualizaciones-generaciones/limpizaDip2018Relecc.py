# -*- coding: utf-8 -*-
"""
Created on Thu Apr  8 09:07:55 2021

@author: sanch
"""

import pandas as pd

dfTotalRelecc=pd.read_csv("totalReleccion.csv",encoding="utf-8")


dfDipFiltro=pd.read_csv("diputados2018.csv",encoding="utf-8")
dfLegisFechasNac=pd.read_csv("legislatura2018.csv",encoding="utf-8")

prueba=pd.merge(dfLegisFechasNac,dfDipFiltro,on="Nombre",how="outer")
totDip=pd.merge(dfTotalRelecc,dfDipFiltro,on="Nombre",how="outer")

#export_csv = prueba.to_csv ("pruebaLegis.csv",index = None, header=True, encoding="utf-8-sig")
export_csv = totDip.to_csv ("totDip.csv",index = None, header=True, encoding="utf-8-sig")
#export_csv = totRelPrueba.to_csv ("totRelPrueba.csv",index = None, header=True, encoding="utf-8-sig")