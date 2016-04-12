"

Author: Gaurav Sood
Date: 4/10/2016

Aim:
Analyzing politifact data
Bias in Scrutiny, Batting Average by R and D

"

# Load lib
library(rvest)
library(plyr)

# Scrape Names
# 6 states:
# True, Mostly-True, Half-True, Barely True, False, Pants on Fire
politifact <- data.frame(cat=c("true", "mostly-true", "half-true", "barely-true", "false", "pants-fire"), ns = c(30, 36, 41, 32, 38, 18))
out        <- lapply(1:nrow(politifact), function(x) NULL)
names(out) <- politifact$cat

for (j in 1:nrow(politifact)) {

	for (i in 1:politifact$ns[j]) {
	
	polfact_page <- read_html(paste0("http://www.politifact.com/truth-o-meter/rulings/", politifact$cat[j], "/?page=", i))
	
	page_names  <- polfact_page %>% 
				   html_nodes(".statement__source") %>%
				   html_text()
	
	out[[j]]    <- rbind(out[[j]], data.frame(page_names, politifact$cat[j]))
	} 
}

outdf <- ldply(out)

# Trim leading or trailing spaces 
outdf$page_names <- gsub("^ | $", "", outdf$page_names)

write.csv(outdf[,-1], file="politifacts.csv", row.names=FALSE)

# Output Pol Names 
# write.csv(unique(outdf$page_names), file="pol_names.csv", row.names=FALSE)

# Merge data on party affiliation of groups covered
pol_facts <- read.csv("politifacts.csv")
pol_names <- read.csv("pol_names.csv")

pol_all   <- merge(pol_facts, pol_names, by.x="page_names", by.y="x", all.x=T, all.y=F)

# Subset on statements by orgs. whose partisanship we know 
pol_all <- subset(pol_all, (lean_dem %in% c("1", "0")))

# Selection Bias 
mean(pol_all$lean_dem==1)
mean(pol_all$lean_dem==0)

# Ratings
pol_all$ratings <- zero1(car::recode(pol_all$politifact.cat.j., "'true'=6;'mostly-true'=5;'half-true'=4;'barely-true'=3;'false'=2;'pants-fire'=1"))

# Batting Average---assuming no bias in selection of statements
sum(pol_all$ratings[pol_all$lean_dem==1])/sum(pol_all$lean_dem==1)
sum(pol_all$ratings[pol_all$lean_dem==0])/sum(pol_all$lean_dem==0)

