## Some Facts about Politifact

I assessed Politifact on: 1) imbalance in scruity: Do they vet statements by Democrats or Democratic leaning organizations more than statements Republicans or Republican leaning organizations, and 2) batting average by party: n_correct/n_checked. 

To answer the question, I scraped the data from [http://politifact.com](http://politifact.com) and independently coded and appended data on party of the person or organization covered. Feel free to download the [script](politifact.R) for scraping and analyzing the data, [scraped data](politifacts.csv) and [data linking people and organizations to party](pol_names.csv).

Until now, Politifact has checked veracity 3,859 statements by 703 politicians and organizations. Of these, I was able to establish the partisanship of 554 people and organizations. I restrict analysis to 3,396 statements by organizations of people whose partisanship I could establish and whose lean either towards the Republican or Democratic party. I code the Politifact 6-point True to Pants on Fire scale (true, mostly-true, half-true, barely-true, false, pants-fire) linearly so that it lies between 0 (pants-fire) and 1 (true).

Of the 3,396 statements, about 44% (n = 1506) of the statements checked by Politifact are by Democrats or Democratic leaning organizations. Rest of the roughly 56\% (n = 1890) are by Republicans or Republican leaning organizations. Mean politifact rating of statements by Democrats or Democratic leaning organizations (batting average) is .63, and .49 for statements by Republicans or Republican leaning organizations. That can happen due to bias in selection of statements, or if Republicans or Republican leaning organizations lie more than Democratic or Democratic leaning organizations. 
