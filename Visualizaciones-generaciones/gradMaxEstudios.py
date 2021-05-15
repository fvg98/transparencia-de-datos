# -*- coding: utf-8 -*-
"""
Created on Thu Apr  8 20:15:11 2021

@author: sanch
"""

import pandas as pd

df=pd.read_csv("bdFinalDip.csv",encoding="utf-8-sig")

res=df.groupby("UltimoGradoEstudios").size()

dfRes=res.to_frame()
dfRes = dfRes.reset_index()
dfRes.columns=["UltimoGradoEstudios","NúmeroLegisladores"]
export_csv = dfRes.to_csv ("gradosEstudioGeneral.csv",index = None, header=True, encoding="utf-8-sig")

