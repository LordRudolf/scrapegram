.onLoad <- function(libname, pkgname) {
  .srapegram <<- new.env(parent = emptyenv())
}


login_check <- function() {
  loginelements <- get_website_element(using = 'xpath',
                                       value = "//nav//descendant::a[@href = '/accounts/activity/']",
                                       min_sleep = 0.2,
                                       avg_sleep = 1,
                                       control_limit = 10,
                                       stop_if_failed = FALSE)
  return(length(loginelements) > 0)
}

##' Start a new session
##'
##' @description Start a new selenium server and browser session
##'
##' @inheritDotParams RSelenium::rsDriver
##'
##' @details
##' The function creates a remote driver via Selenium server function
##' \code{\link[RSelenium:rsDriver]{RSelenium::rsDriver()}}.
##' Note that Selenium server shall be already running.
##' Look up \href{https://docs.ropensci.org/RSelenium/articles/basics.html#docker}{here}
##' on how to set up a new Selenium server.
##'
##' @examples
##' ## Not run:
##' library(scrapeInstagram)
##'
##' start_session()
##'
##' --------------------------------------------------
##' # You may specify Selenium server arguments; e.g., browser and port number
##' start_session(browser = c('firefox'), port = 4444L)
##'
##'--------------------------------------------------
##' # Alternatively, you may define the driver separately and use the function start_session() just to open the browser
##' remDr <- remoteDriver(
##'   remoteServerAddr = "localhost",
##'   port = 4444L,
##'    browserName = "firefox"
##' )
##'start_session(remDr = remDr)
##'
##' ## End(Not run)
##' @export
start_session <- function(..., remDr = NULL) {

  # Check if the user did already run this function (if yes the he may encounter port issues therefore
  # he may need to clear his session)
  if(exists('remDr', envir = .srapegram)) {

    #Check if it is possible to log in
    stop_me <- FALSE
    try({
      if(.srapegram[['remDr']]$getCurrentUrl() != 'https://www.instagram.com/') {
        .srapegram[['remDr']]$navigate('https://www.instagram.com/')
        random_sleep(2, 2)
      }
      stop_me <- login_check()
    }, silent = TRUE)

    if(stop_me) stop('You already have an active Instagram session. Log out from you current account if you want to start a new session.')

    cat(paste0("It appears that you already have an established selenium server and ",
               "an Instagram browser connection."))
    user_input <- readline(paste0("Do you want to clear the previous session and start a new one? (y/n)"))

    if(user_input == 'y') {
      remove('remDr', envir = .srapegram)
      system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)

      warning('Java processes has been stopped...
      You may need to restart your Selenium servers to create a new connection again...', noBreaks. = TRUE)
      stop('The previous server connections has been cleared...
          You may run the function again to establish a new remote driver connection.', fill = TRUE)
    }
  }

  # Validate the whether the optional argument remDr is working and provide contextual error messages if it doesn't
  if(!is.null(remDr)) {
    if(class(remDr) != 'RSelenium') stop('The argument remDr, if provided, must be remoteDriver object class.')

    tryCatch({
      remDr$open()
    }, error = function(e) {
      stop(paste0('Could not initialized the browser session from the provided remDr variable \n \n',
                  'Original error message: \n',
                  e))
    } )
  }

  # Create a new connection if no predefined remDr provided
  tryCatch({
    #remDr <- remoteDriver(...)
    .srapegram[['remDr']] <- ''
    driver <- RSelenium::rsDriver(...)
    remDr <- driver[['client']]
    remDr$open()
  }, error = function(e) {
    stop(paste0('Error establishing a remote driver: \n \n',
                'Original error message: \n',
                e,
                '\n \n',
                'Check if the Selenium server is runnining or try to define the driver manually by ',
                'using the "..." for custom driver server and browser arguments or  provide an already initialized
                server driver using the function argument "remDr".',
                'For more information check "?remoteDriver" or ',
                'visit the website https://docs.ropensci.org/RSelenium/articles/basics.html#docker'))
  })

  .srapegram[['remDr']] <- remDr

  .srapegram[['remDr']]$navigate('https://www.instagram.com/')
  wait_for_page_to_load()
  random_sleep(1, 1)

  if(login_check()) break()

  #Auto close cookies window
  cookies_window <- get_website_element(using = 'xpath',
                                        value = "//button[.='Only allow essential cookies']",
                                        min_sleep = 2,
                                        avg_sleep = 2,
                                        control_limit = 4,
                                        stop_if_failed = FALSE)
  if(length(cookies_window) > 0) {
    .srapegram[['remDr']]$mouseMoveToLocation(webElement = cookies_window[[1]])
    random_sleep(0.2, 0.5)
    .srapegram[['remDr']]$click()
  }

  #Semi-manual login
  login_forms <- get_website_element(using = 'xpath',
                                     value = "//button//descendant::div[.='Log In']",
                                     min_sleep = 2,
                                     avg_sleep = 4,
                                     control_limit = 10,
                                     stop_if_failed = FALSE)
  if(length(login_forms) > 0) {
    cat("Log in to your Instagram account through the browser")

    while(length(login_forms) > 0) {
      login_forms <- get_website_element(using = 'xpath',
                                         value = "//button//descendant::div[.='Log In']",
                                         min_sleep = 0.1,
                                         avg_sleep = 0.5,
                                         control_limit = 1,
                                         stop_if_failed = FALSE)
    }

    save_your_login_info <- get_website_element(using = 'xpath',
                                                value = "//button[.='Not Now']",
                                                min_sleep = 0.2,
                                                avg_sleep = 1,
                                                control_limit = 10,
                                                stop_if_failed = FALSE)
    if(length(save_your_login_info) > 0) {
      .srapegram[['remDr']]$mouseMoveToLocation(webElement = save_your_login_info[[1]])
      random_sleep(2, 2)
      .srapegram[['remDr']]$click()
    }
  } #end of login

  #Auto close notifications window
  notifications_window <- get_website_element(using = 'xpath',
                                              value = "//button[.='Not Now']",
                                              min_sleep = 1,
                                              avg_sleep = 2,
                                              control_limit = 10,
                                              stop_if_failed = FALSE)
  if(length(save_your_login_info) > 0) {
    .srapegram[['remDr']]$mouseMoveToLocation(webElement = notifications_window[[1]])
    random_sleep(1, 0.5)
    .srapegram[['remDr']]$click()
  }

  if(login_check()) {
    cat('Login has been succesful.')
  } else {
    stop('Could not properly read Instagram html tags. Possibly, there been code changes in the Instagram webpage.')
  }
}

##' Open a new window
##'
##' @description Open new window in your web-browser (in case you accidentally closed the previous
##' one and don't want to return the \code{\link[start_session]{start_session()}})
##'
##' @examples
##' ## Not run:
##' open_window()
##' # And... that's it
##' @export
open_window <- function() {
  .srapegram[['remDr']]$open()
  .srapegram[['remDr']]$navigate('https://www.instagram.com/')
  wait_for_page_to_load()
  random_sleep(1, 1)
}
