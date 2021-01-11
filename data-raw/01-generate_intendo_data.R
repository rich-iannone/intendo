library(tidyverse)
library(lubridate)

# Set a seed
set.seed(23)

# Define the IAP names, types, available denominations, and prices for each;
# For each IAP, there a probabilities for purchasing each denominations;
# The `popularity` is a 1:5 scale of overall preference for purchasing the IAP
iaps <-
  dplyr::tribble(
    ~name,            ~type,    ~subtype,  ~size,  ~iap_price, ~size_p, ~popularity,
    "gold1",     "currency", "secondary",    "1",        0.99,   0.182,          4L,
    "gold2",     "currency", "secondary",    "2",        1.99,     0.4,          4L,
    "gold3",     "currency", "secondary",    "3",        4.99,     0.3,          4L,
    "gold4",     "currency", "secondary",    "4",       19.99,     0.1,          4L,
    "gold5",     "currency", "secondary",    "5",       28.99,    0.01,          4L,
    "gold6",     "currency", "secondary",    "6",       59.99,   0.005,          4L,
    "gold7",     "currency", "secondary",    "7",      119.99,   0.003,          4L,
    "gems1",     "currency",   "premium",    "1",        2.49,   0.365,          3L,
    "gems2",     "currency",   "premium",    "2",        9.99,     0.4,          3L,
    "gems3",     "currency",   "premium",    "3",       24.99,     0.2,          3L,
    "gems4",     "currency",   "premium",    "4",       59.99,    0.03,          3L,
    "gems5",     "currency",   "premium",    "5",      129.99,   0.005,          3L,
    "offer1", "offer_agent",     "offer",    "1",        4.99,     0.3,          1L,
    "offer2", "offer_agent",     "offer",    "2",        9.99,     0.2,          1L,
    "offer3", "offer_agent",     "offer",    "3",       14.99,     0.2,          1L,
    "offer4", "offer_agent",     "offer",    "4",       19.99,     0.2,          1L,
    "offer5", "offer_agent",     "offer",    "5",       28.99,     0.1,          1L,
    "pass",   "season_pass",      "pass",    "1",        4.99,     1.0,          5L,
  )

subtypes <- unique(iaps$subtype)
subtypes_probs <- c(5/20, 5/20, 7/20, 3/20)
secondary_probs <- iaps %>% dplyr::filter(subtype == "secondary") %>% dplyr::pull(size_p)
premium_probs <- iaps %>% dplyr::filter(subtype == "premium") %>% dplyr::pull(size_p)
offer_probs <- iaps %>% dplyr::filter(subtype == "offer") %>% dplyr::pull(size_p)
pass_probs <- iaps %>% dplyr::filter(subtype == "pass") %>% dplyr::pull(size_p)

iap_probs <-
  list(
    subtypes = subtypes_probs,
    secondary = secondary_probs,
    premium = premium_probs,
    offer = offer_probs,
    pass = pass_probs
  )

iap_names <-
  list(
    secondary = paste0("gold", seq_along(secondary_probs)),
    premium = paste0("gems", seq_along(premium_probs)),
    offer = paste0("offer", seq_along(offer_probs)),
    pass = paste0("pass", seq_along(pass_probs))
  )

# Define the ad types and the range of revenue amounts per type
ads <-
  dplyr::tribble(
    ~name,         ~size,  ~ad_price_1,  ~ad_price_2, ~size_p,
    "ad_5sec",       "1",         0.02,         0.12,     0.2,
    "ad_10sec",      "2",         0.07,         0.23,     0.2,
    "ad_15sec",      "3",         0.15,         0.60,     0.2,
    "ad_20sec",      "4",         0.35,         1.25,     0.1,
    "ad_30sec",      "5",         0.70,         1.50,     0.1,
    "ad_playable",   "6",         0.55,         1.75,     0.05,
    "ad_survey",     "7",         0.50,         1.50,     0.15,
  )

ad_probs <- ads %>% dplyr::pull(size_p)

ad_names <- ads %>% dplyr::pull(name)

ad_revenue_list <-
  list(
    ad_5sec = seq(ads$ad_price_1[1], ads$ad_price_2[1], 0.01),
    ad_10sec = seq(ads$ad_price_1[2], ads$ad_price_2[2], 0.01),
    ad_15sec = seq(ads$ad_price_1[3], ads$ad_price_2[3], 0.01),
    ad_20sec = seq(ads$ad_price_1[4], ads$ad_price_2[4], 0.01),
    ad_30sec = seq(ads$ad_price_1[5], ads$ad_price_2[5], 0.01),
    ad_playable = seq(ads$ad_price_1[6], ads$ad_price_2[6], 0.01),
    ad_survey = seq(ads$ad_price_1[7], ads$ad_price_2[7], 0.01)
  )

# Exceptional days with rate multipliers
exceptional_tbl <-
  dplyr::tribble(
    ~date,        ~l_idx, ~d_idx, ~r_idx,
    "2015-01-01", 1.1,    1.5,    1.3, # New Year's day
    "2015-01-15", 1.2,    1.2,    1.1, # mid-month
    "2015-02-01", 1.5,    2.1,    1.2, # Super Bowl XLIX
    "2015-02-14", 0.9,    1.2,    1.0, # Valentine's Day
    "2015-02-15", 1.3,    1.6,    1.6, # mid-month
    "2015-04-01", 1.0,    1.2,    1.2, # first day of month
    "2015-05-15", 1.2,    1.4,    1.5, # mid-month
    "2015-06-01", 1.0,    1.3,    1.2, # first day of month
    "2015-06-15", 1.0,    1.4,    1.5, # mid-month
    "2015-07-01", 1.1,    1.3,    1.2, # first day of month
    "2015-07-03", 1.1,    1.5,    1.3, # Independence Day (observed)
    "2015-07-04", 1.2,    2.0,    1.4, # Independence Day
    "2015-07-15", 1.0,    1.4,    1.5, # mid-month
    "2015-08-01", 1.1,    1.3,    1.1, # first day of month
    "2015-08-15", 1.1,    1.3,    1.3, # mid-month
    "2015-09-01", 1.1,    1.2,    1.1, # first day of month
    "2015-09-15", 1.1,    1.2,    1.3, # mid-month
    "2015-09-16", 1.1,    1.1,    1.2, # mid-month
    "2015-10-01", 1.3,    1.4,    1.3, # first day of month
    "2015-10-15", 1.4,    1.3,    1.3, # mid-month
    "2015-10-31", 1.7,    1.2,    1.9, # Halloween
    "2015-11-26", 1.6,    2.5,    1.9, # Thanksgiving
    "2015-11-27", 1.2,    2.2,    1.8, # Black Friday
    "2015-12-01", 1.2,    1.2,    1.4, # first day of month
    "2015-10-15", 1.4,    1.5,    1.3, # mid-month
    "2015-12-24", 1.5,    2.1,    1.5, # Christmas Eve
    "2015-12-25", 1.5,    2.1,    1.7, # Christmas day
    "2015-12-26", 1.5,    2.1,    1.9, # Day after Christmas
    "2015-12-27", 1.5,    2.1,    1.8, # Christmas Break
    "2015-12-28", 1.5,    2.1,    1.7, # Christmas Break
    "2015-12-29", 1.5,    2.1,    1.8, # Christmas Break
    "2015-12-30", 1.5,    2.1,    1.9, # Christmas Break
    "2015-12-31", 1.5,    2.1,    1.2, # New Year's Eve
  )

country_metadata <-
  dplyr::tribble(
    ~country_name,   ~currency, ~ratio_usd, ~ratio_ad,  ~user_count,
    "United States", "USD",      1.0,       1.0,        1500,
    "Canada",        "CAD",      1.0,       1.0,        300,
    "Australia",     "AUD",      1.0,       1.0,        200,
    "Mexico",        "MXN",      0.7,       0.6,        400,
    "United Kingdom","GBP",      1.3,       1.0,        670,
    "France",        "EUR",      1.2,       1.0,        590,
    "Germany",       "EUR",      1.2,       1.0,        500,
    "Spain",         "EUR",      1.1,       0.9,        280,
    "Portugal",      "EUR",      1.0,       0.9,        250,
    "Austria",       "EUR",      1.2,       1.0,        115,
    "Switzerland",   "CHF",      1.4,       1.2,        100,
    "Denmark",       "DKK",      1.4,       1.1,        400,
    "Sweden",        "SEK",      1.3,       1.1,        100,
    "Norway",        "NOK",      1.4,       0.9,        100,
    "China",         "CNY",      0.7,       0.6,        500,
    "Hong Kong",     "HKD",      0.9,       0.7,        700,
    "Philippines",   "PHP",      0.6,       0.4,        250,
    "Russia",        "RUB",      0.7,       0.3,        400,
    "India",         "INR",      0.7,       0.2,        520,
    "Japan",         "JPY",      1.2,       0.6,        680,
    "South Korea",   "KRW",      1.1,       0.7,        430,
    "South Africa",  "ZAR",      1.0,       0.7,        100,
    "Egypt",         "EGP",      0.8,       0.5,        90,
  )

device_tbl <-
  dplyr::tribble(
    ~platform,   ~quality,  ~device,
    "apple",     3,         "iPhone 4",
    "apple",     3,         "iPhone 4S",
    "apple",     5,         "iPhone 5",
    "apple",     5,         "iPhone 5",
    "apple",     5,         "iPhone 5",
    "apple",     7,         "iPhone 6",
    "apple",     7,         "iPhone 6 Plus",
    "apple",     7,         "iPhone 6s",
    "apple",     7,         "iPhone 6s Plus",
    "apple",     3,         "2nd Gen iPad",
    "apple",     5,         "3rd Gen iPad",
    "apple",     5,         "iPad mini",
    "apple",     5,         "3rd Gen iPod",
    "apple",     7,         "4th Gen iPod",
    "apple",     5,         "3rd Gen iPad",
    "apple",     7,         "4th Gen iPad",
    "android",   3,         "Samsung Galaxy A3",
    "android",   5,         "Samsung Galaxy A5",
    "android",   7,         "Samsung Galaxy A7",
    "android",   5,         "Samsung Galaxy S6",
    "android",   5,         "Samsung Galaxy Note 4",
    "android",   5,         "Samsung Galaxy Alpha",
    "android",   5,         "Samsung Galaxy E5",
    "android",   5,         "Samsung Galaxy S6 Edge",
    "android",   3,         "Sony Experia Z5",
    "android",   3,         "Sony Experia Z3",
    "android",   3,         "Sony Experia Z3 Compact",
    "android",   5,         "Sony Experia T3",
    "android",   5,         "Sony Experia M2",
    "android",   3,         "Sony Experia M2 Aqua",
    "android",   5,         "Sony Experia E4",
    "android",   5,         "Sony Experia Z1",
    "android",   3,         "Sony Experia Z1 Compact",
    "android",   5,         "Sony Experia Z2 Tablet",
  )

levels_effort <-
  dplyr::tibble(level = 2, hours = 1.0, additional = 100) %>%
  tidyr::uncount(additional) %>%
  dplyr::mutate(level = dplyr::row_number()) %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    hours = hours +
      sample((-3:3), 1, prob = c(0.05, 0.05, 0.1, 0.1, 0.2, 0.2, 0.3))/10
  ) %>%
  dplyr::ungroup() %>%
  dplyr::add_row(level = 0, hours = 0, .before = 1) %>%
  dplyr::mutate(hours = ifelse(level == 1, 0.2, hours)) %>%
  dplyr::mutate(hours_10 = cumsum(hours)) %>%
  dplyr::mutate(hours_09 = hours_10 * 1.02) %>%
  dplyr::mutate(hours_08 = hours_10 * 1.04) %>%
  dplyr::mutate(hours_07 = hours_10 * 1.05) %>%
  dplyr::mutate(hours_06 = hours_10 * 1.07) %>%
  dplyr::mutate(hours_05 = hours_10 * 1.10) %>%
  dplyr::mutate(hours_04 = hours_10 * 1.12) %>%
  dplyr::mutate(hours_03 = hours_10 * 1.17) %>%
  dplyr::mutate(hours_02 = hours_10 * 1.25) %>%
  dplyr::mutate(hours_01 = hours_10 * 1.50) %>%
  dplyr::select(-hours) %>%
  tidyr::pivot_longer(
    cols = starts_with("hours"),
    names_to = "ability",
    names_prefix = "hours_",
    values_to = "hours"
  ) %>%
  dplyr::mutate(minutes = hours * 60) %>%
  dplyr::mutate(ability = as.numeric(ability))

get_level_at <- function(time_played, ability) {

  a <- ability

  row <- levels_effort %>%
    subset(minutes < time_played) %>%
    subset(ability == a) %>%
    tail(1)

  row[[1]]
}

devices_3 <- device_tbl %>% dplyr::filter(quality == 3) %>% dplyr::pull(device)
devices_5 <- device_tbl %>% dplyr::filter(quality == 5) %>% dplyr::pull(device)
devices_7 <- device_tbl %>% dplyr::filter(quality == 7) %>% dplyr::pull(device)

device_list <-
  list(
    devices_3 = devices_3,
    devices_5 = devices_5,
    devices_7 = devices_7
  )

# Seed players by age
age_distribution <- ceiling(c(rnorm(10000, mean = 18, sd = 8), rnorm(10000, mean = 45, sd = 12)))
age_distribution <- age_distribution[age_distribution > 5 & age_distribution < 85]

exp_dist_1 <- ceiling(rexp(500, 1/3))

exp_dist_2_3 <- ceiling(rexp(500, 1/12)) + 14

exp_dist_4_6 <- ceiling(rexp(500, 1/12)) + 60

create_players <- function(start_day,
                           country_metadata,
                           age_distribution,
                           device_list,
                           fraction = 1) {

  country_metadata <-
    country_metadata %>%
    dplyr::mutate(user_count = ceiling(user_count * fraction))

  n <- sum(country_metadata$user_count)

  age <- sample(age_distribution, n)

  spend_p <-
    dplyr::case_when(
      age >= 51 ~ sample(1:5, 1),
      age >= 31 ~ sample(3:10, 1),
      age >= 17 ~ sample(4:10, 1),
      age >= 10 ~ sample(3:5, 1),
      TRUE ~ sample(1:2, 1)
    )

  ability <-
    dplyr::case_when(
      age >= 51 ~ 3,
      age >= 31 ~ 6,
      age >= 17 ~ 7,
      age >= 10 ~ 7,
      TRUE ~ 3
    )

  device_q_vec <- c(7, 5, 3)
  device_q <-
    dplyr::case_when(
      age >= 51 ~ sample(device_q_vec, size = 1, prob = c(.2, .4, .4)),
      age >= 31 ~ sample(device_q_vec, size = 1, prob = c(.4, .3, .3)),
      age >= 17 ~ sample(device_q_vec, size = 1, prob = c(.5, .3, .2)),
      age >= 10 ~ sample(device_q_vec, size = 1, prob = c(.1, .6, .3)),
      TRUE ~ sample(device_q_vec, size = 1, prob = c(.1, .3, .6))
    )

  device <-
    vapply(
      device_q,
      FUN.VALUE = character(1),
      FUN = function(x) {
        if (x == 3) device <- sample(device_list$devices_3, 1)
        if (x == 5) device <- sample(device_list$devices_5, 1)
        if (x == 7) device <- sample(device_list$devices_7, 1)
        device
      }
    )

  loyalty <-
    dplyr::case_when(
      age >= 51 ~ sample(1:7, 1),
      age >= 31 ~ sample(1:10, 1),
      age >= 17 ~ sample(1:10, 1),
      age >= 10 ~ sample(1:7, 1),
      TRUE ~ sample(1:5, 1)
    )

  game_q <- rep(5, n)
  game_q <- ifelse(device_q > 5, game_q + 1, game_q)
  game_q <- ifelse(device_q < 5, game_q - 1, game_q)
  game_q <- ifelse(loyalty > 6, game_q + 1, game_q)
  game_q <- ifelse(loyalty < 5, game_q - 1, game_q)

  n_days <-
    vapply(
      loyalty,
      FUN.VALUE = numeric(1),
      FUN = function(x) {
        if (x == 1) {
          n_days <- sample(exp_dist_1, 1)
        } else if (x %in% c(2, 3)) {
          n_days <- sample(exp_dist_2_3, 1)
        } else if (x %in% c(4, 5, 6)) {
          n_days <- sample(exp_dist_4_6, 1)
        } else {
          n_days <- 365
        }
        n_days
      })

  stop_p <-
    vapply(
      loyalty,
      FUN.VALUE = numeric(1),
      FUN = function(x) {
        if (x == 1) {
          stop_p <- 0.75
        } else if (x %in% c(2, 3)) {
          stop_p <- 0.25
        } else if (x %in% c(4, 5, 6)) {
          stop_p <- 0.10
        } else {
          stop_p <- 0.00
        }
        stop_p
      })

  end_p <-
    vapply(
      loyalty,
      FUN.VALUE = numeric(1),
      FUN = function(x) {
        if (x == 1) {
          end_p <- 0.2
        } else if (x %in% c(2, 3)) {
          end_p <- 0.2
        } else if (x %in% c(4, 5, 6)) {
          end_p <- 0.2
        } else {
          end_p <- 0.8
        }
        end_p
      })

  p_curve <-
    mapply(
      FUN = function(end_p, n_days) {
        p <- jitter(end_p + (1 - end_p) * exp(-0.02 * 1:n_days), 150)
      },
      end_p = end_p, n_days = n_days
    ) %>% as.list() %>% unlist()

  p_curve[p_curve > 1] <- 1.0

  countries <- rep(country_metadata$country_name, country_metadata$user_count)

  acquistion_types_vec <-
    c("facebook", "google", "apple", "other_campaign", "crosspromo", "organic")
  acquistion_probs_vec <-
    c(0.1, 0.15, 0.05, 0.1, 0.05, 0.55)

  acquisition_types <-
    vapply(
      seq_len(n),
      FUN.VALUE = character(1), USE.NAMES = FALSE,
      FUN = function(x) {
        sample(
          acquistion_types_vec,
          size = 1,
          prob = acquistion_probs_vec,
          replace = FALSE
        )
      }
    )

  player_id <-
    replicate(
      n,
      paste0(
        paste(
          sample(LETTERS, 12),
          collapse = ""
        ),
        paste(
          sample(1:9, 3),
          collapse = ""
        )
      )
    )

  dplyr::tibble(
    player_id = player_id,
    start_day = as.Date(start_day),
    country = countries,
    acquisition = acquisition_types,
    age = age,
    spend_p = spend_p,
    ability = ability,
    device_q = device_q,
    loyalty = loyalty,
    game_q = game_q,
    n_days = n_days,
    stop_p = stop_p,
    end_p = end_p,
    p_curve = list(p_curve)
  )
}

get_times <- function(n_sessions, date) {

  repeat {
    h <- sort(runif(n_sessions) * 24)
    if (!any(diff(h) < 1)) break
  }

  lubridate::as_datetime(date) +
    lubridate::minutes(floor(h * 60)) +
    lubridate::seconds(floor(((h * 60 * 60) %% 1) * 60))
}

player_sessions <- function(player_tbl, i) {

  player_info <- player_tbl[i, ]

  player_id <- player_info$player_id
  p_curve <- player_info$p_curve %>% unlist()
  n_days <- player_info$n_days
  stop_p <- player_info$stop_p

  early_stop <-
    replicate(n_days, sample(c(0, 1), size = 1, prob = c(1 - stop_p, stop_p)))

  if (1 %in% early_stop) {

    stop_n <- min(which(early_stop == 1))
    dates <-
      seq(
        from = player_info$start_day,
        to = player_info$start_day + stop_n - 1,
        by = "1 day"
      )
    p_curve <- p_curve[1:stop_n]

  } else {

    dates <-
      seq(
        from = player_info$start_day,
        to = player_info$start_day + n_days - 1,
        by = "1 day"
      )
  }

  session_tbl <-
    dplyr::tibble(
      player_id = character(0),
      session_id = character(0),
      session_start = lubridate::as_datetime(dates[1])[0],
      session_duration = numeric(0)
    )

  for (j in seq_along(dates)) {

    p_curve_k <- p_curve[j] / 1:3
    sessions <- numeric(5)

    for (k in seq(p_curve_k)) {
      sessions[k] <-
        sample(
          c(1, 0),
          size = 1,
          prob = c(abs(p_curve_k[k]), abs(1 - p_curve_k[k]))
        )
    }

    n_sessions <- sum(sessions)

    if (n_sessions == 0) next

    session_starts <- get_times(n_sessions, dates[j])
    durations <- replicate(n_sessions, sample(3:40, 1) + sample(1:10/10, 1))

    session_ids <-
      replicate(
        n_sessions,
        paste0(player_id, "-", paste(sample(c(letters, 1:9), 8), collapse = ""))
      )

    session_tbl <-
      bind_rows(
        session_tbl,
        dplyr::tibble(
          player_id = player_id,
          session_id = session_ids,
          session_start = session_starts,
          session_duration = durations
        )
      )
  }

  if (nrow(session_tbl) > 300) {
    session_tbl <-
      dplyr::bind_rows(
        session_tbl %>% dplyr::slice_head(n = 1),
        session_tbl %>% dplyr::slice_sample(prop = 0.60)
      ) %>%
      dplyr::distinct() %>%
      dplyr::arrange(session_start)
  }

  session_tbl
}

n_spends <- function(spend_p,
                     session_duration) {

  if (session_duration < 10) {
    # If the session is less than 10 minutes in duration, penalize the
    # likelihood of spending anything with a die toss
    short_session_no_spend <- sample(x = c(0, 1), size = 1, prob = c(0.5, 0.5))

    if (short_session_no_spend == 1) return(0L)
  }

  spend_counter <- 0
  p_multiplier <- 1

  for (i in 1:10) {

    effective_spend_p <- spend_p * p_multiplier

    does_spend <-
      sample(
        x = c(0, 1), size = 1, replace = FALSE,
        prob = c((10 - effective_spend_p) / 10, effective_spend_p / 10)
      )
    spend_counter <- spend_counter + does_spend
    p_multiplier <- p_multiplier * 0.5
    if (does_spend == 0) break
  }

  as.integer(spend_counter)
}

spend_type <- function(spend_p) {

  # Get the subtype
  subtype_purchase <- sample(subtypes, size = 1, prob = iap_probs$subtypes)

  if (subtype_purchase == "pass") subtype_purchase <- "offer"

  # Get the probabilities of purchasing each size
  probs_iaps <- iap_probs[[subtype_purchase]]

  if (spend_p > 7) {
    probs_iaps <- rev(probs_iaps)
  }

  sample(iap_names[[subtype_purchase]], size = 1, prob = probs_iaps)
}

n_ads <- function(session_duration) {

  if (session_duration < 5) {
    # If the session is less than 5 minutes in duration, penalize the
    # likelihood of getting any ads with a die toss
    short_session_no_ad <-
      sample(x = c(0, 1), size = 1, prob = c(0.5, 0.5))

    if (short_session_no_ad == 1) return(0L)
  }

  total_ads <- floor(session_duration / 5)
  if (total_ads == 0) return(0L)

  if (total_ads > 5) total_ads <- 5

  ad_counter <- 0
  for (i in seq_len(total_ads)) {

    gets_ad <- sample(x = c(0, 1), size = 1, prob = c(0.3, 0.7))

    ad_counter <- ad_counter + gets_ad
  }

  as.integer(ad_counter)
}

ad_type <- function(spend_p) {

  ad_type <- sample(ad_names, size = 1, prob = ad_probs)

  if (spend_p >= 7) {

    lower_value_ad <- sample(x = c(0, 1), size = 1, prob = c(0.5, 0.5))

    if (lower_value_ad) ad_type <- ad_names[1]
  }

  ad_type
}

ad_rev <- function(item) {
  sample(ad_revenue_list[[item]], 1)
}

device_type <- function(device_q) {

  if (device_q == 3) idx <- 1
  if (device_q == 5) idx <- 2
  if (device_q == 7) idx <- 3

  sample(device_list[[idx]], size = 1)
}

#
# Generate the tables
#

# Define the dates where there are new player logins
dates_new_players <-
  seq(as.Date("2015-01-01"), as.Date("2015-12-31"), by = 1)

player_tbl <-
  dplyr::bind_rows(
    lapply(
      dates_new_players,
      FUN = function(x) {

        create_players(
          start_day = x,
          country_metadata = country_metadata,
          age_distribution = age_distribution,
          device_list = device_list,
          fraction = 1/400
        )
      }
    )
  )

saveRDS(
  player_tbl,
  file = "data-raw/zzz-process_data/player_tbl_complete.rds"
)

# Build the sessions
for (i in 0:(ceiling(nrow(player_tbl) / 1000) - 1 )) {

  indices <- 1:1000 + (i * 1000)

  indices <- indices[indices <= nrow(player_tbl)]

  sessions <-
    dplyr::bind_rows(
      lapply(
        indices,
        FUN = function(x) {
          player_sessions(player_tbl = player_tbl, i = x)
        }
      )
    )

  saveRDS(
    sessions,
    file = paste0("data-raw/zzz-process_data/sessions_tbl-", i, ".rds")
  )

  print(paste0("Generated `sessions_tbl-", i, ".rds`"))
}

# Reassemble the sessions
session_file_list <-
  list.files(
    "data-raw/zzz-process_data",
    pattern = "sessions_tbl-.*",
    full.names = TRUE
  )

raw_session_tbl <-
  lapply(session_file_list, readRDS) %>%
  dplyr::bind_rows() %>%
  dplyr::left_join(player_tbl, by = "player_id") %>%
  dplyr::mutate(days_active = as.integer(as.Date(session_start) - start_day)) %>%
  dplyr::rowwise() %>%
  dplyr::mutate(n_spends = n_spends(spend_p = spend_p, session_duration = session_duration)) %>%
  dplyr::mutate(n_ads = n_ads(session_duration = session_duration)) %>%
  dplyr::select(-c(p_curve, n_days, stop_p, end_p)) %>%
  dplyr::ungroup() %>%
  dplyr::filter(session_start < lubridate::ymd_hms("2016-01-01 00:00:00"))

session_iap_tbl <-
  raw_session_tbl %>%
  dplyr::filter(n_spends > 0) %>%
  dplyr::select(
    player_id, session_id, session_start, session_duration,
    start_day, acquisition, country, age, spend_p, game_q, device_q, n_spends
  ) %>%
  tidyr::uncount(n_spends) %>%
  dplyr::rowwise() %>%
  dplyr::mutate(item = spend_type(spend_p = spend_p)) %>%
  dplyr::ungroup() %>%
  dplyr::left_join(
    iaps %>% dplyr::select(name, iap_price),
    by = c("item" = "name")
  ) %>%
  dplyr::left_join(
    country_metadata %>% dplyr::select(country_name, ratio_usd),
    by = c("country" = "country_name")
  ) %>%
  dplyr::mutate(price = iap_price * ratio_usd) %>%
  dplyr::mutate(revenue = price - (0.3 * iap_price)) %>%
  dplyr::mutate(type = "iap") %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    time = session_start +
      (sample(seq(0.1, session_duration, by = 0.1), 1) * 60)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(
    player_id, session_id, session_start, time,
    type, item, revenue, session_duration,
    start_day, acquisition, country
  ) %>%
  dplyr::arrange(session_start, time) %>%
  dplyr::filter(time < lubridate::ymd_hms("2016-01-01 00:00:00"))

session_ads_tbl <-
  raw_session_tbl %>%
  dplyr::filter(n_ads > 0) %>%
  dplyr::select(
    player_id, session_id, session_start, session_duration,
    start_day, acquisition, country, age, spend_p, game_q, device_q, n_ads
  ) %>%
  tidyr::uncount(n_ads) %>%
  dplyr::rowwise() %>%
  dplyr::mutate(item = ad_type(spend_p = spend_p)) %>%
  dplyr::mutate(revenue = ad_rev(item = item)) %>%
  dplyr::ungroup() %>%
  dplyr::left_join(
    country_metadata %>% dplyr::select(country_name, ratio_ad),
    by = c("country" = "country_name")
  ) %>%
  dplyr::mutate(revenue = revenue * ratio_ad) %>%
  dplyr::mutate(type = "ad") %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    time = session_start +
      (sample(seq(0.1, session_duration, by = 0.1), 1) * 60)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(
    player_id, session_id, session_start, time,
    type, item, revenue, session_duration,
    start_day, acquisition, country
  ) %>%
  dplyr::arrange(session_start, time) %>%
  dplyr::filter(time < lubridate::ymd_hms("2016-01-01 00:00:00"))

# Create the `all_revenue` table
all_revenue <-
  dplyr::bind_rows(session_iap_tbl, session_ads_tbl) %>%
  dplyr::arrange(session_start, session_id, time) %>%
  dplyr::rename(
    item_type = type,
    item_name = item,
    item_revenue = revenue
  )

session_revenue_tbl <-
  all_revenue %>%
  dplyr::select(
    player_id, session_id, session_start,
    session_duration, item_type, item_revenue
  ) %>%
  dplyr::mutate(row = row_number()) %>%
  tidyr::pivot_wider(
    names_from = item_type,
    values_from = item_revenue
  ) %>%
  dplyr::select(-row) %>%
  dplyr::mutate(ad = ifelse(is.na(ad), 0, ad)) %>%
  dplyr::mutate(iap = ifelse(is.na(iap), 0, iap)) %>%
  dplyr::group_by(player_id, session_id, session_start, session_duration) %>%
  dplyr::summarize(
    ad_revenue = sum(ad, na.rm = TRUE),
    iap_revenue = sum(iap, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  dplyr::arrange(session_start)

# Create the `all_sessions` table
all_sessions <-
  raw_session_tbl %>%
  dplyr::select(
    player_id, session_id, session_start, session_duration,
    n_spends, n_ads
  ) %>%
  dplyr::left_join(
    session_revenue_tbl %>%
      dplyr::select(-session_start, -player_id, -session_duration),
    by = "session_id"
  ) %>%
  dplyr::mutate(rev_ads = ifelse(is.na(ad_revenue), 0.0, ad_revenue)) %>%
  dplyr::mutate(rev_iap = ifelse(is.na(iap_revenue), 0.0, iap_revenue)) %>%
  dplyr::mutate(rev_all = rev_ads + rev_iap) %>%
  dplyr::select(-ad_revenue, -iap_revenue) %>%
  dplyr::rename(n_iap = n_spends) %>%
  dplyr::ungroup() %>%
  dplyr::select(
    player_id, session_id, session_start, session_duration,
    n_iap, n_ads, rev_iap, rev_ads, rev_all
  )

# Create the `users_daily` table
users_daily <-
  raw_session_tbl %>%
  dplyr::select(
    player_id, session_id, session_start, session_duration,
    start_day, country, acquisition, ability, n_spends, n_ads
  ) %>%
  dplyr::mutate(login_date = lubridate::as_date(session_start)) %>%
  dplyr::left_join(
    all_sessions %>%
      dplyr::select(session_id, dplyr::starts_with("rev")),
    by = "session_id"
  ) %>%
  dplyr::group_by(player_id, login_date) %>%
  dplyr::summarize(
    playtime_day = sum(session_duration, na.rm = TRUE),
    sessions_day = dplyr::n(),
    start_day = min(start_day, na.rm = TRUE),
    country = unique(country),
    acquisition = unique(acquisition),
    ability = unique(ability),
    n_iap_day = sum(n_spends, na.rm = TRUE),
    n_ads_day = sum(n_ads, na.rm = TRUE),
    rev_iap_day = sum(rev_iap, na.rm = TRUE),
    rev_ads_day = sum(rev_ads, na.rm = TRUE),
    rev_all_day = sum(rev_all, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  dplyr::arrange(login_date, player_id) %>%
  dplyr::group_by(player_id) %>%
  dplyr::mutate(
    sessions_total = cumsum(sessions_day),
    playtime_total = cumsum(playtime_day),
    n_iap_total = cumsum(n_iap_day),
    n_ads_total = cumsum(n_ads_day),
    rev_iap_total = cumsum(rev_iap_day),
    rev_ads_total = cumsum(rev_ads_day),
    rev_all_total = cumsum(rev_all_day),
  ) %>%
  dplyr::ungroup() %>%
  dplyr::rowwise() %>%
  dplyr::mutate(level_reached = get_level_at(
    time_played = playtime_total, ability = ability)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(in_ftue = ifelse(level_reached == 0, TRUE, FALSE)) %>%
  dplyr::mutate(at_eoc = ifelse(level_reached == 100, TRUE, FALSE)) %>%
  dplyr::mutate(is_customer = ifelse(n_iap_total > 0, TRUE, FALSE)) %>%
  dplyr::select(
    player_id, login_date, sessions_day, playtime_day,
    n_iap_day, n_ads_day, rev_iap_day, rev_ads_day, rev_all_day,
    start_day, sessions_total, playtime_total, level_reached,
    in_ftue, at_eoc, is_customer,
    n_iap_total, n_ads_total,
    rev_iap_total, rev_ads_total, rev_all_total,
    country, acquisition
  )

# Create the `user_summary` table
user_summary <-
  raw_session_tbl %>%
  dplyr::select(
    player_id, session_start, start_day,
    country, acquisition, device_q
  ) %>%
  dplyr::group_by(player_id) %>%
  dplyr::summarize(
    first_login = min(session_start, na.rm = TRUE),
    start_day = min(start_day, na.rm = TRUE),
    country = unique(country),
    acquisition = unique(acquisition),
    device_q = min(device_q, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  dplyr::ungroup() %>%
  dplyr::rowwise() %>%
  dplyr::mutate(device_name = device_type(device_q = device_q)) %>%
  dplyr::ungroup() %>%
  dplyr::select(-device_q) %>%
  dplyr::arrange(first_login)

saveRDS(all_sessions, file = "data-large/all_sessions_large.rds")
saveRDS(users_daily, file = "data-large/users_daily_large.rds")
saveRDS(all_revenue, file = "data-large/all_revenue_large.rds")
saveRDS(user_summary, file = "data-large/user_summary_large.rds")
