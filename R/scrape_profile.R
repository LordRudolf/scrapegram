scrape_profile <- function(profile_name = NULL) {
  if(!is.null(profile_name)) {
    open_profile(profile_name)
  }

  outcome <- list()

  outcome$scrapped_at <- Sys.time()
  outcome$instagram_url <- .srapegram[['remDr']]$getCurrentUrl()[[1]]
  outcome$instagram_profile_name <- gsub('.{1}$', '', gsub('.*.com/', '', outcome$instagram_url))

  header_info <-  .srapegram[['remDr']]$findElements(using = 'xpath', value = "//header//section//ul//li//div")
  header_info <- lapply(header_info, function(x) x$getElementText())
  header_info <- unlist(header_info)

  outcome$number_of_posts <- as.numeric(gsub('\\D', '', header_info[stringr::str_detect(header_info, 'post')]))
  outcome$number_of_followers <- as.numeric(gsub('\\D', '', header_info[stringr::str_detect(header_info, 'followers')]))
  outcome$number_of_following <- as.numeric(gsub('\\D', '', header_info[stringr::str_detect(header_info, 'following')]))

  return(outcome)
}
