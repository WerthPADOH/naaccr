# Functions for interpreting NAACCR data items.
# All these function take character vectors as input. This is the safest way to
# read NAACCR files because they heavily use sentinel values. Columns which will
# be converted to factors don't need cleaning.

interpret_boolean <- function(flag) {
  bool <- rep_len(NA, length(flag))
  bool[flag == '0'] <- FALSE
  bool[flag == '1'] <- TRUE
  bool
}
