# scrapegram
 Scrape data from Instagram slowly but surerly 

# How to get started
1.	Set up the and ensure that your Selenium server is running. More info here: https://docs.ropensci.org/RSelenium/articles/basics.html#docker 
2.	Install this package from Github:
devtools::install_github('LordRudolf/scrapegram')
3.	Open it:
library(scrapegram)
4.	Start a new browser session. If your Selenium is installed for a particular browser, remember to show it in the function arguments:
start_session(browser = 'firefox')
If everything is working correctly, a new browser window will appear and ask you to log in to your In Instagram account. 
5.	After you have logged in, you may start the data scrape. First, define what data you would like to scrape. The code below shows how to scrape images and their descriptions/number of likes by hashtags.
hashtags <- c('nature', 'landscape', 'travelphoto')
download_path <- 'C:/Users/Rudolfs/Desktop/R_scripts/Instagram_data_scrape/' #Your’s will be different
scrape_all(hashtags, path = download_path)
6.	Sit back and watch how the algorithm opens images one by one and downloads them...
You will notice that there have been new files created in the folder you selected as the download path: 
"user_list.csv" has the available profile information of the individual users and the folder "images", which contains subfolders by their Instagram user names.

# ---
This GitHub package severely lacks function documentation and testing at the moment. The issues will be fixed upon a higher number of package users. 
