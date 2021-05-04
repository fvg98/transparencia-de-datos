## ui.R ##
library(shiny)
library(shinydashboard)
library(shinythemes)
library(plotly)
##### #Script para juntar tweets #####
#Hilo 1 de Twitter
tweet <- "https://twitter.com/DatalabITAM/status/1385341212027092992"
url <- URLencode(tweet, reserved = TRUE)
src <- paste0("https://twitframe.com/show?url=", url)
#Hilo 2 de Twitter
tweet_2 <- "https://twitter.com/DatalabITAM/status/1385715021775138816"
url_2 <- URLencode(tweet_2, reserved = TRUE)
src_2 <- paste0("https://twitframe.com/show?url=", url_2)
#Hilo 3 de Twitter
tweet_3 <- "https://twitter.com/DatalabITAM/status/1386808302374322177"
url_3 <- URLencode(tweet_3, reserved = TRUE)
src_3 <- paste0("https://twitframe.com/show?url=", url_3)
#Hilo 4 de Twitter
tweet_4 <- "https://twitter.com/DatalabITAM/status/1388259181791113220"
url_4 <- URLencode(tweet_4, reserved = TRUE)
src_4 <- paste0("https://twitframe.com/show?url=", url_4)


js <- '
$(window).on("message", function(e) {
  var oe = e.originalEvent;
  if (oe.origin !== "https://twitframe.com")
    return;
  if (oe.data.height && oe.data.element.id === "tweet"){
    $("#tweet").css("height", parseInt(oe.data.height) + "px");
  }
});'

js_2 <- '
$(window).on("message", function(e) {
  var oe = e.originalEvent;
  if (oe.origin !== "https://twitframe.com")
    return;
  if (oe.data.height && oe.data.element.id === "tweet_2"){
    $("#tweet_2").css("height", parseInt(oe.data.height) + "px");
  }
});'

js_3 <- '
$(window).on("message", function(e) {
var oe = e.originalEvent;
if (oe.origin !== "https://twitframe.com")
return;
if (oe.data.height && oe.data.element.id === "tweet_3"){
$("#tweet_3").css("height", parseInt(oe.data.height) + "px");
}
});'

js_4 <- '
$(window).on("message", function(e) {
  var oe = e.originalEvent;
  if (oe.origin !== "https://twitframe.com")
    return;
  if (oe.data.height && oe.data.element.id === "tweet_4"){
    $("#tweet_4").css("height", parseInt(oe.data.height) + "px");
  }
});'

###### PRINCIPAL #####
navbarPage(theme = shinytheme("flatly"),
           title = tags$a(href='http://datalabitam.com/index.html',
                          tags$img(src='logo_2.png',height=28,style="display: block; margin-left: auto; margin-right: auto; display: flex; align-items: center; justify-content: center;")),
           windowTitle = HTML("Transparencia legislativa"),
           ###################################################
           # Panel: Visualizaciones
           tabPanel("Visualizaciones",titlePanel(div(windowTitle = "Landing page",
                                                     HTML('<center><img src="VOTO_2.png" width="120"></center>'),
                                                     htmlOutput("header_1"))),tags$br(),
                    tabsetPanel(
                      ###################################################
                      # Género
                      tabPanel("Género",
                               fluidPage(titlePanel(div(p(strong("Paridad de género en diputados por partido")))),
                                         sidebarLayout(
                                           sidebarPanel(checkboxGroupInput("genderSelect", 
                                                                           h4("Seleccione los géneros a mostrar"),
                                                                           choices = list(
                                                                             "Mujeres" = 'muj',
                                                                             "Hombres" = 'hom'
                                                                             ),
                                                                           selected = c('muj','hom')
                                                                           ),
                                                        checkboxGroupInput("partySelect", 
                                                                           h4("Seleccione los partidos a mostrar"),
                                                                           choices = list(
                                                                             "PRD" = 'PRD',
                                                                             "MC" = 'MC',
                                                                             "PES" = 'PES',
                                                                             "MORENA" = 'MORENA',
                                                                             "PRI" = 'PRI',
                                                                             "PAN" = 'PAN',
                                                                             "PT" = 'PT',
                                                                             "PVEM" = 'PVEM',
                                                                             "Sin Partido" = 'Sin Partido'
                                                                             ),
                                                                           selected = c('PRD','MC','PES',
                                                                                        'MORENA','PRI','PAN',
                                                                                        'PT','PVEM','Sin Partido')
                                                                           ),
                                                        actionButton("selectall_party", label="Seleccionar/Eliminar selección")
                                                        ),
                                           mainPanel(plotlyOutput("gender", width = 450))
                                           )
                                         ),
                               fluidPage(titlePanel(div(p(strong("Escolaridad por género de tus diputados")))),
                                         sidebarLayout(sidebarPanel(checkboxGroupInput("schoolSelect", 
                                                                                       h4("Seleccione el grado de estudio a mostrar"),
                                                                                       choices = list("Doctorado" = 'Doctorado',
                                                                                                      "Maestría" = 'Maestría',
                                                                                                      "Licenciatura" = 'Licenciatura',
                                                                                                      "Pasante/Licenciatura trunca" = 'Pasante/Licenciatura trunca',
                                                                                                      "Profesor Normalista" = 'Profesor Normalista',
                                                                                                      "Técnico" = "Técnico",
                                                                                                      "Preparatoria" = "Preparatoria",
                                                                                                      "Secundaria" = 'Secundaria',
                                                                                                      "Primaria" = "Primaria",
                                                                                                      "No disponible" = 'No disponible'
                                                                                                      ),
                                                                                       selected = c('Doctorado','Maestría',"Licenciatura","Pasante/Licenciatura trunca",
                                                                                                    "Preparatoria","Profesor Normalista", "Técnico","Secundaria",
                                                                                                    "Primaria","No disponible")
                                                                                       ),
                                                                    actionButton("selectall_sankey", label="Seleccionar/Eliminar selección")
                                                                    ),
                                                       mainPanel(plotlyOutput("gender_sankey", width = 600))
                                                       )
                                         )
                               ),
                      ###################################################
                      # Generaciones
                      tabPanel("Generaciones",
                               fluidPage(titlePanel(div(p(strong("¿De qué generación son tus diputados?")))),
                                         sidebarLayout(
                                           sidebarPanel(checkboxGroupInput("partySelect_2", 
                                                                           h4("Seleccione los partidos a mostrar"),
                                                                           choices = list("PRD" = 'PRD',
                                                                                          "MC" = 'MC',
                                                                                          "PES" = 'PES',
                                                                                          "MORENA" = 'MORENA',
                                                                                          "PRI" = 'PRI',
                                                                                          "PAN" = 'PAN',
                                                                                          "PT" = 'PT',
                                                                                          "PVEM" = 'PVEM',
                                                                                          "Sin Partido" = 'Sin Partido'),
                                                                           selected = c('PRD','MC','PES',
                                                                                        'MORENA','PRI','PAN',
                                                                                        'PT','PVEM','Sin Partido')
                                                                           ), 
                                                        actionButton("selectall_gener", label="Seleccionar/Eliminar selección"),
                                                        width = 3
                                                        ),
                                           mainPanel(splitLayout(cellWidths = c("50%", "50%"),
                                                                 plotlyOutput("generaciones_count", 
                                                                              width = 425),
                                                                 plotlyOutput("generaciones_prcnt", 
                                                                              width = 425)
                                                                 ),
                                                     width = 9
                                                     )
                                           )
                                         )
                               )
    
                      )
                    ),
           ###################################################
           # Panel: Bases de datos
           tabPanel("Bases de datos",titlePanel(div(windowTitle = "Landing page",
                                                    HTML('<center><img src="INE.png" width="300"></center>'),
                                                    htmlOutput("header_2"))),tags$br(),
                    fluidPage(
                      fluidRow(
                        column(6,htmlOutput("Transparencia_1"),a(href="SIL.rar", "Sistema de Información Legislativa", download=NA, target="_blank"),
                               htmlOutput("Transparencia_2"),a(href="LXIV.rar", "Currícula y votaciones LXIV", download=NA, target="_blank"),
                               htmlOutput("Transparencia_3"),a(href="LX-LXIII.rar", "Legislaturas LX-LXIII", download=NA, target="_blank")),
                        column(6, htmlOutput("Notas_transparencia")
                        )
                        
                      )
                    )
                    ),
           tabPanel("Publicaciones",titlePanel(div(windowTitle = "Landing page",
                                                   HTML('<center><img src="PUB_2.png" width="300"></center>'),
                                                   htmlOutput("header_3"))),tags$br(),
                    fluidRow(
                      tags$head(
                        tags$script(HTML(js)),
                        tags$style(HTML(
                          "
                          .content {
                          margin: auto;
                          padding: 20px;
                          width: 60%;
                          }"))
    ),
    
    uiOutput("frame")
                        ),
    fluidRow(
      tags$head(
        tags$script(HTML(js_2)),
        tags$style(HTML(
          "
                          .content {
                          margin: auto;
                          padding: 20px;
                          width: 60%;
                          }"))
      ),
      
      uiOutput("frame_2")
    ),
    fluidRow(
      tags$head(
        tags$script(HTML(js_3)),
        tags$style(HTML(
          "
                          .content {
                          margin: auto;
                          padding: 20px;
                          width: 60%;
                          }"))
      ),
      
      uiOutput("frame_3")
    ),
    fluidRow(
      tags$head(
        tags$script(HTML(js_4)),
        tags$style(HTML(
          "
                          .content {
                          margin: auto;
                          padding: 20px;
                          width: 60%;
                          }"))
      ),
      
      uiOutput("frame_4")
    )
    
             
           ),
           navbarMenu("Contacto",
                      tabPanel(title=HTML("</a></li><li><a href='https://github.com/fvg98/transparencia-de-datos/' target='_blank'>Repositorio en Github")),        
             tabPanel(title=HTML("</a></li><li><a href='https://twitter.com/DatalabITAM?s=08' target='_blank'>Twitter")),
             tabPanel(title=HTML("</a></li><li><a href='https://instagram.com/datalabitam?igshid=4hr74hjef9n3' target='_blank'>Instagram")),
             tabPanel(title=HTML("</a></li><li><a href='http://datalabitam.com/index.html' target='_blank'>Sitio Web"))
             
           )
           ###################################################
           )
#
                                
                                
                                
              