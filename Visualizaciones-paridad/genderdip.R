setwd("C:/Users/miche/Documents/TP - gender")
library(readr)
library(dplyr)
library(ggplot2)
library(treemapify)
library(ggalluvial)
library(ggpol)

#Carga de datos
data<-read_csv(file="bdFinalDip.csv", locale = locale(encoding = "latin1"))
gender_data<-select(data, UltimoGradoEstudios, Partido, Reeleccion, TipoLegislacion, tipoEleccion)
gender_data<- gender_data%>% arrange(tipoEleccion) %>%
  mutate(Mujer = ifelse(TipoLegislacion == "Diputada Propietario",1,0))
#Contabilizar total de diputados por partido
gd<- gender_data %>% group_by(Partido) %>% summarise(n = n())
#Diferenciar por g�nero
womendip<- gender_data %>% filter(TipoLegislacion == "Diputada Propietario")
mendip<- gender_data %>% filter(TipoLegislacion == "Diputado Propietario")
#Sintetizar datos
por_partidosw<- womendip %>% group_by(Partido) %>% 
  summarise(n = n()) %>%  mutate(total = gd$n, 
                       propor = n/total)
#Creaci�n de paleta
pal<-c("cornflowerblue", "palevioletred2","darkmagenta", "indianred2", "lightseagreen", "midnightblue", 
       "pink4", "maroon4", "deepskyblue4")

#Creacci�n de treemap: proporci�n de diputadas
#en cada partido
windowsFonts(Times=windowsFont("Times New Roman"))
viz1<- ggplot(por_partidosw, aes(fill=Partido,area=propor, 
      label=paste0(Partido, "\n", round(propor,2))))+
geom_treemap() + theme(text=element_text(family="Times", size=14), plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5)) +
  geom_treemap_text(place = "centre", colour = "white", alpha = 0.8) +
labs(title = "Proporci�n de diputadas en cada partido", 
     subtitle = "�Hay paridad de g�nero en LXIV legislatura?",
     caption = "Fuente: Sistema de Informaci�n Legislativa") + 
  scale_fill_manual(values = pal)+ guides(fill=FALSE)
viz1

#Creaci�n de alluvial: relaci�n entre g�nero y grado de estudio
w_est <- womendip %>% group_by(UltimoGradoEstudios) %>%
  summarise(n = n())   %>% mutate(gen= c("Diputada","Diputada","Diputada","Diputada","Diputada","Diputada","Diputada","Diputada","Diputada","Diputada"))   #mujeres subdivididas por estudios
m_est <- mendip %>% group_by(UltimoGradoEstudios) %>%
  summarise(n = n()) %>% mutate(gen = c("Diputado","Diputado","Diputado","Diputado","Diputado","Diputado","Diputado","Diputado","Diputado"))
mw_est<-rbind(w_est,m_est) #uni�n de ambas bases 
mw_est<-rename(mw_est,Escolaridad = UltimoGradoEstudios)

windowsFonts(Times=windowsFont("Times New Roman"))
viz2<-ggplot(mw_est, aes(y = n, axis1= gen, axis2 = Escolaridad))+
  geom_alluvium(aes(fill=Escolaridad))+ 
  labs(title = "�El g�nero influye en el grado de estudios de los diputados?", 
       subtitle = "�Legislatura LXIV 2018-2021",
       caption = "Fuente: Sistema de Informaci�n Legislativa")+
  theme(text=element_text(family="Times", size=16), plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))+
  geom_stratum(aes(fill = Escolaridad))+
  theme_minimal() +   scale_x_continuous(breaks = 1:2, labels = c("G�nero", "Nivel de escolaridad")) 
  viz2

  #Visualizaci�n composici�n de la c�mara por g�nero
gd1<- gender_data %>% group_by(TipoLegislacion) %>% 
  summarise(n = n()) %>% rename(G�nero = TipoLegislacion)

color<-c("plum2","paleturquoise3")
viz3<-ggplot(gd1)+
  geom_parliament(aes(fill=G�nero,seats=n), color = "white")+
  coord_fixed() + theme_void()+ 
  scale_fill_manual(values= color,labels = gd1$G�nero)+
  labs(title  = "Composici�n de la c�mara de diputados por g�nero",
       subtitle="�Hay paridad de g�nero en la LXIV legislatura?",
       caption = "Fuente: Sistema de Informaci�n Legislativa")+
  theme(title = element_text(family="Times",size = 14),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))
viz3                                         
                                          