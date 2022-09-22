get_website_element <- function(using, value, ...,
                                min_sleep = 0.2,
                                avg_sleep = 2,
                                mendatory = FALSE,
                                check_if_video = FALSE) {
  wait_for_page_to_load()
  random_sleep(min_sleep = min_sleep, avg_sleep = avg_sleep)
  elements <- get_element(using = using,
                          value = value,
                          mendatory = mendatory,
                          check_if_video =  check_if_video,
                          ...)

  return(elements)
}

wait_for_page_to_load <- function() {
  #https://stackoverflow.com/questions/42595268/rselenium-scraping-a-dynamically-loaded-page-that-loads-slowly

  control <- 0
  chk <- FALSE
  while(!chk) {
    webElem <- .srapegram[['remDr']]$findElements("css", ".js-infinite-marker")
    if(length(webElem) > 0L){
      tryCatch(
        .srapegram[['remDr']]$executeScript("elem = arguments[0];
                      elem.scrollIntoView();
                        return true;", list(webElem[[1]])),
        error = function(e){}
      )
      Sys.sleep(0.3)
      control <- control + 1
      if(control > 90) stop('Stop! For some reason it takes for forever to load js-infinite-marker from the webpage')
    } else {
      chk <- TRUE
    }
  }
}


#Generate random number of seconds wait time
random_sleep <- function(min_sleep = 0.2, avg_sleep = 2) {

  if(avg_sleep < 0.5) stop('Not acceptable avg_sleep time! Check the function randomSleep')

  sleep_time <- rpois(1, (avg_sleep - 0.5)) + runif(1)
  Sys.sleep(max(min_sleep, sleep_time))
}


#Get element
get_element <- function(using, value,
                        control_limit = 120,
                        stop_if_failed = TRUE,
                        mendatory = FALSE,
                        check_if_video = FALSE) {
  elements <- NULL
  control <- 0

  while(is.null(elements)) {
    if(control > control_limit) {
      if(stop_if_failed) stop() else break()
    }

    elements <- tryCatch({
      elements <- .srapegram[['remDr']]$findElements(using = using, value = value)

      if(mendatory | check_if_video) {
        if(length(elements) < 1) {
          if(check_if_video) {
            video <- .srapegram[['remDr']]$findElements(using = 'xpath',
                                                                      value = "(//article)[2]//descendant::video")
            if(length(video) == 1) elements <- 'VIDEO_FILE' else elements <- NULL
          } else {
            stop()
          }
        }
      }

      elements
    },
    error = function(e) {
      Sys.sleep(0.2)
      control <<- control + 1
      NULL
    })
  }

  return(elements)
}
