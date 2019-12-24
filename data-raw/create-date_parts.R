# Create the date_parts table, used by partial_date to extract info from
# partially missing dates according to the strftime-style format
library(data.table)


date_parts <- fread(
  "data-raw/date_parts.csv",
  header = TRUE,
  colClasses = c(fmt = "character", part = "character", from = "integer", to = "integer")
)
date_parts[, part := factor(part, c("year", "month", "day"))]
save(date_parts, file = "data-raw/sys-data/date_parts.RData", version = 2)
