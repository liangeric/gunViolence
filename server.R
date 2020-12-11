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
      addLegend(pal = pal,
                values = ~penn_deadly_data$n_killed,
                title = "Deaths")
    
    return(m_leaflet)
  })
  
  output$age_comparison <- renderPlotly({
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
    
    p_plotly <- ggplotly(p, height = 600)
    
    return(p_plotly)
  })
  
}