scrape_nickname_only <- function(photos_to_find = 25) {

  wait_for_page_to_load()


  right_arrow <- list(dummy = 'variable')
  counter <- 0

  user_list <- list()

  while(length(right_arrow) == 1) {
    counter <- counter + 1
    image_elements <- get_website_element(using = 'xpath',
                                          value = "(//article)[2]//descendant::img[@style = 'object-fit: cover;']",
                                          mendatory = TRUE,
                                          check_if_video = TRUE)

    if(!any(image_elements == 'VIDEO_FILE')) {

      # Get name of Instagram user
      insta_user <- .srapegram[['remDr']]$findElements(using = 'xpath',
                                                                     value = "//header//descendant::span//a")
      insta_user <- unlist(insta_user[[1]]$getElementText())

      user_list[[length(user_list) + 1]] <-  insta_user

    } # end of image save

    right_arrow <- .srapegram[['remDr']]$findElements(using = 'xpath',
                                                                    value = "//button//div//span[@style ='display: inline-block; transform: rotate(90deg);']")

    #Check stop criteria
    if(counter == photos_to_find) right_arrow <- list()

    if(length(right_arrow) == 1) {
      #go to the next photo
      .srapegram[['remDr']]$mouseMoveToLocation(webElement = right_arrow[[1]])
      .srapegram[['remDr']]$click()
      Sys.sleep(1.5)
      wait_for_page_to_load()
    }
  } #end of while loop

  return(user_list)
}

