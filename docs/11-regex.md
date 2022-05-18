---
output: html_document
editor_options: 
  chunk_output_type: console
---



# (PART\*) 분야별 도구 {#r-tools .unnumbered}

# 정규 표현식 {#regex}

지금까지 파일을 훑어서 패턴을 찾고, 관심있는 라인에서 다양한
비트(bits)를 뽑아냈다. `stringr` 패키지 `str_split`, `str_detect` 같은 
문자열 함수를 사용하였고, 라인에서 일정 부분을 뽑아내기 위해서 
리스트와 문자열 슬라이싱(slicing)을 사용했다.

검색하고 추출하는 작업은 너무 자주 있는 일이어서 파이썬은 상기와 같은
작업을 매우 우아하게 처리하는 **정규 표현식(regular expressions)**으로
불리는 매우 강력한 라이브러리를 제공한다. 정규 표현식을 책의 앞부분에
소개하지 않은 이유는 정규 표현식 라이브러리가 매우 강력하지만, 약간
복잡하고, 구문에 익숙해지는데 시간이 필요하기 때문이다.

정규표현식은 문자열을 검색하고 파싱하는데 그 자체가 작은 프로그래밍
언어다. 사실, 책 전체가 정규 표현식을 주제로 쓰여진 책이 몇권 있다. 이번
장에서는 정규 표현식의 기초만을 다룰 것이다. 정규 표현식의 좀더 자세한
사항은 다음을 참조하라.

- <http://en.wikipedia.org/wiki/Regular_expression>
- <https://cran.r-project.org/web/packages/stringr/vignettes/regular-expressions.html>

R에서 정규표현식을 지원하는 패키지는 많지만, 대표적으로 [`stringr`](https://stringr.tidyverse.org/)
패키지가 활용사례도 많고 문서화도 충실하다.
정규 표현식 패키지를 사용하기 전에 패키지를 가져오기해야
한다. 정규 표현식 패키지의 가장 간단한 쓰임은 `str_detect()` 검색
함수다. 다음 프로그램은 검색 함수의 사소한 사용례를 보여준다.


```r
library(tidyverse)
library(stringr)

hand <- read_lines("data/mbox-short.txt")

for( line in seq_along(hand)) {
  line <- stringr::str_squish(hand[line])
  if(stringr::str_detect(line, "From:")) {
    print(line)
  }
}
```

```
## [1] "From: stephen.marquard@uct.ac.za"
## [1] "From: louis@media.berkeley.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: rjlowe@iupui.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: rjlowe@iupui.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: gsilver@umich.edu"
## [1] "From: gsilver@umich.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: gsilver@umich.edu"
## [1] "From: wagnermr@iupui.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: antranig@caret.cam.ac.uk"
## [1] "From: gopal.ramasammycook@gmail.com"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: stephen.marquard@uct.ac.za"
## [1] "From: louis@media.berkeley.edu"
## [1] "From: louis@media.berkeley.edu"
## [1] "From: ray@media.berkeley.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: cwen@iupui.edu"
```


파일을 열고, 각 라인을 루프로 반복해서 정규 표현식 `stringr::str_detect()` 
함수를 호출하여 문자열 "From"이 포함된 라인만 출력한다. 상기 프로그램에는
진정으로 강력한 정규 표현식 기능이 사용되지 않았다. 왜냐하면,
다른 함수를 가지고도 동일한 결과를 쉽게 구현할 수 있기 때문이다.

정규 표현식의 강력한 기능은 문자열에 해당하는 라인을 좀더 정확하게
제어하기 위해서 검색 문자열에 특수문자를 추가할 때 확인될 수 있다. 매우
적은 코드를 작성할지라도, 정규 표현식에 특수 문자를 추가하는 것만으로도
정교한 일치(matching)와 추출이 가능하게 한다.

예를 들어, 탈자 기호(caret)는 라인의 "시작"과 일치하는 정규 표현식에
사용된다. 다음과 같이 "From:"으로 시작하는 라인만 일치하도록
응용프로그램을 변경할 수 있다.


```r
for( line in seq_along(hand)) {
  line <- stringr::str_squish(hand[line])
  if(stringr::str_detect(line, "^From:")) {
    print(line)
  }
}
```

```
## [1] "From: stephen.marquard@uct.ac.za"
## [1] "From: louis@media.berkeley.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: rjlowe@iupui.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: rjlowe@iupui.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: gsilver@umich.edu"
## [1] "From: gsilver@umich.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: gsilver@umich.edu"
## [1] "From: wagnermr@iupui.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: antranig@caret.cam.ac.uk"
## [1] "From: gopal.ramasammycook@gmail.com"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: stephen.marquard@uct.ac.za"
## [1] "From: louis@media.berkeley.edu"
## [1] "From: louis@media.berkeley.edu"
## [1] "From: ray@media.berkeley.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: cwen@iupui.edu"
```


"From:" 문자열로 *시작*하는 라인만 일치할 수 있다. 여전히 매우 간단한
프로그램으로 다른 패키지에서도 다양한 함수로 동일하게
수행할 수 있다. 하지만, 무엇을 정규 표현식과 매칭하는가에 대해서 
특수 액션 문자(`^`)를 담아 강력한 제어를 수행하는 정규 표현식 개념을
소개하기에는 충분하다.

## 정규 표현식 문자 매칭 {#regex-char-matching}

좀더 강력한 정규 표현식을 작성할 수 있는 다른 특수문자는 많이 있다. 가장
자주 사용되는 특수 문자는 임의 문자를 매칭하는 마침표다.

다음 예제에서 정규 표현식 "F..m:"은 "From:", "Fxxm:", "F12m:", "F!\@m:'
같은 임의 문자열을 매칭한다. 왜냐하면 정규 표현식 마침표 문자가 임의의
문자와 매칭되기 때문이다.


```r
for( line in seq_along(hand)) {
  line <- stringr::str_squish(hand[line])
  if(stringr::str_detect(line, "^F..m:")) {
    print(line)
  }
}
```

```
## [1] "From: stephen.marquard@uct.ac.za"
## [1] "From: louis@media.berkeley.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: rjlowe@iupui.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: rjlowe@iupui.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: gsilver@umich.edu"
## [1] "From: gsilver@umich.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: gsilver@umich.edu"
## [1] "From: wagnermr@iupui.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: antranig@caret.cam.ac.uk"
## [1] "From: gopal.ramasammycook@gmail.com"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: stephen.marquard@uct.ac.za"
## [1] "From: louis@media.berkeley.edu"
## [1] "From: louis@media.berkeley.edu"
## [1] "From: ray@media.berkeley.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: cwen@iupui.edu"
```

정규 표현식에 "\*", "+' ' 문자를 사용하여 문자가 원하는만큼 반복을
나타내는 기능과 결합되었을 때는 더욱 강력해진다. "\*", "+' ' 특수 문자가
검색 문자열에 문자 하나만을 매칭하는 대신에 별표 기호인 경우 0 혹은 그
이상의 매칭, 더하기 기호인 경우 1 혹은 그 이상의 문자의 매칭을 의미한다.

다음 예제에서 반복 **와일드 카드(wild card)** 문자를 사용하여 매칭하는
라인을 좀더 좁힐 수 있다.



```r
for( line in seq_along(hand)) {
  line <- stringr::str_squish(hand[line])
  if(stringr::str_detect(line, "^From:.+@")) {
    print(line)
  }
}
```

```
## [1] "From: stephen.marquard@uct.ac.za"
## [1] "From: louis@media.berkeley.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: rjlowe@iupui.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: rjlowe@iupui.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: gsilver@umich.edu"
## [1] "From: gsilver@umich.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: gsilver@umich.edu"
## [1] "From: wagnermr@iupui.edu"
## [1] "From: zqian@umich.edu"
## [1] "From: antranig@caret.cam.ac.uk"
## [1] "From: gopal.ramasammycook@gmail.com"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: david.horwitz@uct.ac.za"
## [1] "From: stephen.marquard@uct.ac.za"
## [1] "From: louis@media.berkeley.edu"
## [1] "From: louis@media.berkeley.edu"
## [1] "From: ray@media.berkeley.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: cwen@iupui.edu"
## [1] "From: cwen@iupui.edu"
```

검색 문자열 "`^`From:.+@" 은 "From:" 으로 시작하고, ".+" 하나 혹은 그
이상의 문자들, 그리고 `@` 기호와 매칭되는 라인을 성공적으로 찾아낸다.
그래서 다음 라인은 매칭이 될 것이다.

**`From:`** `stephen.marquard@uct.ac.za`

콜론(:)과 `@` 기호 사이의 모든 문자들을 매칭하도록 확장하는 것으로 ".+"
와이드 카드를 간주할 수 있다.

**`From:`**`.+ @`

더하기와 별표 기호를 "밀어내기(pushy)" 문자로 생각하는 것이 좋다. 예를
들어, 다음 문자열은 ".+" 특수문자가 다음에 보여주듯이 밖으로 밀어내는
것처럼 문자열 마지막 `@` 기호를 매칭한다.

**`From:`**`stephen.marquard@uct.ac.za, csev@umich.edu, and cwen @iupui.edu`

다른 특수문자를 추가함으로서 별표나 더하기 기호가 너무
"탐욕(greedy)"스럽지 않게 만들 수 있다. 와일드 카드 특수문자의
탐욕스러운 기능을 끄는 것에 대해서는 자세한 정보를 참조바란다.

## 정규 표현식 데이터 추출 {#regex-extraction}

R `stringr` 패키지로 문자열에서 데이터를 추출하려면, `str_extract_all()` 함수를 사용해서
정규 표현식과 매칭되는 모든 부속 문자열을 추출할 수 있다. 형식에
관계없이 임의 라인에서 전자우편 주소 같은 문자열을 추출하는 예제를
사용하자. 예를 들어, 다음 각 라인에서 전자우편 주소를 뽑아내고자 한다.

```
    From stephen.marquard@uct.ac.za Sat Jan  5 09:14:16 2008
    Return-Path: <postmaster@collab.sakaiproject.org>
              for <source@collab.sakaiproject.org>;
    Received: (from apache@localhost)
    Author: stephen.marquard@uct.ac.za
```

각각의 라인에 대해서 다르게 쪼개고, 슬라이싱하면서 라인 각각의 형식에
맞추어 코드를 작성하고는 싶지는 않다. 다음 프로그램은 `str_extract_all()`
함수를 사용하여 전자우편 주소가 있는 라인을 찾아내고 하나 혹은 그
이상의 주소를 뽑아낸다.


```r
library(stringr)

s <- 'Hello from csev@umich.edu to cwen@iupui.edu about the meeting @2PM'

lst <- str_extract_all(s, '\\S+@\\S+')

# lst
```


`str_extract_all()` 함수는는 두번째 인자 패턴을 갖는 문자열을 찾아서 
전자우편 주소처럼 보이는 모든 문자열을 리스트로 반환한다. 
공백이 아닌 문자 (`\\`S)와 매칭되는 가운데 
`@`을 갖는 두 문자열 시퀀스(sequence)를 매칭한다.

프로그램의 출력은 다음과 같다.


```r
lst
```

```
## [[1]]
## [1] "csev@umich.edu" "cwen@iupui.edu"
```

정규 표현식을 해석하면, 적어도 하나의 공백이 아닌 문자, `@`과 적어도
하나 이상의 공백이 아닌 문자를 가진 부속 문자열을 찾는다. 또한, "`\\`S+"
특수 문자는 가능한 많이 공백이 아닌 문자를 매칭한다. (정규 표현식에서
**"탐욕(greedy)"** 매칭이라고 부른다.)

정규 표현식은 두번 매칭(csev\@umich.edu, cwen\@iupui.edu)하지만, 문자열
"\@2PM"은 매칭을 하지 않는다. 왜냐하면, `@` 기호 *앞*에 공백이 아닌
문자가 하나도 없기 때문이다. 프로그램의 정규 표현식을 사용해서 파일에
모든 라인을 읽고 다음과 같이 전자우편 주소처럼 보이는 모든 문자열을
출력한다.


```r
hand <- read_lines("data/mbox-short.txt")

for( line in seq_along(hand)) {
  
  line <- stringr::str_squish(hand[line])
  x <- stringr::str_extract(line, "\\S+@\\S+")
  
  if(! is.na(str_length(x)) ) {
    print(x)
  }
}
```

각 라인을 읽어 들이고, 정규 표현식과 매칭되는 모든 부속 문자열을
추출한다. `str_extract()` 함수는 문자 벡터를 반환하기 때문에, 전자우편 처럼
보이는 부속 문자열을 적어도 하나 찾아서 출력하기 위해서 반환 리스트 요소
숫자가 `NA` 여부를 간단히 확인한다.

`mbox.txt` 파일에 프로그램을 실행하면, 다음 출력을 얻는다.

```
[1] "stephen.marquard@uct.ac.za"
[1] "<postmaster@collab.sakaiproject.org>"
[1] "<200801051412.m05ECIaH010327@nakamura.uits.iupui.edu>"
[1] "<source@collab.sakaiproject.org>;"
[1] "<source@collab.sakaiproject.org>;"
[1] "<source@collab.sakaiproject.org>;"
[1] "apache@localhost)"
[1] "source@collab.sakaiproject.org;"
[1] "stephen.marquard@uct.ac.za"
[1] "source@collab.sakaiproject.org"
[1] "stephen.marquard@uct.ac.za"
[1] "stephen.marquard@uct.ac.za"
[1] "louis@media.berkeley.edu"
...
```

전자우편 주소 몇몇은 "`<`", ";" 같은 잘못된 문자가 앞과 뒤에 붙어있다.
문자나 숫자로 시작하고 끝나는 문자열 부분만 관심있다고 하자.

그러기 위해서, 정규 표현식의 또 다른 기능을 사용한다. 매칭하려는 다중
허용 문자 집합을 표기하기 위해서 꺾쇠 괄호를 사용한다. 그런 의미에서
"`\`S"은 공백이 아닌 문자 집합을 매칭하게 한다. 이제 매칭하려는 문자에
관해서 좀더 명확해졌다.

여기 새로운 정규 표현식이 있다.

```
    [a-zA-Z0-9]\\S*@\\S*[a-zA-Z]
```

약간 복잡해졌다. 왜 정규 표현식이 자신만의 언어인가에 대해서 이해할 수
있다. 이 정규 표현식을 해석하면, 0 혹은 그 이상의 공백이 아닌
문자("`\\S*`")로 하나의 소문자, 대문자 혹은 숫자("[a-zA-Z0-9]")를
가지며, `@` 다음에 0 혹은 그 이상의 공백이 아닌 문자("`\\S*`")로 하나의
소문자, 대문자 혹은 숫자("[a-zA-Z0-9]")로 된 부속 문자열을 찾는다. 0
혹은 그 이상의 공백이 아닌 문자를 나타내기 위해서 "+"에서 "*"으로
바꿨다. 왜냐하면 "[a-zA-Z0-9]" 자체가 이미 하나의 공백이 아닌 문자이기
때문이다. "*", "+"는 단일 문자에 별표, 더하기 기호 왼편에 즉시 적용됨을
기억하세요.

프로그램에 정규 표현식을 사용하면, 데이터가 훨씬 깔끔해진다.


```r
hand <- read_lines("data/mbox-short.txt")

for( line in seq_along(hand)) {
  
  line <- stringr::str_squish(hand[line])
  x <- stringr::str_extract(line, "[a-zA-Z0-9]\\S*@\\S*[a-zA-Z]")
  
  if(! is.na(str_length(x)) ) {
    print(x)
  }
}
```

```
[1] "stephen.marquard@uct.ac.za"
[1] "postmaster@collab.sakaiproject.org"
[1] "200801051412.m05ECIaH010327@nakamura.uits.iupui.edu"
[1] "source@collab.sakaiproject.org"
[1] "source@collab.sakaiproject.org"
[1] "source@collab.sakaiproject.org"
[1] "apache@localhost"
[1] "source@collab.sakaiproject.org"
[1] "stephen.marquard@uct.ac.za"
[1] "source@collab.sakaiproject.org"
[1] "stephen.marquard@uct.ac.za"
[1] "stephen.marquard@uct.ac.za"
[1] "louis@media.berkeley.edu"
[1] "postmaster@collab.sakaiproject.org"
[1] "200801042308.m04N8v6O008125@nakamura.uits.iupui.edu"
[1] "source@collab.sakaiproject.org"
[1] "source@collab.sakaiproject.org"
[1] "source@collab.sakaiproject.org"
[1] "apache@localhost"
...
```


"source@collab.sakaiproject.org" 라인에서 문자열 끝에 "`>`" 문자를
정규 표현식으로 제거한 것을 주목한다. 정규 표현식 끝에 "[a-zA-Z]"을
추가하여서 정규 표현식 파서가 찾는 임의 문자열은 문자로만 끝나야 되기
때문이다. 그래서, "sakaiproject.org`>`;"에서 "`>`"을 봤을 때, "g"가
마지막 맞는 매칭이 되고, 거기서 마지막 매칭을 마치고 중단한다.

`str_extract_all()` 프로그램의 출력은 리스트의 단일 요소를 가진 문자열로 
R 리스트이다.

## 검색과 추출 조합 {#regex-search-extraction}

다음과 같은 "X-" 문자열로 시작하는 라인의 숫자를 찾고자 한다면,

```
    X-DSPAM-Confidence: 0.8475
    X-DSPAM-Probability: 0.0000  
```

임의의 라인에서 임의 부동 소수점 숫자가 아니라 상기 구문을 가진
라인에서만 숫자를 추출하고자 한다.

라인을 선택하기 위해서 다음과 같이 정규 표현식을 구성한다.

```
    ^X-.*: [0-9.]+
```

정규 표현식을 해석하면, `^`에서 "X-"으로 시작하고, ".*"에서 0 혹은
그이상의 문자를 가지며, 콜론(":")이 나오고 나서 공백을 만족하는 라인을
찾는다. 공백 뒤에 "[0-9.]+"에서 숫자 (0-9) 혹은 점을 가진 하나 혹은 그
이상의 문자가 있여야 한다. 꺽쇠 기호 사이에 마침표는 실제 마침표만
매칭함을 주목하기 바란다. (즉, 꺾쇠 기호 사이는 와일드 카드 문자가
아니다.)

관심을 가지고 있는 특정한 라인과 매우 정확하게 매칭이되는 매우 빠듯한
정규 표현식으로 다음과 같다.


```r
library(stringr)

hand <- read_lines("data/mbox-short.txt")

for( line in seq_along(hand)) {
  
  line <- stringr::str_squish(hand[line])
  x <- stringr::str_detect(line, "^X\\S*: [0-9.]+")
  if(x == TRUE) {
    print(line[x])
  }
}
```


프로그램을 실행하면, 잘 걸러져서 찾고자 하는 라인만 볼 수 있다.

```
[1] "X-DSPAM-Confidence: 0.8475"
[1] "X-DSPAM-Probability: 0.0000"
[1] "X-DSPAM-Confidence: 0.6178"
[1] "X-DSPAM-Probability: 0.0000"
[1] "X-DSPAM-Confidence: 0.6961"
...
```

하지만, 이제 `str_split()` 함수를 사용해서 숫자를 뽑아내는 문제를 해결해야 한다.
`str_split()`을 사용하는 것이 간단해 보이지만, 동시에 라인을 검색하고
파싱하기 위해서 정규 표현식의 또 다른 기능을 사용할 수 있다.

괄호는 정규 표현식의 또 다른 특수 문자다. 정규 표현식에 괄호를
추가한다면, 문자열이 매칭될 때, 무시된다. 하지만, `str_extract()`을 사용할
때, 매칭할 전체 정규 표현식을 원할지라도, 정규 표현식을 매칭하는 부속
문자열의 부분만을 뽑아낸다는 것을 괄호가 표시한다.

그래서, 프로그램을 다음과 같이 수정한다.


```r
library(stringr)

hand <- read_lines("data/mbox-short.txt")

for( line in seq_along(hand)) {
  
  line <- stringr::str_squish(hand[line])
  x <- stringr::str_extract(line, "^X\\S*: ([0-9.]+)")
  prob <- stringr::str_extract(x, "([0-9.]+)")
  
  if(!is.na(prob)) {
    print(prob)
  }
}
```


`str_detect()`을 호출하는 대신에, 매칭 문자열의 부동 소수점 숫자만 뽑아내는데
`str_extract()`에 원하는 부동 소수점 숫자를 표현하는 정규 표현식 부분에
괄호를 추가한다.

프로그램의 출력은 다음과 같다.


```
[1] "0.8475"
[1] "0.0000"
[1] "0.6178"
[1] "0.0000"
[1] "0.6961"
[1] "0.0000"
[1] "0.7565"
[1] "0.0000"
[1] "0.7626"
...
```

숫자가 여전히 리스트에 있어서 문자열에서 부동 소수점으로 변환할 필요가
있지만, 흥미로운 정보를 찾아 뽑아내기 위해서 정규 표현식의 강력한 힘을
사용했다.

이 기술을 활용한 또 다른 예제로, 파일을 살펴보면, 폼(form)을 가진 라인이
많다.

```
    Details: http://source.sakaiproject.org/viewsvn/?view=rev&rev=39772
```

상기 언급한 동일한 기법을 사용하여 모든 변경 번호(라인의 끝에 정수
숫자)를 추출하고자 한다만, 다음과 같이 프로그램을 작성할 수 있다.


```r
library(stringr)

hand <- read_lines("data/mbox-short.txt")

for( line in seq_along(hand)) {
  
  line <- stringr::str_squish(hand[line])
  x <- stringr::str_extract(line, "^Details:.*rev=([0-9]+)")
  rev_num <- stringr::str_extract(x, "([0-9]+)")
  # rev_num <- stringr::str_extract(x, "([:digit:]+)")
  
  if(!is.na(rev_num)) {
    print(rev_num)
  }
}
```

```
## [1] "39772"
## [1] "39771"
## [1] "39770"
## [1] "39769"
## [1] "39766"
## [1] "39765"
## [1] "39764"
## [1] "39763"
## [1] "39762"
## [1] "39761"
## [1] "39760"
## [1] "39759"
## [1] "39758"
## [1] "39757"
## [1] "39756"
## [1] "39755"
## [1] "39754"
## [1] "39753"
## [1] "39752"
## [1] "39751"
## [1] "39750"
## [1] "39749"
## [1] "39746"
## [1] "39745"
## [1] "39744"
## [1] "39743"
## [1] "39742"
```


작성한 정규 표현식을 해석하면, "Details:"로 시작하는 ".*"에 임의의
문자들로, "rev="을 포함하고 나서, 하나 혹은 그 이상의 숫자를 가진 라인을
찾는다. 전체 정규 표현식을 만족하는 라인을 찾고자 하지만, 라인 끝에
정수만을 추출하기 위해서 "[0-9]+"을 괄호로 감쌌다.

프로그램을 실행하면, 다음 출력을 얻는다.

```
[1] "39772"
[1] "39771"
[1] "39770"
[1] "39769"
[1] "39766"
[1] "39765"
[1] "39764"
...
```

"[0-9]+"은 "탐욕(greedy)"스러워서, 숫자를 추출하기 전에 가능한 큰
문자열 숫자를 만들려고 한다는 것을 기억하라. 이런 "탐욕(greedy)"스러운
행동으로 인해서 왜 각 숫자로 모두 5자리 숫자를 얻은 이유가 된다. 정규
표현식 라이브러리는 양방향으로 파일 처음이나 끝에 숫자가 아닌 것을
마주칠 때까지 뻗어 나간다.

이제 정규 표현식을 사용해서 각 전자우편 메시지의 요일에 관심이 있었던 책
앞의 연습 프로그램을 다시 작성한다. 다음 형식의 라인을 찾는다.

```
    From stephen.marquard@uct.ac.za Sat Jan  5 09:14:16 2008
```

그리고 나서, 각 라인의 요일의 시간을 추출하고자 한다. 앞에서 `str_split`를
두번 호출하여 작업을 수행했다. 첫번째는 라인을 단어로 쪼개고, 다섯번째
단어를 뽑아내서, 관심있는 두 문자를 뽑아내기 위해서 콜론 문자에서 다시
쪼갰다.

작동을 할지 모르지만, 실질적으로 정말 부서지기 쉬운 코드로 라인이 잘
짜여져 있다고 가정하에 가능하다. 잘못된 형식의 라인이 나타날 때도 결코
망가지지 않는 프로그램을 담보하기 위해서 충분한 오류 검사기능을
추가하거나 커다란 try/except 블록을 넣으면, 참 읽기 힘든 10-15 라인
코드로 커질 것이다.

다음 정규 표현식으로 훨씬 간결하게 작성할 수 있다.

```
    ^From .* [0-9][0-9]:
```

상기 정규 표현식을 해석하면, 공백을 포함한 "From "으로 시작해서, ".*"에
임의 갯수의 문자, 그리고 공백, 두 개의 숫자 "[0-9][0-9]" 뒤에
콜론(:) 문자를 가진 라인을 찾는다. 일종의 찾고 있는 라인에 대한 정의다.

`str_extract()` 함수를 사용해서 단지 시간만 뽑아내기 위해서, 두 숫자에 괄호를
다음과 같이 추가한다.

```
    ^From .* ([0-9][0-9]):
```

작업 결과는 다음과 같이 프로그램에 반영한다.


```r
library(stringr)

hand <- read_lines("data/mbox-short.txt")

for( line in seq_along(hand)) {
  
  line <- stringr::str_squish(hand[line])
  x <- stringr::str_extract(line, "^From .* ([0-9][0-9]):")
  days <- stringr::str_extract(x, "([0-9][0-9])")
  
  if(!is.na(days)) {
    print(days)
  }
}
```

```
## [1] "09"
## [1] "18"
## [1] "16"
## [1] "15"
## [1] "15"
## [1] "14"
## [1] "11"
## [1] "11"
## [1] "11"
## [1] "11"
## [1] "11"
## [1] "11"
## [1] "10"
## [1] "10"
## [1] "10"
## [1] "09"
## [1] "07"
## [1] "06"
## [1] "04"
## [1] "04"
## [1] "04"
## [1] "19"
## [1] "17"
## [1] "17"
## [1] "16"
## [1] "16"
## [1] "16"
```


프로그램을 실행하면, 다음 출력 결과가 나온다.

```
[1] "09"
[1] "18"
[1] "16"
[1] "15"
[1] "15"
[1] "14"
[1] "11"
[1] "11"
...

```


## 이스케이프(Escape) 문자 {#regex-escape}

라인의 처음과 끝을 매칭하거나, 와일드 카드를 명세하기 위해서 정규
표현식의 특수 문자를 사용했기 때문에, 정규 표현식에 사용된 문자가
"정상(normal)"적인 문자임을 표기할 방법이 필요하고 달러 기호와 탈자
기호(`^`) 같은 실제 문자를 매칭하고자 한다.

역슬래쉬(')́를 가진 문자를 앞에 덮붙여서 문자를 단순히 매칭하고자 한다고
나타낼 수 있다. 예를 들어, 다음 정규표현식으로 금액을 찾을 수 있다.


```r
library(stringr)

x <- 'We just received $10.00 for cookies.'

str_extract(x, pattern = '\\$[0-9.]+')
```

```
## [1] "$10.00"
```

역슬래쉬 달러 기호를 앞에 덮붙여서(`\\$`), 실제로 "라인 끝(end of line)" 매칭
대신에 입력 문자열의 달러 기호와 매칭한다. 정규 표현식 나머지 부분은
하나 혹은 그 이상의 숫자 혹은 소수점 문자를 매칭한다. *주목*: 꺾쇠 괄호
내부에 문자는 "특수 문자"가 아니다. 그래서 "[0-9.]"은 실제 숫자 혹은
점을 의미한다. 꺾쇠 괄호 외부에 점은 "와일드 카드(wild-card)" 문자이고
임의의 문자와 매칭한다. 꺾쇠 괄호 내부에서 점은 점일 뿐이다.

## 요약 {#regex-summary}

지금까지 정규 표현식의 표면을 긁은 정도지만, 정규 표현식 언어에 대해서
조금 학습했다. 정규 표현식은 특수 문자로 구성된 검색 문자열로
"매칭(matching)" 정의하고 매칭된 문자열로부터 추출된 결과물을 정규
표현식 시스템과 프로그래머가 의도한 바를 의사소통하는 것이다. 다음에
특수 문자 및 문자 시퀀스의 일부가 있다.

- `^` 라인의 처음을 매칭.
- `$` 라인의 끝을 매칭.
- `.` 임의의 문자를 매칭(와일드 카드)
- `s` 공백 문자를 매칭.
- `S` 공백이 아닌 문자를 매칭.(`s` 의 반대).
- `*` 바로 앞선 문자에 적용되고 0 혹은 그 이상의 앞선 문자와 매칭을 표기함.
- `*?` 바로 앞선 문자에 적용되고 0 혹은 그 이상의 앞선 문자와 매칭을 "탐욕적이지 않은(non-greedy) 방식"으로 표기함.
- `+` 바로 앞선 문자에 적용되고 1 혹은 그 이상의 앞선 문자와 매칭을 표기함.
- `+?` 바로 앞선 문자에 적용되고 1 혹은 그 이상의 앞선 문자와 매칭을
"탐욕적이지 않은(non-greedy) 방식"으로 표기함.
- `[aeiou]` 명세된 집합 문자에 존재하는 단일 문자와 매칭. 다른 문자는
안되고, "a", "e", "i", "o", "u" 문자만 매칭되는 예제.
- `[a-z0-9]` 음수 기호로 문자 범위를 명세할 수 있다. 소문자이거나 숫자인
단일 문자만 매칭되는 예제.
- `[^A-Za-z]` 집합 표기의 첫문자가 `^`인 경우, 로직을 거꾸로 적용한다.
대문자나 혹은 소문자가 아닌 임의 단일 문자만 매칭하는 예제.
- `( )` 괄호가 정규표현식에 추가될 때, 매칭을 무시한다. 하지만 `str_extract()`을
사용할 때 전체 문자열보다 매칭된 문자열의 상세한 부속 문자열을 추출할 수
있게 한다.
- `\b` 빈 문자열을 매칭하지만, 단어의 시작과 끝에만 사용된다.
- `\B` 빈 문자열을 매칭하지만, 단어의 시작과 끝이 아닌 곳에 사용된다.
- `\d` 임의 숫자와 매칭하여 [0-9] 집합에 상응함.
- `\D` 임의 숫자가 아닌 문자와 매칭하여 [^0-9] 집합에 상응함.

## 유닉스 사용자 보너스 {#unix-users}

정규 표현식을 사용하여 파일을 검색 기능은 1960년대 이래로 유닉스 운영
시스템에 내장되어 여러가지 형태로 거의 모든 프로그래밍 언어에서
이용가능하다.

사실, `str_detect()` 예제에서와 거의 동일한 기능을 하는 **grep**
(Generalized Regular Expression Parser)으로 불리는 유닉스 내장 명령어
프로그램이 있다. 그래서, 맥킨토시나 리눅스 운영 시스템을 가지고 있다면,
명령어 창에서 다음 명령어를 시도할 수 있다.

```
    $ grep '^From:' mbox-short.txt
    From: stephen.marquard@uct.ac.za
    From: louis@media.berkeley.edu
    From: zqian@umich.edu
    From: rjlowe@iupui.edu
```

`grep`을 사용하여, `mbox-short.txt` 파일 내부에 "From:" 문자열로
시작하는 라인을 보여준다. `grep` 명령어를 가지고 약간 실험을 하고
`grep`에 대한 문서를 읽는다면, 파이썬에서 지원하는 정규 표현식과
`grep`에서 지원되는 정규 표현식과 차이를 발견할 것이다. 예를 들어,
`grep` 공백이 아닌 문자 "`\S`"을 지원하지 않는다. 그래서 약간 더 복잡한
집합 표기 "[^ ]"을 사용해야 한다. "[^ ]"은 간단히 정리하면,
공복을 제외한 임의의 문자와 매칭한다.

## 디버깅 {#regex-debugging}

R에 대해서 도움을 어떻게 받을 수 있을까요?

만약 특정 함수의 정확한 이름을 기억해 내기 위해서 빠르게 생각나게 하는
것이 필요하다면 도움이 많이 될 수 있는 간단하고 초보적인 내장 문서가
R에 포함되어 있다. 내장 문서 도움말은 인터랙티브 모드의 R
인터프리터에서 볼 수 있다.

### 도움말 파일 읽어오기

R과 모든 팩키지는 함수에 대한 도움말 파일을 제공한다.
네임스페이스(인터랙티브 R 세션)에 적재된 팩키지에 있는 특정 함수에 대한 도움말은 다음과 같이 찾는다:


```r
?function_name
help(function_name)
```

RStudio에 도움말 페이지에 도움말이 표시된다. (혹은 R 자체로 일반 텍스트로 표시된다)

각 도움말 페이지는 절(section)로 구분된다:

 - 기술(Description): 함수가 어떤 작업을 수행하는가에 대한 충분한 기술
 - 사용법(Usage): 함수 인자와 기본디폴트 설정값
 - 인자(Arguments): 각 인자가 예상하는 데이터 설명 
 - 상세 설명(Details): 알고 있어야 되는 중요한 구체적인 설명
 - 값(Value): 함수가 반환하는 데이터
 - 함께 보기(See Also): 유용할 수 있는 연관된 함수.
 - 예제(Examples): 함수 사용법에 대한 예제들.

함수마다 상이한 절을 갖추고 있다.
하지만, 상기 항목이 알고 있어야 하는 핵심 내용이다.


::: {#regex-help .rmdcaution}

**꿀팁: 도움말 파일 불러 읽어오기** 

R에 대해 가장 기죽게 되는 한 측면이 엄청난 함수 갯수다.
모든 함수에 대한 올바른 사용법을 기억하지 못하면,
엄두가 나지 않을 것이다.
운좋게도, 도움말 파일로 인해 기억할 필요가 없다!

:::

### 특수 연산자

특수 연산자에 대한 도움말을 찾으려면, 인용부호를 사용한다:


```r
?"<-"
```

### 팩키지 도움말 얻기

많은 팩키지에 "소품문(vignettes)"이 따라온다: 활용법과 풍부한 예제를 담은 문서.
어떤 인자도 없이, `vignette()` 명령어를 입력하면 설치된 모든 팩키지에 대한 
모든 소품문 목록이 출력된다;
`vignette(package="package-name")` 명령어는 `package-name` 팩키지명에 대한
이용가능한 모든 소품문 목록을 출력하고, `vignette("vignette-name")` 
명령어는 특정된 소품문을 연다.

팩키지에 어떤 소품문도 포함되지 않는다면, 일반적으로 
`help("package-name")` 명령어를 타이핑해서 도움말을 얻는다.

### 함수가 기억나지 않을 때

함수가 어느 팩키지에 있는지 확신을 못하거나, 구체적인 철자법을 모르는 경우,
퍼지 검색(fuzzy search)을 실행한다:


```r
??function_name
```

### 시작조차 난감할 때

어떤 함수 혹은 팩키지가 필요한지 모르는 경우,
[CRAN Task Views](http://cran.at.r-project.org/web/views) 사이트가 
좋은 시작점이 된다. 유지관리되는 팩키지 목록이 필드로 묶여 잘 정리되어 있다.

### 코드가 동작하지 않을 때

동료로부터 도움을 구해 코드가 동작하지 않는 이슈를 해결한다.
함수 사용에 어려움이 있는 경우, 10 에 9 경우에 찾는 정답이
이미 [Stack Overflow](http://stackoverflow.com/)에 답글이 달려 있다.
검색할 때 `[r]` 태그를 사용한다:


원하는 답을 찾지 못한 경우, 동료에게 질문을 만드는데 몇가지 유용한 함수가 있다:



```r
?dput
```

`dput()` 함수는 작업하고 있는 데이터를 텍스트 파일 형식으로 덤프해서 저장한다.
그래서 다른 사람 R 세션으로 복사해서 붙여넣기 좋게 돕는다.



```r
sessionInfo()
```

```
## R version 4.1.3 (2022-03-10)
## Platform: x86_64-apple-darwin20.6.0 (64-bit)
## Running under: macOS Big Sur 11.3.1
## 
## Matrix products: default
## BLAS:   /usr/local/Cellar/openblas/0.3.20/lib/libopenblasp-r0.3.20.dylib
## LAPACK: /usr/local/Cellar/r/4.1.3/lib/R/lib/libRlapack.dylib
## 
## locale:
## [1] ko_KR.UTF-8/ko_KR.UTF-8/ko_KR.UTF-8/C/ko_KR.UTF-8/ko_KR.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] forcats_0.5.1   stringr_1.4.0   dplyr_1.0.7     purrr_0.3.4    
##  [5] readr_2.1.1     tidyr_1.1.4     tibble_3.1.6    ggplot2_3.3.5  
##  [9] tidyverse_1.3.1 DBI_1.1.1      
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.7       lubridate_1.8.0  assertthat_0.2.1 digest_0.6.29   
##  [5] utf8_1.2.2       R6_2.5.1         cellranger_1.1.0 backports_1.4.0 
##  [9] reprex_2.0.1     RSQLite_2.2.12   evaluate_0.14    httr_1.4.2      
## [13] pillar_1.7.0     rlang_1.0.2      readxl_1.3.1     rstudioapi_0.13 
## [17] blob_1.2.2       jquerylib_0.1.4  rmarkdown_2.11   bit_4.0.4       
## [21] munsell_0.5.0    broom_0.7.10     compiler_4.1.3   modelr_0.1.8    
## [25] xfun_0.28        pkgconfig_2.0.3  htmltools_0.5.2  downlit_0.4.0   
## [29] tidyselect_1.1.1 bookdown_0.24    fansi_1.0.2      crayon_1.5.0    
## [33] tzdb_0.2.0       dbplyr_2.1.1     withr_2.4.3      grid_4.1.3      
## [37] jsonlite_1.7.2   gtable_0.3.0     lifecycle_1.0.1  magrittr_2.0.2  
## [41] scales_1.1.1     vroom_1.5.7      cli_3.2.0        stringi_1.7.6   
## [45] cachem_1.0.6     fs_1.5.1         xml2_1.3.3       bslib_0.3.1     
## [49] ellipsis_0.3.2   generics_0.1.1   vctrs_0.3.8      tools_4.1.3     
## [53] bit64_4.0.5      glue_1.6.2       hms_1.1.1        parallel_4.1.3  
## [57] fastmap_1.1.0    yaml_2.2.1       colorspace_2.0-2 rvest_1.0.2     
## [61] memoise_2.0.1    knitr_1.36       haven_2.4.3      sass_0.4.0
```

`sessionInfo()`는 R 현재 버젼 정보과 함께 적재된 팩키지 정보를 출력한다.
이 정보가 다른 사람이 여러분 문제를 재현하고 디버그하는데 유용할 수 있다.


## 용어정의 {#r-regex-terminology}

- **부서지기 쉬운 코드(brittle code)**:입력 데이터가 특정한 형식일 경우에만 작동하는 코드. 하지만 올바른
    형식에서 약간이도 벗아나게 되면 깨지기 쉽니다. 쉽게 부서지기 때문에
    "부서지기 쉬운 코드(brittle code)"라고 부른다.
- **욕심쟁이 매칭(greedy matching)**:정규 표현식의 "+", "\*" 문자는 가능한 큰 문자열을 매칭하기 위해서 밖으로 확장하는 개념.
- **grep**: 정규 표현식에 매칭되는 파일을 탐색하여 라인을 찾는데 대부분의 유닉스
    시스템에서 사용가능한 명령어. \"Generalized Regular Expression
    Parser\"의 약자.
- **정규 표현식(regular expression)**: 좀더 복잡한 검색 문자열을 표현하는 언어. 정규 표현식은 특수 문자를 포함해서 검색 라인의 처음 혹은 끝만 매칭하거나 많은 비슷한 것을
    매칭한다.
- **와일드 카드(wild card)**: 임의 문자를 매칭하는 특수 문자. 정규 표현식에서 와이드 카드 문자는 마침표 문자다.

## 연습문제 {#r-regex-ex}

1. 유닉스의 `grep` 명령어를 모사하는 간단한 프로그램을 작성하세요. 사용자가
정규 표현식을 입력하고 정규 표현식에 매칭되는 라인수를 셈하는
프로그램입니다.

```
    $ Rscript grep.R
    Enter a regular expression: ^Author
    mbox.txt had 1798 lines that matched ^Author

    $ Rscript grep.R
    Enter a regular expression: ^X-
    mbox.txt had 14368 lines that matched ^X-

    $ Rscript grep.R
    Enter a regular expression: java$
    mbox.txt had 4218 lines that matched java$
```

2. 다음 형식의 라인만을 찾는 프로그램을 작성하세요.

```
`New Revision: 39772`
```

그리고, 정규 표현식과 `str_extract()` 함수를 사용하여 각 라인으로부터
숫자를 추출하세요. 숫자들의 평균을 구하고 출력하세요.

```
    Enter file:mbox.txt 
    38549.7949721

    Enter file:mbox-short.txt
    39756.9259259
```
