#!/usr/bin/env python
# -*- coding: utf-8 -*-

import scrapy
from scrapy.crawler import CrawlerProcess
import re
import json

# Preparamos los URLs iniciales
urls = []
a = [*range(57, 65, 1)]
b = [*range(1, 3, 1)]
# Aquí también se puede usar re.split() para separar el URL sin necesidad
# de incluir los # que puse para ahorrar tiempo.
urlMod = """http://sil.gobernacion.gob.mx/Reportes/Integracion/HCongreso/ResultIntegHCongreso.php?SID=&Prin_El=0&Entidad=0&Legislatura=#&Camara=#&Partido=0&Orden="""
urlDividido = urlMod.split("#")

for i in range(len(a)):
    for j in range(len(b)):
        urls.append(urlDividido[0] + str(a[i]) + urlDividido[1] + str(b[j])
                    + urlDividido[2])

# Spider
URLlegis = """http://sil.gobernacion.gob.mx/Librerias/pp_PerfilLegislador.php?SID=&Referencia="""

cssPath = 'tr td.tddatosazul a[href^="#"]'

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

def creaDicc(a):
    ite = iter(a)
    res_dct = dict(zip(ite,ite))
    return res_dct


class SILSpider(scrapy.Spider):
    name = 'silspider'

    def start_requests(self):
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        referencias = response.css(cssPath).re(r'(?<=Referencia=)\d+')

        links = [URLlegis + referencia for referencia in referencias]

        for link in links:
            yield response.follow(url=link, callback=self.parse_legisladores)

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
        todo_l = limpieza(todo)

        indice_titulos = encuentraDivision(todo_l, titulos)
        indice_catPer = encuentraDivision(todo_l[indice_titulos[0]+1:indice_titulos[1]], cat_perfil_l)

        todo_perfil = limpiezaPerfil(todo_l[indice_titulos[0]+1:indice_titulos[1]], indice_catPer)

#        diccionarios = {}
#        diccionarios[titulos[0]] = creaDicc(todo_perfil)

#        diccionario = {}
# Falta generar algo similar al CURP, pero algunos legisladores no tienen
# fecha de nacimiento registrada
#        diccionario['CURP'] = diccionarios
        diccionario = creaDicc(['CURP',creaCURP(todo_perfil[1])]+todo_perfil)

        with open('data.json', 'a') as f:
            json.dump(diccionario, f, indent=4, ensure_ascii=False).encode('utf8')


process = CrawlerProcess()

process.crawl(SILSpider)

process.start()
