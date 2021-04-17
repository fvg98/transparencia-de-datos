#!/usr/bin/env python
# -*- coding: utf-8 -*-

import scrapy
from scrapy.crawler import CrawlerProcess
import re
import json
# Función para arreglar el tener campos de datos divididos
# entre varios campos, noté que cuando esto pasa la primer letra de los campos
# es minúscula, por lo tanto concateno las celdas que comiencen con minúscula
# y luego borro la celda repetida
def limpieza(lista):
    i = 0
    while i < len(lista):
        if i>0 and bool(re.match(r'^[a-z][^@]+$', lista[i])):
            lista[i-1] += " " + lista[i]
            del lista[i]
        else:
            i+=1
    return lista

def encuentraDivision(todo,categorias):
    indices=[]; i=0; j=0
    while i<len(todo) and j<len(categorias):
          if todo[i] == categorias[j]:
              indices.append(i);i+=1; j+=1
          else:
              i+=1
    return indices

def limpiezaPerfil(sublista, subcategorias):
    res = sublista[:]
    res[subcategorias[-1]+1:] = [" ".join(res[subcategorias[-1]+1:])]
    for i in range(-1,-len(subcategorias),-1):
        res[subcategorias[i-1]+1:subcategorias[i]] = [" ".join(res[subcategorias[i-1]+1:subcategorias[i]])]
    return res


def creaCURP(nombre):
    section = re.findall(':(.*)por', nombre)
    lista_iniciales = re.findall(r"([^\W])(?:[^\W]+)", section[0])
    return "".join(lista_iniciales)


def creaCurp(nombre):
    curp = nombre.replace('.', '')
    curp = nombre.replace('-', '')
    curp = curp.replace(' ', '')
    curp = curp.lower()
    curp = curp.replace('á', 'a')
    curp = curp.replace('é', 'e')
    curp = curp.replace('í', 'i')
    curp = curp.replace('ó', 'o')
    curp = curp.replace('ú', 'u')
    return curp



def creaDicc(a):
    ite = iter(a)
    res_dct = dict(zip(ite,ite))
    return res_dct

class SILSpider(scrapy.Spider):
    name = 'silspider'

    def start_requests(self):
        url = "http://sil.gobernacion.gob.mx/Librerias/pp_PerfilLegislador.php?SID=&Referencia=9221851"
        yield scrapy.Request(url=url, callback=self.parse_legisladores)

# A partir del nombre y fecha de nacimiento, crear un ID
# para cada legislador (RegEx)

# Identificar los títulos de cada tabla y  todas las categorías por tabla

# Usar esas categorías como llaves en nuestro diccionario y meter todo
# lo correspondiente como una lista bajo esa llave

    def parse_legisladores(self, response):

        todo = [i.replace('\n', '').replace('\t', '')
                .replace('\r', '').replace('\xa0','').strip() for i in
                response.css('td[class]:not([id="oculto"]) ::text').extract()]

        perfil = response.css('td[class="SubTitle"]::text').extract()
        comisiones = response.css('td[class="simpletextmayor"] ::text').extract()
#        trayectoria_y_otros = response.css('td[class="simpletextmayor"]::text').extract()
        titulos = perfil + comisiones #+ trayectoria_y_otros

        cats = [i.replace('\n', '').replace('\t', '')
                      .replace('\r', '').replace('\xa0','').strip() for i in
                      response.css('td[class="tdcriterio"] ::text').extract()]

        cat_perfil = [i.replace('\n', '').replace('\t', '')
                             .replace('\r', '').replace('\xa0','').strip() for i in
                             response.css('td[class="tdcriterioPer"] ::text')
                             .extract()]

        datos = [i.replace('\n', '').replace('\t', '')
                      .replace('\r', '').replace('\xa0','').strip() for i in
                      response.css('td[class="tddatosazul"] ::text').extract()]

        cat_perfil_l = limpieza(cat_perfil)
        cats_l = limpieza(cats)
        todo_l = limpieza(todo)
        datos_l = limpieza(datos)

        indice_titulos = encuentraDivision(todo_l, titulos)
        indice_catPer = encuentraDivision(todo_l[indice_titulos[0]+1:indice_titulos[1]], cat_perfil_l)

        todo_perfil = limpiezaPerfil(todo_l[indice_titulos[0]+1:indice_titulos[1]],indice_catPer)

#        diccionarios = {}
#        diccionarios[titulos[0]] = creaDicc(['CURP','1']+todo_perfil)
        diccionario = creaDicc(['CURP',creaCURP(todo_perfil[1])]+todo_perfil)

#        diccionario = {}
#        diccionario['CURP'] = diccionarios

        with open('data2.json', 'a') as f:
            json.dump(diccionario, f, indent=4, ensure_ascii=False).encode('utf8')

process = CrawlerProcess()

process.crawl(SILSpider)

process.start()
