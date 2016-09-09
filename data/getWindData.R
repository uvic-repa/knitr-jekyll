
# ftp://ftp.tor.ec.gc.ca/Pub/Get_More_Data_Plus_de_donnees/
# we can get the list of station id, logitude, location,
# ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Historical_Publications/Wind_energy_map

#install.packages("readxl")
# library("readxl")
# sID <- read_excel("CCDST/TownID.xlsx")
# str(sID)
# 
# 
# envCaID <- read.csv("CCDST/can-weather-stations.csv")
# head(envCaID)
# sID$name=toupper(sID$Name)
# 
# install.packages("dplyr")
# library("dplyr")
# newID <- left_join(sID,envCaID,by="name")
# #glimpse(newID)
# #View(newID)
# write.csv(newID,"newID.csv")

# some station ID missing in webid file. And then manually add them in.

setwd("H:/Dropbox/Research/data")
staID <- read.csv("newID.csv")

head(staID)

#Station names
# Some stations have acronyms after the station name. The most common acronyms are:
#   
#   RS 每 ranger station
# LO 每 lookout tower
# AFS 每 Alberta Forestry Service (the former name of what is now part of Alberta Sustainable Resource Development)
# A 每 airport
# CDA 每 Canada Department of Agriculture (the former name of Agriculture and Agri-Food Canada)
# AGDM 每 Agricultural Drought Monitoring station.

# start off new function for data scraping
getWindData = function(day1 = '2009-10-01', 
                       day2 = '2016-03-10',
                       stationID = 42729,
                       stationName = 'Raymond'){
  
  #-----------------
  # Dependencies:
  #-----------------
  #install.packages(c("lubridate","XML"),repos="http://cran.rstudio.com")
  
  
  library(lubridate)
  library(XML)
  
  ############################
  # HOURLY WEATHER DOWNLOADS #
  ############################
  # Things you need to change for each station:
  location_url = paste("Prov=AB&StationID=",stationID,"&hlyRange=2008-01-08%7C",day2,sep='')   # 
  #day1 = day1
  #day2 = day2
  #--------------------day1 and day1 inside the hlyRange=2010-10-01%7C2013-03-11
  
  # Things that don't need to be changed: (make a date vector)
  start = strptime(day1, format = '%Y-%m-%d')
  end = strptime(day2, format = '%Y-%m-%d')
  days = seq(start, end, 'days')
  
  weather_data = c()
  for (i in 1:length(days)){
    year =  year(days[i])
    month = month(days[i])
    day = day(days[i])
    
    preamb = 'http://climate.weather.gc.ca/climateData/hourlydata_e.html?timeframe=1&'
    start_url = paste('http://climate.weather.gc.ca/climateData/hourlydata_e.html?timeframe=1&',location_url,'&cmdB1=Go&Year=', sep = '')
    mid_url = '&Month='
    mid2_url = '&Day='
    end_url = "&cmdB1=Go#"
    url = paste(start_url, year, mid_url, month, mid2_url, day, end_url, sep = '')
    
    # read xml table from website
    data = readHTMLTable(url)
    data = data.frame(data[2])
    data = data[-1,]
    # solve missing data problem
    if (is.factor(data)){
      # generate NA dataframe for missing data day, for example 2010/11/25
      data=data.frame(matrix(data=NA,nrow=24,ncol = 11))
      data[,1] = 0:23  
    }else{
      
      # Fix dumb time 'Legend add-on
      data[,1] = matrix(unlist(strsplit(as.character(data[,1]), ':', fixed = T)),ncol = 2,byrow = T)[,1]
    }
    # add last four columns
    data$Year = year
    data$Month = month
    data$Day = day
    data$StationName = stationName
    # change colname
    colnames(data) = c("Time", 'TempC', 'DewTempC', 'RelH', 'WindDir', "WindSpdkm.h", "Visibilitykm","PresskPa", "Hmdx", "WindChill", "Weather","Year","Month","Day","stationName")
    # Collate Data
    weather_data = rbind(weather_data,data)  
  }
  
  # This you may want to change: 
  
  # Write .csv using paste(stationName, "_2008_16weather_data.csv", sep='')
  write.csv(weather_data,paste(stationName, "_",strsplit(day1, '-', fixed = T)[[1]][1],"_weather_data.csv", sep=''), row.names = F)
  
  # Thats all ...
}      

# error message, unable to access the data


# factor(0)
# Levels: We're sorry we were unable to satisfy your request.\r\n        The data is either missing, invalid, or subject to review.\r\n        As an alternative,        Hourly data between June 16 2004 and March 18 2016\n          Daily data between June 2004 and March 2016\n          Monthly data between 2004 and 2007


#tail(weather_data,100)
#
# it shows that 2010    11  25 does not have data, so it cause error.
# example:

# if (!require(XML)) install.packages('XML')
# library(XML)
getWindData(day1 = '2015-10-01', 
            day2 = '2016-03-10',
            stationID = 31408,
            stationName = 'Barnwell AGDM')

getWindData(day1 = '2010-11-01', 
            day2 = '2012-01-18',
            stationID = staID[2,"webid"],
            stationName = as.character(staID[2,"name"]))

for(i in 1:nrow(staID)){
  getWindData(day1 = '2008-03-01', 
              day2 = '2009-03-01',
              stationID = staID[i,"webid"],
              stationName = as.character(staID[i,"name"]))
}

for(i in 1:nrow(staID)){
  getWindData(day1 = '2009-01-01', 
              day2 = '2009-12-31',
              stationID = staID[i,"webid"],
              stationName = as.character(staID[i,"name"]))
}


for(j in 2011:2015){
  for(i in 1:nrow(staID)){
    getWindData(day1 = paste(j,"-01-01", sep = ''), 
                day2 = paste(j,"-12-31", sep = ''),
                stationID = staID[i,"webid"],
                stationName = as.character(staID[i,"name"]))
  }
}
# x = sapply(x, function(xx) as.numeric(gsub('[^0-9]', '', xx)))