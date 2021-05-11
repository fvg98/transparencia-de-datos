library(shiny)
#require(shinyserver)
library(plotly)

##########################################
# Data loading
gen_df <- read.csv("Dashboard-data/gen2018.csv")
gender_df <- read.csv("Dashboard-data/bdFinalDip.csv", encoding = "latin1")

##########################################
# Server
server <- function(session, input, output) {
  ###########################################
  # plot1
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  ###########################################
  # generaciones
  observe({
    if (input$selectall_gener > 0) {
      if (input$selectall_gener %% 2 == 0){
        updateCheckboxGroupInput(session = session, 
                                 inputId = "partySelect_2",
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
                                 selected = c(choices = list(
                                   "PRD" = 'PRD',
                                   "MC" = 'MC',
                                   "PES" = 'PES',
                                   "MORENA" = 'MORENA',
                                   "PRI" = 'PRI',
                                   "PAN" = 'PAN',
                                   "PT" = 'PT',
                                   "PVEM" = 'PVEM',
                                   "Sin Partido" = 'Sin Partido'
                                 ))
        )
        
      } else {
        updateCheckboxGroupInput(session = session, 
                                 inputId = "partySelect_2",
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
                                 selected = c())
        
      }}
  })
  gen_df[nrow(gen_df)-1,'Partido'] <- 'Sin Partido'
  xorder1 <- list(categoryorder = 'array', 
                  categoryarray = c('PRI', 'PT', 'PRD', 'PVEM', 'MORENA', 'MC', 'PAN', 'PES', 'Sin Partido'))
  gen_df_subset <- reactive({
    a <- subset(gen_df, Partido  %in% input$partySelect_2)
    a <- cbind(a,gen_df[10,])
    return(a)
  })
  output$generaciones_count <- renderPlotly({
    fig <- plot_ly(gen_df_subset()[-nrow(gen_df),], x = ~Partido, y = ~Millenials, type = 'bar', name = 'Millenials',
                   marker = list(color = '#CE6A46')) %>%  
      add_trace(y = ~GenX, name = 'Generación X', marker = list(color = '#49C23F')) %>%
      add_trace(y = ~Boomers, name = 'Boomers', marker = list(color = '#B343ED')) %>%
      add_trace(y = ~Silenciosa, name = 'Silenciosa', marker = list(color = '#EC28AE')) %>%
      #add_trace(y = ~Total, name = 'Total') %>%
      layout(barmode = 'stack', yaxis = list(title = 'Número de diputados por partido')) %>%
      config(modeBarButtons = list(list('toImage'), list('resetScale2d')), displaylogo = FALSE)
  }) 
  ###########################################
  # generaciones_prcnt
  gen_df[nrow(gen_df),'Partido'] <- 'Todos'
  gen_df$sil_prcnt <- trunc(gen_df$Silenciosa / gen_df$Total * 10000) / 100
  gen_df$boom_prcnt <- trunc(gen_df$Boomers / gen_df$Total * 10000) / 100
  gen_df$genx_prcnt <- trunc(gen_df$GenX / gen_df$Total * 10000) / 100
  gen_df$mill_prcnt <- trunc(gen_df$Millenials / gen_df$Total * 10000) / 100
  xorder2 <- list(categoryorder = 'array', 
                  categoryarray = c('PRI', 'PT', 'PRD', 'PVEM', 'Todos', 'MORENA', 'MC', 'PAN', 
                                    'PES', 'Sin Partido'))
  gen_df_subset <- reactive({
    a <- subset(gen_df, Partido  %in% input$partySelect_2)
    return(a)
  })
  output$generaciones_prcnt <- renderPlotly({
    fig <- plot_ly(gen_df_subset(), x = ~Partido, y = ~mill_prcnt, type = 'bar', name = 'Millenials',
                   marker = list(color = '#CE6A46')) %>%
      add_trace(y = ~genx_prcnt, name = 'Generación X', marker = list(color = '#49C23F')) %>% 
      add_trace(y = ~boom_prcnt, name = 'Boomers', marker = list(color = '#B343ED')) %>%
      add_trace(y = ~sil_prcnt, name = 'Silenciosa', marker = list(color = '#EC28AE')) %>% 
      #add_trace(y = ~Total, name = 'Total') %>%
      layout(barmode = 'stack', yaxis = list(title = 'Porcentaje del total por partido')) %>%
      config(modeBarButtons = list(list('toImage'), list('resetScale2d')), displaylogo = FALSE)
  })
  ###########################################
  # gender
  gender_df$muj <- ifelse(gender_df$TipoLegislacion == 'Diputada Propietario', 1, 0)
  gender_df$hom <- 1 - gender_df$muj
  prop_part <- aggregate(muj ~ Partido, FUN = mean, data = gender_df)
  prop_part$muj <- trunc(prop_part$muj*10000)/10000
  prop_part$hom <- 1 - prop_part$muj
  prop_part[nrow(prop_part),1] <- 'Sin Partido'
  prop_part <- prop_part[order(prop_part$muj),]
  yorder <- list(categoryorder = 'array', 
                 categoryarray = c('Sin Partido', 'PVEM', 'PT', 'PAN', 'PRI', 'MORENA', 'PES', 'MC', 'PRD'))
  gend_aux <- matrix(c('#E4A9FF', '#C7FFA9', 'Mujeres', 'Hombres'), ncol = 2, byrow = T)
  colnames(gend_aux) <- c('muj', 'hom')

  prop_part_subset <- reactive({
    a <- subset(prop_part, Partido  %in% input$partySelect)
    return(a)
  })
  # Botón de selección/deselección 
  observe({
    if (input$selectall_party > 0) {
      if (input$selectall_party %% 2 == 0){
        updateCheckboxGroupInput(session = session, 
                                 inputId = "partySelect",
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
                                 selected = c(choices = list(
                                   "PRD" = 'PRD',
                                   "MC" = 'MC',
                                   "PES" = 'PES',
                                   "MORENA" = 'MORENA',
                                   "PRI" = 'PRI',
                                   "PAN" = 'PAN',
                                   "PT" = 'PT',
                                   "PVEM" = 'PVEM',
                                   "Sin Partido" = 'Sin Partido'
                                 ))
        )
        
      } else {
        updateCheckboxGroupInput(session = session, 
                                 inputId = "partySelect",
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
                                 selected = c())
        
      }}
  })
  
  output$gender <- renderPlotly({
    fig <- plot_ly(type = 'bar', orientation = 'h')
    for (i in input$genderSelect) {
      fig <- fig %>% add_trace(x = prop_part_subset()[,i], y = prop_part_subset()[,1],
                               name = gend_aux[2,i], marker = list(color = gend_aux[1,i]))
    }
    fig <- fig %>% layout(barmode = 'group') %>%
      config(modeBarButtons = list(list('toImage'), list('resetScale2d')), displaylogo = F)
  })
  ###########################################
  # gender_sankey
  nodes <- c('Hombres', 'Mujeres', unique(gender_df$UltimoGradoEstudios))
  nodes <- nodes[c(1,2,4,3,5,7,12,10,8,6,11,9)]
  gender_df$count <- 1
  hom_stud <- aggregate(count ~ UltimoGradoEstudios, FUN = sum, 
                        data = gender_df[gender_df$hom == 1,])
  muj_stud <- aggregate(count ~ UltimoGradoEstudios, FUN = sum, 
                        data = gender_df[gender_df$muj == 1,])
  hom_stud$src <- 0
  muj_stud$src <- 1
  hom_stud$tgt <- c(2,4,3,11,5,8,6,9,7)
  muj_stud$tgt <- c(2,4,3,11,5,8,10,6,9,7)
  node_x <- c(0,0,1,1,1,1,1,1,1,1,1,1) 
  node_y <- c(0,1,-10:-1)
  colors <- c('#C7FFA9','#E4A9FF','#2424FF','#2477FF','#248EFF','#249FFF',
              '#24B3FF','#24C7FF','#24DEFF','#24F8FF','#24FFF8','#24FFEE')
  # Botón de selección/deselección 
  observe({
    if (input$selectall_sankey > 0) {
      if (input$selectall_sankey %% 2 == 0){
        updateCheckboxGroupInput(session = session, 
                                 inputId = "schoolSelect",
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
                                 selected = c(choices = list("Doctorado" = 'Doctorado',
                                                             "Maestría" = 'Maestría',
                                                             "Licenciatura" = 'Licenciatura',
                                                             "Pasante/Licenciatura trunca" = 'Pasante/Licenciatura trunca',
                                                             "Profesor Normalista" = 'Profesor Normalista',
                                                             "Técnico" = "Técnico",
                                                             "Preparatoria" = "Preparatoria",
                                                             "Secundaria" = 'Secundaria',
                                                             "Primaria" = "Primaria",
                                                             "No disponible" = 'No disponible'
                                 ))
                                 )
        
      } else {
        updateCheckboxGroupInput(session = session, 
                                 inputId = "schoolSelect",
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
                                 selected = c())
        
      }}
  })
  # Plot
  output$gender_sankey <- renderPlotly({
    hom_stud <- hom_stud[hom_stud$UltimoGradoEstudios %in% input$schoolSelect,]
    muj_stud <- muj_stud[muj_stud$UltimoGradoEstudios %in% input$schoolSelect,]
    node_x <- c(node_x[hom_stud$UltimoGradoEstudios %in% input$schoolSelect])
    node_y <- c(node_y[hom_stud$UltimoGradoEstudios %in% input$schoolSelect])
    colors <- c(colors[hom_stud$UltimoGradoEstudios %in% input$schoolSelect])
    
    fig <- plot_ly(
      type = "sankey",
      orientation = "h",
      arrangement = 'snap',
      node = list(
        label = nodes,
        color = colors,
        x = node_x,
        y = node_y,
        pad = 15,
        thickness = 20,
        line = list(
          color = "black",
          width = 0.5
        )
      ),
      link = list(
        source = c(hom_stud$src, muj_stud$src),
        target = c(hom_stud$tgt, muj_stud$tgt),
        value = c(hom_stud$count, muj_stud$count)
      )
    )
    fig <- fig %>% layout(
      font = list(
        size = 10
      )
    ) %>% config(modeBarButtons = list(list('toImage'), list('resetScale2d')), displaylogo = F)
  }) 
  ###########################################
  
  #Texto a mostrar en "Bases de datos"
  output$Transparencia_1 <- renderText({paste( 
                                       "<h3><b>Por esa razón ponemos a disposición las siguientes bases de datos:</b></h3>", 
                                       "<b>1.- </b> Perfiles de legisladores del Sistema de Información Legislativa (SIL). Todas las entradas de perfiles legislativos disponibles. Incluye Senadores.",
                                       "",sep = "<br/>")})
  output$Transparencia_2 <- renderText({paste("<b>2.- </b> Curricula de los diputados de la LXIV legislatura de la cámara de diputados. (Incluye votaciones y asistencias)",
                                              "",sep="<br/>")})
  output$Transparencia_3 <- renderText({paste("<b>3.- </b>Curricula de los diputados LX-LXIII legislaturas de la cámara de diputados. (Incluye votaciones)",
                                              "",sep="<br/>")})
  output$Notas_transparencia <- renderText({paste( "<h4><b>Notas:</b></h4>",
                                                   
                                                   "<li> Las bases están en formato JSON y se encuentra debidamente documentadas para el usuario.",
                                                   "",

                                                   "<li> Este es un trabajo en proceso. Esperamos pronto tener la misma información para el senado.",
                                                   "",

                                                   "<li> Somos un proyecto abierto. En la pestaña 'Visítanos en Github' puedes encontrar nuestro código en Python 3 para webscrappear la información proporcionada." ,
                                                   "",

                                                   "<li> Somos un proyecto colaborativo. Si estás en un proyecto similar, quieres apoyarnos a recolectar la información legislativa de México o tienes sugerencias para mejorar la presentación y utilidad de las bases de datos puedes contactarnos. Nuestra info está en la pestaña 'Contacto'." ,
                                                   sep = "<br/>")})
  output$Notas_landing <- renderText({paste( "<h4><b>Nuestro dashboard ofrece las siguientes herramientas:</b></h4>",
                                                   
                                                   "<li> Visualizaciones interactivas para informarte de la composición y comportamiento de la cámara de diputados de la LXIV legislatura.",
                                                   "",
                                                   
                                                   "<li> Bases de datos históricas y actuales de la cámara de diputados que facilitan crear visualizaciones o análisis de su comportamiento a lo largo del tiempo.",
                                                   "",
                                                   "<li> Documentación y código para replicabilidad y actualización de las bases de datos.",
                                                   "",
                                                   "<li> Tutoriales de como usar herramientas que consideramos importantes para informarte en este proceso electoral." ,
                                                   "",sep = "<br/>")})
  output$Transparencia_4 <- renderText({paste( 
    "<h2><b>Bases de datos que ocupamos para las visualizaciones:</b></h2>", 
    "<li> Información usada para las visualizaciones:",
    "",sep = "<br/>")})

  ###############################################
  #Texto a mostrar en landing pages
  output$header_1 <- renderText({paste("<center><b>Datalab</b></center>" ,"<center>Transparencia legislativa</center>",sep=" ")})
  output$header_2 <- renderText({paste("<center><b>Nuestro objetivo es facilitar el acceso a información legislativa</b></center>")})
  output$header_3 <- renderText({paste("<center><b>Publicaciones</b></center>","<center><h4>Haz clic en el Tweet para ver el hilo</h4></center>",sep = " ")})
  output$header_4 <- renderText({paste("<center><b>(Recurso del INE)</b></center>","<center><h4>Te dejamos un pequeño tutorial de como utilizarlo:</h4></center>",sep = " ")})
  output$header_5 <- renderText({paste("<center><b>¡Te damos la bienvenida!</b></center>","<center><h4>Somos un grupo estudiantil que busca aportar en este proceso electoral</h4></center>",sep = " ")})
  output$header_6 <- renderText({paste("<h4><b>Te dejamos un video para guiarte por la página:</b></h4>",sep = " ")})
  ###############################################
  ###############################################
  #Tweets
  output[["frame"]] <- renderUI({
    tagList(
      tags$div(
        class = "content",
        tags$div(tags$iframe(
          id = "https://twitter.com/DatalabITAM/status/1385341212027092992",
          border=0, frameborder=0, height=370, width=600,
          src = "https://twitframe.com/show?url=https%3A%2F%2Ftwitter.com%2FDatalabITAM%2Fstatus%2F1385341212027092992"
        ))
      ),
      singleton(tags$script(HTML(
        "$(document).ready(function(){
          $('iframe#https://twitter.com/DatalabITAM/status/1385341212027092992').on('load', function() {
            this.contentWindow.postMessage(
              { element: {id:this.id}, query: 'height' },
              'https://twitframe.com');
          });
        });")))
    )
  })
  output[["frame_2"]] <- renderUI({
    tagList(
      tags$div(
        class = "content",
        tags$div(tags$iframe(
          id = "https://twitter.com/DatalabITAM/status/1385715021775138816",
          border=0, frameborder=0, height=350, width=800,
          src = "https://twitframe.com/show?url=https%3A%2F%2Ftwitter.com%2FDatalabITAM%2Fstatus%2F1385715021775138816"
        ))
      ),
      singleton(tags$script(HTML(
        "$(document).ready(function(){
          $('iframe#https://twitter.com/DatalabITAM/status/1385715021775138816').on('load', function() {
            this.contentWindow.postMessage(
              { element: {id:this.id}, query: 'height' },
              'https://twitframe.com');
          });
        });")))
    )
  })
  output[["frame_3"]] <- renderUI({
    tagList(
      tags$div(
        class = "content",
        tags$div(tags$iframe(
          id = "https://twitter.com/DatalabITAM/status/1386808302374322177",
          border=0, frameborder=0, height=350, width=800,
          src = "https://twitframe.com/show?url=https%3A%2F%2Ftwitter.com%2FDatalabITAM%2Fstatus%2F1386808302374322177"
        ))
      ),
      singleton(tags$script(HTML(
        "$(document).ready(function(){
        $('iframe#https://twitter.com/DatalabITAM/status/1386808302374322177').on('load', function() {
        this.contentWindow.postMessage(
        { element: {id:this.id}, query: 'height' },
        'https://twitframe.com');
        });
  });")))
    )
    })
  output[["frame_4"]] <- renderUI({
    tagList(
      tags$div(
        class = "content",
        tags$div(tags$iframe(
          id = "https://twitter.com/DatalabITAM/status/1388259181791113220",
          border=0, frameborder=0, height=370, width=800,
          src = "https://twitframe.com/show?url=https%3A%2F%2Ftwitter.com%2FDatalabITAM%2Fstatus%2F1388259181791113220"
        ))
      ),
      singleton(tags$script(HTML(
        "$(document).ready(function(){
        $('iframe#https://twitter.com/DatalabITAM/status/1388259181791113220').on('load', function() {
        this.contentWindow.postMessage(
        { element: {id:this.id}, query: 'height' },
        'https://twitframe.com');
        });
  });")))
    )
    })
  output[["frame_5"]] <- renderUI({
    tagList(
      tags$div(
        class = "content",
        tags$div(tags$iframe(
          id = "https://twitter.com/DatalabITAM/status/1389712137149292545",
          border=0, frameborder=0, height=350, width=800,
          src = "https://twitframe.com/show?url=https%3A%2F%2Ftwitter.com%2FDatalabITAM%2Fstatus%2F1389712137149292545"
        ))
      ),
      singleton(tags$script(HTML(
        "$(document).ready(function(){
        $('iframe#https://twitter.com/DatalabITAM/status/1389712137149292545').on('load', function() {
        this.contentWindow.postMessage(
        { element: {id:this.id}, query: 'height' },
        'https://twitframe.com');
        });
  });")))
    )
  })
  observeEvent(input$navibar,{
    if(input$navibar == "home"){
      browseURL("https://candidaturas.ine.mx/")
    }else if (input$navibar == "git"){
      browseURL("https://github.com/fvg98/transparencia-de-datos/")
    }
  })
}


