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
  
}