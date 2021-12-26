skip_on_cran()

test_that("getting the different data tables works", {

  #
  # Obtaining the small versions of the tables
  #

  all_sessions_tbl <- all_sessions(size = "small")
  expect_type(all_sessions_tbl, "list")

  all_revenue_tbl <- all_revenue(size = "small")
  expect_type(all_revenue_tbl, "list")

  users_daily_tbl <- users_daily(size = "small")
  expect_type(users_daily_tbl, "list")

  user_summary_tbl <- user_summary(size = "small")
  expect_type(user_summary_tbl, "list")

  #
  # Obtaining the small and faulty versions of the tables
  #

  all_sessions_f_tbl <- all_sessions(size = "small", quality = "faulty")
  expect_type(all_sessions_f_tbl, "list")

  all_revenue_f_tbl <- all_revenue(size = "small", quality = "faulty")
  expect_type(all_revenue_f_tbl, "list")

  users_daily_f_tbl <- users_daily(size = "small", quality = "faulty")
  expect_type(users_daily_f_tbl, "list")

  user_summary_f_tbl <- user_summary(size = "small", quality = "faulty")
  expect_type(user_summary_f_tbl, "list")
})
