


# install.packages("googlesheets4")
# install.packages("googledrive")
library(googlesheets4)
library(googledrive)


# Autorizar o googlesheets4 a usar sua conta

gs4_auth()

u <- 'https://docs.google.com/spreadsheets/d/1M1d9_OTcL5D4gdQmuq_C0zugWAT5OfTy6iQFCz-9WIg/edit?resourcekey#gid=2075495360'


df <- read_sheet(u)


drive_find(pattern = 'Introdução a Linguagem R (respostas)')

d <- drive_get('Introdução a Linguagem R (respostas).xlsx') |>
  tibble::as_tibble()



d <- read_sheet(u)

Introdução a Linguagem R (respostas)
