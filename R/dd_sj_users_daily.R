#' Data Dictionary: sj_users_daily
#'
#' The `dd_sj_users_daily()` function generates a data dictionary based on the
#' `sj_users_daily` table, which is available in the **intendo** package as a
#' dataset.
#'
#' @export
dd_sj_users_daily <- function() {

  pointblank::create_informant(
    read_fn = ~ sj_users_daily,
    label = "Daily users playing Super Jetroid",
    tbl_name = "sj_users_daily"
  ) %>%
  pointblank::info_tabular(
    summary = "This summary table provides daily totals for every
    player that had at least one login (i.e., session) in a day. We
    get measures such as daily sessions, time played, number of IAPs
    bought and ads viewed, revenue gained, progression info, and
    some segmentation categories (`country`, `acquisition`, and
    `is_customer`)",
    `each row is` = "A summary for a given player at a given date, and, the
    row is only produced if the player has a session on the date in question.
    Some summarized values are for the date in question (`_day`) and some are
    all days up to the given date (`_total`). Some values are intrinsic to
    the player (e.g., `country`) and repeated for all instances of the player
    for sake of convenience.",
    `data production` = "This table that is created
    nightly in a pipeline run. The data lags by two days because
    revenue information from **App Annie** is delayed by reporting
    from **Apple** and **Google**. Please visit our internal *Intendo*
    website for status reporting. Data providers occasionally revise
    the revenue amounts and adjust for refunds, so, revenue amounts
    can vary a little up to 20 days back from the present day.",
    `person responsible` = "E. Burrows: +1 (416) 329-2462,
    Central Engineering (((Toronto Downtown office)))"
  ) %>%
  pointblank::info_columns(
    columns = "player_id",
    info = "This is a unique identifier for a user/player.",
    details = "Always composed of 12 *uppercase* letters followed
    by 3 digits."
  ) %>%
  pointblank::info_columns(
    columns = "login_date",
    info = "The date (in the [[YYYY-MM-DD]]<<color: steelblue;>> format)
    that a player (with a `player_id`) logged into the game for *any amount
    of time*. Since this is a daily summary by player we expect dates and
    *not* date-time values.",
    details = "Note that dates are based on UTC time and not the player's
    local time. Also, sessions that carry on to the next day (in UTC time,
    again) are not double counted."
  ) %>%
  pointblank::info_columns(
    columns = "sessions_day",
    info = "The number of sessions a player engaged in per day.",
    details = "If a player leaves the game for less than 6-10 seconds and
    returns, the session is preserved by the SDK (no re-login)."
  ) %>%
  pointblank::info_columns(
    columns = "playtime_day",
    info = "The approximate amount of time played in a day counted across all
    sessions started in the day.",
    details = "This can be treated as a minimum since events such as crashes or
    app interruptions (e.g., phone calls) don't get captured in the
    instrumentation. Typically each such event adds 4-5 minutes to the session
    time."
  ) %>%
  pointblank::info_columns(
    columns = "n_iap_day",
    info = "The number of IAPs (in-app purchases) made by the player in the
    day.",
    details = "The value of IAP varies widely and so this only gives an
    approximate measure of the daily spend velocity for a player."
  ) %>%
  pointblank::info_columns(
    columns = "n_ads_day",
    info = "The number of ads viewed by a player in a day.",
    details = "The advertising SDK generally does a good job in tracking the ad
    view upon completion (i.e., not logging out during the middle of an ad)
    though there have been reports it is not perfect (based on ad revenue
    actuals, collected up to a month later)."
  ) %>%
  pointblank::info_columns(
    columns = "rev_iap_day",
    info = "The estimated revenue generated each day by a player from IAPs. The
    value is in USD and already deducts the 30% reserved for the app stores.",
    details = "Players in other countries will pay in their local currencies but
    we set all prices in USD in the two stores, taking into account currency
    conversion and relative affordability across the different regions."
  ) %>%
  pointblank::info_columns(
    columns = "rev_ads_day",
    info = "The estimated revenue earned across all ad views for a player in
    a given day.",
    details = "This estimate is rough compared to IAPs, and we assign an
    average value per ad view based on ad campaigns in play in certain regions.
    These values are never replaced by actuals since payment is bulk across
    all campaigns for inconsistent periods of time. In practice, the difference
    between estimates and actuals will vary as much as 50%."
  ) %>%
  pointblank::info_columns(
    columns = "rev_all_day",
    info = "This is simply the sum of `rev_iap_day` and `rev_ads_day` for a
    player on a given date.",
    details = "These values are based on estimates that only improve slightly
    with time (through backfilling of IAP data). The more uncertain component
    is ad revenue."
  ) %>%
  pointblank::info_columns(
    columns = "start_day",
    info = "The day that the player was first seen (the first login day).",
    details = "When taking the difference in days between `login_date` and
    `start_day` we get the player age, which is important for cohorting metric
    and segmentation."
  ) %>%
  pointblank::info_columns(
    columns = "sessions_total",
    info = "The total number of sessions that the player had up to the day
    in question.",
    details = "This is an important factor for determining player engagement
    but can be misleading since some players may have very short but numerous
    sessions."
  ) %>%
  pointblank::info_columns(
    columns = "playtime_total",
    info = "The total amount of time (in minutes) that the player committed to
    the game up to a given date."
  ) %>%
  pointblank::info_columns(
    columns = "level_reached",
    info = "The maximum level reached in the game. Provides a measure of player
    progression.",
    details = "As levels are being added over time with content updates, this
    is a moving target. However, the distribution of these values across all
    players will serve to increase the urgency in developing additional content
    for the level designers (making this an important metric)."
  ) %>%
  pointblank::info_columns(
    columns = "in_ftue",
    info = "A boolean that indicates whether the player on the given date was
    in the FTUE (first-time user experience), which is the tutorial/training
    level.",
    details = "This is an useful metric and constant concern for the level
    design group since churn at the FTUE (20-30% of new users) is to be
    obviously avoided but enhancements can steer this in the right direction."
  ) %>%
  pointblank::info_columns(
    columns = "at_eoc",
    info = "A boolean that indicates whether the player on the given date
    reached EOC (end of content).",
    details = "A critical mass of players at EOC needs to be monitored and
    communicated to the level design group."
  ) %>%
  pointblank::info_columns(
    columns = "is_customer",
    info = "A boolean that says that the customer has purchased at least one
    IAP.",
    details = "This is necessary for calculation of the DAC (daily active
    customers) KPI but says nothing of remonetization."
  ) %>%
  pointblank::info_columns(
    columns = "n_iap_total",
    info = "The number of IAPs bought by the player up to and including the
    given date.",
    details = "Disproportionately high numbers IAPs for players are indicative
    of whales (whales are noted to have daily spends, usually with higher-priced
    IAPs)."
  ) %>%
  pointblank::info_columns(
    columns = "n_ads_total",
    info = "The number of ad views for a player up to and including the given
    date.",
    details = "This usually scales linearly with the `playtime_total` though
    some regions have high frequencies of interstitial ad placements and players
    designated as grinders are shown substantially more ads."
  ) %>%
  pointblank::info_columns(
    columns = "rev_iap_total",
    info = "The total revenue obtained from the player up to the given date
    from IAPs."
  ) %>%
  pointblank::info_columns(
    columns = "rev_ads_total",
    info = "The total revenue obtained from the player up to the given date
    from ad views."
  ) %>%
  pointblank::info_columns(
    columns = "rev_all_total",
    info = "This is simply the sum of `rev_iap_total` and `rev_ads_total` for a
    player on up to the given date.",
    details = "These values are based on estimates but are generally reasonable
    especially with greater amounts of revenue. The more uncertain component is
    revenue from ad views."
  ) %>%
  pointblank::info_columns(
    columns = pointblank::matches("rev_[a-z]{3}_total"),
    info = "Amounts are in USD."
  ) %>%
  pointblank::info_columns(
    columns = "country",
    info = "The country of the player. This location information is captured at
    first login and doesn't account for sessions/purchases in other countries
    though incidence of that must be rare."
  ) %>%
  pointblank::info_columns(
    columns = "acquisition",
    info = "A label that designates how/where the player was acquired."
  ) %>%
  pointblank::info_section(
    section_name = "Futher Details",
    frequency = "Daily",
    `time of updates` = "Generally between 08:00 and 09:00 UTC",
    `inception` = "2014-12-29",
    revisions = c(
      " - (2015-01-23) added the `country` and `acquisition` columns.",
      " - (2015-03-15) incorporated backfilling of IAP amounts.",
      " - (2015-06-29) added the `level_reached` column."
    )
  ) %>%
  pointblank::get_informant_report(title = "Data Dictionary: `sj_users_daily`")
}

