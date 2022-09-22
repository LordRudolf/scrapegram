hashtags <- c('nature', 'landscape')
scrape_all <- function(hashtags = NULL,
                       instagram_profile = NULL,
                       path = NULL,
                       folder_name = NULL,
                       max_img_downloads_per_profile = 300,
                       oldest_photo = 2017) {

  if(is.null(hashtags) && is.null(instagram_profile) | !is.null(hashtags) && !is.null(instagram_profile)) {
    stop('You need to provide either hashtags argument or instagram_profile argument.')
  }

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

  user_list_file <- paste0(path, '/user_list.csv')
  if(file.exists(user_list_file)) {
    user_list <- read.csv(user_list_file)
  } else {
    user_list <- data.frame()
  }

  if(!is.null(hashtags)) {
    for(i in 1:length(hashtags)) {
      tag <- hashtags[[i]]
      find_profiles_by_tags(tag)
      users <- unlist(scrape_nickname_only())

      for(j in 1:length(users)) {
        new_user <- users[[j]]
        current_user_list <- list.files(paste0(path, '/images'))
        if(new_user %in% current_user_list) {
          warning(paste0('The user ', new_user, ' has been already detected in the image folder. Skipping this user image downloads...'))
          next()
        }

        open_profile(new_user)
        wait_for_page_to_load()
        random_sleep(2, 2)
        profile_info <- scrape_profile()

        user_list <- plyr::rbind.fill(user_list, as.data.frame(profile_info))
        write.csv(user_list,  user_list_file)

        open_first_image()

        scrape_photos(folder_name = new_user)
      } #end of user list loop

    } #end of hashtags loop
  }
}
