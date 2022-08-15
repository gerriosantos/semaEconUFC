

# Tab dplyr ----

tab_dplyr <- tibble(
  Verbos = c('mutate', 'rename', 'select', 'filter', 'group_by', 'summarise',
             'arrange', '*_join', 'relocate', 'across', 'distinct'),
  `Funções` = c('cria novas colunas, mantendo as existentes',
                'renomea colunas de interesse',
                'seleciona colunas de interesse',
                'seleciona um subconjunto de dados (linhas) por condições',
                'realiza agrupamentos de variáveis',
                'condensa múltiplos valores para um ´unico valor, redução de dimensão',
                'reordena linhas',
                'junções de tabelas (left, right, inner, full...)',
                'reordena a posição das coluna',
                'realiza transformações com mais de uma coluna ao mesmo tempo',
                'filtra linhas com valores distintos/unicos')
  )

readr::write_rds(tab_dplyr, 'data-raw/tab_dplyr.rds')


# Tab














