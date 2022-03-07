library(dplyr)
library(stringr)

make_anvil_repo_table <- function(exclude = NULL) {
  # Read in AnVIL repos found by GHA
  df <-
    readr::read_tsv("resources/AnVIL_repos.tsv")
  
  # Replace github url with DaSL url
  df$html_url <-
    stringr::str_replace_all(df$html_url,
                             "https://github.com/jhudsl",
                             "https://jhudatascience.org")
  
  # Filter out any user specified repos (could be some that are in progress, 
  # templates, etc)
  df <-
    df %>%
    filter(!(name %in% exclude)) %>%
    rename(`Book Name` = name,
           `Link` = html_url) %>%
    arrange(`Book Name`)
  
  return(df)
}