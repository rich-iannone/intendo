#' Get a data frame with metadata for all datasets
#'
#' @description
#'
#' The `intendo_metadata()` function provides a data frame containing metadata
#' for datasets in the **intendo** package.
#'
#' @param include Should both perfect and faulty datasets be included in the
#' metadata table? This is the default (`"all"`), otherwise one can use the
#' `"perfect"` or `"faulty"` keywords to get a subset of the metadata table.
#'
#' @return A data frame.
#'
#' @examples
#'
#' # Obtain metadata on all datasets in the package but
#' # only those in their 'perfect' form
#' intendo_metadata(include = "perfect")
#'
#' @export
intendo_metadata <- function(include = c("all", "perfect", "faulty")) {

  include <- match.arg(include)

  metadata_tbl <- intendo_meta

  if (include == "perfect") {
    metadata_tbl <- metadata_tbl[1:16, ]
  }

  if (include == "faulty") {
    metadata_tbl <- metadata_tbl[17:32, ]
  }

  metadata_tbl
}
