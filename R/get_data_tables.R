# Location of GitHub repo
gh_repo_intendo <- "rich-iannone/intendo"

#' All revenue amounts for Super Jetroid
#'
#' @description
#' This summary table provides revenue data for every in-app purchase and ad
#' view for players of Super Jetroid in 2015.
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
#'   frame, or an in-memory DuckDB table (`tbl_dbi`). If a CSV is written then
#'   `TRUE` will be invisibly returned.
#'
#' @examples
#'
#' # Get a preview of the `all_revenue` dataset
#' # with the 'preview' size option
#' all_revenue(size = "preview")
#'
#' @export
all_revenue <- function(
    size = c("small", "medium", "large", "xlarge", "preview"),
    quality = c("perfect", "faulty"),
    type = c("tibble", "data.frame", "duckdb", "csv"),
    keep = FALSE
) {

  size <- match.arg(size)
  quality <- match.arg(quality)
  type <- match.arg(type)

  if (size == "preview") {
    return(all_revenue_preview)
  }

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
#' @inheritParams all_revenue
#'
#' @return A data table object, which could be a tibble (`tbl_df`) a data
#'   frame, or an in-memory DuckDB table (`tbl_dbi`). If a CSV is written then
#'   `TRUE` will be invisibly returned.
#'
#' @examples
#'
#' # Get a preview of the `users_daily` dataset
#' # with the 'preview' size option
#' users_daily(size = "preview")
#'
#' @export
users_daily <- function(
    size = c("small", "medium", "large", "xlarge", "preview"),
    quality = c("perfect", "faulty"),
    type = c("tibble", "data.frame", "duckdb", "csv"),
    keep = FALSE
) {

  size <- match.arg(size)
  quality <- match.arg(quality)
  type <- match.arg(type)

  if (size == "preview") {
    return(users_daily_preview)
  }

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
#' @inheritParams all_revenue
#'
#' @return A data table object, which could be a tibble (`tbl_df`) a data
#'   frame, or an in-memory DuckDB table (`tbl_dbi`). If a CSV is written then
#'   `TRUE` will be invisibly returned.
#'
#' @examples
#'
#' # Get a preview of the `user_summary` dataset
#' # with the 'preview' size option
#' user_summary(size = "preview")
#'
#' @export
user_summary <- function(
    size = c("small", "medium", "large", "xlarge", "preview"),
    quality = c("perfect", "faulty"),
    type = c("tibble", "data.frame", "duckdb", "csv"),
    keep = FALSE
) {

  size <- match.arg(size)
  quality <- match.arg(quality)
  type <- match.arg(type)

  if (size == "preview") {
    return(user_summary_preview)
  }

  get_sj_tbl_from_gh_url(
    name = "user_summary",
    size = size,
    quality = quality,
    type = type,
    keep = keep
  )
}

#' All player sessions for Super Jetroid
#'
#' @description
#' This table provides information on player sessions and summarizes the number
#' of revenue events (ad views and IAP spends) and provides total revenue
#' amounts (in USD) broken down by type for the session.
#'
#' @inheritParams all_revenue
#'
#' @return A data table object, which could be a tibble (`tbl_df`) a data
#'   frame, or an in-memory DuckDB table (`tbl_dbi`). If a CSV is written then
#'   `TRUE` will be invisibly returned.
#'
#' @examples
#'
#' # Get a preview of the `all_sessions` dataset
#' # with the 'preview' size option
#' all_sessions(size = "preview")
#'
#' @export
all_sessions <- function(
    size = c("small", "medium", "large", "xlarge", "preview"),
    quality = c("perfect", "faulty"),
    type = c("tibble", "data.frame", "duckdb", "csv"),
    keep = FALSE
) {

  size <- match.arg(size)
  quality <- match.arg(quality)
  type <- match.arg(type)

  if (size == "preview") {
    return(all_sessions_preview)
  }

  get_sj_tbl_from_gh_url(
    name = "all_sessions",
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

  if (type == "duckdb") {

    if (!requireNamespace("duckdb", quietly = TRUE)) {

      stop(
        "Accessing a DuckDB table requires the duckdb package:\n",
        "* It can be installed with `install.packages(\"duckdb\")`.",
        call. = FALSE
      )
    }

    if (!requireNamespace("dplyr", quietly = TRUE)) {

      stop(
        "Accessing a DuckDB table requires the dplyr package:\n",
        "* It can be installed with `install.packages(\"dplyr\")`.",
        call. = FALSE
      )
    }

    if (!requireNamespace("DBI", quietly = TRUE)) {

      stop(
        "Accessing a DuckDB table requires the DBI package:\n",
        "* It can be installed with `install.packages(\"DBI\")`.",
        call. = FALSE
      )
    }
  }

  file_name <-
    paste0(
      "sj_", name, "_", size,
      if (quality == "perfect") NULL else "_f",
      ".rds"
    )

  if (file_name %in% list.files(full.names = FALSE)) {

    tbl_data <- readRDS(file_name)

  } else {

    url <-
      paste0(
        "https://github.com/",
        gh_repo_intendo,
        "/raw/main/data-",
        size, "/", file_name
      )

    if (!keep) {

      temp_dir <- tempdir()
      file_path <- file.path(temp_dir, file_name)

    } else {
      file_path <- file_name
    }

    download_out <- download_remote_file(url = url, destfile = file_path)
    tbl_data <- readRDS(file = file_path)
  }

  if (type == "data.frame") {

    tbl_data <- as.data.frame(tbl_data, stringsAsFactors = FALSE)

  } else if (type == "duckdb") {

    # Create a connection for a DuckDB table
    connection <- DBI::dbConnect(drv = duckdb::duckdb(), dbdir = ":memory:")

    table_name <- sub(".rds", "", file_name)

    # Copy the tabular data into the `connection` object
    suppressWarnings(
      tbl_data <-
        dplyr::copy_to(
          dest = connection,
          df = tbl_data,
          name = table_name
        )
    )

  } else if (type == "csv") {

    utils::write.csv(
      tbl_data,
      file = paste0(name, ".csv"),
      na = "NA",
      row.names = FALSE,
      eol = "\n"
    )

    message(
      paste0(
        "The file `", paste0(name, ".csv"), "` was written to the ",
        "working directory."
      )
    )

    return(invisible(TRUE))
  }

  tbl_data
}

download_remote_file <- function(url, ...) {

  if (grepl("^https?://", url)) {

    is_r32 <- getRversion() >= "3.2"

    if (.Platform$OS.type == "windows") {

      if (is_r32) {

        method <- "wininet"

      } else {

        seti2 <- utils::"setInternet2"
        internet2_start <- seti2(NA)

        if (!internet2_start) {

          on.exit(suppressWarnings(seti2(internet2_start)))
          suppressWarnings(seti2(TRUE))
        }

        method <- "internal"
      }

      suppressWarnings(utils::download.file(url, method = method, ...))

    } else {

      if (is_r32 && capabilities("libcurl")) {

        method <- "libcurl"

      } else if (nzchar(Sys.which("wget")[1])) {

        method <- "wget"

      } else if (nzchar(Sys.which("curl")[1])) {

        method <- "curl"
        orig_extra_options <- getOption("download.file.extra")

        on.exit(options(download.file.extra = orig_extra_options))
        options(download.file.extra = paste("-L", orig_extra_options))

      } else if (nzchar(Sys.which("lynx")[1])) {

        method <- "lynx"

      } else {
        stop("No download method can be found.")
      }

      utils::download.file(url, method = method, ...)
    }

  } else {
    utils::download.file(url, ...)
  }
}
