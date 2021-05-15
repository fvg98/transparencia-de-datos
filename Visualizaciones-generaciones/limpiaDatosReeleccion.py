# -*- coding: utf-8 -*-
"""
Created on Sun Apr  4 14:18:03 2021

@author: sanch
"""

with open("diputadosReelecc.txt",encoding="utf-8") as f:
    with open("dipReelecc.csv", "w",encoding="utf-8-sig") as f1:
        for line in f:
            cad=str(line)
            f1.write(cad.replace('	', ',')) 
            