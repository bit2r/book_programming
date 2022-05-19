library(httr)

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

url_link <- stringr::str_extract_all(html, pattern = 'href="(http://.*?)"')

print(url_link)
