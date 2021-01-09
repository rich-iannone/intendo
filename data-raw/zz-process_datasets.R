library(usethis)

intendo_users <- readRDS("data-raw/intendo_users.rds")
intendo_revenue <- readRDS("data-raw/intendo_revenue.rds")
intendo_daily_users <- readRDS("data-raw/intendo_daily_users.rds")

users_daily_small <- readRDS("data-raw/users_daily_small.rds")
all_revenue_small <- readRDS("data-raw/all_revenue_small.rds")
all_sessions_small <- readRDS("data-raw/all_sessions_small.rds")
user_summary_small <- readRDS("data-raw/user_summary_small.rds")

users_daily_small_f <- readRDS("data-raw/users_daily_small_f.rds")
all_revenue_small_f <- readRDS("data-raw/all_revenue_small_f.rds")
all_sessions_small_f <- readRDS("data-raw/all_sessions_small_f.rds")
user_summary_small_f <- readRDS("data-raw/user_summary_small_f.rds")

# Create external datasets
usethis::use_data(
  intendo_users, intendo_revenue, intendo_daily_users,
  users_daily_small, all_revenue_small,
  all_sessions_small, user_summary_small,
  users_daily_small_f, all_revenue_small_f,
  all_sessions_small_f, user_summary_small_f,
  internal = FALSE, overwrite = TRUE
)
