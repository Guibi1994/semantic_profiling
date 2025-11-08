library(dplyr)
library(tidyr)
library(ggplot2)
library(openai)
library(fmsb)
readRenviron(path = ".Renviron")

# Funciones complementarias
cos_similarity <- function(A,B) {
  similarity = sum(A * B) / (sqrt(sum(A^2)) * sqrt(sum(B^2)))  
  return(similarity)
}

embedding <- function(text) {
  reference_embedding <- openai::create_embedding(
  input = text,
  model = "text-embedding-3-small",
  openai_api_key = Sys.getenv("OPENAI"))

  tokens = reference_embedding$usage[1]
  usd_cost = as.numeric(reference_embedding$usage[1])*(0.02/(10^6))
  cop_cost = usd_cost*4000

  message(paste0(
    "Tokens gastados: ",tokens,
    "\nCosto (USD): ", scales::dollar(usd_cost),
    "\nCosto (COP); ", scales::dollar(cop_cost),
    "\nModelo usado: text-embedding-3-small"))
  
  return(unlist(reference_embedding$data$embedding))
}

scale_to_red <- function(vector_objetivo) {
  x <- as.numeric((scale(vector_objetivo)+(abs(min(scale(vector_objetivo), na.rm = T))))/
                    max(scale(vector_objetivo)+(abs(min(scale(vector_objetivo), na.rm = T))),
                        na.rm = T))
  return(x)
}

semantic_radar <- function(semantic_similarity_matrix) {
  semantic_similarity_matrix |> mutate(max = 1) |> 
      select(archetype,max) |> 
      pivot_wider(names_from = archetype,values_from = max) |> 
  rbind(
    semantic_similarity_matrix |> mutate(min = 0) |> 
      select(archetype,min) |> 
      pivot_wider(names_from = archetype,values_from = min)) |> 
  rbind(
    semantic_similarity_matrix |> 
      mutate(similarity = scale_to_red(similarity)) |> 
  pivot_wider(names_from = archetype,values_from = similarity)) |> 
  radarchart()  
}



# 1. Extraer iformació de valoración -----
reference_valuation = 
  "
  Ese guibor es una chanda me pidio prestado plata y todo salio mal, se me perdio. Ahora me
  pone como una referencia... yo no se si es man es pendejo o chiflado: ese man es mala paga.
  Mucho cuidado. Y cuadno lo llame, muy grosero y peleon, una mierda de pelado.
  "

# 2. Definición de arquetipos -----

debtor_archetypes <- function(reference_valuation) { 
  
  archetypes = data.frame(
    archetypes = c(
      "El cumplido",
      "El prevenido",
      "El atrasado crónico",
      "El sobreendeudado",
      "El invisible",
      "El oportunista",
      "El conflictivo"),
    descriptions = c(
      "Historial impecable, paga puntual y mantiene bajo nivel de riesgo.",
      "Se anticipa a problemas, pide plazos o refinancia antes de caer en mora.",
      "Siempre paga tarde, normaliza el atraso como forma de financiamiento.",
      "Tiene múltiples deudas, alta carga financiera y poca capacidad de pago.",
      "Difícil de contactar, no actualiza datos ni responde gestiones.",
      "Aprovecha promociones, condonaciones o amnistías, paga solo si conviene.",
      "Resiste la gestión, niega la obligación o amenaza o pelea")) |> 
    mutate(full_text = paste0(archetypes,": ",descriptions))


  # Embedings

  reference_embedding <- embedding(text = reference_valuation)

  archetypes_embeddings <- data.frame(
    archetype = character(),
    embedding = numeric())

  semantic_similarity_matrix <- data.frame(
    archetype = character(),
    similarity = numeric())

  for (i in 1:nrow(archetypes)) {
    
    # Calcular embedding de cada arquetipo
    .archetype <- archetypes$archetypes[i]
    .embedding <- embedding(text = archetypes$full_text[i])

    # Base de emebedings
    archetypes_embeddings  <- rbind(
      archetypes_embeddings,
      data.frame(
        archetype = .archetype,
        embedding = .embedding))
    
    # Matriz de similitud

    semantic_similarity_matrix <- rbind(
      semantic_similarity_matrix,
      data.frame(
        archetype = .archetype,
        similarity = cos_similarity(reference_embedding, .embedding)
      )
    )
  }
  radar = semantic_radar(semantic_similarity_matrix)

    return(list(
      "reference_embedding"=reference_embedding,
      "archetypes_embeddings"=archetypes_embeddings,
      "semantic_similarity_matrix"=semantic_similarity_matrix,
      "plot" = radar))
  
}


result = debtor_archetypes(
  reference_valuation = 
    "Si coosoa Jairo, si teien un negiocio de reparación de motos, le he visto
  que le hcieorn un par de escandalos por que no entrego unas reparaciones, pero el man
  se ve de buena familia. Sin embargo, yo no le prestaria de mi plata. El amn tiene 1l negocio hace 
  10 años y se ve q facturea bien")

  result$semantic_similarity_matrix
  



