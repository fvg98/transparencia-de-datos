# -*- coding: utf-8 -*-
"""
Created on Tue Mar 16 18:29:47 2021

@author: sanch
"""
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


df = pd.read_json ("datos.json",encoding="utf-8")

def cleanData(df):
    df=df.drop(columns=["Experiencia legislativa:","Toma de protesta:"])
    df=df.rename(columns={"Nombre:":"Nombre","Último grado de estudios:":"UltimoGradoEstudios",
                        "Preparación académica:":"PreparacionAcademica","Zona:":"Zona",
                        "Principio de elección:":"PrincipioEleccion","Nacimiento:":"Nacimiento",
                        "Partido:":"Partido"})
    
    df[["TipoLegislacion","Resto"]]=df["Nombre"].str.split(':',1,expand=True)
    df[["Nombre","Legislatura"]]=df["Resto"].str.split('por',1,expand=True)
    df[["Extra","Legislatura"]]=df["Legislatura"].str.split('la',1,expand=True)
    df[["Extra2","Periodo de la legislatura"]]=df["Periodo de la legislatura:"].str.split('Del',1,expand=True)
    df[["InicioLegislatura","FinLegislatura"]]=df["Periodo de la legislatura"].str.split('al',1,expand=True)
    df[["FechaNacimiento","LugarNacimiento"]]=df["Nacimiento"].str.split('Entidad:',1,expand=True)
    df[["Extra3","FechaNacimiento"]]=df["FechaNacimiento"].str.split(':',1,expand=True)
    df[["LugarNacimiento","Extra3"]]=df["LugarNacimiento"].str.split('Ciudad:',1,expand=True)
    df[["Apellido","Nombre"]]=df["Nombre"].str.split(',',1,expand=True)
    
    df['Nombre']=df['Nombre'].str.strip()
    df['Apellido']=df['Apellido'].str.strip()
    df["Nombre"]=df["Nombre"]+" "+df["Apellido"]
    
    df[["Extra4","Zona"]]=df["Zona"].str.split(':',1,expand=True)
    
    df["Legislatura"]=df["Legislatura"].str.replace("Legislatura","")
    df["Legislatura"]=df["Legislatura"].str.strip()
    
    df=df.drop(columns=["Extra4","Extra","Resto",
                        "Extra2","Periodo de la legislatura","Nacimiento","Extra3",
                        "Periodo de la legislatura:"])
    
    df=df[['CURP','Nombre','TipoLegislacion','Partido','FechaNacimiento','LugarNacimiento',
            'PrincipioEleccion', 'Zona',"UltimoGradoEstudios", 
            'PreparacionAcademica','Legislatura',"InicioLegislatura","FinLegislatura"]]
    
    df['FechaNacimiento']=df['FechaNacimiento'].str.strip()
    df['InicioLegislatura']=df['InicioLegislatura'].str.strip()
    df['FinLegislatura']=df['FinLegislatura'].str.strip()
    
    for index in df.index:
        if "N/A" in df.loc[index,'FechaNacimiento']:
            df.loc[index,'FechaNacimiento'] = "01/01/1900"
        if  df.loc[index,'FechaNacimiento'] is None:
            df.loc[index,'FechaNacimiento'] = "01/01/1900"
      
    df['FechaNacimiento'] =  pd.to_datetime(df['FechaNacimiento'], 
                                              format="%d/%m/%Y")
    df['InicioLegislatura'] =  pd.to_datetime(df['InicioLegislatura'], 
                                              format="%d/%m/%Y")
    df['FinLegislatura'] =  pd.to_datetime(df['FinLegislatura'], 
                                              format="%d/%m/%Y")
    df=df.sort_values(by=["InicioLegislatura","Nombre"])
    return df

df=cleanData(df)
# w1=" FechaNacimiento >'01/01/1900' & FechaNacimiento <='31/12/1945' and "
# w2=" InicioLegislatura >='1/08/2018' and "
# w3=" (TipoLegislacion=='Diputado Propietario' or TipoLegislacion=='Diputada Propietario' )"
# consulta=w1+w2+w3
# sel="select count(Partido), Partido from df"
# w4=" where FechaNacimiento >'01/01/1900' and FechaNacimiento <='31/12/1945' and "
# w5=" group by Partido"
# cons2=sel+w4+w2+w3+w5

# genSilenciosa=df.query(consulta)

# gp=genSilenciosa.groupby("Partido")


# f, ax = plt.subplots()
# sns.axes_style("whitegrid")


export_csv = df.to_csv ("bd.csv",index = None, header=True, encoding="utf-8-sig")

