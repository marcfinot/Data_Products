library(shiny)
TMYlocationfile <- "http://rredc.nrel.gov/solar/old_data/nsrdb/1991-2005/tmy3/TMY3_StationsMeta.csv"
location_table <- read.csv(TMYlocationfile, header=TRUE)
location_table$location <- paste(location_table$State,location_table$Site.Name)
index <- order(location_table$location)
location_sorted <- location_table[index,]

shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("Solar Radiation summary based on TMY data"),
    sidebarPanel(
#      selectInput('locationID','Please choose location',location_sorted$USAF,selected = 704540),
      selectInput('locationID','location name',location_sorted$location,selected = "CA MOUNTAIN VIEW MOFFETT FLD NAS"),
      submitButton('Submit'),
      h5('data downloaded from http://rredc.nrel.gov/')
    ),
    mainPanel(
      h3('Results of solar radiation info for the following location'),
      verbatimTextOutput("inputValue"),
      h4('typical daily insolation in kWh/m2 (equiv. number of hours of sun)'),
      verbatimTextOutput("prediction"),
      plotOutput('newHist')
    )
  )
)