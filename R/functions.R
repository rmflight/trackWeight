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

#' read data
#'
#' reads the data from the existing sheet
#'
#' @importFrom RCurl getURL
#' @export
#' @return data.frame
read_sheet_data <- function(){
  sheet_url <- scan(".gs_url", what = character())
  sheet_csv <- getURL(sheet_url, .opts = list(ssl.verifypeer = FALSE))
  sheet_data <- read.table(textConnection(sheet_csv), sep = ",", header = TRUE, stringsAsFactors = FALSE)
  sheet_data
}

#' plot weight
#'
#' @export
#' @import cowplot
#' @import ggplot2
#' @return plot
plot_weight <- function(weight_data){
  theme_set(theme_cowplot())
  ggplot(weight_data, aes(x = date, y = weight, color = status)) + geom_line(color = "black", aes(group = 1)) + geom_point() + ylim(c(200, 270)) + theme(axis.text.x = element_text(angle = 90))
}
