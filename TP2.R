library("dplyr")
library("sf")

### EXERCICE 1 ###

# Question 1 #

France_metro <- st_read("fonds/commune_francemetro_2021.shp",options = "ENCODING=WINDOWS-1252")

# Question 2 #

summary(France_metro)
str(France_metro)

# Question 3 #

View(France_metro[1:10,])

# Question 4 #

st_crs(France_metro)


# Question 5 #

communes_Bretagne <- France_metro%>% 
  filter(reg == "53") %>% 
  select (code, libelle, epc, dep, surf)

# Non on observe une variable supplémentaire qui est geometry.

# Question 6 #

str(communes_Bretagne)

#Oui la table est bien un objet sf.

# Question 7 #

plot(communes_Bretagne, lwd=0.1)

# Question 8 #

plot(st_geometry(communes_Bretagne), lwd=0.1)

# Question 9 #

communes_Bretagne$surf2 <- st_area(communes_Bretagne$geometry)
# La variable est en m^2

# Question 10 #

units(communes_Bretagne$surf2) <- "km^2"

# Question 11 #

str(communes_Bretagne)

# Question 12 #

dept_bretagne <- communes_Bretagne %>% 
  group_by(dep) %>% 
  summarise(surf2 = sum(surf2))

plot(dept_bretagne)

# Question 13 #


dept_bretagne2 <- communes_Bretagne %>% 
  group_by(dep) %>% 
  summarise(st_union(geometry))

plot(st_geometry(dept_bretagne2, lwd=0.1))


## Question 14 ##

centroid_dept_bretagne <- dept_bretagne %>% 
  summarise(dep, geometry = st_centroid(geometry))

plot(centroid_dept_bretagne)

# a
# Ce sont des points. 
# b 
plot(st_geometry(dept_bretagne2, lwd=0.1))
plot(centroid_dept_bretagne,add = TRUE)
#c

dep<-(c("29","35", "22","56"))
name_dep<-(c("Finistere", "Ile et Vilaine", "Cote d'Amor", "Morbihan"))  
table_a_fusionner<-data.frame(dep,name_dep)

table_nom_dep <- inner_join(table_a_fusionner, centroid_dept_bretagne, by = "dep")

#d
centroid_coord<-st_drop_geometry((table_nom_dep))
centroid_coord<-st_coordinates(table_nom_dep)




