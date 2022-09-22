#hashtags <- c('nature', 'land scape')
find_profiles_by_tags <- function(hashtags) {
  wait_for_page_to_load()

  if(class(hashtags) != 'character') stop(paste0('The variable "hashtags" must be a character vector but instead ',
                                                 class(hashtags), ' provided'))

  if(length(hashtags) > 1) {
    tag <- hashtags[sample(1:length(hashtags), 1)]
  } else {
    tag <- hashtags
  }

  if(stringr::str_detect(tag, ' ')) stop('The hasthtags are not allowed to contain spaces \n',
                                         paste0("Problems with the hashtag '", tag, "'."))

  tag <- gsub('^#', '', tag)
  print(paste0('Finding a random profile with the hashtag ', tag, '...'))

  url <- paste0('https://www.instagram.com/explore/tags/', tag, '/')
  .srapegram[['remDr']]$navigate(url)

  image_elements <- get_website_element(using = 'xpath',
                                        value = '//article//descendant::a//descendant::img',
                                        mendatory = TRUE)
  .srapegram[['remDr']]$mouseMoveToLocation(webElement = image_elements[[1]])
  random_sleep(0.2, 0.5)
  .srapegram[['remDr']]$click()
}
