open_profile <- function(profile_name) {
  url <- paste0('https://www.instagram.com/', profile_name, '/')
  .srapegram[['remDr']]$navigate(url)
  wait_for_page_to_load()
  random_sleep(2, 2)
}

open_first_image <- function() {
  image_elements <- get_website_element(using = 'xpath',
                                        value = '//article//descendant::a//descendant::img',
                                        mendatory = TRUE)
  .srapegram[['remDr']]$mouseMoveToLocation(webElement = image_elements[[1]])
  random_sleep(0.2, 0.5)
  .srapegram[['remDr']]$click()
  wait_for_page_to_load()
  random_sleep(2, 2)
}
