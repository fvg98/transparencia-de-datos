setwd("C:/Users/miche/Documents/TP - gender")
library(readr)
library(dplyr)
library(ggplot2)

data<-read_csv(file="bdCandidatos.csv", locale = locale(encoding = "latin1"))
gender_cand<- data %>% select(PartidosCoalicion, 
    ENTIDAD, tipoCandidato,tipoCandidatura, edad, genero)
gender_prop<- gender_cand %>% 
  filter(tipoCandidatura == "DIPUTACIÓN FEDERAL RP"| tipoCandidatura == "DIPUTACIÓN FEDERAL MR") %>%
  filter(tipoCandidato == "PROPIETARIO")

#Total de diputadxs propietarixs por partido y género
propietarios <-gender_prop %>% 
  group_by(PartidosCoalicion, genero) %>%
  summarise(total = n(), .groups = "drop")

#Mayoría representativa, propietarios por estado y género

propietariosmre <-gender_prop %>% 
  filter(tipoCandidatura== "DIPUTACIÓN FEDERAL MR") %>%
  group_by(ENTIDAD, genero) %>% 
  summarise(total=n(), .groups = "drop")

#Diputadxs tipo elección y género

diputados <-gender_cand %>% 
  group_by(tipoCandidato, tipoCandidatura, genero) %>% 
  summarise(total=n(), .groups = "drop")
  
  
#Visualizaciones
viz1<-ggplot(data=propietarios, aes(y=total, x=PartidosCoalicion, fill = genero))+
  geom_bar(stat="identity")
viz2<-ggplot(data=propietariosmre, aes(x= ENTIDAD, y = total, fill=genero))+
  geom_bar(stat="identity") + coord_flip()
viz3<-ggplot(data=diputados, aes(y=total, x=tipoCandidatura, fill=tipoCandidato))+
  geom_bar(stat="identity") + coord_flip()
