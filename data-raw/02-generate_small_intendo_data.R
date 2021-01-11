library(tidyverse)

# Set a seed
set.seed(23)

users_daily_large <- readRDS("data-large/users_daily_large.rds")
all_revenue_large <- readRDS("data-large/all_revenue_large.rds")
all_sessions_large <- readRDS("data-large/all_sessions_large.rds")
user_summary_large <- readRDS("data-large/user_summary_large.rds")

users_basis <-
  user_summary_large %>%
  dplyr::distinct(player_id) %>%
  dplyr::pull()

n_users_basis <- length(users_basis)

n_users_small <- floor(n_users_basis / 10)

users_small <- sample(users_basis, size = n_users_small)

users_daily_small <-
  users_daily_large %>%
  dplyr::filter(player_id %in% users_small)

all_revenue_small <-
  all_revenue_large %>%
  dplyr::filter(player_id %in% users_small)

all_sessions_small <-
  all_sessions_large %>%
  dplyr::filter(player_id %in% users_small)

user_summary_small <-
  user_summary_large %>%
  dplyr::filter(player_id %in% users_small)

saveRDS(users_daily_small, file = "data-raw/sj_users_daily.rds")
saveRDS(all_revenue_small, file = "data-raw/sj_all_revenue.rds")
saveRDS(all_sessions_small, file = "data-raw/sj_all_sessions.rds")
saveRDS(user_summary_small, file = "data-raw/sj_user_summary.rds")
