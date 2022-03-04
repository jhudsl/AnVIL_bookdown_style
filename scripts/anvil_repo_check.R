#!/usr/bin/env Rscript

library(optparse)
library(httr)

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

message(paste("Checking for remote git repository:", repo))

httr::GET(
  "https://api.github.com/search/repositories?q=AnVIL+user:jhudsl",
  httr::add_headers(Authorization = paste("token", git_pat))
)

message(paste("Checked the API"))
