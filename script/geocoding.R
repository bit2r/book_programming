
library(tidyverse)
library(httr)
library(jsonlite)

# 주소를 지정합니다.

typeline <- function(msg = "주소를 입력하세요 - ") {
  if (interactive() ) {
    url <- readline(msg)
  } else {
    cat(msg);
    url <- readLines("stdin",n=1);
  }
  return(url)
}

address <- typeline() # '서울특별시 강남구 역삼동 737'

# HTTP 요청을 실행합니다.
address_res <- GET(url = 'https://dapi.kakao.com/v2/local/search/address.json',
                query = list(query = address),
                add_headers(Authorization = paste0("KakaoAK ", Sys.getenv("DAUM_MAP_API_KEY"))) )

# 지리정보 데이터프레임 변환
address_list <- address_res %>%
  content(as = 'text') %>%
  fromJSON()

## 도로명주소
address_list$documents$road_address %>%
  select(주소 = address_name, 경도 = x, 위도=y)


