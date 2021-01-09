library(tidyverse)
library(lubridate)

# Set a seed
set.seed(23)

users_daily <- readRDS("data-raw/users_daily.rds")
all_revenue <- readRDS("data-raw/all_revenue.rds")
all_sessions <- readRDS("data-raw/all_sessions.rds")
user_summary <- readRDS("data-raw/user_summary.rds")

users_daily_small <- readRDS("data-raw/users_daily_small.rds")
all_revenue_small <- readRDS("data-raw/all_revenue_small.rds")
all_sessions_small <- readRDS("data-raw/all_sessions_small.rds")
user_summary_small <- readRDS("data-raw/user_summary_small.rds")

# The `users_daily` table is made faulty in these ways:
#
# 1. The `n_iap_day` column is `numeric` instead of `integer`
# 2. The `player_id` sometimes has an `&` character appended to it
# 3. The `login_date` sometimes has the wrong year
# 4. The `playtime_total` is sometimes not increasing with `login_date`
# 5. There are a few duplicate rows
# 6. Ad revenue is often spuriously high in mid-January 2015
# 7. The encoding for "United States" in `country` is sometimes "US"
# 8. The encoding for "United Kingdom" in `country` is sometimes "UK"
# 9. The `sessions_day` column will sometimes have a `0` value, which isn't logical
# 10. The `acquisition` column will sometimes contain missing values
# 11. The `country` column will sometimes contain missing values
# 12. The `in_ftue` column will sometimes be TRUE even if `level_reached` is above `0`
# 13. The `at_eoc` column will sometimes be TRUE even if `level_reached` is below `100`
# 14. The `playtime_day` column will sometimes have negative values
# 15. If `sessions_day` is 2 and `login_date` is the same as `start_day` then
#     `sessions_total` is seen as `1`
# 16. Sometimes, `rev_ads_day` can be `0` even if `n_ads_day` > `0`
# 17. For the entire month of November, `rev_all_total` is too high
# 18. Some users will have multiple `start_day` values
# 19. In December, the `is_customer` column will often be incorrect
# 20. The `level_reached` value will sometimes backtrack in July and August

create_users_daily_f <- function(users_daily) {

  random_duplicate_rows <-
    sample(seq_len(nrow(users_daily)), size = 124)

  users_daily %>%
    dplyr::mutate(row_number = dplyr::row_number()) %>%
    dplyr::mutate(n_iap_day = as.numeric(n_iap_day)) %>% # 1
    dplyr::rowwise() %>%
    dplyr::mutate(
      player_id = ifelse(
        sample(1:100, 1) == 1,
        paste0(player_id, "&"),
        player_id
      )
    ) %>% # 2
    dplyr::mutate(
      login_date = lubridate::as_date(ifelse(
        sample(1:100, 1) == 1,
        login_date + 365,
        login_date
      ))
    ) %>% # 3
    dplyr::mutate(
      playtime_total = ifelse(
        sample(1:100, 1) == 1 && playtime_total > 100,
        playtime_total - as.numeric(sample(20:40, 1)),
        playtime_total
      )
    ) %>% # 4
    dplyr::mutate(
      duplicated = ifelse(
        row_number %in% random_duplicate_rows,
        sample(1:3, 1),
        1
      )
    ) %>%
    tidyr::uncount(duplicated) %>% # 5
    dplyr::rowwise() %>%
    dplyr::mutate(
      rev_ads_day = ifelse(
        sample(1:20, 1) == 1 &&
          login_date > lubridate::ymd("2015-01-15") &&
          login_date < lubridate::ymd("2015-01-20"),
        rev_ads_day * 20,
        rev_ads_day
      )
    ) %>% # 6
    dplyr::mutate(
      country = ifelse(
        sample(1:10, 1) == 1 &&
          country == "United States",
        "US",
        country
      )
    ) %>% # 7
    dplyr::mutate(
      country = ifelse(
        sample(1:10, 1) == 1 &&
          country == "United Kingdom",
        "UK",
        country
      )
    ) %>% # 8
    dplyr::mutate(
      sessions_day = ifelse(
        sample(1:100, 1) == 1,
        0L,
        sessions_day
      )
    ) %>% # 9
    dplyr::mutate(
      acquisition = ifelse(
        sample(1:200, 1) == 1,
        NA_character_,
        acquisition
      )
    ) %>% # 10
    dplyr::mutate(
      country = ifelse(
        sample(1:100, 1) == 1,
        NA_character_,
        country
      )
    ) %>% # 11
    dplyr::mutate(
      in_ftue = ifelse(
        sample(1:100, 1) == 1,
        TRUE,
        in_ftue
      )
    ) %>% # 12
    dplyr::mutate(
      at_eoc = ifelse(
        sample(1:50, 1) == 1,
        TRUE,
        at_eoc
      )
    ) %>% # 13
    dplyr::mutate(
      playtime_day = ifelse(
        sample(1:75, 1) == 1,
        playtime_day * -1.0,
        playtime_day
      )
    ) %>% # 14
    dplyr::mutate(
      sessions_total = ifelse(
        sessions_day == 2 && login_date == start_day,
        1L,
        sessions_total
      )
    ) %>% # 15
    dplyr::mutate(
      rev_ads_day = ifelse(
        sample(1:75, 1) == 1,
        0.0,
        rev_ads_day
      )
    ) %>% # 16
    dplyr::mutate(
      rev_all_total = ifelse(
        lubridate::month(login_date) == 11,
        rev_all_total + 2.75,
        rev_all_total
      )
    ) %>% # 17
    dplyr::mutate(
      start_day = lubridate::as_date(ifelse(
        sample(1:75, 1) == 1,
        login_date,
        start_day
      ))
    ) %>% # 18
    dplyr::mutate(
      is_customer = ifelse(
        sample(1:10, 1) == 1 && lubridate::month(login_date) == 12,
        FALSE,
        is_customer
      )
    ) %>% # 19
    dplyr::mutate(
      level_reached = ifelse(
        sample(1:10, 1) == 1 &&
          lubridate::month(login_date) %in% c(7, 8) &&
          level_reached > 10,
        level_reached - 2.0,
        level_reached
      )
    ) %>% # 20
    dplyr::ungroup() %>%
    dplyr::select(-row_number)
}


# The `all_revenue` table is made faulty in these ways:
#
# 1. The `country` column will sometimes contain missing values
# 2. The `player_id` sometimes has an `&` character appended to it
# 3. The `item_revenue` is sometimes 0 for `ad_5sec`
# 4. The `acquisition` item `facebook` is sometimes capitalized
# 5. The `acquisition` item `google` is sometimes capitalized
# 6. The `item_name` beginning with `offer` sometimes won't have a suffixed number
# 7. The `item_type` is sometimes missing
# 8. The `acquisition` column will sometimes contain missing values
# 9. The `country` column will sometimes contain missing values
# 10. The `session_duration` column will sometimes have negative values

create_all_revenue_f <- function(all_revenue) {

  all_revenue %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      country = ifelse(
        sample(1:100, 1) == 1,
        NA_character_,
        country
      )
    ) %>% # 1
    dplyr::mutate(
      player_id = ifelse(
        sample(1:100, 1) == 1,
        paste0(player_id, "&"),
        player_id
      )
    ) %>% # 2
    dplyr::mutate(
      item_revenue = ifelse(
        sample(1:5, 1) == 1 && item_name == "ad_5sec",
        0.0,
        item_revenue
      )
    ) %>% # 3
    dplyr::mutate(
      acquisition = ifelse(
        sample(1:5, 1) == 1 && acquisition == "facebook",
        "Facebook",
        acquisition
      )
    ) %>% # 4
    dplyr::mutate(
      acquisition = ifelse(
        sample(1:5, 1) == 1 && acquisition == "google",
        "Google",
        acquisition
      )
    ) %>% # 5
    dplyr::mutate(
      item_name = ifelse(
        sample(1:10, 1) == 1 && grepl("offer", item_name),
        "offer",
        item_name
      )
    ) %>% # 6
    dplyr::mutate(
      item_type = ifelse(
        sample(1:24, 1) == 1,
        NA_character_,
        item_type
      )
    ) %>% # 7
    dplyr::mutate(
      acquisition = ifelse(
        sample(1:200, 1) == 1,
        NA_character_,
        acquisition
      )
    ) %>% # 8
    dplyr::mutate(
      country = ifelse(
        sample(1:100, 1) == 1,
        NA_character_,
        country
      )
    ) %>% # 9
    dplyr::mutate(
      session_duration = ifelse(
        sample(1:100, 1) == 1,
        session_duration * -1.0,
        session_duration
      )
    ) %>% # 10
    dplyr::ungroup()
}

# The `all_sessions` table is made faulty in these ways:
#
# 1. The `n_iap` column is `numeric` instead of `integer`
# 2. The first component of the `session_id` will sometimes not match
#    the `player_id`
# 3. The `player_id` is sometimes missing
# 4. There is occasionally a `rev_iap` value of 1.39 even though
#    `n_iap` is `0`
# 5. There are some `rev_all` that aren't the exact sum of
#    `rev_iap` and `rev_ads`
# 6. The `session_duration` column will sometimes have huge values
# 7. Some `session_start` values will have the wrong year
# 8. Some `rev_all` values are missing
# 9. There is a disproportionate amount of `session_start` values
#     with the same timestamp ("2015-05-15 11:32:44")
# 10. There are five completely empty rows in the table

create_all_sessions_f <- function(all_sessions) {

  other_player_ids <-
    all_sessions %>%
    dplyr::select(player_id) %>%
    dplyr::distinct() %>%
    head(500) %>%
    dplyr::pull(player_id)

  empty_rows <-
    sample(seq_len(nrow(all_sessions)), size = 5)


  all_sessions %>%
    dplyr::mutate(n_iap = as.numeric(n_iap)) %>% # 1
    dplyr::rowwise() %>%
    dplyr::mutate(
      session_id = ifelse(
        sample(1:50, 1) == 1,
        paste0(sample(other_player_ids, 1), "-", gsub(".*?-", "", session_id)),
        session_id
      )
    ) %>% # 2
    dplyr::mutate(
      player_id = ifelse(
        sample(1:100, 1) == 1,
        NA_character_,
        player_id
      )
    ) %>% # 3
    dplyr::mutate(
      rev_iap = ifelse(
        sample(1:20, 1) == 1 && n_iap == 0,
        1.39,
        rev_iap
      )
    ) %>% # 4
    dplyr::mutate(
      rev_all = ifelse(
        sample(1:80, 1) == 1,
        rev_iap + rev_ads + 2.75,
        rev_all
      )
    ) %>% # 5
    dplyr::mutate(
      session_duration = ifelse(
        sample(1:100, 1) == 1,
        8888,
        session_duration
      )
    ) %>% # 6
    dplyr::mutate(
      session_start = ifelse(
        sample(1:100, 1) == 1,
        session_start + (2 * 24 * 60 * 60 * 365) + (24 * 60 * 60),
        session_start
      ) %>%
        as.POSIXct(tz = "GMT", origin = "1970-01-01")
    ) %>% # 7
    dplyr::mutate(
      rev_all = ifelse(
        sample(1:80, 1) == 1,
        NA_real_,
        rev_all
      )
    ) %>% # 8
    dplyr::mutate(
      session_start = ifelse(
        !is.na(session_start) && sample(1:80, 1) == 1,
        lubridate::ymd_hms("2015-05-15 11:32:44"),
        session_start
      ) %>%
        as.POSIXct(tz = "GMT", origin = "1970-01-01")
    ) %>% # 9
    dplyr::ungroup() %>%
    dplyr::add_row(.after = empty_rows[1]) %>%
    dplyr::add_row(.after = empty_rows[2]) %>%
    dplyr::add_row(.after = empty_rows[3]) %>%
    dplyr::add_row(.after = empty_rows[4]) %>%
    dplyr::add_row(.after = empty_rows[5]) # 10
}

# The `user_summary` table is made faulty in these ways:
#
# 1. The `acquisition` column will sometimes contain missing values
# 2. The `country` column will sometimes contain missing values
# 3. Some `first_login` values will have the wrong year
# 4. Some `device_name` values are all in lowercase with no spaces
# 5. Some `country` values are presented as two-letter country codes

create_user_summary_f <- function(user_summary) {

  user_summary %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      acquisition = ifelse(
        sample(1:200, 1) == 1,
        NA_character_,
        acquisition
      )
    ) %>% # 1
    dplyr::mutate(
      country = ifelse(
        sample(1:100, 1) == 1,
        NA_character_,
        country
      )
    ) %>% # 2
    dplyr::mutate(
      first_login = ifelse(
        sample(1:100, 1) == 1,
        first_login + (2 * 24 * 60 * 60 * 365) + (24 * 60 * 60),
        first_login
      ) %>%
        as.POSIXct(tz = "GMT", origin = "1970-01-01")
    ) %>% # 3
    dplyr::mutate(
      device_name = ifelse(
        sample(1:5, 1) == 1 && grepl("Sony", device_name),
        tolower(gsub(" ", "", device_name)),
        device_name
      )
    ) %>% # 4
    dplyr::mutate(
      country = dplyr::case_when(
        sample(1:10, 1) == 1 && country == "Denmark" ~ "DK",
        sample(1:10, 1) == 1 && country == "Switzerland" ~ "CH",
        sample(1:10, 1) == 1 && country == "Germany" ~ "DE",
        sample(1:10, 1) == 1 && country == "Philippines" ~ "PH",
        sample(1:10, 1) == 1 && country == "Norway" ~ "NO",
        sample(1:10, 1) == 1 && country == "Hong Kong" ~ "HK",
        TRUE ~ country
      )
    ) %>% # 5
    dplyr::ungroup()
}


users_daily_f <-
  create_users_daily_f(users_daily = users_daily)
all_revenue_f <-
  create_all_revenue_f(all_revenue = all_revenue)
all_sessions_f <-
  create_all_sessions_f(all_sessions = all_sessions)
user_summary_f <-
  create_user_summary_f(user_summary = user_summary)

users_daily_small_f <-
  create_users_daily_f(users_daily = users_daily_small)
all_revenue_small_f <-
  create_all_revenue_f(all_revenue = all_revenue_small)
all_sessions_small_f <-
  create_all_sessions_f(all_sessions = all_sessions_small)
user_summary_small_f <-
  create_user_summary_f(user_summary = user_summary_small)


saveRDS(users_daily_f, file = "data-raw/users_daily_f.rds")
saveRDS(all_revenue_f, file = "data-raw/all_revenue_f.rds")
saveRDS(all_sessions_f, file = "data-raw/all_sessions_f.rds")
saveRDS(user_summary_f, file = "data-raw/user_summary_f.rds")

saveRDS(users_daily_small_f, file = "data-raw/users_daily_small_f.rds")
saveRDS(all_revenue_small_f, file = "data-raw/all_revenue_small_f.rds")
saveRDS(all_sessions_small_f, file = "data-raw/all_sessions_small_f.rds")
saveRDS(user_summary_small_f, file = "data-raw/user_summary_small_f.rds")
