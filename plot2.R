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


##Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
##(fips == "24510") from 1999 to 2008? Use the base plotting system to make a 
##plot answering this question.
print("Aggregating Totals...")
NEI_bal <- NEI[NEI$fips=="24510",]
agg_total_bal <- aggregate(Emissions ~ year, NEI_bal,sum)

print("Plotting...")
png(filename="plot2.png", width = 480, height = 480)
barplot(agg_total_bal$Emissions, names.arg=agg_total_bal$year, xlab="Year", 
        ylab="PM2.5 Emissions (Tons)", main="Total PM2.5 Emissions (Baltimore)")
dev.off()