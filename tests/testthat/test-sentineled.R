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

test_that("subset assignment results in valid value/sentinel pairs", {
  s <- sentineled(c(1:4, NA), 3:4)
  s[2:3] <- 5:6
  expect_identical(s, sentineled(c(1, 5, 6, 4, NA), 3:4))
  s <- sentineled(c(1:4, NA), 3:4)
  s[2:3] <- 4:5
  expect_identical(s, sentineled(c(1, 4, 5, 4, NA), 3:4))
  expect_true(is.na(s[2]))
  expect_identical(sentinels(s)[2], sentinels(s)[4])
  s <- sentineled(c(1:4, NA), 3:4)
  s[[2]] <- 5
  expect_identical(s, sentineled(c(1, 5, 3, 4, NA), 3:4))
  s <- sentineled(c(1:4, NA), 3:4)
  s[[2]] <- 4
  expect_identical(s, sentineled(c(1, 4, 3, 4, NA), 3:4))
  expect_true(is.na(s[2]))
  expect_identical(sentinels(s)[2], sentinels(s)[4])
})

test_that("Conversion to sentineled retains attributes", {
  n <- setNames(1:26, letters)
  attr(n, "pet") <- "dog"
  s <- sentineled(n, 1)
  expect_named(s, letters)
  expect_identical(attr(s, "pet"), "dog")
})

test_that("format.sentineled works", {
  # Don't leave choices to session options
  orig_op <- options(
    scipen = 1000,
    digits = 10,
    OutDec = "."
  )
  on.exit(options(orig_op))
  s <- sentineled(c(1, 1000000, "tiny", "enormous", NA), c("tiny", "enormous"))
  expect_identical(
    format(s),
    c("         1", "   1000000", "    <tiny>", "<enormous>", "        NA")
  )
  expect_identical(format(s[-4]), c("      1", "1000000", " <tiny>", "     NA"))
  expect_identical(format(s[-c(2, 4)]), c("     1", "<tiny>", "    NA"))
  expect_identical(
    format(s, trim = TRUE),
    c("1", "1000000", "<tiny>", "<enormous>", "NA")
  )
  expect_identical(
    format(s[c(1, 4, 5)], width = 11),
    c("          1", " <enormous>", "         NA")
  )
})

test_that("sentineled columns in a data.frame print nicely", {
  s <- sentineled(c(1:4, NA), 2:3, c("a", "bbbb"))
  d <- data.frame(x = s)
  result <- capture.output(print(d))
  expect_identical(
    result,
    c(
      "       x",
      "1      1",
      "2    <a>",
      "3 <bbbb>",
      "4      4",
      "5     NA"
    )
  )
})

test_that("sentineled vectors are good for use", {
  s <- sentineled(c(1, 2, 3), c(2, 3), c("x", "y"))
  sub_x <- s[sentinels(s) == "x"]
  expect_identical(as.numeric(sub_x), NA_real_)
  expect_identical(is.na(s), c(FALSE, TRUE, TRUE))
})

test_that("naaccr_sentineled works", {
  gleason <- naaccr_sentineled(
    c("02", "10", "X7", "X8", "X9", ""),
    "gleasonScoreClinical"
  )
  expect_is(gleason, "sentineled")
  expect_identical(as.numeric(gleason), c(2, 10, NA, NA, NA, NA))
  expect_identical(
    levels(gleason),
    c("", "procedure not done", "not applicable", "not documented")
  )
  expect_identical(
    as.character(sentinels(gleason)),
    c("", "", "procedure not done", "not applicable", "not documented", NA)
  )
})

test_that("naaccr_sentineled warns for non-fields", {
  expect_warning(naaccr_sentineled(1, "foo"))
})
