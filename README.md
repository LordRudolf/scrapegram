# scrapegram
 Scrape data from Instagram slowly but surerly 

# How to get started <br />
1.	Set up the and ensure that your Selenium server is running. More info here: https://docs.ropensci.org/RSelenium/articles/basics.html#docker <br />
2.	Install this package from Github: <br />
`devtools::install_github('LordRudolf/scrapegram')` <br />
3.	Open it:  <br />
`library(scrapegram)` <br />
4.	Start a new browser session. If your Selenium is installed for a particular browser, remember to show it in the function arguments: <br />
`start_session(browser = 'firefox')` <br />
If everything is working correctly, a new browser window will appear and ask you to log in to your In Instagram account. <br />
5.	After you have logged in, you may start the data scrape. First, define what data you would like to scrape. The code below shows how to scrape images and their descriptions/number of likes by hashtags. <br />
`hashtags <- c('nature', 'landscape', 'travelphoto')` <br />
`download_path <- 'C:/Users/Rudolfs/Desktop/R_scripts/Instagram_data_scrape/' #Your’s will be different` <br />
`scrape_all(hashtags, path = download_path)` <br />
6.	Sit back and watch how the algorithm opens images one by one and downloads them... <br />
You will notice that there have been new files created in the folder you selected as the download path: <br />
"user_list.csv" has the available profile information of the individual users and the folder "images", which contains subfolders by their Instagram user names.<br />
<br />
# --- 
This GitHub package severely lacks function documentation and testing at the moment. The issues will be fixed upon a higher number of package users. 
