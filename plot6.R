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


##Compare emissions from motor vehicle sources in Baltimore City with emissions 
##from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
##Which city has seen greater changes over time in motor vehicle emissions?
print("Subsetting...")
#subset motor vehicles
vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]

#Subset emissions from Baltimore
bal_nei <- vehiclesNEI[vehiclesNEI$fips == 24510,]
bal_nei$city <- "Baltimore City"

#Subset emissions from LA
la_nei <- vehiclesNEI[vehiclesNEI$fips=="06037",]
la_nei$city <- "Los Angeles County"

#Bind Baltimore and LA
bal_la_nei <- rbind(bal_nei,la_nei)


#plot
print("Plotting...")
png(filename="plot6.png", width = 480, height = 480)
ggp <- ggplot(bal_la_nei, aes(x=factor(year), y=Emissions, fill=city)) +
    geom_bar(aes(fill=year),stat="identity") +
    facet_grid(scales="free", space="free", .~city) +
    guides(fill=FALSE) + 
    labs(x="year", y="Total PM2.5 Emission (Tons") + 
    labs(title="PM2.5 Baltimore & LA Motor Vehicle Emissions")
print(ggp)
dev.off()