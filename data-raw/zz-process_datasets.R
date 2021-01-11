library(usethis)

sj_users_daily <- readRDS("data-raw/sj_users_daily.rds")
sj_all_revenue <- readRDS("data-raw/sj_all_revenue.rds")
sj_all_sessions <- readRDS("data-raw/sj_all_sessions.rds")
sj_user_summary <- readRDS("data-raw/sj_user_summary.rds")

sj_users_daily_f <- readRDS("data-raw/sj_users_daily_f.rds")
sj_all_revenue_f <- readRDS("data-raw/sj_all_revenue_f.rds")
sj_all_sessions_f <- readRDS("data-raw/sj_all_sessions_f.rds")
sj_user_summary_f <- readRDS("data-raw/sj_user_summary_f.rds")

# Create external datasets
usethis::use_data(
  sj_users_daily, sj_all_revenue, sj_all_sessions, sj_user_summary,
  sj_users_daily_f, sj_all_revenue_f, sj_all_sessions_f, sj_user_summary_f,
  internal = FALSE, overwrite = TRUE
)
