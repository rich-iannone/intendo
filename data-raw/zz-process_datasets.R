library(usethis)

# source("data-raw/01-generate_intendo_data-2.R")

intendo_users <- readRDS("data-raw/intendo_users.rds")
intendo_revenue <- readRDS("data-raw/intendo_revenue.rds")
intendo_daily_users <- readRDS("data-raw/intendo_daily_users.rds")

users_daily <- readRDS("data-raw/users_daily.rds")
all_revenue <- readRDS("data-raw/all_revenue.rds")
all_sessions <- readRDS("data-raw/all_sessions.rds")

# Create external datasets
usethis::use_data(
  intendo_users, intendo_revenue, intendo_daily_users,
  users_daily, all_revenue, all_sessions,
  internal = FALSE, overwrite = TRUE
)
