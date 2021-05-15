# -*- coding: utf-8 -*-
"""
Created on Sun Apr  4 14:39:47 2021

@author: sanch
"""

import pandas as pd

df=pd.read_csv("bd.csv",encoding="utf-8-sig")

def bdLegislatura(año,tipoLegis):
    w1=" InicioLegislatura >='"+año+"-08-01' and "
    if tipoLegis=="diputados":
        wLegis=" (TipoLegislacion=='Diputado Propietario' or TipoLegislacion=='Diputada Propietario' )"
    elif tipoLegis=="senadores": 
        wLegis=" (TipoLegislacion=='Senador Propietario' or TipoLegislacion=='Senadora Propietario' )"
    wTotal=w1+wLegis
    dfLegis=df.query(wTotal)
    return dfLegis

def guardaCsv(nombreArch,df):
    df.to_csv (nombreArch+".csv",index = None, header=True, encoding="utf-8-sig")
    
dfLegis=bdLegislatura("2018", "diputados")

guardaCsv("diputados2018",dfLegis)