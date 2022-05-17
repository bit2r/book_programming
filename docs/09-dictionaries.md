
---
output: html_document
editor_options: 
  chunk_output_type: console
---



# 딕셔너리 {#named-list}

명칭을 갖는 리스트(named list)는 딕셔너리로 더 잘 알려져 있고,
**딕셔너리(dictionary)**는 리스트 같지만 좀더 일반적이다. 리스트에서
위치(인텍스)는 정수이지만, 딕셔너리에서는 인덱스는 임의 자료형(type)이
될 수 있다.

딕셔너리를 인덱스 집합(**키(keys)**라고 부름)에서 값(value) 집합으로
사상(mapping)하는 것으로 생각할 수 있다. 각각의 키는 값에 대응한다. 키와
값을 연관시키는 것을 **키-값 페어(key-value pair)**라고 부르고, 종종
항목(item)으로도 부른다.

한 예제로, 영어 단어에서 스페인 단어에 매핑되는 사전을 만들 것이다. 키와
값은 모두 문자열이다.

`list` 함수는 항목이 전혀 없는 리스트를 신규로 생성한다. `list`는
내장함수명이어서, 변수명으로 사용하는 것을 피해야 한다.


```r
eng2kr <- list()
eng2kr
```

```
## list()
```


`list()`는 빈 리스트임을 나타낸다. 리스트에 신규 요소를
추가하기 위해서 `list()` 함수 내부에 `'명칭'='값'`과 같이
명칭과 값을 지정한다.


```r
eng2kr <- list('one' = '하나')
```


상기 코드는 키(명칭) `'one'`에서 값 `'하나'`를 매핑하는 항목을 생성한다.
명칭을 갖는 리스를 다시 출력하면, 키-값
페어(key-value pair)를 볼 수 있다.


```r
eng2kr
```

```
## $one
## [1] "하나"
```


다수 키-값을 갖는 명칭을 갖는 리스트를 제작할 경우
순차적으로 작성하고 `list()`로 감싼다.예를 들어, 세개 항목을 가진 
명칭을 갖는 리스트를 생성할 수 있다.



```r
eng2kr <- list('one' = '하나',
               'two' = '둘',
               'three' = '셋')
```


`eng2sp`을 출력하면 다음과 같다.



```r
eng2kr
```

```
## $one
## [1] "하나"
## 
## $two
## [1] "둘"
## 
## $three
## [1] "셋"
```


명칭을 갖는 리스트에서 키를 사용해서 상응하는 값을 찾을 수 있다.


```r
eng2kr['one']
```

```
## $one
## [1] "하나"
```


`'two'` 키는 항상 값 `'둘'`에 상응되어서 명칭을 갖는 리스트 항목 순서는 문제가
되지 않는다.

만약 키가 리스트에 존재하지 않으면, `NULL` 값을 반환한다.


```r
eng2kr['four']
```

```
## $<NA>
## NULL
```


`length()` 함수를 리스트에 사용하여 키-값 페어(key-value pair) 항목 개수를
파악할 수 있다.


```r
length(eng2kr)
```

```
## [1] 3
```


`%in%` 연산자는 명칭을 갖는 리스트에 키(Key, 명칭)이 있는지 알려준다.
`%in%` 연산자는 각 항목마다 키(명칭)가 있는지 참/거짓으로 알려주기 때문에
`any()`와 결합해서 사용하게 되면 리스트에 키가 있는지 없는지만 확인할 때 요긴하다.


```r
names(eng2kr) %in% "one" %>% any()
```

```
## [1] TRUE
```

비교를 위해서 리스트에 없는 키(명칭) `five`를 확인해보자.


```r
names(eng2kr) %in% "five" %>% any()
```

```
## [1] FALSE
```

이번에는 리스트에 값이 있는지를 확인해보자.


```r
eng2kr %in% "둘"
```

```
## [1] FALSE  TRUE FALSE
```


"둘" 값을 갖는 항목이 있는지를 `%in%` 연산자를 사용해서 확인했다.


```r
eng2kr %in% c("둘", "셋")
```

```
## [1] FALSE  TRUE  TRUE
```

조금 확장해서 "둘", "셋"이 있는지도 없는지도 쉽게 확인할 수 있다.

### 연습문제 

`words.txt` 단어를 읽어서 명칭을 갖는 리스트에 키로 저장하는 프로그램을
작성하세요. 값이 무엇이든지 상관없습니다. 리스트에 문자열을 확인하는
가장 빠른 방법으로 명칭을 확인할 경우 `names()` 함수와
값을 확인할 경우 그냥 `%in%` 연산자와 조합하여 사용할 수 있습니다.

## 계수기 집합으로 리스트 {#named-list-wordlist}


문자열이 주어진 상태에서, 각 문자가 얼마나 나타나는지를 센다고
가정합시다. 몇 가지 방법이 아래에 있습니다.

1.  26개 변수를 알파벳 문자 각각에 대해 생성한다. 그리고 나서 아마도
    연쇄 조건문을 사용하여 문자열을 훑고 해당 계수기(counter)를 하나씩
    증가한다.

2.  26개 요소를 가진 리스트를 생성한다. 
    리스트 안에 인덱스로 숫자를 사용해서 적당한
    계수기(counter)를 증가한다.

3.  키(key)로 문자, 계수기(counter)로 해당 값(value)을 갖는 리스트를
    생성한다. 처음 문자를 만나면, 딕셔너리에 항목으로 추가한다. 추가한
    후에는 기존 항목 값을 증가한다.

상기 3개 옵션은 동일한 연산을 수행하지만, 각각은 다른 방식으로 연산을
구현한다.

**구현(implementation)**은 연산(computation)을 수행하는 방법이다. 어떤
구현 방법이 다른 것 보다 낫다. 
다음에 명칭을 갖는 리스트로 구현한 코드가 있다.


```r
word <- 'brontosaurus'
word_split <- strsplit(word, "")[[1]]

n_list <- list()

for(char in 1:length(word_split)) {
  
  if( word_split[char]  %in% names(n_list) ) { # 기존 존재하는 키(명칭)
    n_list[[ word_split[char] ]] <- n_list[[ word_split[char] ]] + 1
  } else { # 처음 출현하는 키(명칭)
    temp_list <- list()
    temp_list[[word_split[char]]] <- 1
    n_list <- append(n_list, temp_list)
  }
}

# n_list
```


계수기(counter) 혹은 빈도에 대한 통계 용어인 **히스토그램(histogram)**을
효과적으로 산출할 수 있다.

`for` 루프는 문자열을 훑는다. 매번 루프를 반복할 때마다 리스트에 문자
`c`가 없다면, 키 `c`와 초기값 1을 가진 새로운 항목을 생성한다. 문자
`c`가 이미 리스트에 존재한다면, `n_list[['c']]`을 증가한다.

다음 프로그램 실행 결과가 있다.


```r
n_list
```

```
## $b
## [1] 1
## 
## $r
## [1] 2
## 
## $o
## [1] 2
## 
## $n
## [1] 1
## 
## $t
## [1] 1
## 
## $s
## [1] 2
## 
## $a
## [1] 1
## 
## $u
## [1] 2
```
    

히스토그램은 문자 `’a’`, `'b'`는 1회, `'o'`는 2회 등등 나타남을
보여준다.

R은 태생에 통계를 근간으로 하기 때문에 빈도수를 구하거나 하는 문제를 아주 
쉽고 간결하게 작성할 수 있다. 앞선 `for`, `if` 문을 명칭이 있는 리스트 
자료구조를 이용해서 길게 작성했지만, `table()` 함수를 사용하면 
훨씬 간결하게 동일한 효과를 낼 수 있다.



```r
word <- 'brontosaurus'
word_split <- strsplit(word, "")[[1]]

table(word_split) %>% 
  as.list()
```

```
## $a
## [1] 1
## 
## $b
## [1] 1
## 
## $n
## [1] 1
## 
## $o
## [1] 2
## 
## $r
## [1] 2
## 
## $s
## [1] 2
## 
## $t
## [1] 1
## 
## $u
## [1] 2
```


시간을 가지고서 잠시 `if` 문과 `in` 연산자를 사용한 루프와
적절한 전처리 과정을 거쳐 자료형을 맞추고 나서
`table()` 함수를 사용한 방식을 비교해 보세요. 
동일한 연산을 수행하지만,
하나가 더 간결한다.

## 리스트와 파일 {#named-list-file}


딕셔너리의 흔한 사용법 중의 하나는 텍스트로 작성된 파일에 단어 빈도를
세는 것이다.
<http://shakespeare.mit.edu/Tragedy/romeoandjuliet/romeo_juliet.2.2.html>
사이트 덕분에 *로미오와 쥴리엣(Romeo and Juliet)* 텍스트 파일에서
시작합시다.

처음 연습으로 구두점이 없는 짧고 간략한 텍스트 버젼을 사용한다. 나중에
구두점이 포함된 전체 텍스트로 작업할 것이다.

```
    But soft what light through yonder window breaks
    It is the east and Juliet is the sun
    Arise fair sun and kill the envious moon
    Who is already sick and pale with grief
```    

파일 라인을 읽고, 각 라인을 단어 리스트로 쪼개고, 루프를 돌려 사전을
이용하여 각 단어의 빈도수를 세는 R 프로그램을 작성한다.

두 개의 `for` 루프를 사용한다. 외곽 루프는 파일 라인을 읽고, 내부 루프는
특정 라인의 단어 각각에 대해 반복한다. 하나의 루프는 *외곽* 루프가 되고,
또 다른 루프는 *내부* 루프가 되어서 **중첩 루프(nested loops)**라고
불리는 패턴 사례다.

외곽 루프가 한번 반복을 할 때마다 내부 루프는 모든 반복을 수행하기
때문에 내부 루프는 "좀더 빨리" 반복을 수행하고 외곽 루프는 좀더 천천히
반복을 수행하는 것으로 생각할 수 있다.

두 중첩 루프의 조합이 입력 파일의 모든 라인에 있는 모든 단어의 빈도를
계수(count)하는 것을 보증한다.

중첩루프를 돌려 단어 빈도수를 계산하는 것도 가능하지만
R의 강력한 내장함수를 활용하여 간결하게 다음과 같이 작성할 수도 있다.


```r
romeo_text <- "But soft what light through yonder window breaks It is the east and Juliet is the sun Arise fair sun and kill the envious moon Who is already sick and pale with grief"

romeo_split <- stringr::str_split(romeo_text, " ")[[1]]

romeo_freq <- romeo_split %>% 
  table() %>% 
  as.list()  
```


프로그램을 실행하면, 정렬되지 않은 해쉬 순서로 모든 단어의 빈도수를
출력합니다. `romeo.txt` 파일은
[www.py4inf.com/code/romeo.txt](www.py4inf.com/code/romeo.txt)에서
다운로드 가능하다. 다운로드 받은 `romeo.txt` 파일을 로컬 파일에 저장한 후에 
파일명을 읽어 실행하는 코드를 작성하여 실행하면 다음과 같은 결과를 확인할 수 있다.

이를 위해서 앞서 작성한 코드를 다음과 같이 사용자 입력을 받아 처리할 수 있도록
`count1.R` 파일에 저장시킨다.


```r
## script/count1.R

library(tidyverse)

cat("파일명을 입력하세요?")

input_filename <- readLines("stdin", n=1)

romeo_text <- readr::read_lines(input_filename)

romeo_split <- stringr::str_split(romeo_text, " ")

romeo_freq <- romeo_split %>% unlist() %>%
  table() %>%
  as.list()

romeo_freq
```


상기 코드를 쉘에서 Rscript 명령어로 실행하게 되면 `romeo.txt` 파일에 담긴 
단어 빈도수를 계산할 수 있게 된다.


```r
$ Rscript --vanilla script/count1.R

파일명을 입력하세요? data/romeo.txt
$already
[1] 1

$and
[1] 3

$Arise
[1] 1

$breaks
[1] 1

$But
[1] 1

$east
[1] 1

$envious
[1] 1

$fair
[1] 1

$grief
[1] 1

$is
[1] 3

$It
[1] 1

$Juliet
[1] 1

$kill
[1] 1

$light
[1] 1

$moon
[1] 1

$pale
[1] 1

$sick
[1] 1

$soft
[1] 1

$sun
[1] 2

$the
[1] 3

$through
[1] 1

$what
[1] 1

$Who
[1] 1

$window
[1] 1

$with
[1] 1

$yonder
[1] 1
```



가장 높은 빈도 단어와 빈도수를 찾기 위해서 리스트를 훑는 것이
불편하다. 좀더 도움이 되는 출력결과를 만들려고 코드를 바꿔보자.

## 반복과 리스트 {#named-list-loop}

`for`문에 순서(sequence)로서 리스트를 사용한다면, 리스트 키를
훑는다. 루프는 각 키와 해당 값을 출력한다.


```r
counts <- list('chuck' = 1 , 
               'annie' = 42, 
               'jan'   = 100)

for( count in seq_along(counts) ) {
  cat( names(counts)[count], ":", counts[[names(counts)[count]]], "\n")
}
```

출력은 다음과 같다.


```
## chuck : 1 
## annie : 42 
## jan : 100
```

이 패턴을 사용해서 앞서 기술한 다양한 루프 숙어를 구현한다. 예를 들어,
리스트에서 10 보다 큰 값을 가진 항목을 모두 찾고자 한다면, 다음과 같이
코드를 작성한다.



```r
counts <- list('chuck' = 1 , 
               'annie' = 42, 
               'jan'   = 100)

for( count in seq_along(counts) ) {
  if( counts[[names(counts)[count]]] > 10 ) {
    cat( names(counts)[count], ":", counts[[names(counts)[count]]], "\n")
  }
}
```


`for` 루프는 딕셔너리 *키(keys)*를 반복한다. 그래서, 인덱스 연산자를
사용해서 각 키에 상응하는 *값(value)*을 가져와야 한다. 여기 출력값이
있다.



```
## annie : 42 
## jan : 100
```

10 이상 값만 가진 항목만 볼 수 있다.

알파벳 순으로 키를 출력하고자 한다면, 리스트 객체에서 이름을 따로 추출해서 
알파벳순서로 정렬한다. 그리고 이를 리스트 객체에 반영하여 정렬된 
명칭이 있는 리스트를 준비한다.아래와 같이 정렬된 순서로 키/값
페어(key/value pair)를 출력한다.


```r
counts <- list('chuck' = 1 , 
               'annie' = 42, 
               'jan'   = 100)

name_sorted <- sort(names(counts))
counts <- counts[name_sorted]

for( count in seq_along(counts) ) {
    cat( names(counts)[count], ":", counts[[names(counts)[count]]], "\n")
}
```


다음에 출력결과가 있다.



```
## annie : 42 
## chuck : 1 
## jan : 100
```


첫 명칭이 있는 리스트는 정렬되지 않은 키 리스트였다면, 
`for` 루프로 정렬된 키/값 페어(key/value pair)를 확인할 수 있다.

## 고급 텍스트 파싱{named-list-advanced}

`romeo.txt` 파일을 사용한 상기 예제에서, 수작업으로 모든 구두점을
제거해서 가능한 단순하게 만들었다. 실제 텍스트는 아래 보여지는 것처럼
많은 구두점이 있다.

```
    But, soft! what light through yonder window breaks?
    It is the east, and Juliet is the sun.
    Arise, fair sun, and kill the envious moon,
    Who is already sick and pale with grief,
```

R `stringr` 패키지 `str_split()` 함수는 공백을 찾고 공백으로 구분되는 토큰으로 단어를
처리하기 때문에, "soft!" 와 "soft"는 다른 단어로 처리되고 각 단어에
대해서 별도 딕셔너리 항목을 생성한다.

파일에 대문자가 있어서, "who"와 "Who"를 다른 단어, 다른 빈도수를 가진
것으로 처리한다.

`stringr` 패키지 `str_to_lower`, `str_squish`, `str_replace_all`, 문자열 함수를 사용해서 상기 문제를
해결할 수 있다. `str_replace_all` 함수가 가장 적합하다. `str_replace_all` 함수에
대한 문서가 다음에 있다.

```
str_replace_all(string, pattern, replacement)
```

`pattern` 매개변수를 사용해서 모든 구두점을 삭제할 수 있다.
"구두점"으로 간주되는 문자 리스트는 `[[:punct:]]`에 정의되어 있어
별도 `~!@#$%^&*(){}_+:\"<>?,./;'[]-=`와 같이 지정하지 않아도 된다.
`replacement`에는 삭제 혹은 교체 문자를 지정하면 된다.

프로그램을 다음과 같은 수정을 한다.


```r
library(tidyverse)

cat("파일명을 입력하세요?")

input_filename <- readLines("stdin", n=1)

romeo_text <- readr::read_lines(input_filename)

romeo_split <- stringr::str_split(romeo_text, " ") %>% 
  unlist() %>% 
  stringr::str_to_lower() %>% 
  stringr::str_replace_all(., pattern = "[[:punct:]]",
                              replacement = "")

romeo_freq <- romeo_split %>% unlist() %>%
  table() %>%
  as.list()

romeo_freq
```

`str_replace_all` 함수를 사용해서 모든 구두점을 제거했고, `str_to_lower` 함수를
사용해서 라인을 소문자로 수정했다. 나머지 프로그램은 변경된 것이 없다.


상기 프로그램을 실행한 출력결과는 다음과 같다.


```r
$ $ Rscript.exe script/count2.R

파일명을 입력하세요? data/romeo.txt
$already
[1] 1

$and
[1] 3

$arise
[1] 1

$breaks
[1] 1

$but
[1] 1

$east
[1] 1

$envious
[1] 1

$fair
[1] 1

$grief
[1] 1

$is
[1] 3

$it
[1] 1

$juliet
[1] 1

$kill
[1] 1

$light
[1] 1

$moon
[1] 1

$pale
[1] 1

$sick
[1] 1

$soft
[1] 1

$sun
[1] 2

$the
[1] 3

$through
[1] 1

$what
[1] 1

$who
[1] 1

$window
[1] 1

$with
[1] 1

$yonder
[1] 1
```


출력결과는 여전히 다루기 힘들어 보입니다. R 프로그래밍을 통해 정확히
찾고자는 하는 것을 찾았으나 R **튜플(tuples)**(다양한 자료형을 갖는 리스트)에 
대해서 학습할 필요성을 느껴진다. 튜플을 학습할 때, 다시 이 예제를 살펴볼 것이다.

## 디버깅 {r-dicionaries-debugging}

점점 더 큰 데이터로 작업함에 따라, 수작업으로 데이터를 확인하거나 출력을
통해서 디버깅을 하는 것이 어려울 수 있다. 큰 데이터를 디버깅하는 몇가지
방법이 있다.

1. **입력값을 줄여라(Scale down the input)**

    가능하면, 데이터 크기를 줄여라. 예를 들어, 프로그램이 텍스트
    파일을 읽는다면, 첫 10줄로 시작하거나, 찾을 수 있는 작은 예제로
    시작하라. 데이터 파일을 편집하거나, 프로그램을 수정해서 첫 `n`
    라인만 읽도록 프로그램을 변경하라.

    오류가 있다면, `n`을 줄여서 오류를 재현하는 가장 작은 값으로
    만들어라. 그리고 나서, 오류를 찾고 수정해 나감에 따라 점진적으로
    늘려나가라.

2. **요약값과 자료형을 확인하라(Check summaries and types)**

    전체 데이터를 출력하고 검증하는 대신에 데이터를 요약하여 출력하는
    것을 생각하라: 예를 들어, 딕셔너리 항목의 숫자 혹은 리스트 숫자의
    총계

    실행 오류(runtime errors)의 일반적인 원인은 올바른 자료형(right
    type)이 아니기 때문이다. 이런 종류의 오류를 디버깅하기 위해서, 종종
    값의 자료형을 출력하는 것으로 충분하다.

3. **자가 진단 작성(Write self-checks)**

    종종 오류를 자동적으로 검출하는 코드를 작성한다. 예를 들어, 리스트
    숫자의 평균을 계산한다면, 결과값은 리스트의 가장 큰 값보다 클 수
    없고, 가장 작은 값보다 작을 수 없다는 것을 확인할 수 있다. "완전히
    비상식적인" 결과를 탐지하기 때문에 "건전성 검사(sanity check)"라고
    부른다.

    또 다른 검사법은 두가지 다른 연산의 결과를 비교해서 일치하는지
    살펴보는 것이다. "일치성 검사(consistency check)"라고 부른다.

4. **고급 출력(Pretty print the output)**

   디버깅 출력결과를 서식화하는 것은 오류 발견을 용이하게 한다.

다시 한번, 발판(scaffolding)을 만드는데 들인 시간이 디버깅에 소비되는
시간을 줄일 수 있다.

## 용어정의 {#r-dictionaries-terminology}

- **명칭있는 리스트/딕셔너리(dictionary)**: 키(key)에서 해당 값으로 매핑(mapping)
- **해쉬테이블(hashtable)**: 파이썬 딕셔너리를 구현하기 위해 사용된 알고리즘
- **해쉬 함수(hash function)**: 키에 대한 위치를 계산하기 위해서 해쉬테이블에서 사용되는 함수
- **히스토그램(histogram)**: 계수기(counter) 집합.
- **구현(implementation)**: 연산(computation)을 수행하는 방법
- **항목(item)**: 키-값 페어(key-value pair)에 대한 또 다른 이름.
- **키(key)**: 키-값 페어(key-value pair)의 첫번째 부분으로 딕셔너리에 나타나는 객체.
- **키-값 페어(key-value pair)**: 키에서 값으로 매핑 표현.
- **룩업(lookup)**: 키를 가지고 해당 값을 찾는 딕셔너리 연산.
- **중첩 루프(nested loops)**: 루프 "내부"에 하나 혹은 그 이상의 루프가 있음. 외곽 루프가 1회
    실행될 때, 내부 루프는 전체 반복을 완료함.
- **값(value)**:키-값 페어(key-value pair)의 두번째 부분으로 딕셔너리에 나타나는
    객체. 앞에서 사용한 단어 "값(value)" 보다 더 구체적이다.

## 연습문제{#r-dictionaries-ex}


1. 커밋(commit)이 무슨 요일에 수행되었는지에 따라 전자우편 메세지를
구분하는 프로그램을 작성하세요. "From"으로 시작하는 라인을 찾고, 3번째
단어를 찾아서 요일별 횟수를 계수(count)하여 저장하세요. 프로그램 끝에
딕셔너리 내용을 출력하세요. (순서는 문제가 되지 않습니다.)

```
    Sample Line:
    From stephen.marquard@uct.ac.za Sat Jan  5 09:14:16 2008

    Sample Execution:
    Rscript --vanilla dow.R
    Enter a file name: mbox-short.txt
    {'Fri': 20, 'Thu': 6, 'Sat': 1}
```    

2. 전자우편 로그(log)를 읽고, 히스토그램을 생성하는 프로그램을 작성하세요.
딕셔너리를 사용해서 전자우편 주소별로 얼마나 많은 전자우편이 왔는지를
계수(count)하고 딕셔너리를 출력합니다.

```
    Enter file name: mbox-short.txt
    {'gopal.ramasammycook@gmail.com': 1, 'louis@media.berkeley.edu': 3, 
    'cwen@iupui.edu': 5, 'antranig@caret.cam.ac.uk': 1, 
    'rjlowe@iupui.edu': 2, 'gsilver@umich.edu': 3, 
    'david.horwitz@uct.ac.za': 4, 'wagnermr@iupui.edu': 1, 
    'zqian@umich.edu': 4, 'stephen.marquard@uct.ac.za': 2, 
    'ray@media.berkeley.edu': 1}
```    

4. 상기 프로그램에 누가 가장 많은 전자우편 메시지를 가졌는지 알아내는
코드를 추가하세요.

결국, 모든 데이터를 읽고, 딕셔너리를 생성한다. 최대
루프를 사용해서 딕셔너리를 훑어서 누가 가장
많은 전자우편 메시지를 갖는지, 그리고 그 사람이 얼마나 많은 메시지를
갖는지 출력한다.

```
    Enter a file name: mbox-short.txt
    cwen@iupui.edu 5

    Enter a file name: mbox.txt
    zqian@umich.edu 195
```

5. 다음 프로그램은 주소 대신에 도메인 이름을 기록한다. 누가 메일을 보냈는지
대신(즉, 전체 전자우편 주소) 메시지가 어디에서부터 왔는지 출처를
기록한다. 프로그램 마지막에 딕셔너리 내용을 출력한다.

```
    Rscript --vanilla schoolcount.R
    Enter a file name: mbox-short.txt
    {'media.berkeley.edu': 4, 'uct.ac.za': 6, 'umich.edu': 7, 
    'gmail.com': 1, 'caret.cam.ac.uk': 1, 'iupui.edu': 8}
```
