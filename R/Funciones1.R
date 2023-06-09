# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

# library(readxl)
# library(tidyverse)
# library(openxlsx)





# asdas <- crearBaseNombresInd(datos)

# View(asdas)


#
#
#
# crearBasedeCorrecion <- function(datos) {
#
#   datos$nombre <- toupper(datos$nombre)
#
#   # FILTRADO Y TRABAJO DE LA BASE----
#
#   ## seleccionamos columnas de inter?s-----
#
#   datos_filtrados <- datos %>% select(
#     "nombre", "apellido", "Fecha nacimiento.", "Ocurrio en.", "Edad de la madre.","Lugar de residencia.",
#     "regcivil", "acta","tiporegistro" , "Sexo.", "departamento", "localidad", "Distrito municipal.","Seccional policial."
#   )
#
#   # INTENTO DE CHEQUEAR COLUMNAS, NO FUNCIONA
#
#   # if (names(datos_filtrados) == c("nombre","apellido","Fecha nacimiento.",
#   #                                 "Ocurrio en.","Edad de la madre." ,"Lugar de residencia.",
#   #                                 "regcivil","acta","tiporegistro",
#   #                                 "Sexo.", "departamento","localidad",
#   #                                 "Distrito municipal.","Seccional policial." )) {
#   #
#   # }
#   #
#   # c("nombre","apellido","Fecha nacimiento.",
#   #  "Ocurrio en.","Edad de la madre." ,"Lugar de residencia.",
#   #  "regcivil","acta","tiporegistro",
#   #  "Sexo.", "departamento","localidad",
#   #  "Distrito municipal.","Seccional policial." )
#
#
#   ## Guardo los nombres originales en una columna----
#   datos_filtrados$nombre_tipeado <- datos_filtrados$nombre
#
#   names(datos_filtrados)
#
#   datos_filtrados <- datos_filtrados[,c(15,1:14)]
#
#
#   ## Filtro los registros con dato faltante en el nombre
#   datos1 <- datos_filtrados %>% filter(
#     is.na(nombre) == F,
#     nombre != "SIN DATOS",
#     nombre != "SIN DATO",
#     nombre != "DESCONOCIDO"
#   )
#
#   datosFaltantes <- datos_filtrados %>% filter(
#     is.na(nombre) == T |
#       nombre == "SIN DATOS" |
#       nombre == "SIN DATO" |
#       nombre == "DESCONOCIDO"
#   )
#
#   # Separo los nombres
#
#
#   lista_nombres <- str_split(datos1$nombre, " ")
#
#
#   #
#   ## Elimino las palabras vacias y articuos/enlaces para que no se consideren como un nombre mas-------
#   #
#
#   descartes <- toupper(
#     c(""," ","EL", "LOS", "LA", "LAS", "LO", "A", "AL", "DEL",
#       "UN", "UNA", "UNOS", "UNAS",
#       "a", "ante", "bajo", "cabe", "con", "contra", "de", "desde",
#       "durante", "en", "entre", "hacia", "hasta", "mediante",
#       "para", "por", "segun", "sin", "so", "sobre", "tras", "versus", "via")
#   )
#
#   cuenta <- 0
#   for(i in 1:length(lista_nombres)){
#     descarte <- NULL
#     for(j in 1:length(lista_nombres[[i]])){
#       if(lista_nombres[[i]][j] %in% descartes){
#         descarte <- c(descarte,-j)
#         cuenta <- cuenta+1
#       }
#     }
#     if(!is.null(descarte)){
#       lista_nombres[[i]] <- lista_nombres[[i]][descarte]
#     }
#   }
#
#
#   #
#   ## Buscamos cuantos nombres tiene una persona como maximo-----
#   #
#
#   maximo <- 0
#
#   for (i in 1:(length(lista_nombres))){
#     if(length(lista_nombres[[i]])>maximo){
#       maximo <- length(lista_nombres[[i]])
#     }
#   }
#
#   if(length(lista_nombres)!=nrow(datos1)){
#     stop("Hubo un error en el filtrado de los nombres.\nLa cantidad de nombres no coincide con la cantidad de\nnacidos que en teoría tienen al menos un nombre.\n")
#   }
#
#
#   datos2 <- datos1
#
#   cant_nombres <- c("Primero", "Segundo")
#
#   if (maximo>=3) {cant_nombres <- c(cant_nombres, "Tercero")}
#   if (maximo>=4) {cant_nombres <- c(cant_nombres, "Cuarto")}
#   if (maximo>=5) {cant_nombres <- c(cant_nombres, "Quinto")}
#   if (maximo>=6) {cant_nombres <- c(cant_nombres, "Sexto")}
#
#   # a
#   # datos2$Primero <- rep(NA,length(lista_nombres))
#   # datos2$Segundo <- rep(NA,length(lista_nombres))
#   # if (maximo>=3) {datos2$Tercero <- rep(NA,length(lista_nombres))}
#   # if (maximo>=4) {datos2$Cuarto <- rep(NA,length(lista_nombres))}
#   # if (maximo>=5) {datos2$Quinto <- rep(NA,length(lista_nombres))}
#
#   # creamos las columnas de cada posicion de nombre
#
#   for (i in cant_nombres) {
#     datos2 <- datos2 %>%
#       mutate(nomb = NA)
#     names(datos2)[length(names(datos2))] <- i
#   }
#
#   datos2$cantidad_nombres <- rep(NA,length(lista_nombres))
#
#   # Llenamos la columna de los nombres y la de cantidad de nombres
#
#   # p <- 0
#   for(i in 1:length(lista_nombres)){
#     for (j in 1:maximo) {
#       datos2[i,cant_nombres[j]] <- lista_nombres[[i]][j]
#     }
#     datos2$cantidad_nombres[i] <- length(lista_nombres[[i]])
#   }
#
#
#
#   # CORRECIONES DE NOMBRES
#
#
#   reemplazos_hombres <- read_xlsx("./data/correciones_hombres_R.xlsx")
#
#   reemplazos_mujeres <- read_xlsx("./data/correciones_mujeres_R.xlsx")
#
#
#
#   datos2_hombres <- datos2 %>%
#     filter(Sexo. == "1 - Masculino")
#
#   for (i in 1:nrow(datos2_hombres)) {
#     for (j in cant_nombres) {
#       if(is.na(datos2_hombres[i,j]) || !(datos2_hombres[i,j] %in% reemplazos_hombres$Nombre)){
#         next
#       }
#       datos2_hombres[i,j] <- reemplazos_hombres$Corregido[match(datos2_hombres[i,j],reemplazos_hombres$Nombre)]
#     }
#
#   }
#
#
#
#   datos2_mujeres <- datos2 %>%
#     filter(Sexo. != "1 - Masculino")
#
#   for (i in 1:nrow(datos2_mujeres)) {
#     for (j in cant_nombres) {
#       if(is.na(datos2_mujeres[i,j]) || !(datos2_mujeres[i,j] %in% reemplazos_mujeres$Nombre)){
#         next
#       }
#       datos2_mujeres[i,j] <- reemplazos_mujeres$Corregido[match(datos2_mujeres[i,j],reemplazos_mujeres$Nombre)]
#     }
#   }
#
#   datos3 <- rbind(datos2_hombres,datos2_mujeres)
#
#   if(nrow(datos3) != nrow(datos2)){
#     stop("Los tamaños de las bases antes y después de la correccion no coinciden")
#   }
#
#   for (i in cant_nombres) {
#     datosFaltantes <- datosFaltantes %>%
#       mutate(nomb = NA)
#     names(datosFaltantes)[length(names(datosFaltantes))] <- i
#   }
#
#   datosFaltantes$cantidad_nombres <- rep("No disponible",nrow(datosFaltantes))
#
#   datos_print <- rbind(datos3,datosFaltantes)
#
#   View(datos_print)
#
#   # en caso de querer ver la base con las columnas de nombres agregadas
#   # write.xlsx(datos_print, "./Bases_creadas/base_nombres_arreglada.xlsx)
#
#
#
#
#   # CREAMOS LA BASE FINAL PARA EL AN?LISIS-----
#   # names(datos_print)
#
#   data_long <- gather(datos_print[,c(-2:-1)],
#                       posicion,
#                       nombre_ind,
#                       Primero:Tercero,
#                       na.rm = T
#   )
#
#   rm(datos1,datos2,datos2_hombres,datos2_mujeres,datos3,datosFaltantes)
#   rm(datos_filtrados)
#
#
#
#   faltantes_final <- datos_print %>%
#     filter(is.na(Primero)) %>%
#     select(c(-2:-1), -Segundo, -Tercero, -Primero)
#   faltantes_final$posicion <- NA
#   faltantes_final$nombre_ind <- NA
#
#   names(faltantes_final) == names(data_long)
#
#
#
#   nombres_final <- rbind(data_long, faltantes_final)
#   nombres_final$ID <- c(1:nrow(nombres_final))
#
#   class(nombres_final$`Fecha nacimiento.`)
#
#
#   # write.xlsx(,file = "nombres_individuales1*asdsad.xlsx")
#
#   return(nombres_final)
#
# }
# crearBaseNombresInd <- function(datos) {
#
#   datos$nombre <- toupper(datos$nombre)
#
#   # FILTRADO Y TRABAJO DE LA BASE----
#
#   ## seleccionamos columnas de inter?s-----
#
#   datos_filtrados <- datos %>% select(
#     "nombre", "apellido", "Fecha nacimiento.", "Ocurrio en.", "Edad de la madre.","Lugar de residencia.",
#     "regcivil", "acta","tiporegistro" , "Sexo.", "departamento", "localidad", "Distrito municipal.","Seccional policial."
#   )
#
#
#   ## Guardo los nombres originales en una columna----
#   datos_filtrados$nombre_tipeado <- datos_filtrados$nombre
#
#   # names(datos_filtrados)
#
#   datos_filtrados <- datos_filtrados[,c(15,1:14)]
#
#
#   ## Filtro los registros con dato faltante en el nombre
#   datos1 <- datos_filtrados %>% filter(
#     is.na(nombre) == F,
#     nombre != "SIN DATOS",
#     nombre != "SIN DATO",
#     nombre != "DESCONOCIDO"
#   )
#
#   datosFaltantes <- datos_filtrados %>% filter(
#     is.na(nombre) == T |
#       nombre == "SIN DATOS" |
#       nombre == "SIN DATO" |
#       nombre == "DESCONOCIDO"
#   )
#
#   # Separo los nombres
#
#
#   lista_nombres <- str_split(datos1$nombre, " ")
#
#
#   #
#   ## Elimino las palabras vacias y articuos/enlaces para que no se consideren como un nombre mas-------
#   #
#
#   descartes <- toupper(
#     c(""," ","EL", "LOS", "LA", "LAS", "LO", "A", "AL", "DEL",
#       "UN", "UNA", "UNOS", "UNAS",
#       "a", "ante", "bajo", "cabe", "con", "contra", "de", "desde",
#       "durante", "en", "entre", "hacia", "hasta", "mediante",
#       "para", "por", "segun", "sin", "so", "sobre", "tras", "versus", "via")
#   )
#
#   cuenta <- 0
#   for(i in 1:length(lista_nombres)){
#     descarte <- NULL
#     for(j in 1:length(lista_nombres[[i]])){
#       if(lista_nombres[[i]][j] %in% descartes){
#         descarte <- c(descarte,-j)
#         cuenta <- cuenta+1
#       }
#     }
#     if(!is.null(descarte)){
#       lista_nombres[[i]] <- lista_nombres[[i]][descarte]
#     }
#   }
#
#
#   #
#   ## Buscamos cuantos nombres tiene una persona como maximo-----
#   #
#
#   maximo <- 0
#
#   for (i in 1:(length(lista_nombres))){
#     if(length(lista_nombres[[i]])>maximo){
#       maximo <- length(lista_nombres[[i]])
#     }
#   }
#
#   if(length(lista_nombres)!=nrow(datos1)){
#     stop("Hubo un error en el filtrado de los nombres.\nLa cantidad de nombres no coincide con la cantidad de\nnacidos que en teoría tienen al menos un nombre.\n")
#   }
#
#
#   datos2 <- datos1
#
#   cant_nombres <- c("Primero", "Segundo")
#
#   if (maximo>=3) {cant_nombres <- c(cant_nombres, "Tercero")}
#   if (maximo>=4) {cant_nombres <- c(cant_nombres, "Cuarto")}
#   if (maximo>=5) {cant_nombres <- c(cant_nombres, "Quinto")}
#   if (maximo>=6) {cant_nombres <- c(cant_nombres, "Sexto")}
#
#
#   # creamos las columnas de cada posicion de nombre
#
#   for (i in cant_nombres) {
#     datos2 <- datos2 %>%
#       mutate(nomb = NA)
#     names(datos2)[length(names(datos2))] <- i
#   }
#
#   datos2$cantidad_nombres <- rep(NA,length(lista_nombres))
#
#   # Llenamos la columna de los nombres y la de cantidad de nombres
#
#   # p <- 0
#   for(i in 1:length(lista_nombres)){
#     for (j in 1:maximo) {
#       datos2[i,cant_nombres[j]] <- lista_nombres[[i]][j]
#     }
#     datos2$cantidad_nombres[i] <- length(lista_nombres[[i]])
#   }
#
#   return(datos2)
#
# }
#
#
