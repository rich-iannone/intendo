skip_on_cran()

test_that("getting a data table works", {

  all_sessions_tbl <- all_sessions(size = "small")
  expect_type(all_sessions_tbl, "list")

  all_revenue_tbl <- all_revenue(size = "small")
  expect_type(all_revenue_tbl, "list")

  users_daily_tbl <- users_daily(size = "small")
  expect_type(users_daily_tbl, "list")

  user_summary_tbl <- user_summary(size = "small")
  expect_type(user_summary_tbl, "list")
})
