## Test Environments

* Local: Windows, R version 3.6.1

## R CMD check results (2020-04-25)

### devtools::check() locally:
0 errors | 0 warnings | 0 notes

### devtools::check_rhub()
0 errors | 0 warnings | 1 notes

NOTES:
removed vignittes in the build (by adding to `.Rbuildignore`) and removed `VignetteBuilder: knitr` in the `DESCRIPTION` field.

```
  Maintainer: 'Paul Julian <pauljulianphd@gmail.com>'
  New submission
```

### devtools::check_win_devel()
0 errors | 0 warnings | 1 notes


## CRAN comments (2020-04-30)

```
Please omit the redundant "in R" from the package title.

Please make sure that you do not change the user's options, par or working directory. If you really have to do so within functions, please ensure with an *immediate* call of on.exit() that the settings are reset when the function is exited. e.g.:
...
oldpar <- par(no.readonly = TRUE)       # code line i
on.exit(par(oldpar))                    # code line i + 1
...
par(mfrow=c(2,2))                       # somewhere after
...
If you're not familiar with the function, please check ?on.exit. This function makes it possible to restore options before exiting a function even if the function breaks. Therefore it needs to be called immediately after the option change within a function.

Please fix and resubmit.

```

```
  The Date field is over a month old
```

Notes upon re-submission
This is a re-submission. Based on comments from reviewer "in R" was removed from the description file, on.exit(...) was added to restore user's options and date in DESCRIPTION files was updated.

