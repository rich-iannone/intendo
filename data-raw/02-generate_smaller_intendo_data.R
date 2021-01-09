library(tidyverse)

# Set a seed
set.seed(23)

users_daily_small <- readRDS("data-raw/users_daily.rds")
all_revenue_small <- readRDS("data-raw/all_revenue.rds")
all_sessions_small <- readRDS("data-raw/all_sessions.rds")
user_summary_small <- readRDS("data-raw/user_summary.rds")

users_basis <-
  user_summary_small %>%
  dplyr::distinct(player_id) %>%
  dplyr::pull()

n_users_basis <- length(users_basis)

n_users_small <- floor(n_users_basis / 10)

users_small <- sample(users_basis, size = n_users_small)

users_daily_small <-
  users_daily_small %>%
  dplyr::filter(player_id %in% users_small)

all_revenue_small <-
  all_revenue_small %>%
  dplyr::filter(player_id %in% users_small)

all_sessions_small <-
  all_sessions_small %>%
  dplyr::filter(player_id %in% users_small)

user_summary_small <-
  user_summary_small %>%
  dplyr::filter(player_id %in% users_small)

saveRDS(users_daily_small, file = "data-raw/users_daily_small.rds")
saveRDS(all_revenue_small, file = "data-raw/all_revenue_small.rds")
saveRDS(all_sessions_small, file = "data-raw/all_sessions_small.rds")
saveRDS(user_summary_small, file = "data-raw/user_summary_small.rds")
