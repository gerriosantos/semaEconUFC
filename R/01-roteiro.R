
rm(list = ls())
gc()

library(tidyverse)
library(readxl)


############ IMPORTAR DADOS ################################

# Importando ----

# rais <- read_xlsx(path = 'data-raw/df_rais.xlsx')

covid <- read_csv('data-raw/caso.csv')

# Pegar online no brail.io (ultimo atualização no site em 2022-03-27)
# url = "https://data.brasil.io/dataset/covid19/caso.csv.gz"
# covid <- readr::read_csv(url)





######## ORGANIZAR E MANIPULAR (Wrangling) ###########

# Organizando e manipulando -----

# dplyr ----

# Forma Ineficiente

covid_1 <- mutate(covid, regiao = case_when(
    state %in% c('PA', 'AM', 'AP', 'RO', 'AC', 'TO', 'RR') ~ "NO",
    state %in% c('BA', 'CE', 'PE', 'MA', 'PI', 'SE', 'AL', 'PB', 'RN') ~ "NE",
    state %in% c('SP', 'RJ', 'MG', 'ES') ~ "SE",
    state %in% c('RS', 'PR', 'SC') ~ "SU",
    state %in% c('MS', 'MT', 'GO', 'DF') ~ "CO"))

covid_2 <- rename(covid_1, pop = estimated_population_2019)

covid_3 <- select(covid_2, date, regiao, state, city, place_type, pop, deaths)

covid_4 <- filter(covid_3, regiao == 'NE')

covid_5 <-  group_by(covid_4, state)

covid_6 <- summarise(covid_5, deaths = max(deaths, na.rm = T))

covid_7 <-  arrange(covid_6, deaths)





#Forma Eficiente
# Criar regiao a partir das UFs
covid_1 <- covid |>
  mutate(regiao = case_when(
    state %in% c('PA', 'AM', 'AP', 'RO', 'AC', 'TO', 'RR') ~ "NO",
    state %in% c('BA', 'CE', 'PE', 'MA', 'PI', 'SE', 'AL', 'PB', 'RN') ~ "NE",
    state %in% c('SP', 'RJ', 'MG', 'ES') ~ "SE",
    state %in% c('RS', 'PR', 'SC') ~ "SU",
    state %in% c('MS', 'MT', 'GO', 'DF') ~ "CO")

  )|>
  rename(pop = estimated_population_2019) |>
  select(date, regiao, state, city, place_type, pop, deaths) |>
  filter(regiao == 'NE') |>
  group_by(state) |>
  summarise(deaths = max(deaths, na.rm = T)) |>
  arrange(deaths)


# Criar uma tibble ----

cod_uf <- tibble(
  state = c("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE"),
  cod_state = c(27, 29, 23, 21, 25, 26, 22, 24, 28)
  ) |> arrange(cod_state)


# cod_uf <- data.frame(
#   state = c("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE"),
#   cod_state = c(27, 29, 23, 21, 25, 26, 22, 24, 28)
# ) |> arrange(cod_state)


# Juntar as bases

# Join id = 'state'
# Após, realocar cod_state antes do state
# transformar mais de uma coluna

covid_join <- left_join(covid_1, cod_uf, by = 'state') |>
  relocate(cod_state, .before = state) |>
  # basico a intermediário
  mutate(across(.cols = c(cod_state, deaths), .fns =  as.character))


###################### FUNCOES JOINS ###################################

# joins ----
# Fazer ligações de tabelas usando uma CHAVE


tab_1 <- tibble(A = c('a', 'b', 'c'), B = c('t', 'u', 'v'), C = 1:3)

tab_2 <- tibble(A = c('a', 'b', 'd'), `B` = c('t', 'u', 'w'), D = 3:1)


# MATATING JOIN (Junta tabelas)

# Mantem tudo da chave da tab_1
left_join(tab_1, tab_2)

# Mantem tudo da chave da tab_2
right_join(tab_1, tab_2)

# Mantem o que é comum entre tab_1 e tab_2
inner_join(tab_1, tab_2)

# Mantem tudo das chaves de tab_1 e tab_2
full_join(tab_1, tab_2)



# FILTERING

#  a semi_join retorna linhas de tab_1 para as quais há valores
# correspondentes em tab_2 (mas não as colunas tab_2)

# Retorna linhas de tab_1 que estão em tab_2
semi_join(tab_1, tab_2)


# Retorna linhas de tab_1 que não estão em tab_2
anti_join(tab_1, tab_2)

#

# site bom para ver https://rpubs.com/CristianaFreitas/311735

###############  BIND_COL E BIND_ROW ###########################

t_1 <- tibble(A = c('a', 'b', 'c'), B = c('t', 'u', 'v'), C = 1:3)

t_2 <- tibble(E = c('a', 'b', 'd'), `F` = c('t', 'u', 'w'), G = 3:1)




# tidy ----

# Base Ceará
covid <- covid |>
  filter(state == 'CE' & city %in% c('Coreaú', 'Sobral'))


# separate
covid_1 <- separate(data = covid, col = date, into = c('ano', 'mes', 'dia'), sep = '-')

# unite
covid_2 <- unite(data = covid_1, col = 'date2', c('ano', 'mes', 'dia'), sep = '-')


# pivotagem

# Base de dados para pivotagem
d <- covid_1 |> select(ano, city, deaths) |>
  group_by(ano, city) |>
  summarise(deaths = max(deaths))


d1 <- pivot_wider(data = d, names_from = ano, values_from = deaths, names_glue = 'mortes_{ano}')


d2 <- pivot_longer(data = d1, cols = c('2020', '2021'), names_to = 'ano', values_to = 'deaths')

write_rds(d1, 'data-raw/tab_piv_wider.rds')

# drop_na

rm(list = ls())

covid <- read_csv('data-raw/caso.csv')


covid_na <- drop_na(data = covid)

covid_na <- drop_na(data = covid, city)








