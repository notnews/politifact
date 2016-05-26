"
Aim: 
Analyzing politifact data
Bias in Scrutiny, Batting Average by R and D

Author: Gaurav Sood
Date: 5/25/2016

"

# Global Opt
options(stringsAsFactors=FALSE)

# Base libs
library(goji)

# set dir
setwd(githubdir)
setwd("politifact")

# Load dat
library(curl)
pol_facts <- read.csv(curl("https://raw.githubusercontent.com/soodoku/politifact/master/politifacts.csv"))
pol_names <- read.csv(curl("https://raw.githubusercontent.com/soodoku/politifact/master/pol_names.csv"))

pol_all   <- merge(pol_facts, pol_names, by.x="page_names", by.y="x", all.x=T, all.y=F)

# Subset on statements by orgs. whose partisanship we know 
pol_all  <- subset(pol_all, (lean_dem %in% c("1", "0")))

# Ratings
pol_all$ratings <- zero1(car::recode(pol_all$politifact.cat.j., "'true'=6;'mostly-true'=5;'half-true'=4;'barely-true'=3;'false'=2;'pants-fire'=1"))

# 1. Selection Bias 
# -----------------------------
mean(pol_all$lean_dem==1)
# [1] 0.4434629
mean(pol_all$lean_dem==0)

# 2. Batting Average---assuming no bias in selection of statements
# -----------------------------------------------------------------
sum(pol_all$ratings[pol_all$lean_dem==1])/sum(pol_all$lean_dem==1)
# [1] 0.6329349
sum(pol_all$ratings[pol_all$lean_dem==0])/sum(pol_all$lean_dem==0)
# [1] 0.4915344

# 3. By person: Distribution: Is it a consequence of a few people?
# -------------------------------------------------------------------
library(plyr)
library(dplyr)
by_person  <- ddply(pol_all, ~page_names, summarise, total=n(), mean_rat = mean(ratings), dem = mean(as.numeric(lean_dem)))
t30_person <- by_person[order(-by_person$total),][1:30,]

# The plot
library(ggplot2)
library(scales)
library(grid)

# Reorder
t30_person$page_names <- factor(t30_person$page_names, levels=t30_person$page_names[order(t30_person$total)], ordered=TRUE)

ggplot(t30_person, aes(total, page_names)) +
geom_point(aes(colour=factor(dem), alpha=.8)) + 
ylab("") + 
xlab("Total Number of Statements Investigated") + 
scale_colour_manual(values=c("#dd3333", "#3333dd")) + 
scale_x_continuous(breaks=seq(0, 500, 100), labels=seq(0, 500, 100)) + 
theme_minimal(base_size=9) +
theme(panel.grid.major=element_line(color="#F0F0F0",size=.25)) +
theme(panel.grid.minor=element_blank()) +
theme(axis.ticks=element_blank()) +
theme(legend.position="none") +
theme(plot.title=element_text(color="#525252", size=10, vjust=1.25)) +
theme(axis.text.x=element_text(size=9, color="#636363")) +
theme(axis.text.y=element_text(size=9, color="#636363")) +
theme(axis.title.x=element_text(size=10, color="#323232", vjust=0)) +
theme(axis.title.y=element_text(size=10, color="#323232", vjust=1.25)) +
theme(plot.margin = unit(c(0.35, 0.2, 0.3, 0.35), "cm"))
ggsave("figs/t30_total_investigated.pdf")
ggsave("figs/t30_total_investigated.png")

# 4. Since there is such a large skew, we can take Obama out and see again
# -------------------------------------------------------------------------
mean(pol_all$lean_dem[pol_all$page_names!="Barack Obama"]==1)
# [1] 0.3398533

# Let us take till 90th percentile (arbitrary but ok)
quantile(by_person$total, .9)

select_names <- by_person$page_names[by_person$total < quantile(by_person$total, .9)]

mean(pol_all$lean_dem[pol_all$page_names %in% select_names]==1)
# [1] 0.4275583

# 5. Check if selection bias by batting average
# ------------------------------------------------
# Relationship b/w how often an actor is covered and how often they are incorrect
with(by_person, cor(total, mean_rat))
# [1] 0.01176192

with(t30_person, cor(total, mean_rat))
# [1] 0.2451008

# By Party
ddply(by_person, .(dem), function(x) cor(x$mean_rat, x$total))
#  dem         V1
#  1   0 0.01052708
#  2   1 0.01220616

# Running pearson 
ddply(by_person, .(dem), function(x) cor(x$mean_rat, x$total, method="spearman"))
#   dem           V1
# 1   0 0.0643790413
# 2   1 0.0004538915

ddply(by_person, .(dem), function(x) cor(x$mean_rat, log(x$total)))
# dem         V1
# 1   0 0.02467068
# 2   1 0.01017017

ggplot(by_person, aes(total, mean_rat)) +
geom_point(aes(colour=factor(dem), alpha=.8)) + 
ylab("Batting Average") + 
xlab("Total Number of Statements Investigated") + 
scale_colour_manual(values=c("#dd3333", "#3333dd")) + 
scale_y_continuous(breaks=seq(0, 1, .25), labels=nolead0s(seq(0, 1, .25))) + 
theme_minimal(base_size=9) +
theme(panel.grid.major=element_line(color="#F0F0F0",size=.25)) +
theme(panel.grid.minor=element_blank()) +
theme(axis.ticks=element_blank()) +
theme(legend.position="none") +
theme(plot.title=element_text(color="#525252", size=10, vjust=1.25)) +
theme(axis.text.x=element_text(size=9, color="#636363")) +
theme(axis.text.y=element_text(size=9, color="#636363")) +
theme(axis.title.x=element_text(size=10, color="#323232", vjust=0)) +
theme(axis.title.y=element_text(size=10, color="#323232", vjust=1.25)) +
theme(plot.margin = unit(c(0.35, 0.2, 0.3, 0.35), "cm"))
ggsave("figs/batting_average_total_investigated.pdf")
ggsave("figs/batting_average_total_investigated.png")
