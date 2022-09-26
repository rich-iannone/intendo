# Location of GitHub repo
gh_repo_intendo <- "rich-iannone/intendo"

#' All revenue amounts for Super Jetroid
#'
#' @description
#' This summary table provides revenue data for every in-app purchase and ad
#' view for players of Super Jetroid in 2015.
#'
#' @inheritParams all_sessions
#'
#' @return A data table object, which could be a tibble (`tbl_df`) a data
#'   frame, or an in-memory DuckDB table (`tbl_dbi`).
#'
#' @export
all_revenue <- function(
    size = c("small", "medium", "large", "xlarge"),
    quality = c("perfect", "faulty"),
    type = c("tibble", "data.frame", "duckdb"),
    keep = FALSE
) {

  size <- rlang::arg_match(size)
  quality <- rlang::arg_match(quality)
  type <- rlang::arg_match(type)

  get_sj_tbl_from_gh_url(
    name = "all_revenue",
    size = size,
    quality = quality,
    type = type,
    keep = keep
  )
}

#' Daily users playing Super Jetroid
#'
#' @description
#' This summary table provides daily totals for every player that had at least
#' one login/session in a day. We get measures such as daily sessions, time
#' played, number of IAPs bought and ads viewed, revenue gained, progression
#' info, and some segmentation categories.
#'
#' @inheritParams all_sessions
#'
#' @return A data table object, which could be a tibble (`tbl_df`) a data
#'   frame, or an in-memory DuckDB table (`tbl_dbi`).
#'
#' @export
users_daily <- function(
    size = c("small", "medium", "large", "xlarge"),
    quality = c("perfect", "faulty"),
    type = c("tibble", "data.frame", "duckdb"),
    keep = FALSE
) {

  size <- rlang::arg_match(size)
  quality <- rlang::arg_match(quality)
  type <- rlang::arg_match(type)

  get_sj_tbl_from_gh_url(
    name = "users_daily",
    size = size,
    quality = quality,
    type = type,
    keep = keep
  )
}

#' User summaries for Super Jetroid
#'
#' @description This summary table provides information on each user. We get
#' information here such as the first login/session time and some information
#' useful for segmentation.
#'
#' @inheritParams all_sessions
#'
#' @return A data table object, which could be a tibble (`tbl_df`) a data
#'   frame, or an in-memory DuckDB table (`tbl_dbi`).
#'
#' @export
user_summary <- function(
    size = c("small", "medium", "large", "xlarge"),
    quality = c("perfect", "faulty"),
    type = c("tibble", "data.frame", "duckdb"),
    keep = FALSE
) {

  size <- rlang::arg_match(size)
  quality <- rlang::arg_match(quality)
  type <- rlang::arg_match(type)

  get_sj_tbl_from_gh_url(
    name = "user_summary",
    size = size,
    quality = quality,
    type = type,
    keep = keep
  )
}

get_sj_tbl_from_gh_url <- function(
    name,
    size,
    quality,
    type,
    keep
) {

  file_name <-
    paste0(
      "sj_", name, "_", size,
      if (quality == "perfect") NULL else "_f",
      ".rds"
    )

  if (file_name %in% list.files()) {

    tbl_data <- readRDS(file_name)

  } else {

    tbl_data <-
      pointblank::file_tbl(
        file = pointblank::from_github(
          file = file_name,
          repo = gh_repo_intendo,
          subdir = paste0("data-", size)
        ),
        keep = keep
      )
  }

  if (type == "data.frame") {

    tbl_data <- as.data.frame(tbl_data, stringsAsFactors = FALSE)

  } else if (type == "duckdb") {

    tbl_data <-
      pointblank::db_tbl(
        table = tbl_data,
        dbname = ":memory:",
        dbtype = "duckdb"
      )
  }

  tbl_data
}

#' All player sessions for Super Jetroid
#'
#' @description
#' This table provides information on player sessions and summarizes the number
#' of revenue events (ad views and IAP spends) and provides total revenue
#' amounts (in USD) broken down by type for the session.
#'
#' @param size A keyword that allows getting different variants of the table
#'   based on the size of player base. The default `"small"` table has the
#'   lowest number of players/records. Increasing in size, we can also opt for
#'   the `"medium"`, `"large"`, or `"xlarge"` versions.
#' @param quality The data quality level of the returned dataset. There are two
#'   options: (1) `"perfect"` provides a pristine table with no errors at all
#'   and (2) `"faulty"` gives you a table with a multitude of errors.
#' @param type The table return type. By default, this is a `"tibble"` but a
#'   `"data.frame"` can instead be returned if using that keyword. If you have
#'   the **duckdb** package installed, you can instead obtain the table as an
#'   in-memory DuckDB database table.
#' @param keep Should the downloaded data be stored on disk in the working
#'   directory? By default, this is `FALSE`. If the file is available in the
#'   next invocation then the data won't be downloaded again.
#'
#' @return A data table object, which could be a tibble (`tbl_df`) a data
#'   frame, or an in-memory DuckDB table (`tbl_dbi`).
#'
#' @export
all_sessions <- function(
    size = c("small", "medium", "large", "xlarge"),
    quality = c("perfect", "faulty"),
    type = c("tibble", "data.frame", "duckdb"),
    keep = FALSE
) {

  size <- rlang::arg_match(size)
  quality <- rlang::arg_match(quality)
  type <- rlang::arg_match(type)

  get_sj_tbl_from_gh_url(
    name = "all_sessions",
    size = size,
    quality = quality,
    type = type,
    keep = keep
  )
}
