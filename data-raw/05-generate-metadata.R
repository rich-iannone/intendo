library(tidyverse)

dataset_basename_vec <- c("all_revenue", "users_daily", "user_summary", "all_sessions")
sizes <- c("small", "medium", "large", "xlarge")

dataset_allnames_vec <-
  apply(expand.grid(dataset_basename_vec, sizes, c("", "f")), 1, paste, collapse = "_")
dataset_allnames_vec <- gsub("_$", "", dataset_allnames_vec)

get_local_data <- function(name) {
  size <- unlist(strsplit(name, "_"))[3]
  readRDS(paste0("data-", size, "/sj_", name, ".rds"))
}

get_metadata_row <- function(name) {

  data_tbl <- get_local_data(name = name)

  basename <- paste0(unlist(strsplit(name, "_"))[1:2], collapse = "_")
  size <- unlist(strsplit(name, "_"))[3]
  type <- if (grepl("_f$", name)) "faulty" else "perfect"
  rows <- nrow(data_tbl)
  columns <- ncol(data_tbl)

  dplyr::tibble(
    name = name,
    basename = basename,
    size = size,
    type = type,
    rows = rows,
    columns = columns
  )
}

intendo_meta <-
  dplyr::tibble(
    name = character(0),
    basename = character(0),
    size = character(0),
    type = character(0),
    rows = integer(0),
    columns = integer(0)
  )

for (i in seq_along(dataset_allnames_vec)) {

  metadata_row <- get_metadata_row(name = dataset_allnames_vec[i])
  intendo_meta <- dplyr::bind_rows(intendo_meta, metadata_row)
}
