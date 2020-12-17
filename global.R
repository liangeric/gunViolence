library(tidyverse)
library(leaflet)
library(shiny)
library(lubridate)
library(shinyWidgets)
library(tidytext)
library(wordcloud)
library(shinydashboard)
library(plotly)
library(xts)
library(dygraphs)
library(billboarder)
library(maps)
library(mapproj)
data(stop_words)

deaths <- read_csv("https://raw.githubusercontent.com/liangeric/gunViolence/main/filteredViolence.csv")
subData <- filter(deaths,!is.na(gun_type) & gun_type != "Unknown")
subData$gun_type <- factor(subData$gun_type,levels = 
                             c("Handgun","Shotgun","Rifle","Win",
                               "AR-15","22 LR","AK-47","Auto","Mag","Other"))
penn_deadly_data <- read_csv("https://raw.githubusercontent.com/liangeric/gunViolence/main/pennDeadly.csv")
age_data_region <- read_csv("https://raw.githubusercontent.com/liangeric/gunViolence/main/gun-violence-ages.csv")
colnames(age_data_region)[3] = "Average Age of Victims"
colnames(age_data_region)[4] = "Average Age of Suspects"
colnames(age_data_region)[5] = "Region"

data <- read_csv("https://raw.githubusercontent.com/liangeric/gunViolence/main/injured_killed.csv")
df_killed <- aggregate(data$n_killed, by=list(date=data$date), FUN=sum)
df_injured <- aggregate(data$n_injured, by=list(date=data$date), FUN=sum)
#iterate over dataset and save date as a temp variable
'%ni%' <- Negate('%in%')
values <- c()
killed <- c()
injured <- c()
for (date in seq(min(data$date), max(data$date), 1)) {
  values <- c(values, sum(data$date == date))
  if (date %ni% df_killed$date) {
    killed <- c(killed, 0)
  }
  else {
    #grab x value corresponding to date
    killed <- c(killed, df_killed$x[which(df_killed$date==date)])
  }
  if (date %ni% df_injured$date) {
    injured <- c(injured, 0)
  }
  else {
    #grab x value corresponding to date
    injured <- c(injured, df_injured$x[which(df_injured$date==date)])
  }
}
df_time <- data.frame(
  time=seq(from=min(data$date), to=max(data$date), by=1 ), 
  value=values, killed=killed, injured=injured
)
Incidents <- xts(x = df_time$value, order.by = df_time$time)
Killed<- xts(x = df_time$killed, order.by = df_time$time)
Injured <- xts(x = df_time$injured, order.by = df_time$time)
variables <- cbind(Incidents, Killed, Injured)
participants <- data.frame(category = c("female suspects", "male suspects", 
                                        "female victims", "male victims"),
                           count = c(3429, 45059, 6975, 34193))

gun_violence2018 <- read_csv("https://raw.githubusercontent.com/liangeric/gunViolence/main/violence_2018.csv",
                             col_types = "df")
gun_violence2018 = gun_violence2018 %>% filter(n_guns_involved != 1)
gun_violence2018$n_guns_involved <- cut(gun_violence2018$n_guns_involved, breaks = c(1, 2, 3, 4, 5, 10, 50, Inf), labels = c("2", "3", "4", "5", "6-10", "11-50", "50+"))
gun_violence2018$NumberAffected = as.factor(gun_violence2018$n_affected)
gun_violence2018$NumberAffected <- factor(gun_violence2018$NumberAffected, levels = c("0", "1", "2", "3", "4", "5", "6", "7", "8+"))
gun_violence2018$NumberAffected = fct_collapse(gun_violence2018$NumberAffected, "5+" = c("5", "6", "7", "8+"))


data_one_year <- read_csv("")
us_data <- map_data("state") %>% select(-c(order, subregion))

incident_data <- select(data_one_year, state, n_killed, n_injured) %>%
  group_by(state) %>%
  summarize(count = n(), total_killed = sum(n_killed), total_injured = sum(n_injured)) %>%
  filter(state != "Alaska" & state != "Hawaii") %>% mutate(state = tolower(state)) %>%
  left_join(us_data, by = c("state" = "region"))
