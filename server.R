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
                  aes(x = `Average Age of Suspects`, y = `Average Age of Victims`,
                      color = Region)) +
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
                                   Region %in% input$region)
      })
      
      p <- ggplot(react(),
                  aes(x = `Average Age of Suspects`, y = `Average Age of Victims`,
                      color = Region)) +
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
    
    p <- ggplot(incident_data) +
      geom_polygon(aes(x = long, y = lat, group = as.factor(group), 
                       fill = count,
                       text = sprintf("Deaths: %s\nNum. Injuries: %s", 
                                      total_killed, total_injured)), 
                   color = "black") +
      scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 2500) +
      coord_map("polyconic") +
      labs(title = "Number of Gun Violence Incidents by State",
           fill = "Num. of \nIncidents") +
      theme(axis.title = element_blank(),
            axis.text = element_blank(),
            axis.ticks = element_blank(),
            panel.background = element_blank())
    
    p_plotly <- ggplotly(p, width = 800, height = 500, tooltip = "text")
    
    return(p_plotly)
  })
  
  output$num_guns <- renderPlotly({
    
    p <- ggplot(gun_violence2018,
                aes(x = n_guns_involved)) +
      geom_bar(aes(fill = NumberAffected, text = paste0("Count: ", ..count..)),
               col = "black") +
      scale_fill_manual(values = c("#FFFFB2", "#FED976", "#FEB24C", "#FD8D3C", "#F03B20", "#BD0026")) +
      labs(title = "Number of Guns Involved by Number Affected",
           subtitle = "Data from first 3 months of 2018. Excludes incidents in which one gun was involved because these were the vast majority.",
           x = "Number of Guns Involved",
           y = "Number of Incidents of Gun Violence",
           fill = "Number of People Affected")
    
    p_plotly <- ggplotly(p, height = 500, width = 800, tooltip = "text") %>%
      layout(margin = list(r = 250))
    
    return(p_plotly)
  })
  
}