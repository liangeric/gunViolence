function(input, output) {
  
  output$gun_type_plot <- renderPlot({
    
    wantedStates <-  input$stateOpt
    
    if (length(wantedStates) == 0) {
      p <- ggplot(subData, aes(x = gun_type)) +
        geom_bar() + 
        theme(axis.text.x = element_text(angle = 45)) +
        labs(title = "Distribution of Known Gun Types",
             x = "Gun Type",
             y = "Number of Incidents"
        )
    }
    else{
      statesubData <- filter(subData, state %in% wantedStates)
      
      p <- ggplot(statesubData, aes(x = gun_type, fill = state)) +
        geom_bar() + 
        theme(axis.text.x = element_text(angle = 45)) +
        labs(title = "Distribution of Known Gun Types",
             x = "Gun Type",
             y = "Number of Incidents",
             fill = "State")
    }
    
    return(p)
  })
  
  output$text_cloud <- renderPlot({
    
    wantedStates <-  input$stateOptText
    
    if (length(wantedStates) == 0) {
      p <- dplyr::select(deaths, notes) %>%
        filter(!is.na(notes)) %>%
        unnest_tokens(word, notes) %>%
        anti_join(stop_words) %>%
        count(word) %>%
        with(wordcloud(word, n, max.words = 100))
    }
    else {
      statesubData <- filter(subData, state %in% wantedStates)
      p <- dplyr::select(subData, notes) %>%
        filter(!is.na(notes)) %>%
        unnest_tokens(word, notes) %>%
        anti_join(stop_words) %>%
        count(word) %>%
        with(wordcloud(word, n, max.words = 100)) 
    }
    
    return(p)
  })
  
  output$pennsylvania <- renderLeaflet({
    
    pal <- colorFactor(c("lightpink", "red", "red4"), penn_deadly_data$n_killed)
    
    m_leaflet <- penn_deadly_data %>% leaflet() %>%
      addTiles() %>%
      addCircleMarkers(color = ~pal(penn_deadly_data$n_killed),
                       lng = penn_deadly_data$longitude,
                       lat = penn_deadly_data$latitude,
                       opacity = 0.75,
                       popup = paste("Occured: ", format(as.Date(penn_deadly_data$date), "%b %d, %Y"),
                                     "<br/>Number killed: ", penn_deadly_data$n_killed,
                                     "<br/>Number injured: ", penn_deadly_data$n_injured,
                                     "<br/><a href='", penn_deadly_data$source_url, "'>More Information</a>")) %>%
      leaflet::addLegend(pal = pal,
                values = ~penn_deadly_data$n_killed,
                title = "Deaths")
    
    return(m_leaflet)
  })
  
  output$age_comparison <- renderPlotly({
    
    if(length(input$region) == 0){
      react <- reactive({
        age_data_region %>% filter(month == input$month)
      })
      
      p <- ggplot(react(),
                  aes(x = avg_suspect_age, y = avg_victim_age,
                      color = region)) +
        geom_point() +
        labs(x = "Average Age of Suspects",
             y = "Average Age of Victims",
             color = "Region",
             title = "Distribution of Suspect and Victim Ages") +
        geom_abline(slope = 1, intercept = 0)
      
      p_plotly <- ggplotly(p, height = 500)
    }
    else{
      react <- reactive({
        age_data_region %>% filter(month == input$month,
                                   region %in% input$region)
      })
      
      p <- ggplot(react(),
                  aes(x = avg_suspect_age, y = avg_victim_age,
                      color = region)) +
        geom_point() +
        labs(x = "Average Age of Suspects",
             y = "Average Age of Victims",
             color = "Region",
             title = "Distribution of Suspect and Victim Ages") +
        geom_abline(slope = 1, intercept = 0)
      
      p_plotly <- ggplotly(p, height = 500)
    }
    
    return(p_plotly)
  })
  
  output$dygraph <- renderDygraph({
    time_dygraph <- dygraph(data = variables, main = "Gun Violence Incidents in the US from 2013-2018",
                            xlab = "Date", ylab = "Frequency") %>%
      dyOptions(colors = c("red", "orange", "blue")) %>%
      dyRangeSelector
    
    return(time_dygraph)
  })
  
  output$donut <- renderBillboarder({
    billboard <- billboarder() %>% 
      bb_donutchart(data = participants) %>%
      bb_title(text = "Participants of Gun Violence Incidents (March 2017-March 2018)", position = "top-center") %>%
      bb_colors_manual(
        'female suspects' = "red",
        'male suspects' = "orange",
        'female victims' = "blue",
        'male victims' = "purple"
      )
    return(billboard)
  })
  
  output$us_graph <- renderPlotly({
    
    p <- ggplot(us_data) +
      geom_polygon(aes(x = long,
                       y = lat,
                       group = group,
                       fill = factor(gv_cat)), 
                   color = "black") +
      scale_fill_manual(values = c("gray75", "cadetblue1", "cornflowerblue", "darkblue"),
                        labels = c("0-3.317", "3.317-4.789", "4.789-6.140", "6.140-24.770")) +
      theme_void() +
      coord_map("polyconic") +
      labs(title = "Incidents of Gun Violence per 100,000 People by State",
           fill = "# Incidents per 100k People")
    
    p_plotly <- ggplotly(p, height = 500, width = 800)
    
    return(p_plotly)
  })
  
  output$num_guns <- renderPlotly({
    
    p <- ggplot(gun_violence2018,
                aes(x = log(n_guns_involved))) +
      geom_histogram(bins = 5,
                     aes(fill = as.factor(n_affected)),
                     col = "black") +
      scale_fill_manual(values = c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#000000")) +
      labs(title = "Log Number of Guns Involved by Number Affected",
           x = "Log of Number of Guns Involved",
           y = "Number of Incidents of Gun Violence",
           fill = "Number of People Affected")
    
    p_plotly <- ggplotly(p, height = 500, width = 800)
    
    return(p_plotly)
  })
  
}