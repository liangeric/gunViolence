dashboardPage(
  dashboardHeader(title = "Group 11 Project"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Gun Type Distribution", tabName = "partA"),
      menuItem("Notes Word Cloud", tabName = "partB"),
      menuItem("Test",tabName = "partC"),
      menuItem("Test2",tabName = "partD")
    )
  ),
  dashboardBody(
    tabItems(

      tabItem(tabName = "partA",
              fluidRow(
                box(
                  plotOutput(outputId = "gun_type_plot", height = 400)
                  ),
                box(
                  title = "Controls",
                  selectInput(inputId = "stateOpt",
                              label = "States in Graph:",
                              choices = state.name,
                              multiple = TRUE)
                )
              )
              ),
      

      tabItem(tabName = "partB",
              fluidRow(
                box(
                  plotOutput(outputId = "text_cloud", height = 600)
                ),
                box(
                  title = "Controls",
                  selectInput(inputId = "stateOptText",
                              label = "States in Word Cloud:",
                              choices = state.name,
                              multiple = TRUE)
                )
              )
              ),
      
      tabItem(tabName = "partC",
              fluidRow(
                box(
                  title = "Deadly Gun Incidents in Pennsylvania (March 2017 - March 2018)",
                  leafletOutput(outputId = "pennsylvania", height = 400, 
                             width = 800)
                )
              )
              ),
      tabItem(tabName = "partD",
              fluidRow(
                box(
                  plotlyOutput(outputId = "age_comparison",
                             height = 400, width = 900)
                ),
                box(
                  title = "Comparison of Age of Suspect and Age of Victim (March 2017 - March 2018)",
                  selectizeInput(inputId = "region",
                                 label = "Choose Your Regions",
                                 choices = levels(factor(age_data_region$region)),
                                 selected = "Northeast",
                                 multiple = TRUE,
                                 options = NULL),
                  
                  sliderTextInput(inputId = "month",
                                  label = "Select Month",
                                  choices = c("March 2017", "April 2017", "May 2017",
                                              "June 2017", "July 2017", "August 2017",
                                              "September 2017", "October 2017",
                                              "November 2017", "December 2017",
                                              "January 2018", "February 2018",
                                              "March 2018"))
                )
              )
              )
      )
    )
  )