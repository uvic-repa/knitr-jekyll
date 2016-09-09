# Generate sorted station data from raw data (env ca)
# each csv file has one station's data from 2004 to 2016 March
# each row is one hour observation
# one year has 365 days and each day has 24 observations
# Jon Duan 2016, UVic, department of Economics,
# ver1.0, 2016 Mar. 21
# install.packages("readxl")
# library("readxl")
# 
# 
if (!require("pacman")) install.packages("pacman")
pacman::p_load(dplyr, tidyr, readxl,knitr,ggplot2)

# start a function to calculate whole wind data for one station
compileWind=function(stationName= "BARNWELL AGDM"){

    # start from one year
    
    annualData=read.csv(paste("./2004/",stationName,"_2004_weather_data.csv",sep=''), stringsAsFactors=F)
    #str(annualData)
    #head(annualData)
    #annualData$Date=as.Date( paste( annualData$Month , annualData$Day , sep = "." )  , format = "%m.%d" )
    annualData$MonthDay <- paste( month.abb[annualData$Month], annualData$Day, sep="-" )
    annualData$WindSpdkm.h=as.numeric(as.character(annualData$WindSpdkm.h)) # !! first to character and set the numeric 
    # test code
    # annualWind=annualData %>%
    #   select(MonthDay, Time, WindSpdkm.h) 
    # head(annualWind)
    # not necessary, to generate extra data
    wholeWind=annualData %>%
      select(MonthDay,Time, `2004`=WindSpdkm.h) #select the variable by using backticks
    #head(wholeWind)
    # start to column bind next year
    # i=2006 # test one year data
    for (i in 2005:2016){
      annualData=read.csv(paste("./",i,"/",stationName,"_",i,"_weather_data.csv", sep=''))
      annualData$WindSpdkm.h=as.numeric(as.character(annualData$WindSpdkm.h))
      annualData$MonthDay <- paste( month.abb[annualData$Month], annualData$Day, sep="-" )
      # str(annualData)
      # head(annualData)
      annualWind=annualData %>%
        select(MonthDay,Time, WindSpdkm.h)
      names(annualWind)[3] = as.character(i) # simple method of rename
    # rename( "WindSpdkm.h2005" = WindSpdkm.h) does not work with number or in dplyr
      wholeWind=left_join(wholeWind, annualWind, by = c("MonthDay","Time"))
     # last time forgot to add ,sep=' '
      write.csv(wholeWind, paste(stationName,"_weather_data.csv", sep=' '))
    } 
} # end of compile wind
# 

# start loop all stations
newID=read.csv("newID02.csv")

for (i in 2:19) {
  compileWind(stationName= newID[i,"name"])
}




#remove(i)

