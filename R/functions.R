#' generate dates
#'
#' creates a data.frame that can be easily imported into a google sheet for
#' tracking weight over a date range.
#'
#' @param start_date the start date
#' @param end_date the end date
#' @param fasting which days are fasting days?
#'
#' @examples
#' generate_dates(lubridate::today())
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
  out_dates
}

#' read data
#'
#' reads the data from the existing sheet
#'
#' @param file a file to read a url from
#' @param url the actual url
#'
#' @examples
#' # from a file
#' url_file <- system.file("extdata", "gs_url", package = "trackWeight")
#' read_sheet_data(file = url_file)
#'
#' # from the url directly
#' read_sheet_data(url = "https://docs.google.com/spreadsheets/d/1f7X_60NeRRfXxhc3KGO62NdIz2wwfWIrY_vpOMy9hPY/export?format=csv")
#'
#' @importFrom RCurl getURL
#' @importFrom utils read.table
#' @export
#' @return data.frame
read_sheet_data <- function(file = NULL, url = NULL){
  if (is.null(file) && is.null(url)) {
    stop("Must provide a file or URL directly!")
  }
  if (!is.null(file)) {
    if (file.exists(file)) {
      sheet_url <- scan(file, what = character())
    }
  } else if (!is.null(url)) {
    sheet_url <- url
  }

  sheet_csv <- getURL(sheet_url, .opts = list(ssl.verifypeer = FALSE))
  sheet_data <- read.table(textConnection(sheet_csv), sep = ",", header = TRUE, stringsAsFactors = FALSE)
  sheet_data
}

#' plot weight
#'
#' generates a nice plot of weight over time to help keep me motivated
#'
#' @param weight_data data.frame containing "date", "weight", "status"
#' @param ylim the limits in the y-direction (defaults to minimum and maximum of data)
#'
#' @export
#' @import ggplot2
#' @importFrom dplyr lead
#' @return plot
plot_weight <- function(weight_data, ylim = range(weight_data$weight, na.rm = TRUE)){
  suppressWarnings(theme_set(cowplot::theme_cowplot()))
  weight_data <- weight_data[!(is.na(weight_data$weight)), ]
  weight_lead <- weight_data$weight - dplyr::lag(weight_data$weight)
  weight_lead[is.na(weight_lead)] <- 0
  weight_data$dir <- "down"
  weight_data[weight_lead > 0, "dir"] <- "up"
  ggplot(weight_data, aes_string(x = "date", y = "weight", color = "status", fill = "status", shape = "dir")) + geom_line(color = "black", aes(group = 1)) + geom_point(size = 4) + ylim(ylim) + theme(axis.text.x = element_text(angle = 90)) + scale_shape_manual(values = c("up" = 24, "down" = 25))
}
