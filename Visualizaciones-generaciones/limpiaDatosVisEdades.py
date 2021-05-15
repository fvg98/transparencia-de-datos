# -*- coding: utf-8 -*-
"""
Created on Sun Apr  4 14:38:25 2021

@author: sanch
"""

import pandas as pd

df=pd.read_csv("actualLegislatura.csv",encoding="utf-8-sig")

df[["Extra","Nombre"]]=df["nombre"].str.split('Dip.',1,expand=True)
df[["Nombre","Extra"]]=df["Nombre"].str.split('(',1,expand=True)
df['Nombre']=df['Nombre'].str.strip()

df=df.drop(columns=["Extra","nombre"])

df=df[['inic_edo', 'nom_edo', 'Nombre', 'tipo_elec', 'FechaNacimiento','edo', 'ent']]
df=df.sort_values(by=["Nombre","FechaNacimiento"])
export_csv = df.to_csv ("legislatura2018.csv",index = None, header=True, encoding="utf-8-sig")


