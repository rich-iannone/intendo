library(usethis)

source("data-raw/01-generate_intendo_data.R")

# Create external datasets

usethis::use_data(
  intendo_users, intendo_revenue, intendo_daily_users,
  internal = FALSE, overwrite = TRUE
)
