import scrapy
import re

# Preparamos los URLs iniciales
urls = []
a = [*range(57, 65, 1)]
b = [*range(1, 3, 1)]
urlMod = """http://sil.gobernacion.gob.mx/Reportes/Integracion/HCongreso
        /ResultIntegHCongreso.php
        ?SID=&Prin_El=0&Entidad=0&Legislatura=#&Camara=#&Partido=0&Orden="""
urlDividido = urlMod.split("#")

for i in range(len(a)):
    for j in range(len(b)):
        urls.append(urlDividido[0] + str(a[i]) + urlDividido[1] + str(b[j])
                    + urlDividido[2])

# Spider
URLlegis = """http://sil.gobernacion.gob.mx/Librerias
            /pp_PerfilLegislador.php?SID=&Referencia="""

cssPath = ' body div#main.subtitle table tbody tr td.tddatosazul a[href^="#"]'

outerHTML = """<a href="#1" onclick="mUtil.winLeft(&quot;/Librerias/
            pp_PerfilLegislador.php?SID=&amp;
            Referencia=9219077&quot;,500,700,1,&quot;leg&quot;);">
            Abdala Carmona Yahleel</a>"""
pattern = r'(?<=Referencia=)\d+'
numRef = []


class SILSpider(scrapy.Spider):
    name = 'silspider'

    def start_requests(self):
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        referencias = response.css(cssPath).extract()
        for referencia in referencias:
            numRef.append(re.findall(pattern, referencia))

        links = [URLlegis + e for e in numRef]

        for link in links:
            yield response.follow(url=link, callback=self.parse2)

    def parse2(self, response):
        yield "hello"
