#!/usr/bin/env Rscript

# Written by Candace Savonen Sept 2021

if (!("optparse" %in% installed.packages())){
  install.packages("optparse")
}

library(optparse)

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

gtoken <- config(token = git_pat)
req <- GET("https://api.github.com/search/repositories?q=AnVIL+user:jhudsl", gtoken)

message(paste("Checked the API"))

# Print out the result
#write(check_git_repo(repo, git_pat = git_pat), stdout())
