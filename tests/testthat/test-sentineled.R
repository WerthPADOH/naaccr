library(testthat)
library(naaccr)


context("Reading NAACCR-formatted files")

test_that("sentineled stores sentinel levels properly", {
  s <- sentineled(NA, "cat")
  expect_identical(levels(s), c("", "cat"))
  s <- sentineled(NA, 1:2)
  expect_identical(levels(s), c("", "1", "2"))
  s <- sentineled(1:10, 8:9, c("a", "b"))
  expect_identical(levels(s), c("", "a", "b"))
})

test_that("subsets of sentineled are also sentineled, and can be assigned to", {
  s <- sentineled(1:10, 8:9)
  sub_range <- s[1:5]
  expect_is(sub_range, "sentineled")
  expect_identical(sub_range, sentineled(s[1:5], 8:9))
  sub_single <- s[[1]]
  expect_is(sub_single, "sentineled")
  expect_identical(sentineled(sub_single), sentineled(s)[1])
})

test_that("Conversion to sentineled retains attributes", {
  n <- setNames(1:26, letters)
  attr(n, "pet") <- "dog"
  s <- sentineled(n, 1)
  expect_named(s, letters)
  expect_identical(attr(s, "pet"), "dog")
})

test_that("sentineled vectors are good for use", {
  s <- sentineled(c(1, 2, 3), c(2, 3), c("x", "y"))
  sub_x <- s[sentinels(s) == "x"]
  expect_identical(as.numeric(sub_x), NA_real_)
  expect_identical(is.na(s), c(FALSE, TRUE, TRUE))
})
