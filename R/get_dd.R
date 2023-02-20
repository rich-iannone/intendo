#' Data Dictionary for `all_revenue`
#'
#' The `all_revenue_dd()` function generates a data dictionary based on the
#' `all_revenue` table.
#'
#' @inheritParams all_sessions
#'
#' @return A `ptblank_informant` object.
#'
#' @examples
#'
#' # Get a preview of the `all_revenue` dataset
#' # with the 'preview' size option
#' all_revenue_dd(size = "preview")
#'
#' @export
all_revenue_dd <- function(
    size = c("small", "medium", "large", "xlarge", "preview"),
    quality = c("perfect", "faulty"),
    type = c("tibble", "data.frame", "duckdb")
) {

  size <- match.arg(size)
  quality <- match.arg(quality)
  type <- match.arg(type)

  if (size == "preview") {
    return(all_revenue_preview)
  }

  check_pointblank()

  formula <-
    get_sj_tbl_read_fn(
      name = "all_revenue",
      size = size,
      quality = quality,
      type = type
    )

  informant <-
    pointblank::create_informant(
      tbl = formula,
      label = "All revenue events for *Super Jetroid*",
      tbl_name = "all_revenue"
    )

  informant <-
    pointblank::info_tabular(
      informant,
      summary = "This summary table provides revenue data for every in-app \\
      purchase and ad view captured by our instrumentation for *Super \\
      Jetroid*. Details about the timing of the revenue event \\
      (`session_start` and `time` of earned revenue) are provided along with \\
      identifiers for the revenue source and some metadata for the player for \\
      segmentation purposes.",
      `each row is` = "A discrete revenue event for a player in a session. \\
      Details about the revenue source are provided for both IAPs and ad \\
      views. Some values intrinsic to the player (e.g., `country`) are \\
      provided for sake of convenience.",
      `data production` = "This table that is created three times a day \\
      at set times. The data for advertising events is delayed by three days \\
      because such information is pulled from our three advertising partners \\
      but one of them requires the extra time to have the revenue \\
      information available. Please visit our internal *Intendo* website to \\
      view status reports on delayed data. Data providers for IAPs \\
      occasionally revise the revenue amounts and adjust for refunds, so, \\
      revenue amounts can vary somewhat for up to 20 days back from the \\
      present day.",
      `person responsible` = "C. Ellefson: +1 (416) 329-3702,
      Central Engineering (((Downtown office)))"
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "player_id",
      info = "A unique identifier for a user/player.",
      details = "Always composed of 12 *uppercase* letters followed \\
      by 3 digits."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "session_id",
      info = "A unique identifier for a player session.",
      details = "The session in which the revenue event occurred. Always \\
      composed of the `player_id` followed by a hyphen and a random \\
      alphanumeric string of 8 characters (using lowercase letters)."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "session_start",
      info = "The starting time of the session in which a revenue event \\
      occurred.",
      details = "This is a datetime value (in the \\
      [[YYYY-MM-DD hh-mm-ss]]<<color: steelblue;>> format). Note that this \\
      is based on UTC time and not the player's local time."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "time",
      info = "The time that the revenue event occurred.",
      details = "This is captured by the store SDK and transmitted to us at \\
      the moment of purchase initiation. However, some cancelled/failed \\
      transactions will still appear as a purchase. In later pipeline runs, \\
      this is corrected with store data. The incidence of this happening is \\
      generally quite low however. This is a datetime value (in the \\
      [[YYYY-MM-DD hh-mm-ss]]<<color: steelblue;>> format). Note that this \\
      is based on UTC time and not the player's local time."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "item_type",
      info = "The type of the item that was purchased.",
      details = "Either `\"iap\"` or `\"ad\"` which stand for in-app purchase \\
      (or IAP) and ad view. Each item type has a specific set of `item_name` \\
      values."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "item_name",
      info = "A name that describes the ad type (always in the form `ad_`) \\
      or the IAP item (using the non-user-facing, in-store product name).",
      details = "The advertising-based item names are generally either clips, \\
      (distinguished by the length of the clip in seconds), a survey type \\
      (`\"ad_survey\"`), or a playable (`\"ad_playable\"`). The IAPs fall \\
      into three subtypes: (1) primary currency of `\"gold\"` with **7** \\
      levels, (2) secondary currency of `\"gems\"` with **5** levels, and (3) \\
      different `offer`s issued by the SAO engine (**5** levels). The higher \\
      the level, the higher the value and the corresponding cost. These names \\
      map directly to the store item names (both ITC and Play Store)."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "item_revenue",
      info = "The estimated USD revenue generated by the IAP or ad view.",
      details = "IAP item revenue amounts are estimated by item cost by \\
      region. While ad revenue is obtained from our advertising partners \\
      though their respective APIs, that data is not available in a \\
      granularity that matches up with ad view events. Therefore all \\
      single-event ad revenue amounts in this column are estimates."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "session_duration",
      info = "The length of the session (in minutes) in which the revenue \\
      event took place."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "start_day",
      info = "The day that the player was first seen (the first login day).",
      details = "When taking the difference in days between `session_start` \\
      and `start_day` we get the player age, which is important for \\
      cohorting metrics and segmentation."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "acquisition",
      info = "A label that designates how/where the player was acquired."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "country",
      info = "The country of the player. This location information is \\
      captured at first login and doesn't account for sessions/purchases in \\
      other countries though incidence of that must be rare."
    )

  informant <-
    pointblank::info_section(
      informant,
      section_name = "Further Details",
      frequency = "Three times per day",
      `time of updates` = "At 09:00, 17:00, and 23:00 UTC",
      `inception` = "2014-11-25",
      revisions = c(
        " - (2015-01-28) improved the precision of the `time` value.",
        " - (2015-02-05) added the `acquisition` and `country` columns."
      )
    )

  informant <- pointblank::incorporate(informant)

  informant <-
    pointblank::get_informant_report(
      informant,
      title = "Data Dictionary: `all_revenue`",
      size = "600px"
    )

  informant
}

#' Data Dictionary for `users_daily`
#'
#' The `users_daily_dd()` function generates a data dictionary based on the
#' `users_daily` table.
#'
#' @inheritParams all_sessions
#'
#' @return A `ptblank_informant` object.
#'
#' @examples
#'
#' # Get a preview of the `users_daily` dataset
#' # with the 'preview' size option
#' users_daily_dd(size = "preview")
#'
#' @export
users_daily_dd <- function(
    size = c("small", "medium", "large", "xlarge", "preview"),
    quality = c("perfect", "faulty"),
    type = c("tibble", "data.frame", "duckdb")
) {

  size <- match.arg(size)
  quality <- match.arg(quality)
  type <- match.arg(type)

  if (size == "preview") {
    return(users_daily_preview)
  }

  check_pointblank()

  formula <-
    get_sj_tbl_read_fn(
      name = "users_daily",
      size = size,
      quality = quality,
      type = type
    )

  informant <-
    pointblank::create_informant(
      tbl = formula,
      label = "Daily users playing *Super Jetroid*",
      tbl_name = "users_daily"
    )

  informant <-
    pointblank::info_tabular(
      informant,
      summary = "This summary table provides daily totals for every player \\
      that had at least one login (i.e., session) in a day. We get measures \\
      such as daily sessions (`sessions_day`), time played (`playtime_day`), \\
      number of IAPs bought and ads viewed (`n_iap_day` and `n_ads_day`), \\
      revenue gained (`rev_all_day`), progression info (`playtime_total`, \\
      `level_reached`, etc.), and some segmentation categories (`country`, \\
      `acquisition`, and `is_customer`).",
      `each row is` = "A summary for a given player at a given date, and, \\
      the row is only produced if the player had a session on the date in \\
      question. Some summarized values are for the date in question (`_day`) \\
      and some are all days up to the given date (`_total`). Some values are \\
      intrinsic to the player (e.g., `country`) and repeated for all \\
      instances of the player for sake of convenience.",
      `data production` = "This table that is created nightly in a pipeline \\
      run. The data lags by two days because revenue information from \\
      **App Annie** is delayed because of corresponding reporting delays from \\
      both **Apple** and **Google**. Please visit our internal *Intendo* \\
      website for status reporting. Data providers occasionally revise the \\
      revenue amounts and adjust for refunds, so, revenue amounts can vary \\
      slightly for up to 20 days back from the present day.",
      `person responsible` = "E. Burrows: +1 (416) 329-2462, \\
      Central Engineering (((Downtown office)))"
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "player_id",
      info = "A unique identifier for a user/player.",
      details = "Always composed of 12 *uppercase* letters followed \\
      by 3 digits."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "login_date",
      info = "The date that a player logged into the game for *any amount \\
      of time*.",
      details = "Since this is a daily summary by player we expect dates and \\
      *not* date-time values. The date is in the \\
      [[YYYY-MM-DD]]<<color: steelblue;>> format and dates are based on UTC \\
      time and not the player's local time. Furthermore, sessions that carry \\
      on to the next day (again, in UTC time) are not double counted."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "sessions_day",
      info = "The number of sessions a player engaged in per day.",
      details = "If a player leaves the game for less than 6-10 seconds and \\
      returns, the session is preserved by the SDK (no re-login)."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "playtime_day",
      info = "The approximate amount of time played in a day counted across \\
      all sessions started in the day.",
      details = "This can be treated as a minimum since events such as \\
      crashes or app interruptions (e.g., phone calls) don't get captured in \\
      the instrumentation. Typically each such event adds 4-5 minutes to the \\
      session time."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "n_iap_day",
      info = "The number of IAPs (in-app purchases) made by the player in the \\
      day.",
      details = "The value of IAP varies widely and so this only gives an \\
      approximate measure of the daily spend velocity for a player."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "n_ads_day",
      info = "The number of ads viewed by a player in a day.",
      details = "The advertising SDK generally does a good job in tracking \\
      the ad view upon completion (i.e., not logging out during the middle of \\
      an ad) though there have been reports it is not perfect (based on ad \\
      revenue actuals, collected up to a month later)."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "rev_iap_day",
      info = "The estimated revenue generated each day by a player from IAPs.",
      details = "The value is in USD and already deducts the 30% reserved for \\
      the app stores. Players in other countries will pay in their local \\
      currencies but we set all prices in USD in the two stores, taking into \\
      account currency conversion and relative affordability across the \\
      different regions."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "rev_ads_day",
      info = "The estimated revenue earned across all ad views for a player \\
      in a given day.",
      details = "This estimate is rough compared to IAPs, and we assign an \\
      average value per ad view based on ad campaigns in play in certain \\
      regions. These values are never replaced by actuals since payment is \\
      bulk across all campaigns for inconsistent periods of time. In \\
      practice, the difference between estimates and actuals will vary as \\
      much as 50%."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "rev_all_day",
      info = "The sum of `rev_iap_day` and `rev_ads_day` for a player on a \\
      given date.",
      details = "These values are based on estimates that only improve \\
      slightly with time (through backfilling of IAP data). The more \\
      uncertain component is ad revenue."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "start_day",
      info = "The day that the player was first seen (the first login day).",
      details = "When taking the difference in days between `login_date` and \\
      `start_day` we get the player age, which is important for cohorting \\
      metrics and segmentation."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "sessions_total",
      info = "The total number of sessions that the player had up to the day \\
      in question.",
      details = "This is an important factor for determining player \\
      engagement but can be misleading since some players may have very short \\
      but numerous sessions."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "playtime_total",
      info = "The total amount of time (in minutes) that the player committed \\
      to the game up to a given date."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "level_reached",
      info = "The maximum level reached in the game. Provides a measure of \\
      player progression.",
      details = "As levels are being added over time with content updates, \\
      this is a moving target. However, the distribution of these values \\
      across all players will serve to increase the urgency in developing \\
      additional content for the level designers (making this an important \\
      metric)."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "in_ftue",
      info = "A boolean that indicates whether the player on the given date \\
      was in the FTUE (first-time user experience), which is the \\
      tutorial/training level.",
      details = "This is an useful metric and of constant concern for the \\
      level design group since churn at the FTUE (20-30% of new users) is to \\
      be obviously avoided but enhancements can steer this in the right \\
      direction."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "at_eoc",
      info = "A boolean that indicates whether the player on the given date \\
      reached EOC (end of content).",
      details = "A critical mass of players at EOC needs to be monitored and \\
      communicated to the level design group."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "is_customer",
      info = "A boolean that says that the customer has purchased at least \\
      one IAP.",
      details = "This is necessary for calculation of the DAC (daily active \\
      customers) KPI but says nothing of remonetization."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "n_iap_total",
      info = "The number of IAPs bought by the player up to and including the \\
      given date.",
      details = "Disproportionately high numbers IAPs for players are \\
      indicative of whales (whales are noted to have daily spends, usually \\
      with higher-priced IAPs)."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "n_ads_total",
      info = "The number of ad views for a player up to and including the \\
      given date.",
      details = "This usually scales linearly with the `playtime_total` \\
      though some regions have high frequencies of interstitial ad placements \\
      and players designated as grinders are shown substantially more ads."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "rev_iap_total",
      info = "The total revenue obtained from the player up to the given date \\
      from IAPs."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "rev_ads_total",
      info = "The total revenue obtained from the player up to the given date \\
      from ad views."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "rev_all_total",
      info = "This is simply the sum of `rev_iap_total` and `rev_ads_total` \\
      for a player on up to the given date.",
      details = "These values are based on estimates but are generally \\
      reasonable especially with greater amounts of revenue. The more \\
      uncertain component is revenue from ad views."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = pointblank::matches("rev_[a-z]{3}_total"),
      info = "Amounts are in USD."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "country",
      info = "The country of the player. This location information is \\
      captured at first login and doesn't account for sessions/purchases in \\
      other countries though incidence of that must be rare."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "acquisition",
      info = "A label that designates how/where the player was acquired."
    )

  informant <-
    pointblank::info_section(
      informant,
      section_name = "Further Details",
      frequency = "Daily",
      `time of updates` = "Generally between 08:00 and 09:00 UTC",
      `inception` = "2014-12-29",
      revisions = c(
        " - (2015-01-23) added the `country` and `acquisition` columns.",
        " - (2015-03-15) incorporated backfilling of IAP amounts.",
        " - (2015-06-29) added the `level_reached` column."
      )
    )

  informant <- pointblank::incorporate(informant)

  informant <-
    pointblank::get_informant_report(
      informant,
      title = "Data Dictionary: `users_daily`",
      size = "600px"
    )

  informant
}

#' Data Dictionary for `user_summary`
#'
#' The `user_summary_dd()` function generates a data dictionary based on the
#' `user_summary` table.
#'
#' @inheritParams all_sessions
#'
#' @return A `ptblank_informant` object.
#'
#' @examples
#'
#' # Get a preview of the `user_summary` dataset
#' # with the 'preview' size option
#' user_summary_dd(size = "preview")
#'
#' @export
user_summary_dd <- function(
    size = c("small", "medium", "large", "xlarge", "preview"),
    quality = c("perfect", "faulty"),
    type = c("tibble", "data.frame", "duckdb")
) {

  size <- match.arg(size)
  quality <- match.arg(quality)
  type <- match.arg(type)

  if (size == "preview") {
    return(user_summary_preview)
  }

  check_pointblank()

  formula <-
    get_sj_tbl_read_fn(
      name = "user_summary",
      size = size,
      quality = quality,
      type = type
    )

  informant <-
    pointblank::create_informant(
      tbl = formula,
      label = "Summary of all users at first login in *Super Jetroid*",
      tbl_name = "user_summary"
    )

  informant <-
    pointblank::info_tabular(
      informant,
      summary = "This summary table provides information on each user and \\
      this information is captured after the first login and shouldn't \\
      normally change (except perhaps for data encodings, if there are \\
      optimizations that can be done). We get information here such as the \\
      first login time and some information useful for segmentation \\
      (`country`, `acquisition`, and `device_name`).",
      `each row is` = "A summary for a given player at first login with one \\
      row per unique player (every player assigned an ID is accounted for in \\
      this table). All data were captured on the first login session.",
      `data production` = "This table is created nightly in a pipeline run. \\
      Please visit our internal *Intendo* website for status reporting.",
      `person responsible` = "E. Burrows: +1 (416) 329-2462, \\
      Central Engineering (((Downtown office)))"
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "player_id",
      info = "A unique identifier for a user/player.",
      details = "Always composed of 12 *uppercase* letters followed by \\
      3 digits."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "first_login",
      info = "The date and time (UTC) that the player was first seen. This is \\
      typically called the *first login*.",
      details = "At the first login, the user is taken very quickly to the \\
      FTUE (first-time user experience) but it's not guaranteed as the user \\
      may 'login' (generating a username) but end the session just after \\
      that."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "start_day",
      info = "The day that the player was first seen (the first login day). \\
      This is simply the day time-part of the `first_login` value and so this \\
      is still based on UTC time.",
      details = "When taking the difference in days between `session_start` \\
      (present in the `all_sessions` table) and `start_day` we get the player \\
      age, which is important for cohorting metrics and segmentation."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "country",
      info = "The country of the player. This location information is \\
      captured at first login and doesn't account for sessions/purchases in \\
      other countries though incidence of that must be rare."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "acquisition",
      info = "A label that designates how/where the player was acquired."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "device_name",
      info = "A label that provides a product name for the device used to log \\
      into the game in the player's first session.",
      details = "Taken from the user agent string (which isn't stored)."
    )

  informant <-
    pointblank::info_section(
      informant,
      section_name = "Further Details",
      frequency = "Continuously updated",
      `time of updates` = "Continuously updated",
      `inception` = "2014-12-12"
    )

  informant <- pointblank::incorporate(informant)

  informant <-
    pointblank::get_informant_report(
      informant,
      title = "Data Dictionary: `user_summary`",
      size = "600px"
    )

  informant
}

#' Data Dictionary for `all_sessions`
#'
#' The `all_sessions_dd()` function generates a data dictionary based on the
#' `all_sessions` table.
#'
#' @inheritParams all_sessions
#'
#' @return A `ptblank_informant` object.
#'
#' @examples
#'
#' # Get a preview of the `all_sessions` dataset
#' # with the 'preview' size option
#' all_sessions_dd(size = "preview")
#'
#' @export
all_sessions_dd <- function(
    size = c("small", "medium", "large", "xlarge", "preview"),
    quality = c("perfect", "faulty"),
    type = c("tibble", "data.frame", "duckdb")
) {

  size <- match.arg(size)
  quality <- match.arg(quality)
  type <- match.arg(type)

  if (size == "preview") {
    return(all_sessions_preview)
  }

  check_pointblank()

  formula <-
    get_sj_tbl_read_fn(
      name = "all_sessions",
      size = size,
      quality = quality,
      type = type
    )

  informant <-
    pointblank::create_informant(
      tbl = formula,
      label = "All player sessions from *Super Jetroid*",
      tbl_name = "all_sessions"
    )

  informant <-
    pointblank::info_tabular(
      informant,
      summary = "This table provides data for all player sessions. It also \\
      contains summarized data for the number of revenue events (ad views and \\
      IAP spends) and provides total revenue amounts (in USD) broken down by \\
      type for each session.",
      `each row is` = "A player session. Each session has a unique identifier \\
      and every row contains pertinent information about player revenue \\
      earned during the session.",
      `data production` = "This table is revised consistently throughout the \\
      day. Please visit our internal *Intendo* website to view status \\
      reports on delayed data.",
      `person responsible` = "C. Ellefson: +1 (416) 329-3702,
      Central Engineering (((Downtown office)))"
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "player_id",
      info = "A unique identifier for a user/player.",
      details = "Always composed of 12 *uppercase* letters followed \\
      by 3 digits."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "session_id",
      info = "A unique identifier for a player session.",
      details = "Always composed of the `player_id` followed by a hyphen and \\
      a random alphanumeric string of 8 characters (using lowercase letters)."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "session_start",
      info = "The starting time of the session.",
      details = "This is a datetime value \\
      (in the [[YYYY-MM-DD hh-mm-ss]]<<color: steelblue;>> format) for when \\
      a player (with `player_id`) logged into the game."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "session_duration",
      info = "The length of the session (in minutes)."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "n_iap",
      info = "The number of IAPs (in-app purchases) made by the player in \\
      the session.",
      details = "The value of an IAP varies widely and so a count only gives \\
      an approximate measure of the daily spend velocity for a player."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "n_ads",
      info = "The number of ads viewed by a player in the session.",
      details = "The advertising SDK generally does a good job in tracking \\
      the ad view upon completion (i.e., not logging out during the middle \\
      of an ad) though there have been reports it is not perfect (based on \\
      ad revenue actuals, collected up to a month later)."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "rev_iap",
      info = "The estimated revenue generated in the session by a player \\
      from IAPs.",
      details = "The value is in USD and already deducts the 30% reserved \\
      for the app stores. Players in other countries will pay in their local \\
      currencies but we set all prices in USD in the two stores, taking into \\
      account currency conversion and relative affordability across the \\
      different regions."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "rev_ads",
      info = "The estimated revenue earned across all ad views for a player \\
      in the session.",
      details = "This estimate is rough compared to IAPs, and we assign an \\
      average value per ad view based on ad campaigns in play in certain \\
      regions. These values are never replaced by actuals since payment is \\
      bulk across all campaigns for inconsistent periods of time. In \\
      practice, the difference between estimates and actuals will vary as \\
      much as 30%."
    )

  informant <-
    pointblank::info_columns(
      informant,
      columns = "rev_all",
      info = "The sum of `rev_iap_day` and `rev_ads_day` for a player in a \\
      given session.",
      details = "These values are based on estimates that only improve \\
      slightly with time (through backfilling of IAP data). The more \\
      uncertain component is the ad revenue."
    )

  informant <-
    pointblank::info_section(
      informant,
      section_name = "Further Details",
      frequency = "Continuously updated",
      `time of updates` = "Continuously updated",
      `inception` = "2014-12-12"
    )

  informant <- pointblank::incorporate(informant)

  informant <-
    pointblank::get_informant_report(
      informant,
      title = "Data Dictionary: `all_sessions`",
      size = "600px"
    )

  informant
}

get_sj_tbl_read_fn <- function(name, size, quality, type) {

  args <- c()

  if (size != "small") {
    args <- c(args, paste0("size = ", dQuote(size, "double")))
  }

  if (size != "perfect") {
    args <- c(args, paste0("quality = ", dQuote(quality, "double")))
  }

  if (size != "tibble") {
    args <- c(args, paste0("type = ", dQuote(type, "double")))
  }

  args <- paste(args, collapse = ", ")

  stats::as.formula(paste0("~ intendo::", name, "(", args, ")"))
}

check_pointblank <- function() {

  if (!requireNamespace("pointblank", quietly = TRUE)) {

    stop(
      "Obtaining a data dictionary requires the pointblank package:\n",
      "* It can be installed with `install.packages(\"pointblank\")`.",
      call. = FALSE
    )
  }
}
