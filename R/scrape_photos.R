
scrape_photos <- function(path = NULL,
                          folder_name = NULL,
                          max_img_downloads = 300,
                          oldest_photo = 2017) {
  wait_for_page_to_load()

  if(is.null(path)) {
    path <- .srapegram$download_dir
    if(is.null(path)) {
      stop("You haven't provided the download directory path for the scraped images.
           Use the function argument 'path' or define it globally using the function setDir()")
    }
  } else {
    if(!file.exists(path)) stop('The directory does not exist')
  }
  dirCheck(path)

  if(is.null(folder_name)) {
    folder_name <- ''
  } else {
    dir.create(paste0(path, '/images/', folder_name))
  }

  csv_file_name <- paste0(path, '/descriptions/', folder_name, '.csv')
  if(file.exists(csv_file_name)) {
    photo_data <- read.csv(csv_file_name)
  } else {
    photo_data <- data.frame()
  }

  right_arrow <- list(dummy = 'variable')
  counter <- 0

  while(length(right_arrow) == 1) {
    counter <- counter + 1
    image_elements <- get_website_element(using = 'xpath',
                                          value = "(//article)[2]//descendant::img[@style = 'object-fit: cover;']",
                                          mendatory = TRUE,
                                          check_if_video = TRUE)

    if(!any(image_elements == 'VIDEO_FILE') && length(image_elements) > 0) {

      img_link <- image_elements[[1]]$getElementAttribute('src')[[1]]

      # Get name of Instagram user
      insta_user <- .srapegram[['remDr']]$findElements(using = 'xpath',
                                                                     value = "//header//descendant::span//a")
      insta_user <- unlist(insta_user[[1]]$getElementText())

      # Get description
      descr <- .srapegram[['remDr']]$findElements(using = 'xpath',
                                                                value = "(//article)[2]//h2//following-sibling::div/span")
      if(length(descr) == 1) {
        descr <- unlist(descr[[1]]$getElementText())
      } else {
        descr <- NA
      }

      # Get likes
      likes <- .srapegram[['remDr']]$findElements(using = 'xpath',
                                                                value = "(//article)[2]//descendant::a//div//span")
      if(length(likes) == 1) {
        likes <- unlist(likes[[1]]$getElementText())
      } else {
        likes <- NA
      }

      # Data dded
      date_added <- .srapegram[['remDr']]$findElements(using = 'xpath',
                                                                     value = "(//article)[2]//descendant::a//div//time")
      date_added <-  unlist(date_added[[1]]$getElementText())

      # Get image
      img_subname <- paste0(insta_user, '_', as.numeric(Sys.time()), '_counter_', counter, '.jpg')
      img_name <- paste0(path, '/images/', folder_name, '/', img_subname)
      utils::download.file(img_link, img_name, mode = 'wb')

      add_this <- data.frame(
        insta_user = insta_user,
        image_name = img_subname,
        image_counter = counter,
        image_scrapped_at = Sys.time(),
        image_added = date_added,
        number_of_likes = likes,
        image_description = descr
      )

      photo_data <- plyr::rbind.fill(photo_data, add_this)
      write.csv(
        photo_data,
        csv_file_name
      )
    } # end of image save

    right_arrow <- .srapegram[['remDr']]$findElements(using = 'xpath',
                                                                    value = "//button//div//span[@style ='display: inline-block; transform: rotate(90deg);']")

    #Check stop criteria
    check_for_old_photo <- as.numeric(gsub('.*,', '',date_added))
    if(is.na(check_for_old_photo)) check_for_old_photo <- 99999
    if(check_for_old_photo < oldest_photo & check_for_old_photo > 2012) right_arrow <- list() #No need downloading very old photos
    if(counter == max_img_downloads) right_arrow <- list() #300 photos per profile is more than enough

    if(length(right_arrow) == 1) {
      #go to the next photo
      .srapegram[['remDr']]$mouseMoveToLocation(webElement = right_arrow[[1]])
      .srapegram[['remDr']]$click()
      Sys.sleep(1.5)
      wait_for_page_to_load()
    }

  } #end of while loop
}
