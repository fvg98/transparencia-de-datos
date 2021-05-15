# -*- coding: utf-8 -*-
"""
Created on Sun Mar 21 19:03:44 2021

@author: sanch
"""
# with open('prueba2.txt', 'r',encoding="utf-8") as file:
#     data = file.read().replace('}{', '},{')

with open("prueba2.txt",encoding="utf-8") as f:
    with open("datos.txt", "w",encoding="utf-8") as f1:
        for line in f:
            cad=str(line)
            f1.write(cad.replace('}{', '},{')) 