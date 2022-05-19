
---
output: html_document
editor_options: 
  chunk_output_type: console
---



# 작업 자동화 {#r-automation}

파일, 네트워크, 서비스, 그리고 데이터베이스에서 데이터를 읽어왔다.
R은 또한 여러분의 로컬 컴퓨터 디렉토리와 폴더를 훑어서 파일도
읽어온다.

이번 장에서, 여러분의 로컬 컴퓨터를 스캔하고 각 파일에 대해서 연산을
수행하는 프로그램을 작성한다. 파일은 디렉토리(또한 "폴더"라고도
부른다.)에 정렬되어 보관된다. 간단한 R 스크립트로 전체 로컬
컴퓨터나 디렉토리 여기저기 뒤져야 찾아지는 수백 수천개 파일에 대한
단순한 작업을 짧게 수행한다.

트리상의 디렉토리나 파일을 여기저기 돌아다니기 위해서 `os.walk`과 `for`
루프를 사용한다. `open`이 파일 콘텐츠를 읽는 루프를 작성하는 것과
비슷하게, `socket`은 네트워크 연결된 콘텐츠를 읽는 루프를 작성하고,
`urllib`는 웹문서를 열어 콘텐츠를 루프를 통해서 읽어오게 한다.

## 파일 이름과 경로 {#r-paths}

모든 실행 프로그램은 "현재 디렉토리(current directory)"를 가지고 있는데
작업 대부분을 수행하는 디폴트 디렉토리가 된다. 예를 들어, 읽기 위해서
파일을 연다면, R은 현재 디렉토리에서 파일을 찾는다.

`libuv` C 라이브러리에 기반한 [`fs`](https://cran.r-project.org/web/packages/fs/index.html) 
패키지는 파일과 디렉토리를 작업하는 함수를 제공한다. 
`path_wd()` 함수는 현재 디렉토리 이름을 반환한다.



```r
library(fs)

cwd <- fs::path_wd()
# C:/swc/book_programming
```

`cwd` 는 **current working directory**의 약자로 현재 작업 디렉토리다.
예제의 결과는 `C:/swc/book_programming`인데 
현재 작성중인 전자책 `book_programming` 의 홈 디렉토리가 된다.

파일을 식별하는 `cwd` 같은 문자열을 경로(path)라고 부른다.
**상대경로(relative path)**는 현재 디렉토리에서 시작하고,
**절대경로(absolute path)**는 파일 시스템의 가장 최상단의 디렉토리에서
시작한다.

지금까지 살펴본 경로는 간단한 파일 이름이여서, 현재 디렉토리에서
상대적이다. 파일의 절대 경로를 알아내기 위해서 `fs::path_abs()` 함수를
사용한다.


```r
fs::path_abs("index.Rmd")
C:/swc/book_programming/index.Rmd
```

`dir_exists`는 디렉토리, `file_exists`는 파일이 존재하는지 검사한다.


```r
fs::dir_exists("data")
```

```
data  
TRUE
```


```r
fs::file_exists("index.Rmd")
```

```
index.Rmd 
TRUE 
```


`dir_ls()` 함수는 은 주어진 디렉토리에 파일 리스트(그리고 다른 디렉토리)를
반환한다.


```r
fs::dir_ls()
```

```
00-why.Rmd             01-intro.Rmd           02-var.Rmd             03-cont.Rmd            04-func.Rmd            
05-loop.Rmd            06-string.Rmd          07-file.Rmd            08-list.Rmd            09-dictionaries.Rmd    
10-tuples.Rmd          11-regex.Rmd           12-database.Rmd        13-web.Rmd             14-tasks.Rmd           
assets                 book.bib               book_programming.rds   book_programming.Rproj data                   
DESCRIPTION            Dockerfile             docs                   index.Rmd              LICENSE                
now.json               packages.bib           preamble.tex           README.md              references.Rmd         
script                 style.css              toc.css                _bookdown.yml          _bookdown_files        
_build.sh              _common.R              _deploy.sh             _output.yml            _publish.R      
```


## 명령 줄 인자 [^R-scripts] [^RScript-kor] {#tasks-commandline}

[^R-scripts]: [R scripts](http://www.r-bloggers.com/r-scripts/)

[^RScript-kor]: [.R 스크립트를 인자와 함께 실행](http://statkclee.github.io/parallel-r/r-parallel-rscript-exec.html)

![R 스크핍트 실행](assets/images/parallel-r-script-exec.png){width=100%}
명령라인 인터페이스에서 R 스크립트를 실행하고 다양한 R 스크립트 실행방법을 살펴보자.
먼저, 유닉스/리눅스/윈도우 운영체제가 준비되었다면 R스크립트 실행환경을 준비한다.

### R 설치 {#install-r}

R을 스크립트 형태(`.R`) 파일로 실행할 경우 가장 먼저 `r-base-core`를 설치한다. 
그래픽 사용자 인터페이스가 없는 형태의 R이 설치되며 R 스크립트 실행에 필요한 
연관된 프로그램도 더불어 설치한다.

```
$ sudo apt-get install -y r-base-core
```

### R 스크립트 실행환경 {#install-env} 

R과 스크립트를 실행할 `Rscript` 실행프로그램이 위치한 디렉토리를 확인한다. 
여기에 사용되는 명령어는 `which`다.
`which R` 명령어를 통해 R 실행파일이 `/usr/bin/` 디렉토리에 위치한 것을 확인할 수 있다.

```
$ which R
/usr/bin/R
```

`which Rscript` 명령어를 통해 Rcript 실행파일도 
`/usr/bin/` 디렉토리에 위치한 것을 확인할 수 있다.

```
$ which Rscript
/usr/bin/Rscript
```

`echo $PATH` 명령어를 통해 `/usr/bin`, 경우에 따라서는 `/usr/local/bin` 
디렉토리에 R과 Rscript 실행파일이 존재하는 것을 확인한다.

```
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
```

### R 스크립트 파일 실행 {#exec-rscript} 

`.R` 스크립트 파일을 명령라인 인터페이스로 실행하는 방법은 다양한다. 
먼저 `hello_world.R` 스크립트 파일을 생성한다.

```
#! /usr/bin/env Rscript

print("Hello World!!!")
```

쉬뱅(shebang, #!) 다음에 스크립트를 실행할 프로그램을 지정한다. 
`Rscript`로 지정하여 R스크립트를 실행하는데 사용한다.

`#! /usr/bin/env Rscript`

```
$ chmod +x hello_world.R
$ ./hello_world.R
```

`chmod +x` 명령어를 통해서 일반 텍스트 파일을 실행가능한 
파일 형식으로 지정한다.
`hello_world.R` 파일이 실행가능한 형태가 되었기 때문에 
`./hello_world.R` 명령어로 R스크립트를 실행시킨다.

```
Hello World!!!
```

### 다른 R 스크립트 파일 실행법 {#exec-run-other-ways}

R스크립트를 실행하는 방법은 다양하다.

```
$ R --slave -f hello_world.R
$ Rscript hello_world.R
```

`Rscript` 명령어로 실행을 시켜도 동일한 산출 결과가 출력된다.

```
$ R CMD BATCH hello_world.R hello_world_output.txt
```

`R CMD BATCH` 명령어로 실행시키면 실행결과가 `hello_world_output.txt` 파일에 저장된다. `hello_world_output.txt` 파일명을 지정하지 않으면 `hello_world.Rout` 파일에 저장된다.

```
$ R --no-save << RSCRIPT
     print("Hello World")
  RSCRIPT
```

`R --no-save <<` 사용법도 가능하다.

## 실습 사례 [^swcarpentry-r-cmd] {#tasks-swcarpentry}

[^swcarpentry-r-cmd]: [R프로그래밍 - 명령-라인 프로그램](http://statkclee.github.io/r-novice-inflammation/05-cmdline-kr.html)

### R스크립트 작성 {#make-rscript}

`Rscript r_session_info.R` 명령어를 실행해서 
실제로 RStudio나 R 콘솔을 열지 않고도 R 세션정보를 명령라인 인터페이스에서 처리하는 R 스크립트를 작성한다.

텍스트 편집기를 열고, `sessionInfo()`를 적고 파일명을 `r_session_info.R`로 저장한다.


```r
sessionInfo()
```

배쉬쉘에서 R스크립트를 실행해서 R 세션정보를 받아확인한다.


```shell
$ Rscript r_session_info.R
```

```
R version 3.0.2 (2013-09-25)
Platform: x86_64-pc-linux-gnu (64-bit)

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C
 [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8
 [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8
 [7] LC_PAPER=en_US.UTF-8       LC_NAME=C
 [9] LC_ADDRESS=C               LC_TELEPHONE=C
[11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C

attached base packages:
[1] stats     graphics  grDevices utils     datasets  base
```

### R스크립트 출력결과 파일저장 {#sessionInfo-save}

`>` 파이프 연산자를 사용해서 R 스크립트 출력결과를 텍스트 파일로 저장한다.


```shell
$ Rscript r_session_info.R > r_session_info_pipe_output.txt
```

또다른 방법은 R 스크립트 내부에서 출력결과를 파일에 저장하고 
프로그램을 종료하는 방법도 있다.

`caputre.output` 함수를 `cat`과 함께 사용하는데, 
한글도 적용이 가능하도록, `encoding="UTF-8"`도 추가한다.


```r
output <- capture.output(sessionInfo())
cat("R 세션정보", output, file="./r_session_info_rscript.txt", sep="\n", encoding="UTF-8")
```

`Rscript r_session_info.R` 명령어를 실행시키면 다음과 같이 실행결과가 텍스트 파일 `r_session_info_rscript.txt`로 떨어진다.

```
R 세션정보
R version 3.0.2 (2013-09-25)
Platform: x86_64-pc-linux-gnu (64-bit)

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C
 [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8
 [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8
 [7] LC_PAPER=en_US.UTF-8       LC_NAME=C
 [9] LC_ADDRESS=C               LC_TELEPHONE=C
[11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C

attached base packages:
[1] stats     graphics  grDevices utils     datasets  base
UTF-8
```

## 자동화 사례: 국가별 통계 {#task-args}

`.R` 스크립트를 유닉스/리눅스상에서 유연하게 동작시킨다.
R 스크립트를 수정하지 않고, 인자를 바꿔 작업을 수행하는 방법을 살펴보자.
국가별 통계를 데이터 파일을 달리하여 R스크립트 통계량을 산출하는 방법을 
사례로 구현해보자.

![R 스크립트 실행](assets/images/parallel-r-args.png){width=100%}

### 인자를 받는 R 스크립트 {#task-args-rscript}

유닉스/GNU리눅스 환경에서 통계모형, 기계학습, 딥러닝 작업을 하게 되면 텍스트 형태 데이터, R스크립트, 출력 산출물을 갖게 되고, 입력 데이터를 출력산출물로 변환시키는데 R이 역할을 하게 된다.

R 스크립트를 유연하게 만들게 되면 데이터만 바꿔도 산출물을 생성해 내고, 경우에 따라 인자값을 달리하면 원하는 다른 결과를 얻게 된다.


### 데이터 변경 R 스크립트 {#task-rscript-gdp}

[SOME TIME SERIES DATA SETS](http://www2.stat.duke.edu/~mw/ts_data_sets.html)에서 [Per capita annual GDP for several countries during 1950-1983 (first row is 1950, last is 1983) ](http://www2.stat.duke.edu/~mw/data-sets/ts_data/gdp) 데이터를 사용한다. 데이터를 `austria.csv`, `canada.csv`, `france.csv`와 같이 구분하여 저장한다.

#### R 스크립트 시제품 제작 {#rscript-prototype}

먼저 `austria.csv` 파일을 불러와서 평균을 계산하는 R스크립트를 작성한다. 


```r
# 데이터 불러오기
gdp.df <- read.csv("austria.csv", sep=",", head=FALSE)
# 평균계산
gdp.mean <- mean(gdp.df$V1)
# 계산결과 화면출력
cat("평균: ", gdp.mean, "\n", encoding="utf-8")
```

`Rscript r-args-ex01.R` 실행결과 예상대로 평균 GDP가 계산되었다.

```
$ Rscript r-args-ex01.R
평균:  0.06553276
```

#### 입력파일 변경 R스크립트 실행 {#rscript-change-data-file}

국가가 더 많을 수도 있지만, `austria.csv`, `france.csv`, `canada.csv` 3개 국가가 csv 파일로 데이터가 저장되어 있으니, 입력파일을 달리하여 평균을 계산하도록 R스크립트를 작성한다.

`commandArgs` 명령어를 통해 명령라인에서 인자를 받아 온다. 인자가 순서대로 들어오기 때문에 첫번째 인자로 들어오는 국가에 대한 GDP 평균을 구하고, 이를 화면에 출력하는 R스크립트다. `strsplit` 함수를 사용해서 파일명 앞쪽 -- `.csv` 확장자 제거 -- 만을 뽑아내어 국가명을 명기했다.


```r
#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
country <- args[1]

# 데이터 불러오기
gdp.df <- read.csv(country, sep=",", head=FALSE)
# 평균계산
gdp.mean <- mean(gdp.df$V1)
# 계산결과 화면출력
cat(strsplit(country, '\\.')[[1]][1], "평균: ", gdp.mean, "\n", encoding="utf-8")
```


상기 R스크립트를 쉘에서 실행한 결과는 다음과 같다.

```
$ Rscript r-args-ex02.R  austria.csv
austria 평균:  0.06553276
$ Rscript r-args-ex02.R france.csv
france 평균:  20.95751
$ Rscript r-args-ex02.R canada.csv
canada 평균:  5.817088
```

#### 국가별 기본통계 계산 {#task-stat-by-countries}

국가 데이터를 바꾸는 것에 더해서 최소, 평균, 최대 GDP를 계산하는 로직을 추가한다.
`commandArgs` 함수로 인자를 받는데, 최종 인자는 `-1`로 지정되기 때문에 그런 특성을 이용하여 R스크립트를 작성한다.
따라서, 첫번째 인자에 최소, 평균, 최소를 구할 것인지 정보를 받고, 마지막 인자로 파일명을 받는다. 


```r
#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
action = args[1]
country <- args[-1]

# 데이터 불러오기
gdp.df <- read.csv(country, sep=",", head=FALSE)
# 기초 통계량 계산

if(action == "--min") {
    gdp.min <- min(gdp.df$V1)
    cat(strsplit(country, '\\.')[[1]][1], "최소: ", gdp.min, "\n", encoding="utf-8")
}else if(action == "--mean") {
    gdp.mean <- mean(gdp.df$V1)
    cat(strsplit(country, '\\.')[[1]][1], "평균: ", gdp.mean, "\n", encoding="utf-8")
}else if (action=="--max"){
    gdp.max <- max(gdp.df$V1)
    cat(strsplit(country, '\\.')[[1]][1], "최대: ", gdp.max, "\n", encoding="utf-8")
}
```

`Rscript r-args-ex03.R --min canada.csv` 명령라인을 살펴보면, `r-args-ex03.R` R 스크립트를 실행하고, `--min` 인자로 최소값을 계산하는데, `canada.csv` 데이터 파일을 이용한다. 

```
$ Rscript r-args-ex03.R --min canada.csv
canada 최소:  3.651109
$ Rscript r-args-ex03.R --max canada.csv
canada 최대:  8.382785
$ Rscript r-args-ex03.R --mean canada.csv
canada 평균:  5.817088
```

::: {#rscript-passing .rmdcaution}

**R 스크립트에 인자를 넘기는 패키지**

* [commandArgs](https://stat.ethz.ch/R-manual/R-devel/library/base/html/commandArgs.html)
* [optparse - Command Line Option Parser](https://cran.r-project.org/web/packages/optparse/index.html)
* [argparse - Command line optional and positional argument parser](https://cran.r-project.org/web/packages/argparse/index.html)
* [getopt - C-like getopt behavior](https://cran.r-project.org/web/packages/getopt/)

:::

## 파이프(Pipes) {#tasks-pipe}

대부분의 운영 시스템은 **쉘(shell)**로 알려진 명령어 기반 인터페이스를
지원한다. 일반적으로 쉘은 파일 시스템을 탐색하거나 응용 프로그램을
실행하는 명령어를 지원한다. 예를 들어, 유닉스에서 `cd` 명령어로
디렉토리를 변경하고 `ls` 명령어로 디렉토리의 콘텐츠를 보여주고,
`firefox`를 타이핑해서 웹브라우져를 실행한다.

쉘에서 실행시킬 수 있는 어떤 프로그램이나 **파이프(pipe)**를 사용하여
파이썬에서도 실행시킬 수 있다. 파이프는 작동중인 프로세스를 표현하는
객체다.

예를 들어, 유닉스 명령어[^unix-ls] `ls -l`는 정상적으로 현재 디렉토리의
콘텐츠(긴 형식으로)를 보여준다. `system2()` 내장함수, 혹은 
[`processx`](https://cran.r-project.org/web/packages/processx/index.html), 
[`sys`](https://cran.r-project.org/web/packages/sys/index.html) 패키지를
가지고 `ls` 를 실행시킬 수 있다.

[^unix-ls]: 파이프를 사용하여 `ls` 같은 운영 시스템 명령어로 대화할 때, 무슨
    운영 시스템을 사용하는지 알고 운영 시스템에서 지원되는 명령어로
    파이프를 열수 있다는 것이 중요하다.


```r
system2("ls", "-l", stdout = TRUE, stderr = TRUE)
```

```
 [1] "total 960"                                                                
 [2] "-rw-r--r--   1 tidyverse  staff  16280  5 18 10:26 00-why.Rmd"            
 [3] "-rw-r--r--   1 tidyverse  staff  44481  5 18 10:26 01-intro.Rmd"          
 [4] "-rw-r--r--   1 tidyverse  staff  25092  5 18 10:26 02-var.Rmd"            
 [5] "-rw-r--r--   1 tidyverse  staff  20041  5 18 10:26 03-cont.Rmd"           
 [6] "-rw-r--r--   1 tidyverse  staff  24862  5 18 10:26 04-func.Rmd"           
 [7] "-rw-r--r--   1 tidyverse  staff  19254  5 18 10:26 05-loop.Rmd"           
 [8] "-rw-r--r--   1 tidyverse  staff  19007  5 18 10:26 06-string.Rmd"         
 [9] "-rw-r--r--   1 tidyverse  staff  26301  5 18 10:26 07-file.Rmd"           
[10] "-rw-r--r--   1 tidyverse  staff  27648  5 18 10:26 08-list.Rmd"           
[11] "-rw-r--r--   1 tidyverse  staff  22463  5 18 10:26 09-dictionaries.Rmd"   
[12] "-rw-r--r--   1 tidyverse  staff  12085  5 18 10:26 10-tuples.Rmd"         
[13] "-rw-r--r--   1 tidyverse  staff  30744  5 18 12:42 11-regex.Rmd"          
[14] "-rw-r--r--   1 tidyverse  staff  36390  5 19 11:15 12-database.Rmd"       
[15] "-rw-r--r--   1 tidyverse  staff  18931  5 19 11:15 13-web.Rmd"            
[16] "-rw-r--r--   1 tidyverse  staff  32936  5 19 12:19 14-tasks.Rmd"          
[17] "-rw-r--r--   1 tidyverse  staff    115  5 18 10:26 DESCRIPTION"           
[18] "-rw-r--r--   1 tidyverse  staff    150  5 18 10:26 Dockerfile"            
[19] "-rw-r--r--   1 tidyverse  staff   6556  5 18 10:26 LICENSE"               
[20] "-rw-r--r--   1 tidyverse  staff    741  5 18 10:26 README.md"             
[21] "-rw-r--r--   1 tidyverse  staff    671  5 19 11:15 _bookdown.yml"         
[22] "-rw-r--r--   1 tidyverse  staff    235  5 18 10:26 _build.sh"             
[23] "-rw-r--r--   1 tidyverse  staff    842  5 18 10:26 _common.R"             
[24] "-rwxr-xr-x   1 tidyverse  staff    398  5 18 10:26 _deploy.sh"            
[25] "-rw-r--r--   1 tidyverse  staff    360  5 18 10:26 _output.yml"           
[26] "-rw-r--r--   1 tidyverse  staff   1427  5 18 10:26 _publish.R"            
[27] "drwxr-xr-x   4 tidyverse  staff    128  5 18 14:45 assets"                
[28] "-rw-r--r--   1 tidyverse  staff   3203  5 18 10:26 book.bib"              
[29] "-rw-r--r--   1 tidyverse  staff    277  5 18 10:26 book_programming.Rproj"
[30] "-rw-r--r--   1 tidyverse  staff    208  5 19 12:10 book_programming.rds"  
[31] "drwxr-xr-x  10 tidyverse  staff    320  5 18 14:04 data"                  
[32] "drwxr-xr-x  48 tidyverse  staff   1536  5 19 12:10 docs"                  
[33] "-rw-r--r--   1 tidyverse  staff   6272  5 18 10:26 index.Rmd"             
[34] "-rw-r--r--   1 tidyverse  staff     41  5 18 10:26 now.json"              
[35] "-rw-r--r--   1 tidyverse  staff   2655  5 18 10:26 packages.bib"          
[36] "-rw-r--r--   1 tidyverse  staff    161  5 18 10:26 preamble.tex"          
[37] "-rw-r--r--   1 tidyverse  staff     55  5 18 10:26 references.Rmd"        
[38] "drwxr-xr-x   4 tidyverse  staff    128  5 18 10:26 script"                
[39] "-rw-r--r--   1 tidyverse  staff    172  5 18 10:26 style.css"             
[40] "-rw-r--r--   1 tidyverse  staff   2443  5 18 10:26 toc.css"   
```

인자는 쉘 명령어를 포함하는 문자열이다. 

### 유닉스 철학과 파이프 {#tasks-pipe-unix}

![R 파이프라인](assets/images/parallel-r-pipeline.png){width=100%}

통계 예측모형, 기계학습, 딥러닝 시스템을 개발할 경우 유닉스/리눅스 운영체제로 환경을 통일하고 텍스트 파일을 모든 프로그램과 시스템이 의사소통하는 기본 인터페이스로 잡고, 이를 파이프로 연결한다.

1. 텍스트 데이터로 분석에 사용될 혹은 훈련데이터로 준비한다.
1. 파이썬 혹은 쉘스크립트, R스크립트를 활용하여 전처리한다.
1. R `tidymodels` 혹은 파이썬 `Scikit-learn` 예측모형을 적합, 기계학습 훈련, 시각화를 수행한다.
1. 마크다운(웹), LaTeX(조판) 출력형식에 맞춰 서식을 결정한다.
1. 최종 결과를 텍스트, 이미지 파일, pdf, html로 출력한다.


```shell
$ cat data.txt | preProcesswithPython.py | runModelwithR.R | formatOutput.sh > mlOutput.txt
```

::: {#unix-philosophy .rmdcaution}

**[유닉스 철학](https://en.wikipedia.org/wiki/Unix_philosophy)**

[원문] Write programs that do one thing and do it well. Write programs to work together. Write programs to handle text streams, because that is a universal interface. -- Doug McIlroy
 
* 한가지 작업만 매우 잘하는 프로그램을 작성한다(Write programs that do one thing and do it well)
* 프로그램이 함께 동작하도록 작성한다(Write programs to work together)
* 텍스트를 다루는 프로그램을 작성한다. 이유는 어디서나 사용되는 인터페이스가 되기 때문이다(Write programs to handle text streams, because that is a universal interface)

:::


## 용어정의 {#tasks-terminology}


- **절대경로(absolute path)**:
    파일이나 디렉토리가 어디에 저장되어 있는지를 저장하는 문자열로
    "최상단의 디렉토리"에서 시작해서, 현재 작업 디렉토리에 관계없이
    파일이나 디렉토리를 접근하는데 사용할 수 있다.
- **체크썸(checksum)**: 
    **해싱(hashing)**을 참조하세요. "체크썸(checksum)"단어는 네트워크로
    데이터가 보내지거나 백업 매체에 쓰여지고 다시 읽어올 때, 데이터가
    왜곡되었는지를 검증하는 필요에서 생겨났다. 데이터가 쓰여지거나
    보내질 때, 송신 시스템은 체크썸을 계산하고 또한 체크썸도 보낸다.
    데이터가 읽혀지거나 받았을 때, 수신 시스템을 수신된 데이터의
    체크썸을 다시 계산하고 받은 체크썸과 비교한다. 만약 체크썸이
    매칭되지 않으면, 전송 시에 데이터가 왜곡된 것으로 판단해야 한다.
- **명령 줄 인자(command line argument)**:
    파이썬 파일 이름 뒤에 명령 줄에 매개 변수.
- **현재 작업 디렉토리(current working directory)**:
    여러분이 "작업하고 있는" 현재 디렉토리. 명령-줄 인터페이스에서
    대부분의 시스템에 `cd` 명령어를 사용하여 작업 디렉토리를 변경할 수
    있다. 경로 정보 없이 파일만을 사용하여 파이썬에서 파일을 열게 될 때,
    파일은 프로그램을 실행하고 있는현재 작업 디렉토리에 있어야 한다.
- **해싱(hashing)**:
    가능한 큰 데이터를 읽고 그 데이터에 대해서 유일한 체크썸을 생성하는
    것. 최고의 해쉬 함수는 거의 "충돌(collision)"을 만들지 않는다.
    여기서 충돌은 서로 다른 두 데이터 스트림에 해쉬 함수를 줄 때 동일한
    해쉬값을 돌려받는 것이다. MD5, SHA1, SHA256 는 가장 많이 사용되는
    해쉬 함수의 사례다.
- **파이프(pipe)**:
    파이프는 실행하는 프로그램에 연결이다. 파이프를 사용해서, 데이터를
    다른 프로그램에 보내거나 그 프로그램에서 데이터를 받는 프로그램을
    작성할 수 있다. 파이프는 **소켓(socket)**과 매우 유사하다. 차이점은
    파이프는 동일한 컴퓨터에서 실행되는 프로그램을 연결하는데만
    사용된다는 것이다. (즉, 네트워크를 통해서는 사용할 수 없다.)
- **상대경로(relative path)**:
    파일 혹은 디렉토리가 어디에 저장되었는지를 현재 작업 디렉토리에
    상대적으로 표현하는 문자열.
- **쉘(shell)**: 
    운영 시스템에 명령줄 인터페이스. 다른 시스템에서는 또한 "터미널
    프로그램(terminal program)"이라고 부른다. 이런 인터페이스에서 라인에
    명령어와 매개 변수를 타입하고 명령을 실행하기 위해서 "엔터(enter)"를
    누른다.
- **워크(walk)**:
    모든 디렉토리를 방문할 때까지 디렉토리, 하위 디렉토리, 하위의 하위
    디렉토리 전체 트리를 방문하는 개념을 나타내기 위해서 사용된 용어.
    여기서 이것을 "디렉토리 트리를 워크"한다고 부른다.

## 연습문제 {#tasks-exercise}

MP3 파일이 대규모로 수집되어 있은 곳에는 같은 노래의 복사본 하나 이상이
다른 디렉토리 혹은 다른 파일 이름으로 저장되어 있을 수 있다. 이번
연습문제의 목표는 이런 중복 파일을 찾는 것이다.

1.  `.mp3`같은 확장자를 가진 파일을 모든 디렉토리와 하위 디렉토리를
    검색해서 동일한 크기를 가진 파일짝을 목록으로 보여주는 프로그램을
    작성하세요. 

2.  **체크썸(checksum)** 알고리즘이나 해싱을 사용하여 중복 콘텐츠를 가진
    파일을 찾는 이전의 프로그램을 개작하세요. 예를 들어, MD5
    (Message-Digest algorithm 5)는 임의적으로 긴 "메시지"를 가지고
    128비트 "체크썸"을 반환한다. 다른 콘텐츠를 가진 두 파일이 같은
    체크썸을 반환할 확률은 매우 적다.

    [wikipedia.org/wiki/Md5](wikipedia.org/wiki/Md5)에서 MD5에 대해서 더
    배울 수 있다. 다음 코드 조각은 파일을 열고, 읽고, 체크썸을 계산한다.

    체크섬을 계산하고 키로 이미 딕셔너리에 있게 되면, 중복 콘텐츠인 두
    파일 있어서 딕셔너리에 파일과 방금전에 읽은 파일을 출력한다. 사진
    파일 폴더에서 실행한 샘플 출력물이 다음에 있다.

```
        ./2004/11/15-11-04_0923001.jpg ./2004/11/15-11-04_1016001.jpg
        ./2005/06/28-06-05_1500001.jpg ./2005/06/28-06-05_1502001.jpg
        ./2006/08/11-08-06_205948_01.jpg ./2006/08/12-08-06_155318_02.jpg
```

    명백하게 때때로 같은 사진을 한번 이상 보내거나 원본을 삭제하지 않고
    종종 사진 사본을 만든다.





