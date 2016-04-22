## Some Facts about Politifact

I answer two questions using data from Politifact:  

1. **Imbalance in scruity**: Do they vet statements by Democrats or Democratic leaning organizations more than statements Republicans or Republican leaning organizations?  
2. **Batting average by party**: Roughly n_correct/n_checked, but instantiated here as mean Politifact rating.   

To interpret the numbers, you need to make two assumptions:  

1. Number of statements made by Republicans and Republican leaning persons and organizations is the same as that made by people and organizations on the left.  
2. Truthiness of statements by Republican and Republican leaning persons and organizations is the same as that of left leaning people and organizations.

To answer the questions, I scraped data from [http://politifact.com](http://politifact.com) and independently coded and appended data on party of the person or organization covered. (Feel free to download the [script](politifact.R) for scraping and analyzing the data, [scraped data](politifacts.csv) and [data linking people and organizations to party](pol_names.csv). If you catch an error, please let me know by opening an issue.)

Until now, Politifact has checked veracity of 3,859 statements by 703 politicians and organizations. Of the 703 politicians and organizations, I was able to establish the partisanship of 554. I restrict analysis to 3,396 statements by the 554 organizations and people whose partisanship I could establish, and who lean either towards the Republican or Democratic party. I code the Politifact 6-point True to Pants on Fire scale (true, mostly-true, half-true, barely-true, false, pants-fire) linearly so that it lies between 0 (pants-fire) and 1 (true).

Of the 3,396 statements, about 44% (n = 1506) of the statements checked by Politifact are by Democrats or Democratic leaning organizations. Rest of the roughly 56% (n = 1890) are by Republicans or Republican leaning organizations. Mean politifact rating of statements by Democrats or Democratic leaning organizations (batting average) is .63; it is .49 for statements by Republicans or Republican leaning organizations. That can happen due to bias in selection of statements, or if Republicans or Republican leaning organizations lie (say incorrect things) more often than Democrats or Democratic leaning people or organizations. 
