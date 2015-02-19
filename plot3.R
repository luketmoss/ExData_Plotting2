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


##Of the four types of sources indicated by the type (point, nonpoint, onroad, 
##nonroad) variable, which of these four sources have seen decreases in 
##emissions from 1999-2008 for Baltimore City? Which have seen increases in 
##emissions from 1999-2008? Use the ggplot2 plotting system to make a plot 
##answer this question.
print("Plotting...")
NEI_bal <- NEI[NEI$fips=="24510",]

png(filename="plot3.png", width = 480, height = 480)
ggp <- ggplot(NEI_bal,aes(factor(year),Emissions,fill=type)) +
    geom_bar(stat="identity") +
    guides(fill=FALSE) +
    theme_bw() + 
    labs(x="year", y="Total PM2.5 Emission (Tons)") +
    facet_grid(.~type,scales = "free",space="free") +  
    labs(title="PM2.5 Baltimore Emissions by Type")
print(ggp)
dev.off()