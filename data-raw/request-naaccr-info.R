# Retrieve NAACCR field data from the SEER API.
# Make sure to set some environment variables:
#   SEER_API_KEY
#     Your SEER API key
#   HTTP_PROXY
#     URL of your proxy server
library(httr)
library(jsonlite)
library(data.table)
library(magrittr)


api_url       <- 'https://api.seer.cancer.gov'
api_key       <- Sys.getenv("SEER_API_KEY")
key_header    <- add_headers(.headers = c('X-SEERAPI-Key' = api_key))
proxy_url     <- Sys.getenv('HTTP_PROXY')
proxy_details <- use_proxy(proxy_url)


GET_to_list <- function(path, ...) {
  response <- RETRY(
    verb   = 'GET',
    url    = api_url,
    path   = path,
    accept_json(),
    key_header,
    proxy_details,
    ...
  )
  stop_for_status(response)
  stopifnot(http_type(response) == 'application/json')
  json_text <- content(response, as = 'text')
  fromJSON(json_text, simplifyVector = FALSE)
}


# NAACCR format version numbers ------------------------------------------------
versions_response <- GET_to_list('rest/naaccr/versions')
versions <- vapply(
  X         = versions_response,
  FUN       = getElement,
  FUN.VALUE = character(1L),
  name      = 'version'
)

# Item names and numbers -------------------------------------------------------
items <- paste0('rest/naaccr/', versions) %>%
  lapply(GET_to_list) %>%
  lapply(rbindlist) %>%
  setNames(versions) %>%
  rbindlist(idcol = 'naaccr_version')
items[, naaccr_version := as.integer(naaccr_version)]

# Item information -------------------------------------------------------------
item_info_lookup <- matrix(
  ncol     = 2L,
  dimnames = list(NULL, c('field', 'type')),
  byrow    = TRUE,
  c(
    'item',          'integer',
    'name',          'character',
    'start_col',     'integer',
    'end_col',       'integer',
    'alignment',     'character',
    'padding_char',  'character',
    'documentation', 'character'
  )
)
rownames(item_info_lookup) <- item_info_lookup[, 'field']


# Using the item structure returned by the API, return a list of the item's and
# any sub-items' values.
arrange_item_details <- function(raw_item) {
  fields <- item_info_lookup[, 'field']
  item_values <- raw_item[fields]
  names(item_values) <- fields
  child_values <- lapply(raw_item[['subfield']], arrange_item_details)
  append(list(item_values), unlist(child_values, recursive = FALSE))
}


# Replace any NULL values with NA of the appropriate type
ensure_field_values <- function(field_list,
                                field_types = item_info_lookup[, 'type']) {
  fields <- names(field_list)
  mapply(
    FUN = function(value, type) {
      if (is.null(value)) {
        as(NA, type)
      } else {
        value
      }
    },
    field_list,
    field_types[fields],
    SIMPLIFY = FALSE
  )
}


items[
  ,
  item_listing := url_paths <- sprintf(
      'rest/naaccr/%d/item/%d',
      .BY$naaccr_version,
      item
    ) %>%
    lapply(GET_to_list) %>%
    list()
  ,
  by = 'naaccr_version'
]
naaccr_info_from_api <- items[
  ,
  item_listing %>%
    lapply(arrange_item_details) %>%
    unlist(recursive = FALSE) %>%
    lapply(ensure_field_values) %>%
    rbindlist(),
  by = 'naaccr_version'
][
  order(naaccr_version, item)
]

naaccr_info_from_api[, alignment := tolower(alignment)]

write.csv(
  naaccr_info_from_api[, list(
    naaccr_version,
    item,
    name,
    start_col,
    end_col,
    alignment,
    padding_char
  )],
  file         = "data-raw/naaccr_info_from_api.csv",
  row.names    = FALSE,
  quote        = TRUE,
  na           = "na",
  fileEncoding = "UTF-8"
)
