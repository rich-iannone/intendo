library(usethis)

source("data-raw/X01-generate-metadata.R")
source("data-raw/X01-generate-previews.R")

# Create internal dataset
usethis::use_data(
  intendo_meta,
  all_revenue_preview,
  users_daily_preview,
  user_summary_preview,
  all_sessions_preview,
  internal = TRUE, overwrite = TRUE
)
