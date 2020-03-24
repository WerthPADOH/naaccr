library(naaccr)
library(testthat)

context("partial_date")

test_that("partial_date inherits from Date", {
  d <- partial_date(2000, 1, 1)
  expect_true(inherits(d, "Date"))
})

test_that("Can extract parts from partial dates", {
  d <- as.partial_date(c("20000102", "200504  ", "2007"))
  expect_identical(year(d), c(2000L, 2005L, 2007L))
  expect_identical(month(d), c(1L, 4L, NA_integer_))
  expect_identical(mday(d), c(2L, NA_integer_, NA_integer_))
})

test_that("Can assign parts to partial dates (with invalid dates becoming NA)", {
  d <- partial_date(1998, 12, 15)
  year(d) <- 2000
  expect_identical(d, partial_date(2000, 12, 15))
  month(d) <- 2
  expect_identical(d, partial_date(2000, 2, 15))
  mday(d) <- 29
  expect_identical(d, partial_date(2000, 2, 29))
  expect_warning(year(d) <- 2001)
  expect_identical(d, partial_date(NA, NA, NA))
})

test_that("Partial date subsets and sub-assignments are valid", {
  d <- partial_date(c(2000, 2005, 2007), c(1, 4, NA), c(2, NA, NA))
  sub_mult <- d[c(1, 3)]
  expect_s3_class(sub_mult, "partial_date")
  expect_identical(year(sub_mult), year(d)[c(1, 3)])
  expect_identical(month(sub_mult), month(d)[c(1, 3)])
  expect_identical(mday(sub_mult), mday(d)[c(1, 3)])
  sub_one <- d[[2]]
  expect_s3_class(sub_one, "partial_date")
  expect_identical(year(sub_one), year(d)[[2]])
  expect_identical(month(sub_one), month(d)[[2]])
  expect_identical(mday(sub_one), mday(d)[[2]])
  d2 <- d
  d[c(3, 2)] <- partial_date(c(2010, 1980), c(5, 12), c(30, NA))
  expect_identical(d, partial_date(c(2000, 1980, 2010), c(1, 12, 5), c(2, NA, 30)))
  d2[[1]] <- partial_date(1950, 8, 13)
  expect_identical(d2, partial_date(c(1950, 2005, 2007), c(8, 4, NA), c(13, NA, NA)))
})

test_that("Logical comparisons of partial_date uses what's known", {
  p <- partial_date(c(2000, 2005, 2007), c(1, 4, 12), c(1, 30, 31))
  expect_s3_class(p + 1, "partial_date")
  expect_identical(p + 1, partial_date(c(2000, 2005, 2008), c(1, 5, 1), c(2, 1, 1)))
  expect_identical(p - 1, partial_date(c(1999, 2005, 2007), c(12, 4, 12), c(31, 29, 30)))

  r <- as.Date(c("2000-01-01", "3030-3-30", "2007-12-15"))
  expect_identical(p == r, c(TRUE, FALSE, FALSE))
  expect_identical(p > r, c(FALSE, FALSE, TRUE))
  expect_identical(p >= r, c(TRUE, FALSE, TRUE))
  expect_identical(p < r, c(FALSE, TRUE, FALSE))
  expect_identical(p <= r, c(TRUE, TRUE, FALSE))
})

test_that("partial dates work as columns in popular data set classes", {
  p <- partial_date(c(2000, 2005, 2019, NA), c(1, 5, NA, NA), c(20, NA, NA, NA))
  dframe <- data.frame(p = p)
  dtable <- data.table::data.table(p = p)
  tib <- tibble::tibble(p = p)
  expect_identical(dframe[, "p", drop = TRUE], p)
  expect_identical(dframe[c(2, 3), "p", drop = TRUE], p[2:3])
  expect_identical(tib[, "p", drop = TRUE], p)
  skip("Currently needs fixed in data.table package")
  expect_identical(tib[c(2, 3), "p", drop = TRUE], p[2:3])
  testthat::expect_identical(dtable[, p], p)
  expect_identical(dtable[c(2, 3), p], p[2:3])
})

test_that("Algebra with partially-known dates uses what's known when possible", {
  cases <- expand.grid(
    known = seq.Date(as.Date("1999-12-31"), as.Date("2004-12-31"), by = "26 days"),
    partial_to = c("year", "month", "day"),
    offset = -367:367
  )
  cases[["partial"]] <- as.partial_date(cases[["known"]])
  known_month <- cases[["partial_to"]] == "month"
  cases[known_month, "partial"] <- partial_date(
    year = year(cases[known_month, "known"]),
    month = month(cases[known_month, "known"]), day = NA
  )
  known_year <- cases[["partial_to"]] == "year"
  cases[known_year, "partial"] <- partial_date(
    year = year(cases[known_year, "known"]), month = NA, day = NA
  )
  known_day <- cases[["partial_to"]] == "day"
  result_known <- cases[["known"]] + cases[["offset"]]
  result_partial <- cases[["partial"]] + cases[["offset"]]
  expect_true(all(result_partial[known_day] == result_known[known_day]))
  expect_true(all(
    month(result_partial[known_month]) == month(result_known[known_month]) |
      is.na(result_partial[known_month])
  ))
  expect_true(all(
    year(result_partial[known_month]) == year(result_known[known_month]) |
      is.na(result_partial[known_month])
  ))
  expect_true(all(
    year(result_partial[known_year]) == year(result_known[known_year]) |
      is.na(result_partial[known_year])
  ))

  # Specific edge cases
  p <- partial_date(c(2000, 2000, 2000, NA), c(2, 2, NA, NA), c(15, NA, NA, NA))
  expect_identical(year(p + 350), c(2001L, 2001L, NA, NA)) # maybe next year
  expect_identical(year(p + 325), c(2001L, NA, NA, NA)) # less maybe next year
  expect_identical(month(p + 1), c(2L, NA, NA, NA)) # maybe next month
  expect_identical(month(p + 31), c(3L, 3L, NA, NA)) # definitely next month

  p2 <- partial_date(c(2001, 2001, 2001, NA), c(2, 2, NA, NA), c(15, NA, NA, NA))
  expect_identical(year(p2 + 365), c(2002L, 2002L, 2002L, NA)) # definitely next year

  q <- partial_date(2001, NA, c(5, 10, 24))
  expect_identical(q - 4, partial_date(2001, NA, c(1, 6, 20)))
  expect_identical(q - 5, partial_date(c(NA, 2001, 2001), NA, c(NA, 5, 19)))
  expect_identical(q + 4, partial_date(2001, NA, c(9, 14, 28)))
  expect_identical(q + 5, partial_date(2001, NA, c(10, 15, NA)))
  expect_identical(q + 8, partial_date(c(2001, 2001, NA), NA, c(13, 18, NA)))

  expect_identical(partial_date(2003, NA, NA) + 365, partial_date(2004, NA, NA))
  expect_identical(partial_date(2003, NA, NA) + 366, partial_date(2004, NA, NA))
  expect_identical(partial_date(2003, NA, NA) - 365, partial_date(2002, NA, NA))
  expect_identical(partial_date(2003, NA, NA) - 366, partial_date(NA, NA, NA))
  expect_identical(partial_date(2004, NA, NA) + 365, partial_date(NA, NA, NA))
  expect_identical(partial_date(2004, NA, NA) + 366, partial_date(NA, NA, NA))
  expect_identical(partial_date(2004, NA, NA) - 365, partial_date(NA, NA, NA))
  expect_identical(partial_date(2004, NA, NA) - 366, partial_date(NA, NA, NA))
  expect_identical(partial_date(2005, NA, NA) + 365, partial_date(2006, NA, NA))
  expect_identical(partial_date(2005, NA, NA) + 366, partial_date(NA, NA, NA))
  expect_identical(partial_date(2005, NA, NA) - 365, partial_date(2004, NA, NA))
  expect_identical(partial_date(2005, NA, NA) - 366, partial_date(2004, NA, NA))

  # Regression test cases (were buggy once)
  expect_identical(partial_date(2001, 04, NA) + 1, partial_date(2001, NA, NA))
  expect_identical(partial_date(2003, NA, 5) + 30, partial_date(NA, NA, NA))
})

test_that("midpoint and means", {
  p <- partial_date(
    year = c(1950, 1950, 1950, NA, NA),
    month = c(3, 3, NA, 3, NA),
    day = c(10, NA, 10, 10, NA)
  )
  expect_identical(
    midpoint_partial_date(p),
    as.Date(c("1950-03-10", "1950-03-16", "1950-06-26", NA, NA))
  )
  expect_identical(mean(p[1:2]), as.Date("1950-03-13"))
  expect_identical(mean(p), as.Date(NA))
  expect_identical(mean(p, na.rm = TRUE, impute_fun = NULL), as.Date("1950-03-10"))
})

test_that("partial date formats", {
  p <- partial_date(
    year = c(1950, 1950, 1950, NA, NA),
    month = c(  3,    3,   NA,  3, NA),
    day = c(   10,   NA,   10, 10, NA)
  )
  expect_identical(
    format(p, "%m/%d/%y"),
    c("03/10/50", "03/??/50", "??/10/50", "03/10/??", NA)
  )
})
