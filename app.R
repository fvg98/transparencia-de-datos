
library(shiny)

library(shinydashboard)


Cuerpo <- dashboardBody(
  fluidRow(
    tabBox(
      title = "Miembros", 
      id = "Miembros",height = "250px",selected = "Equipo 1",
      tabPanel("Equipo 1","Miembros del primer equipo:",
               verbatimTextOutput("Miembros1")),
      tabPanel("Equipo 2","Miembros del segundo equipo:",
               verbatimTextOutput("Miembros2")),
      tabPanel("Equipo 3","Miembros del tercer equipo:",
               verbatimTextOutput("Miembros3"))
    ),
    tabBox(
      title = "Objetivos",
      id = "Objetivos",height = "250px", selected = "Equipo 1",
      tabPanel("Equipo 1","Objetivos del primer equipo:",
               verbatimTextOutput("Objetivo1")),
      tabPanel("Equipo 2","Objetivos del segundo equipo:",
               verbatimTextOutput("Objetivo2")),
      tabPanel("Equipo 3","Objetivos del tercer equipo:",
               verbatimTextOutput("Objetivo3"))
    )
  ),
  fluidRow(
    tabBox(
      title = tagList(shiny::icon("glasses"), "Chequeo"
      ),
      height = "120px", width = "800px",
      tabPanel("Equipos","Mostrando los miembros de:",
               verbatimTextOutput(
                 "selección1"
               )),
      tabPanel("Objetivos","Mostrando los objetivos de:",
               verbatimTextOutput(
                 "selección2"
               ))
    )
  ),fluidRow(
    box(
      plotOutput("plot1", height = 250)
    ),
    box(
      title = "Controles",
      sliderInput("slider", "Número de observaciones:", 1, 100, 50)
    )
  )
)

Lateral <- dashboardSidebar(disable = T)

Encabezado <- dashboardHeader(title = tags$a(href='http://datalabitam.com/index.html',
                                             tags$img(src='logo.png',height=37,width=100)))

ui <- dashboardPage(skin = "yellow",
                    Encabezado,
                    Lateral,
                    Cuerpo
)

# Dashboard para conectar: 

#Servidor

server <- function(input, output) {
  
  set.seed(122)
  histdata <- rnorm(500)
  
  output$selección1 <- renderText(
    {
      input$Miembros
    }
  )
  output$selección2 <- renderText(
    {
      input$Objetivos
    }
  )
  output$Miembros1 <- renderText(
    {
      "Rafa, JC y Marlen"
    }
  )
  output$Miembros2 <- renderText(
    {
      "Paco y David"
    }
  )
  output$Miembros3 <- renderText(
    {
      "Mich, Alexis, Nubia y Montse"
    }
  )
  output$Objetivo1 <- renderText(
    {
      "Webscrappear y ordenar bases de datos."
    }
  )
  output$Objetivo2 <- renderText(
    {
      "Conectar este dashboard a internet y luego adecuarlo."
    }
  )
  output$Objetivo3 <- renderText(
    {
      "Crear un plan de divulgación atractivo."
    }
  )
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}