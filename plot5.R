##Define global variables
data_file_name <- "data.zip"
file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

##Download data
if(!file.exists(data_file_name)){
    print("Downloading Data")
    download.file(file_url,data_file_name, mode = "wb")
}

##Install and Load Library
if(!is.element("ggplot2", installed.packages()[,1])){
    print("Installing ggplot2 package")
    install.packages("ggplot2")
}
library(ggplot2)

##Unzip files
if(!file.exists("Source_Classification_Code.rds")){
    print("Unzipping Source_Classification_Code.rds...")
    unzip("data.zip",files="Source_Classification_Code.rds")
}

if(!file.exists("summarySCC_PM25.rds")){
    print("Unzipping summarySCC_PM25.rds...")
    unzip("data.zip",files="summarySCC_PM25.rds")
}

##Read the files
if(!exists("NEI")){
    print("Reading summarySCC_PM25.rds...")
    NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")){
    print("Reading Source_Classification_Code.rds...")
    SCC <- readRDS("Source_Classification_Code.rds")
}


##How have emissions from motor vehicle sources changed from 1999-2008 in 
##Baltimore City?
print("Subsetting...")
#subset motor vehicles
vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]

#subset baltimore motor vehicles
baltimoreVehiclesNEI <- vehiclesNEI[vehiclesNEI$fips==24510,]

#plot
print("Plotting...")
png(filename="plot5.png", width = 480, height = 480)
ggp <- ggplot(baltimoreVehiclesNEI,aes(factor(year),Emissions)) +
    geom_bar(stat="identity",fill="grey",width=0.75) +
    theme_bw() +  guides(fill=FALSE) +
    labs(x="year", y="Total PM2.5 Emission (in Tons)") + 
    labs(title="PM2.5 Baltimore Motor Vehicle Emissions")
print(ggp)
dev.off()