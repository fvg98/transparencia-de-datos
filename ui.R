## ui.R ##
library(shiny)
library(shinydashboard)
library(shinythemes)
library(plotly)

navbarPage(theme = shinytheme("flatly"),
           title = tags$a(href='http://datalabitam.com/index.html',
                          tags$img(src='logo_2.png',height=37, align = "center")),
           ###################################################
           # Panel: Visualizaciones
           tabPanel("Visualizaciones",titlePanel(div(windowTitle = "Landing page",
                                                     img(src = "INE.png", width = "20%", class = "bg"),
                                                     "Datalab - Transparencia legislativa")),tags$br(),
                    tabsetPanel(
                      ###################################################
                      # Género
                      tabPanel("Género",
                               fluidPage(titlePanel(div(p(strong("Paridad de género por partido")))),
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
                               fluidPage(titlePanel(div(p(strong("¿De qué generación son tus representantes?")))),
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
           # Panel: Código
           tabPanel("Código",titlePanel(div(windowTitle = "Landing page",
                                            img(src = "INE.png", width = "20%", class = "bg"),
                                            "Aqui vendría una descripción.")),tags$br(),
                    tabsetPanel(
                      tabPanel("Prueba",fluidRow(
                        box(plotOutput("plot1", height = 250)),
                        box(title = "Controls", sliderInput("slider", "Number of observations:", 1, 100, 50)
                            )
                        ))
                      )
                    ),
           ###################################################
           # Panel: Bases de Datos
           tabPanel("Bases de Datos",titlePanel(div(windowTitle = "Landing page",
                                            img(src = "INE.png", width = "20%", class = "bg"),
                                            "Aqui vendría otra descripción.")),tags$br(),
                    tabsetPanel(
                      tabPanel("Prueba",fluidRow(
                        
                        ))
                    )
           )
           
           ###################################################
           )

                                
              