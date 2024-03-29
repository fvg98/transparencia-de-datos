setwd("C:/Users/miche/Documents/TP - gender")
library(readr)
library(dplyr)
library(ggplot2)

data<-read_csv(file="bdCandidatos.csv", locale = locale(encoding = "latin1"))
gender_cand<- data %>% select(PartidosCoalicion, 
    ENTIDAD, tipoCandidato,tipoCandidatura, edad, genero)
gender_prop<- gender_cand %>% 
  filter(tipoCandidatura == "DIPUTACI�N FEDERAL RP"| tipoCandidatura == "DIPUTACI�N FEDERAL MR") %>%
  filter(tipoCandidato == "PROPIETARIO")

#Total de diputadxs propietarixs por partido y g�nero
propietarios <-gender_prop %>% 
  group_by(PartidosCoalicion, genero) %>%
  summarise(total = n(), .groups = "drop")

propietarios2 <-gender_prop %>% 
 # filter(tipoCandidatura == "DIPUTACI�N FEDERAL MR") %>%
  group_by(PartidosCoalicion) %>%
  summarise(total = n())


#Mayor�a representativa, propietarios por estado y g�nero

propietariosmre <-gender_prop %>% 
  filter(tipoCandidatura== "DIPUTACI�N FEDERAL MR") %>%
  group_by(ENTIDAD, genero) %>% 
  summarise(total=n(), .groups = "drop")

#Diputadxs tipo elecci�n y g�nero

diputados <-gender_cand %>% 
  group_by(tipoCandidato, tipoCandidatura, genero) %>% 
  summarise(total=n(), .groups = "drop") %>%
  mutate(tipo=case_when(tipoCandidatura == "DIPUTACI�N FEDERAL MR" & 
                          genero == "M" &
               tipoCandidato == "PROPIETARIO" ~ "Candidatas a diputadas propietarias por MR",
                        tipoCandidatura == "DIPUTACI�N FEDERAL MR" & 
                          genero == "H" &
                  tipoCandidato == "PROPIETARIO" ~ "Candidatos a diputados propietarios por MR",
               tipoCandidatura == "DIPUTACI�N FEDERAL MR" & 
                 genero == "M" &
                 tipoCandidato == "SUPLENTE" ~ "Candidatas a diputadas suplentes por MR",
               tipoCandidatura == "DIPUTACI�N FEDERAL MR" & 
                 genero == "H" &
                 tipoCandidato == "SUPLENTE" ~ "Candidatos a diputados suplentes por MR",
               tipoCandidatura == "DIPUTACI�N FEDERAL RP" & 
                          genero == "M"&
                 tipoCandidato == "PROPIETARIO" ~ "Candidatas a diputadas propietarias por RP",
               tipoCandidatura == "DIPUTACI�N FEDERAL RP" & 
                 genero == "H"&
                 tipoCandidato == "PROPIETARIO" ~ "Candidatos a diputados propietarios por RP",
               tipoCandidatura == "DIPUTACI�N FEDERAL RP" & 
                 genero == "M"&
                 tipoCandidato == "SUPLENTE" ~ "Candidatas a diputadas suplentes por RP",
               tipoCandidatura == "DIPUTACI�N FEDERAL RP" & 
                 genero == "H"&
                 tipoCandidato == "SUPLENTE" ~ "Candidatos a diputados suplentes por RP"))

  
#Visualizaciones
viz1<-ggplot(data=propietarios, aes(y=total, x=PartidosCoalicion, fill = genero))+
  geom_bar(stat="identity")
viz2<-ggplot(data=propietariosmre, aes(x= ENTIDAD, y = total, fill=genero))+
  geom_bar(stat="identity") + coord_flip()
viz3<-ggplot(data=diputados, aes(y=total, x=tipo, fill=tipoCandidato))+
  geom_bar(stat="identity") + coord_flip()
