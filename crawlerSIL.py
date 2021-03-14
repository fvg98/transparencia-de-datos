import scrapy
from scrapy.crawler import CrawlerProcess
import re

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
        if i>0 and bool(re.match(r'^[a-z]', lista[i])):
            lista[i-1] += " " + lista[i]
            del lista[i]
        else:
            i+=1
    return lista


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
                .replace('\r', '').strip() for i in
                response.css('td[class]:not([id="oculto"]) ::text').extract()]

        perfil = response.css('td[class="SubTitle"]::text').extract()
        comisiones = response.css('td[class="simpletextmayor"] ::text').extract()
        trayectoria_y_otros = response.css('td[class="simpletextmayor"]::text').extract()
        titulos = perfil + comisiones + trayectoria_y_otros

        categorias = [i.replace('\n', '').replace('\t', '')
                      .replace('\r', '').strip() for i in
                      response.css('td[class="tdcriterio"] ::text').extract()]

        categorias_perfil = [i.replace('\n', '').replace('\t', '')
                             .replace('\r', '').strip() for i in
                             response.css('td[class="tdcriterioPer"] ::text')
                             .extract()]

        datos = [i.replace('\n', '').replace('\t', '')
                      .replace('\r', '').strip() for i in
                      response.css('td[class="tddatosazul"] ::text').extract()]

        categorias_perfil_l = limpieza(categorias_perfil)
        categorias_l = limpieza(categorias)
        todo_l = limpieza(todo)
        datos_l = limpieza(datos)


        with open('out.txt', 'a') as f:
            for categoria in titulos:
                f.write("%s, " % categoria)
            f.write("\n")
            for item in todo_l:
                f.write("%s, " % item)
            f.write("\n")




diccionario = dict()

process = CrawlerProcess()

process.crawl(SILSpider)

process.start()
