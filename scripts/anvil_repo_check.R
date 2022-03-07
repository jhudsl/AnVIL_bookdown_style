#!/usr/bin/env Rscript

library(optparse)
library(httr)
# library(jsonlite)
# library(dplyr)
# library(readr)

option_list <- list(
  optparse::make_option(
    c("--repo"),
    type = "character",
    default = NULL,
    help = "GitHub repository name, e.g. jhudsl/DaSL_Course_Template_Bookdown",
  ),
  optparse::make_option(
    c("--git_pat"),
    type = "character",
    default = NULL,
    help = "GitHub personal access token",
  )
)

# Read the arguments passed
opt_parser <- optparse::OptionParser(option_list = option_list)
opt <- optparse::parse_args(opt_parser)

repo <- opt$repo
git_pat <- opt$git_pat

if (!is.character(repo)) {
  repo <- as.character(repo)
}

message(paste("You are here:", repo))
message(paste("Checking for AnVIL repositories..."))

req <- httr::GET(
  "https://api.github.com/search/repositories?q=AnVIL+user:jhudsl",
  httr::add_headers(Authorization = paste("token", git_pat))
)

message(paste(httr::content(req, as = "text")))
message(paste("http_error:", httr::http_error(req)))

# if (!(httr::http_error(req))) {
#   message(paste("API request successful!"))
#   repo_dat <-
#     jsonlite::fromJSON(httr::content(req, as = "text"), flatten = TRUE)
#   repo_df <-
#     dplyr::tibble(repo_dat$items) %>% dplyr::select(name, html_url)
#   if (!dir.exists("resources")) {
#     dir.create("resources")
#   }
#   if (nrow(repo_df) > 0) {
#     write(nrow(repo_df), stdout())
#     readr::write_tsv(repo_df, file.path('resources', 'AnVIL_repos.tsv'))
#   } else {
#     readr::write_tsv(tibble(), file.path('resources', 'AnVIL_repos.tsv'))
#   }
#
# } else {
#   message(paste("API request failed!"))
#   if (!dir.exists("resources")) {
#     dir.create("resources")
#   }
#   readr::write_tsv(tibble(), file.path('resources', 'AnVIL_repos.tsv'))
# }
