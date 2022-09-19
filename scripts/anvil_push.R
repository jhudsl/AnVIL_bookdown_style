#!/usr/bin/env Rscript

# --------- ---------

# #' @importFrom utils tail
library(utils)
.md_to_ipynb <-
  function(md_paths)
  {
    ipynb_paths <- sub("\\.md", ".ipynb", md_paths)
    for (i in seq_along(md_paths)) {
      system2(
        "notedown",
        c(
          md_paths[[i]],
          "-o",
          ipynb_paths[[i]],
          "--match=fenced --pre 'from IPython.display import IFrame, display, HTML'"
        )
      )
      ## FIXME: more robust way to add / update top-level metadata
      txt <- readLines(ipynb_paths[[i]])
      idx <- tail(grep(' "metadata": {},', txt, fixed = TRUE), 1)
      txt[idx] <- paste0(
        ' "metadata": {',
        '  "kernelspec": {',
        '   "display_name": "R",',
        '   "language": "R",',
        '   "name": "ir"',
        '  }',
        '},'
      )
      writeLines(txt, ipynb_paths[[i]])
    }
    ipynb_paths
  }

# #' @importFrom AnVIL avbucket gsutil_cp
library(AnVIL)
.cp_to_cloud_notebooks <-
  function(notebooks, namespace, name)
  {
    message("starting gsutil cp step")
    avworkspaces()
    avbucket("anvil-outreach", "Learn_AnVIL_on_AnVIL")
    bucket <- avbucket(namespace, name)
    message("bucket name is", bucket)
    bucket_notebooks <- paste0(bucket, "/notebooks/")
    message("Copying from", bucket_notebooks, "to", bucket)
    gsutil_cp(notebooks, bucket_notebooks)
    message(paste0(bucket_notebooks, basename(notebooks)))
    
    # bucket_resources <- paste0(bucket)
    # gsutil_cp("/Users/avahoffman/Dropbox/FredHutch/Learn_AnVIL_on_AnVIL/vignettes/resources/", bucket_resources, recursive = TRUE)
  }


# #' @importFrom here here
library(here)
send_notebooks <-
  function(repo, namespace, name)
  {
    system2("mkdir", "-p docs/anvil")
    system2("cp", "docs/*.md docs/anvil")
    docs_path <- file.path(here(), "docs/anvil")
    md_paths <- dir(docs_path, pattern = "\\.md$", full.names = TRUE)
    ipynb_paths <- .md_to_ipynb(md_paths)
    message("Pushing the following .ipynb to AnVIL:", ipynb_paths)
    #system2("notedown", "docs/anvil/02-chapter_of_course.md -o docs/anvil/02-chapter_of_course.ipynb --match=fenced --pre 'from IPython.display import IFrame, display, HTML'")
    system2(
      "find",
      "docs/anvil -name '*.ipynb' -type f -print0 | xargs -0 sed -i 's|    <img src=\\\\\"|<img src=\\\\\"|g'"
    )
    system2(
      "find",
      paste0(
        "docs/anvil -name '*.ipynb' -type f -print0 | xargs -0 sed -i 's|<img src=\\\\\"|<img src=\\\\\"https://github.com/",
        repo,
        "/raw/main/docs/|g'"
      )
    )
    .cp_to_cloud_notebooks(ipynb_paths, namespace, name)
  }

# --------- parse options ---------

library(optparse)

option_list <- list(
  optparse::make_option(
    c("--repository"),
    type = "character",
    default = NULL,
    help = "This GitHub Repository (e.g., jhudsl/AnVIL_Template)",
  ),
  optparse::make_option(
    c("--namespace"),
    type = "character",
    default = NULL,
    help = "AnVIL Billing Project",
  ),
  optparse::make_option(
    c("--name"),
    type = "character",
    default = NULL,
    help = "AnVIL Workspace Name",
  )
)

# Read in the arguments
opt_parser <- optparse::OptionParser(option_list = option_list)
opt <- optparse::parse_args(opt_parser)
repository <- opt$repository
namespace <- opt$namespace
name <- opt$name

# --------- send notebooks ---------

send_notebooks(repository, namespace, name)
