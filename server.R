library(shiny)
#require(shinyserver)
library(plotly)

##########################################
# Data loading
gen_df <- read.csv("gen2018.csv")
gender_df <- read.csv("bdFinalDip.csv", encoding = "latin1")

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
  colors <- c('C7FFA9','#E4A9FF','#2424FF','#2477FF','#248EFF','#249FFF',
              '#24B3FF','#24C7FF','#24DEFF','#24F8FF','#24FFF8','#24FFEE')
  
  output$gender_sankey <- renderPlotly({
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
    )
  }) 
  ###########################################
  # test
  Animals <- c("giraffes", "orangutans", "monkeys")
  SF_Zoo <- c(20, 14, 23)
  LA_Zoo <- c(12, 18, 29)
  data <- data.frame(Animals, SF_Zoo, LA_Zoo)
  
  output$test <- renderPlotly({
    fig <- plot_ly(data, x = ~Animals, y = ~SF_Zoo, type = 'bar', name = 'SF Zoo')
    fig <- fig %>% add_trace(y = ~LA_Zoo, name = 'LA Zoo')
    fig <- fig %>% layout(yaxis = list(title = 'Count'), barmode = 'stack') 
      
    
    fig <- fig %>% config(modeBarButtons = list(list('toImage'), list('resetScale2d')), displaylogo = F)
  })
  
  
}


