##Define global variables
data_file_name <- "data.zip"
file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

##Download data
if(!file.exists(data_file_name)){
    print("Downloading Data")
    download.file(file_url,data_file_name, mode = "wb")
}

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


##Have total emissions from PM2.5 decreased in the United States from 1999 to 
##2008? Using the base plotting system, make a plot showing the total PM2.5 
##emission from all sources for each of the years 1999, 2002, 2005, and 2008.
print("Aggregating Totals...")
aggregated_totals <- aggregate(Emissions ~ year,NEI, sum)

print("Plotting...")
png(filename="plot1.png", width = 480, height = 480)
barplot(aggregated_totals$Emissions, names.arg=aggregated_totals$year, 
        xlab="Year", ylab="PM2.5 Emissions", main="Total PM2.5 Emissions")
dev.off()