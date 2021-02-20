#' Data Dictionary: sj_user_summary
#'
#' The `dd_sj_user_summary()` function generates a data dictionary based on the
#' `sj_user_summary` table, which is available in the **intendo** package as a
#' dataset.
#'
#' @export
dd_sj_user_summary <- function() {

  pointblank::create_informant(
    read_fn = ~ sj_user_summary,
    label = "Current summary of all users playing Super Jetroid",
    tbl_name = "sj_user_summary"
  ) %>%
    pointblank::info_tabular(
      summary = "This summary table provides information on each user and this
      information is captured after the first login and shouldn't normally
      change (except perhaps data encodings, if there are optimizations that
      can be done). We get information here such as the first login time and
      some information useful for segmentation (`country`, `acquisition`, and
      `device_name`)",
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
      columns = "first_login",
      info = "The date and time (UTC) that the player was first seen. This is
      typically called the 'first login'.",
      details = "At the first login, the user is taken pretty quickly to the
      FTUE (first time user experience) but it's not guaranteed as the user may
      'login' (generating a username by us) but end the session just after
      that."
    ) %>%
    pointblank::info_columns(
      columns = "start_day",
      info = "The day that the player was first seen (the first login day).",
      details = "When taking the difference in days between `session_start` and
    `start_day` we get the player age, which is important for cohorting metrics
    and segmentation."
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
    pointblank::info_columns(
      columns = "device_name",
      info = "A label that provides a device label for the device used to log
      into the game in the player's first session. Taken from the user agent."
    ) %>%
    pointblank::info_section(
      section_name = "Futher Details",
      frequency = "Daily",
      `time of updates` = "Generally between 09:00 and 10:00 UTC",
      `inception` = "2015-01-23",
      revisions = c(
        " - (2015-01-25) added the `country` and `acquisition` columns.",
        " - (2015-03-16) incorporated backfilling of IAP amounts.",
        " - (2015-05-09) improved the reporting of the `device_name`."
      )
    ) %>%
    pointblank::get_informant_report(
      title = "Data Dictionary: `sj_user_summary`"
    )
}

