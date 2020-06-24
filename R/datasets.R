#' The `intendo_users` dataset
#'
#' @format A tibble with 743306 rows and 14 variables:
#' \describe{
#' \item{user_id}{A unique identifier for the user.}
#' \item{first_login}{A date-time that indicates the first time the player started the game.}
#' \item{iap_count}{}
#' \item{iap_revenue}{}
#' \item{ad_count}{}
#' \item{ad_revenue}{}
#' \item{total_revenue}{}
#' \item{customer}{}
#' \item{subscriber}{}
#' \item{first_iap}{}
#' \item{platform}{}
#' \item{device}{}
#' \item{acquired}{}
#' \item{country}{}
#' }
#'
#' @examples
#' # Here is a glimpse at the data
#' # available in `intendo_users`
#' dplyr::glimpse(intendo_users)
"intendo_users"

#' The `intendo_revenue` dataset
#'
#' @format A tibble with 1969139 rows and 8 variables:
#' \describe{
#' \item{user_id}{}
#' \item{session_id}{}
#' \item{time}{}
#' \item{name}{}
#' \item{size}{}
#' \item{type}{}
#' \item{price}{}
#' \item{revenue}{}
#' }
#'
#' @examples
#' # Here is a glimpse at the data
#' # available in `intendo_revenue`
#' dplyr::glimpse(intendo_revenue)
"intendo_revenue"

#' The `intendo_daily_users` dataset
#'
#' @format A tibble with 743306 rows and 14 variables:
#' \describe{
#' \item{user_id}{}
#' \item{session_id}{}
#' \item{time}{}
#' \item{total_sessions}{}
#' \item{total_time}{}
#' \item{level_reached}{}
#' \item{at_eoc}{}
#' \item{in_ftue}{}
#' \item{is_customer}{}
#' \item{iap_revenue}{}
#' \item{ad_revenue}{}
#' \item{total_revenue}{}
#' \item{acquired}{}
#' \item{iap_count}{}
#' \item{ad_count}{}
#' }
#'
#' @examples
#' # Here is a glimpse at the data
#' # available in `intendo_daily_users`
#' dplyr::glimpse(intendo_daily_users)
"intendo_daily_users"
