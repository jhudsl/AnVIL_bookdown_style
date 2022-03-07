library(dplyr)
library(stringr)

make_anvil_repo_table <- function(exclude = NULL) {
  df <-
    readr::read_tsv("resources/AnVIL_repos.tsv")
  
  df$html_url <-
    stringr::str_replace_all(df$html_url,
                             "https://github.com/jhudsl",
                             "https://jhudatascience.org")
  
  df <-
    df %>%
    filter(!(name %in% exclude)) %>%
    rename(`Book Name` = name,
           `Link` = html_url) %>%
    arrange(`Book Name`)
  
  return(df)
}

make_anvil_repo_table(exclude = c("anvil-intro",
                                  "AnVIL_bookdown_style"))