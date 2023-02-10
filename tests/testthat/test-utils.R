test_that("certain utility functions are available", {

  expect_true(is.function(download_remote_file))
  expect_true(is.function(get_sj_tbl_from_gh_url))
  expect_true(is.function(get_sj_tbl_read_fn))
  expect_true(is.function(check_pointblank))
})
