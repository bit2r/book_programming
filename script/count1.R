
library(tidyverse)

cat("파일명을 입력하세요?")

input_filename <- readLines("stdin", n=1)

romeo_text <- readr::read_lines(input_filename)

romeo_split <- stringr::str_split(romeo_text, " ")

romeo_freq <- romeo_split %>% unlist() %>%
  table() %>%
  as.list()

romeo_freq
