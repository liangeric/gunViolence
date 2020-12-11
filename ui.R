library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Group 11 Project"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Part a", tabName = "partA"),
      menuItem("Part b", tabName = "partB")
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
              )
      )
    )
  )