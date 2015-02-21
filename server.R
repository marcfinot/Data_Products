TMYlocationfile <- "http://rredc.nrel.gov/solar/old_data/nsrdb/1991-2005/tmy3/TMY3_StationsMeta.csv"
location_table <- read.csv(TMYlocationfile, header=TRUE)
location_table$location <- paste(location_table$State,location_table$Site.Name)
index <- order(location_table$location)
location_sorted <- location_table[index,]

solarRadiation <- function(location){
  location_USAF <- location_sorted$USAF[(location == location_sorted$location)]
#  location_USAF <- location
  file <- paste("http://rredc.nrel.gov/solar/old_data/nsrdb/1991-2005/data/tmy3/",location_USAF,"TYA.CSV",sep="")
#  print(file)
  table <- read.csv(file,header = TRUE, skip = 1)
  daily_sun <- tapply(0.001 * table$GHI..W.m.2., table$Date..MM.DD.YYYY., sum)
  return(daily_sun)
} 

shinyServer(
  function(input, output) {
    output$inputValue <- renderPrint({input$locationID})
    output$prediction <- renderPrint({summary(solarRadiation(input$locationID))})
    output$newHist <- renderPlot({
      hist(solarRadiation(input$locationID), xlab='daily radiation (kW/m2)', col='lightblue',main=input$location)
    })
  }
)
