#' Data Dictionary: dd_sj_all_sessions
#'
#' The `dd_sj_all_sessions()` function generates a data dictionary based on the
#' `sj_all_sessions` table, which is available in the **intendo** package as
#' a dataset.
#'
#' @export
dd_sj_all_sessions <- function() {

  pointblank::create_informant(
    read_fn = ~ sj_all_sessions,
    label = "All player sessions from *Super Jetroid*",
    tbl_name = "sj_all_sessions"
  ) %>%
    pointblank::info_tabular(
      summary = "This table provides information on player sessions and
      summarizes the number of revenue events (ad views and IAP spends) and
      provides total revenue amounts (in USD) broken down by type for the
      session.",
      `each row is` = "A player session.",
      `data production` = "This table is revised consistently throughout the
      day. Please visit our internal *Intendo* website to view status reports
      on delayed data.",
      `person responsible` = "C. Ellefson: +1 (905) 329-3702,
      Central Engineering (((Toronto Downtown office)))"
    ) %>%
    pointblank::info_columns(
      columns = "player_id",
      info = "This is a unique identifier for a user/player.",
      details = "Always composed of 12 *uppercase* letters followed
      by 3 digits."
    ) %>%
    pointblank::info_columns(
      columns = "session_id",
      info = "The date (in the [[YYYY-MM-DD]]<<color: steelblue;>> format)
      that a player (with a `player_id`) logged into the game for *any amount
      of time*. Since this is a daily summary by player we expect dates and
      *not* date-time values.",
      details = "Note that dates are based on UTC time and not the player's
      local time. Also, sessions that carry on to the next day (in UTC time,
      again) are not double counted."
    ) %>%
    pointblank::info_columns(
      columns = "session_start",
      info = "The starting time of the session in which a revenue event
      occurred. This is a datetime value (in the [[YYYY-MM-DD hh-mm-ss]]
      <<color: steelblue;>> format) for when a player (with a `player_id`)
      logged into the game and is associated with a session that had at least
      one revenue event.",
    details = ""
    ) %>%
    pointblank::info_columns(
      columns = "session_duration",
      info = "The length of the session (in minutes) in which the revenue
      event took place."
    ) %>%
    pointblank::info_columns(
      columns = "n_iap",
      info = "The number of IAPs (in-app purchases) made by the player in the
      session.",
    details = "The value of IAP varies widely and so this only gives an
      approximate measure of the daily spend velocity for a player."
    ) %>%
    pointblank::info_columns(
      columns = "n_ads",
      info = "The number of ads viewed by a player in the session.",
      details = "The advertising SDK generally does a good job in tracking the
      ad view upon completion (i.e., not logging out during the middle of an
      ad) though there have been reports it is not perfect (based on ad revenue
      actuals, collected up to a month later)."
    ) %>%
    pointblank::info_columns(
      columns = "rev_iap",
      info = "The estimated revenue generated in the session by a player from
      IAPs. The value is in USD and already deducts the 30% reserved for the
      app stores.",
      details = "Players in other countries will pay in their local currencies
      but we set all prices in USD in the two stores, taking into account
      currency conversion and relative affordability across the different
      regions."
    ) %>%
    pointblank::info_columns(
      columns = "rev_ads",
      info = "The estimated revenue earned across all ad views for a player in
      the session.",
      details = "This estimate is rough compared to IAPs, and we assign an
      average value per ad view based on ad campaigns in play in certain
      regions. These values are never replaced by actuals since payment is bulk
      across all campaigns for inconsistent periods of time. In practice, the
      difference between estimates and actuals will vary as much as 50%."
    ) %>%
    pointblank::info_columns(
      columns = "rev_all",
      info = "This is simply the sum of `rev_iap_day` and `rev_ads_day` for a
      player in a given session.",
      details = "These values are based on estimates that only improve slightly
      with time (through backfilling of IAP data). The more uncertain component
      is ad revenue."
    ) %>%
    pointblank::info_section(
      section_name = "Futher Details",
      frequency = "Continuously updated",
      `time of updates` = "Continuously updated",
      `inception` = "2014-12-12"
    ) %>%
    pointblank::incorporate() %>%
    pointblank::get_informant_report(
      title = "Data Dictionary: `sj_all_sessions`"
    )
}
