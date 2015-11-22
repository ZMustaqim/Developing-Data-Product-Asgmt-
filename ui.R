

library(shiny)
library(rCharts)


  shinyUI(
    navbarPage("Economic Damage Impact by Weather Condition in the U.S.",
              
               tabPanel("Info",
                        mainPanel(
                          h3('Synopsis:'),
                          h5("This application attempts to analyze data of natural events from the U.S. 
                             National Oceanic and Atmospheric Administration's (NOAA) storm database 
                             which had the impact from economy perspective. With storm database, 
                             data processing and analyzing done to find the impact trending and result 
                             been show in yearly trending.[IMPACT TRENDING tab]"),
                          
                          h3(" How to use this App:"),
                          
                          h4(" Choose year range:"),
                          sliderInput("ccc", 
                                      "Year Range:", 
                                      min = 1950, 
                                      max = 2011, 
                                      value = c(1971, 1990)
                                  ),
                          
                          h5('Above slider used to select range of year for the data to be populated 
                             from 1950 until 2011 '),
                          
                          h4(" Choose Event type:"),
                          
                          h5('Next is to select what type of event we need to see the trending.'),
                          
                          actionButton(inputId = "xxx", label = "Select all", icon = icon("check-square")),
                          actionButton(inputId = "yyy", label = "Reset", icon = icon("check-square")),
                          
                          h5('Press "Select_all" button to select all event'),
                          h5('Press "Reset" button to un-select all event'),
                          
                          h3(" Result:"),
                          h5('Yearly trending will populate at the right side according to selection of years and events')
                        )
                        
               ),
               
          tabPanel("Impact Trending",             
             sidebarPanel(
               sliderInput("range", 
                           "Year Range:", 
                           min = 1950, 
                           max = 2011, 
                           value = c(1950, 1956)),
              
               h5('Event Type Selection:'),
               
               actionButton(inputId = "select_all", label = "Select all", icon = icon("check-square")),
               actionButton(inputId = "clear_all", label = "Reset", icon = icon("check-square")),
               uiOutput("evtypeControls")
               
             ),
             
             mainPanel(
               
               tabPanel(p(icon("line-chart"), "By year"),
                        h4('Economic impact by year', align = "center"),
                        showOutput("economicImpact", "nvd3"),
                        h4('Number of events by year', align = "center"),
                        showOutput("eventsByYear", "nvd3")

               )
               
             )
            )
          
     
               
          
    ))
  
  
  
  

