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

