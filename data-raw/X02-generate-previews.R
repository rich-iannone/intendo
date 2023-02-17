library(tidyverse)
library(intendo)

all_revenue_preview <-
  all_revenue() |>
  slice_head(n = 200)

users_daily_preview <-
  users_daily() |>
  slice_head(n = 200)

user_summary_preview <-
  user_summary() |>
  slice_head(n = 200)

all_sessions_preview <-
  all_sessions() |>
  slice_head(n = 200)
