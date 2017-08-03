#' generate dates
#'
#' creates a data.frame that can be easily imported into a google sheet for
#' tracking weight over a date range.
#'
#' @param date_start the start date
#' @param date_end the end date
#' @param fasting_on which days are fasting days?
#'
#' @import lubridate
#' @return data.frame
#' @export
generate_dates <- function(start_date, end_date = start_date + 31, fasting = "week"){
  if (fasting == "week") {
    feasting_days <- c(7,1)
  }
  start_date <- ymd(start_date)
  use_dates <- seq(start_date, end_date, 1)
  out_dates <- data.frame(date = use_dates, stringsAsFactors = FALSE)
  out_dates$status <- "fasting"
  out_dates[wday(out_dates$date) %in% feasting_days, "status"] <- "feasting"
  out_dates$weight <- NA
}

