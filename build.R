roxygen2md::roxygen2md()

library(roxygen2)
roxygen2::roxygenise()

#devtools::test()

devtools::document()

devtools::check()

devtools::check_rhub()

###
#knit README

pkgdown::build_site()


##
# devtools::build()
