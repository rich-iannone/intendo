library(usethis)

# source("data-raw/01-generate_intendo_data.R")

saveRDS(intendo_users, file = "data-raw/intendo_users.rds")
saveRDS(intendo_revenue, file = "data-raw/intendo_revenue.rds")
saveRDS(intendo_daily_users, file = "data-raw/intendo_daily_users.rds")

# # Create external datasets
# usethis::use_data(
#   intendo_users, intendo_revenue, intendo_daily_users,
#   internal = FALSE, overwrite = TRUE
# )
