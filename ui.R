## ui.R ##
library(shiny)
library(shinydashboard)
library(shinythemes)
library(plotly)
HTML('<script> document.title = "Internet Tab Name"; </script>')
navbarPage(theme = shinytheme("flatly"),
           title = tags$a(href='http://datalabitam.com/index.html',
                          tags$img(src='logo_2.png',height=37,style="display: block; margin-left: auto; margin-right: auto; display: flex; align-items: center; justify-content: center;")),
           windowTitle = HTML("Transparencia legislativa"),
           ###################################################
           # Panel: Visualizaciones
           tabPanel("Visualizaciones",titlePanel(div(windowTitle = "Landing page",
                                                     img(src = "INE.png", width = "20%", class = "bg"),
                                                     "Datalab - Transparencia legislativa")),tags$br(),
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
                                            img(src = "INE.png", width = "20%", class = "bg"),
                                            "Nuestro objetivo es facilitar el acceso a información legislativa")),tags$br(),
                    fluidPage(
                      fluidRow(
                        column(6, htmlOutput("Transparencia_1"),a(href="Legis_60-61.rar", "Legislaturas LX-LXIII", download=NA, target="_blank")
                               ),
                        column(6, htmlOutput("Notas_transparencia")
                        )
                        
                      ),
                      fluidRow(
                        column(6,splitLayout( div(style="display:inline-block",downloadButton('Descarga_1', 'SIL'), style="float:right"),
                               div(style="display:inline-block",downloadButton('Descarga_2', 'LXIV legislatura'), style="float:right"),
                               div(style="display:inline-block",downloadButton('Descarga_3', 'LX-LXIII legislatura'), style="float:right"))
                        )
                      )
                    )
                    ),
           ###################################################
           # Panel: Código
           tabPanel("Contacto",titlePanel(div(windowTitle = "Landing page",
                                                             img(src = "INE.png", width = "20%", class = "bg"),
                                                             "Contáctanos:")),tags$br(),
                    fluidPage(
                      fluidRow(
                        downloadButton("downloadData2", "test")
                      )
                    )
           ),
           ###################################################
           # Panel: Visitanos
           tabPanel(title=HTML("</a></li><li><a href='https://github.com/fvg98/transparencia-de-datos/' target='_blank'>Visítanos en Github"))
           ###################################################
           )

                                
                                
                                
              