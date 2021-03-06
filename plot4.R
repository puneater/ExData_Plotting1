##############################################################

#  Loading the data


## downloading the zip file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "data.zip")

## checking the file
unzip("data.zip", list = TRUE)

## reading first hundred rows to check data and get classes for columns
xt<-read.table(unz("data.zip","household_power_consumption.txt"), nrows = 100, sep = ";", header = TRUE)
cl<-sapply(xt[1,], class)

## reading all the data
data <- read.table(unz("data.zip","household_power_consumption.txt"), colClasses = cl, sep = ";", header = TRUE, na.strings = "?")

## filtering out data forequired dates
reqdata <- data[data$Date %in% c("1/2/2007", "2/2/2007"),]

## releasing unrequired variables
rm(list = c("cl", "data", "xt"))

## merging the columns carrying date and time
reqdata$Date <- paste(reqdata$Date, reqdata$Time)

## converting the data type to POSIXlt
reqdata$Date <- strptime(reqdata$Date, format = "%d/%m/%Y %H:%M:%S")

## removing the Time column
reqdata <- reqdata[,c(1,3:ncol(reqdata))]

## renaming the Date column to DateTime
names(reqdata)[1] <- "DateTime"

##############################################################

# Plotting the fourth graph, carrying four plots


## creating first plot
par(mfcol = c(2,2))
par(mar = c(4,4,1,1))
par(oma = C(0,0,0,0))
with(reqdata, plot(DateTime,
			    Global_active_power,
			    type = "n",
			    ylab = "Global Active Power (kilowatts)",
			    xlab = "")
)
lines.default(reqdata$DateTime, reqdata$Global_active_power)

## creating second plot
with(reqdata, plot(DateTime, Sub_metering_3, type = "n", ylab = "Energy sub metering", xlab = "", ylim = c(0,50)))
lines.default(reqdata$DateTime, reqdata$Sub_metering_1)
lines.default(reqdata$DateTime, reqdata$Sub_metering_2, col = "red")
lines.default(reqdata$DateTime, reqdata$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = 1, box.lty = 0, xjust = 1, yjust = 0, y.intersp = 0.4)

##creating the third plot
with(reqdata, plot(DateTime,
			    Voltage,
			    type = "n",
			    xlab = "DateTime",
			    ylab = "Voltage")
)
lines.default(reqdata$DateTime, reqdata$Voltage)

##creating the fourth plot
with(reqdata, plot(DateTime,
			    Global_active_power,
			    type = "n",
			    xlab = "DateTime",
			    ylab = "Global_active_power")
)
lines.default(reqdata$DateTime, reqdata$Global_active_power)

## copying to a png file
dev.copy(png, file = "plot4.png", width = 480, height = 480)

##closing the device
dev.off()