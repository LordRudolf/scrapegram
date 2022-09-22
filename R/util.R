#' Set download directory for the scrapped objects
setDir <- function(path) {
  if(!file.exists(path)) stop('The directory does not exist')
  .srapegram$download_dir <- path
}

#Check directory whether it has all the required subfolders
dirCheck <- function(path) {
  path <- gsub('/$', '', path)
  if(!file.exists(paste0(path, '/images'))) {
    dir.create('images')
  }
  if(!file.exists(paste0(path, '/descriptions'))) {
    dir.create('descriptions')
  }
}
