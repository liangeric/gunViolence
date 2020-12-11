library(tidyverse)
library(leaflet)
library(shiny)
library(lubridate)
library(shinyWidgets)
library(tidytext)
library(wordcloud)
library(shinydashboard)
data(stop_words)

deaths <- read_csv("https://raw.githubusercontent.com/liangeric/gunViolence/main/filteredViolence.csv")
subData <- filter(deaths,!is.na(gun_type) & gun_type != "Unknown")
subData$gun_type <- factor(subData$gun_type,levels = 
                             c("Handgun","Shotgun","Rifle","Win",
                               "AR-15","22 LR","AK-47","Auto","Mag","Other"))
penn_deadly_data <- read_csv("https://raw.githubusercontent.com/liangeric/gunViolence/main/pennDeadly.csv")
age_data_region <- read_csv("https://raw.githubusercontent.com/liangeric/gunViolence/main/gun-violence-ages.csv")