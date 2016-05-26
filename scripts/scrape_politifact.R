"

Author: Gaurav Sood
Date: 4/10/2016

Aim:
Scrape and save
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

