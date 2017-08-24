Track Your Own Weight
---------------------

If you want to track your own weight, then you will need to do a couple of things.

### Setup a Spreadsheet

To setup a spreadsheet of your own, first generate the dates that you are interested in to save to a file and copy them into a Google Sheet.

``` r
dates <- generate_dates(lubridate::today())
write.table(dates, file = "tmp_dates.csv", row.names = FALSE, col.names = TRUE, sep = ",")
```

### Obtain Spreadsheet URL

To read your spreadsheet, you need to share it. The easiest way to do this is by creating a sharing link, and then modifying it.

For example, you should get a sharing url like this:

`https://docs.google.com/spreadsheets/d/1f7X_60NeRRfXxhc3KGO62NdIz2wwfWIrY_vpOMy9hPY`

You then want to add: `/export?format=csv` to the end, so that it would be:

`https://docs.google.com/spreadsheets/d/1f7X_60NeRRfXxhc3KGO62NdIz2wwfWIrY_vpOMy9hPY/export?format=csv`

You can either input this URL directly each time, or save it in a file and supply the file name instead.

### Generate Plot

``` r
library(trackWeight)
weight_data <- read_sheet_data(url = "https://docs.google.com/spreadsheets/d/1f7X_60NeRRfXxhc3KGO62NdIz2wwfWIrY_vpOMy9hPY/export?format=csv")
plot_weight(weight_data)
```

![](track_your_own_files/figure-markdown_github/unnamed-chunk-2-1.png)
