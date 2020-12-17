dashboardPage(
  dashboardHeader(title = "Gun Violence Incidents"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Gun Type Distribution", tabName = "partA"),
      menuItem("Notes Word Cloud", tabName = "partB"),
      menuItem("Gun Incidents PA Map",tabName = "partC"),
      menuItem("Suspect & Victim Ages Distribution",tabName = "partD"),
      menuItem("Gun Incidents Time Series",tabName = "partE"),
      menuItem("Suspect & Victim Gender",tabName = "partF"),
      menuItem("Gun Incidents US Map",tabName = "partG"),
      menuItem("Number of Guns & Affected",tabName = "partH")
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
                             width = 800),
                  height = 500,
                  width = 10
                )
              )
              ),
      tabItem(tabName = "partD",
              fluidRow(
                box(
                  plotlyOutput(outputId = "age_comparison",
                               height = 500, width = 800),
                  height = 550,
                  width = 10
                )
              ),
              fluidRow(
                box(
                  title = "Comparison of Age of Suspect and Age of Victim (March 2017 - March 2018)",
                  selectizeInput(inputId = "region",
                                 label = "Choose Your Regions",
                                 choices = levels(factor(age_data_region$Region)),
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
              ),
      tabItem(tabName = "partE",
              fluidRow(
                box(
                  dygraphOutput(outputId = "dygraph", height = "500px", 
                                width = "700px"),
                  height = 550,
                  width = 10
                  )
                )
              ),
      
      tabItem(tabName = "partF",
              fluidRow(
                box(
                  billboarderOutput(outputId = "donut", height = "500px",
                                    width = "500px")
                  )
                )
              ),
      
      tabItem(tabName = "partG",
              fluidRow(
                box(
                  plotlyOutput(outputId = "us_graph",
                               height = 500, width = 800),
                  height = 550,
                  width = 11
                )
              )
              ),
      tabItem(tabName = "partH",
              fluidRow(
                box(
                  plotlyOutput(outputId = "num_guns",
                               height = 500, width = 800),
                  height = 550,
                  width = 11
                )
              )
      )
      
      )
    )
  )