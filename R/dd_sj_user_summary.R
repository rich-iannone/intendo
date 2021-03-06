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
    label = "Summary of important player activity in *Super Jetroid*",
    tbl_name = "sj_user_summary"
  ) %>%
    pointblank::info_tabular(
      summary = "This summary table provides information on each user and this
      information is captured after the first login and shouldn't normally
      change (except perhaps data encodings, if there are optimizations that
      can be done). We get information here such as the first login time and
      some information useful for segmentation (`country`, `acquisition`, and
      `device_name`)",
      `each row is` = "A summary for a given player at first login, and, there
      is one row per unique player (every player assigned an ID is accounted for
      in this table). All data were captured on the first login session.",
      `data production` = "This table is created nightly in a pipeline run.
      Please visit our internal *Intendo* website for status reporting.",
      `person responsible` = "E. Burrows: +1 (416) 329-2462,
      Central Engineering (((Toronto Downtown office)))"
    ) %>%
    pointblank::info_columns(
      columns = "player_id",
      info = "This is a unique identifier for a user/player.",
      details = "Always composed of 12 *uppercase* letters followed by 3
      digits."
    ) %>%
    pointblank::info_columns(
      columns = "first_login",
      info = "The date and time (UTC) that the player was first seen. This is
      typically called the 'first login'.",
      details = "At the first login, the user is taken very quickly to the
      FTUE (first-time user experience) but it's not guaranteed as the user may
      'login' (generating a username) but end the session just after that."
    ) %>%
    pointblank::info_columns(
      columns = "start_day",
      info = "The day that the player was first seen (the first login day).",
      details = "When taking the difference in days between `session_start`
      (present in the `sj_all_sessions` table) and `start_day` we get the
      player age, which is important for cohorting metrics and segmentation."
    ) %>%
    pointblank::info_columns(
      columns = "country",
      info = "The country of the player. This location information is captured
      at first login and doesn't account for sessions/purchases in other
      countries though incidence of that must be rare."
    ) %>%
    pointblank::info_columns(
      columns = "acquisition",
      info = "A label that designates how/where the player was acquired."
    ) %>%
    pointblank::info_columns(
      columns = "device_name",
      info = "A label that provides a product name for the device used to log
      into the game in the player's first session. Taken from the user agent."
    ) %>%
    pointblank::info_section(
      section_name = "Further Details",
      frequency = "Continuously updated",
      `time of updates` = "Continuously updated",
      `inception` = "2014-12-12"
    ) %>%
    pointblank::incorporate() %>%
    pointblank::get_informant_report(
      title = "Data Dictionary: `sj_user_summary`"
    )
}
