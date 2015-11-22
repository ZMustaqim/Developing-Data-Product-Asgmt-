library(shiny)
library(ggplot2)
library(rCharts)
library(data.table)
library(dplyr)


# Loading data

dt <- read.csv('data123.csv') %>% mutate(EVTYPE = tolower(EVTYPE))
evtypes <- sort(unique(dt$EVTYPE))


shinyServer(function(input, output, session) {
  

  values <- reactiveValues() #Define reactive value
  values$evtypes <- evtypes
  
  output$evtypeControls <- renderUI({ # create checkbox
    checkboxGroupInput('evtypes', 'Event types', evtypes, selected=values$evtypes )
  })
  

  observe({ # for select all button
    if(input$select_all ==0) return()
    values$evtypes <- c()
  })
  
  observe({
    if(input$select_all ==0) return()
    values$evtypes <- evtypes
  })
  observe({ # for reset  button
    if(input$clear_all ==0) return()
    values$evtypes <- c()
  })
  
  
  dt.agg.year <- reactive({ #preparing dataset
    aggregate_by_year(dt, input$range[1], input$range[2], input$evtypes)
  })

  

  output$eventsByYear <- renderChart({ #plot event by year
    plot_events_by_year(dt.agg.year())
  })
  
  

  output$economicImpact <- renderChart({ #plot economic impact by year
    plot_impact_by_year(
      dt = dt.agg.year() %>% select(Year, Crops, Property),
      dom = "economicImpact",
      yAxisLabel = "Total damage (Million USD)",
      desc = TRUE
    )
  })
  
  plot_events_by_year <- function(dt, dom = "eventsByYear", yAxisLabel = "Count") {
    eventsByYear <- nPlot(
      Count ~ Year,
      data = dt,
      type = "lineChart", dom = dom, width = 650
    )
    
    eventsByYear$chart(margin = list(left = 100))
    eventsByYear$yAxis( axisLabel = yAxisLabel, width = 80)
    eventsByYear$xAxis( axisLabel = "Year", width = 70)
    eventsByYear
  }
  
  plot_impact_by_year <- function(dt, dom, yAxisLabel, desc = FALSE) {
    impactPlot <- nPlot(
      value ~ Year, group = "variable",
      data = melt(dt, id="Year") %>% arrange(Year, if (desc) { desc(variable) } else { variable }),
      type = "stackedAreaChart", dom = dom, width = 650
    )
    impactPlot$chart(margin = list(left = 100))
    impactPlot$yAxis(axisLabel = yAxisLabel, width = 80)
    impactPlot$xAxis(axisLabel = "Year", width = 70)
    
    impactPlot
  }
  
  aggregate_by_year <- function(dt, year_min, year_max, evtypes) {
    round_2 <- function(x) round(x, 2)
    

    dt %>% filter(YEAR >= year_min, YEAR <= year_max, EVTYPE %in% evtypes) %>%

      group_by(YEAR) %>% summarise_each(funs(sum), COUNT:CROPDMG) %>%

      mutate_each(funs(round_2), PROPDMG, CROPDMG) %>%
      rename(
        Year = YEAR, Count = COUNT,
        Fatalities = FATALITIES, Injuries = INJURIES,
        Property = PROPDMG, Crops = CROPDMG
     )
  }
  
})
