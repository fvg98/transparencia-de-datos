import scrapy

# Preparamos los URLs iniciales
urls = []
a = [*range(55, 65, 1)]
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
            /pp_PerfilLegislador.php?SID=&Referencia=#"""


class SILSpider(scrapy.Spider):
    name = 'silspider'

    def start_requests(self):
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        links = response.css('Los href, nos interesa &Referencia').extract()
        for link in links:
            yield response.follow(url=link, callback=self.parse2)

    def parse2(self, response):
        yield "hello"
