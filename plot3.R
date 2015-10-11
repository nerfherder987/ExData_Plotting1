# Coursera Exploratory Data Analysis
# Course Project 1 - Plot3

# Name each of the plot files as plot1.png, plot2.png, etc.

# Create a separate R code file (plot1.R, plot2.R, etc.) that constructs the corresponding 
# plot, i.e. code in plot1.R constructs the plot1.png plot. 

# Import packages
packs <- c("dplyr","lubridate") # Character vector of packages to be imported
lapply(packs,library,character.only=T,logical.return=FALSE) # Import the packages 

# Set working directory
setwd("/home/Documents")

# Estimate memory needed for data file
# lines by columns multiplied by 8 bytes per column
est.size <- ((2075259*9)*8)/10^6
# About 150 MB

# Load data file as dplyr data table
data <- tbl_df(read.table("household_power_consumption.txt", 
                          header=TRUE, 
                          sep= ";", 
                          na.strings = c("?","")))
# Packages sqldf has a function that would allow me to read in only lines that match
# a given condition. Didn't go that route because my computer has sufficient memory to 
# handle a file this size without any preprocessing.

# Look at actual memory size of data object
format(object.size(data),units="MB")
# 126.8 MB

# Column names
names(data)
# [1] "Date"        "Time"         "Global_active_power"   "Global_reactive_power"
# [5] "Voltage"     "Global_intensity"      "Sub_metering_1"        "Sub_metering_2"       
# [9] "Sub_metering_3" 

### Clean up the data columns
data$dateTime <- paste(data$Date, data$Time) # make combined date/time column
# Convert to date format
data$dateTime <- strptime(data$dateTime, format = "%d/%m/%Y %H:%M:%S",tz="UTC")

# Format individual columns.
data$Date <- as.Date(data$Date, format = "%d/%m/%Y", tz="UTC")
data$Time <- as.character(data$Time)
# data$Time <- strptime(data$Time, format = "%H:%M:%S") # left time as character
# Kept adding system date ahead of the time. 

## Select only the data between the following dates:
## ymd_hms function is from the lubridate package
startDate <- ymd_hms("2007-02-01 00:00:00",tz="UTC")
endDate <- ymd_hms("2007-02-02 23:59:59",tz="UTC")

## Create subset that includes only observations from the specified dates
## Filter from dplyr didn't work for POSIXlt / POSIXt
data.sub <- data[data$dateTime >= startDate & data$dateTime <= endDate,]
# 2880 rows

# Construct the plot and save it to a PNG file with a width of 480 pixels 
# and a height of 480 pixels.

## Opens PNG
png('plot3.png',
    width=480,height=480,
    units='px',
    bg="transparent")

# Make graph
with(data.sub, plot(dateTime, Sub_metering_1, type = "n",ylim=c(0,38),
                    xlab="", ylab="Energy sub metering"))
with(data.sub, lines(dateTime, Sub_metering_1, type = "l", col="black"))
with(data.sub, lines(dateTime, Sub_metering_2, type = "l", col="red"))
with(data.sub, lines(dateTime, Sub_metering_3, type = "l", col="blue"))
legend("topright", lty=c(1,1), col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off() # close graphics device

# Your code file should include code for reading the data so that the plot can be fully 
# reproduced. You must also include the code that creates the PNG file. 

# Add the PNG file and R code file to the top-level 
# folder of your git repository (no need for separate sub-folders)