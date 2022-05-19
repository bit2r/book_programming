library(httr)
library(rvest)

typeline <- function(msg = "Enter - ") {
  if (interactive() ) {
    url <- readline(msg)
  } else {
    cat(msg);
    url <- readLines("stdin",n=1);
  }
  return(url)
}

url <- typeline()

html <- httr::GET(url)
webpage <- rvest::read_html(html)

a_href <- webpage %>%
  html_elements("a") %>%
  html_attr("href")

a_text <- webpage %>%
  html_elements("a") %>%
  html_text() %>%
  stringr::str_remove("\n")

cat("URL: ", a_href, "\n")
cat("Content:", a_text)
