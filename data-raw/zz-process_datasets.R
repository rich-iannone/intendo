library(usethis)

source("data-raw/05-generate-metadata.R")

# Create internal dataset
usethis::use_data(
  intendo_meta,
  internal = TRUE, overwrite = TRUE
)
