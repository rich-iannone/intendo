library(usethis)

intendo_users <- readRDS("data-raw/intendo_users.rds")
intendo_revenue <- readRDS("data-raw/intendo_revenue.rds")
intendo_daily_users <- readRDS("data-raw/intendo_daily_users.rds")

users_daily <- readRDS("data-raw/users_daily.rds")
all_revenue <- readRDS("data-raw/all_revenue.rds")
all_sessions <- readRDS("data-raw/all_sessions.rds")
user_summary <- readRDS("data-raw/user_summary.rds")

# Create external datasets
usethis::use_data(
  intendo_users, intendo_revenue, intendo_daily_users,
  users_daily, all_revenue, all_sessions, user_summary,
  internal = FALSE, overwrite = TRUE
)
