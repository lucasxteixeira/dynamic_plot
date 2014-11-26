## app.R

library(curl)
library(rCharts)
library(maps)
library(leaflet)
library(reshape2)



server <- function(input, output, session) {

	data <- read.csv(curl("https://docs.google.com/spreadsheets/d/1mzlXYuJ3RBdr_X94dhrHasndG1uoSD2VvjIq7nBDbaQ/export?gid=0&format=csv"))

	output$populationBarChart <- renderChart2({
	    nPlot(Population ~ City, data = data, type = "multiBarChart")
	})

	output$diseaseLineChart <- renderChart2({
	    diseaseLineChart <- rPlot(Pop_with_Heart_Diseases ~ City, data = data, type = 'line')
	    diseaseLineChart$guides(y = list(min = 0, title = "Population with Heart Diseases"))
	    return(diseaseLineChart)
	})

	output$diseaseBarChart <- renderChart2({
		nPlot(Obese_Population ~ Obese_Treament, group = "Country", data = data, type = "multiBarChart")
	})

	output$obeseDistributionChart <- renderChart2({
		obesityDistribution = melt(data[-c(1,3:8)], id.vars="City")
	    d1 = dPlot(y="City", x="value",data=obesityDistribution, groups="variable",type="bar")
		d1$xAxis(type = "addPctAxis")
		d1$yAxis(type = "addCategoryAxis")
		d1$legend( x = 60, y = 10, width = 700, height = 20, horizontalAlign = "left")
	    return(d1)
	})

	map <- createLeafletMap(session, 'map')

	observe({
	    map$clearMarkers()
	   
		input$map_zoom

		for ( i in 1:nrow(data) ) {
		  	point <- data[i,]  
		   	map$addMarker(
		        point$Latitude,
		        point$Longitude,
		        point$City,
		        list(
		          	awesome=list(
		            	icon=NULL, 
		            	markerColor="cadetblue"
		        	)
		       	)
		    )
		}
	})


}

ui <- shinyUI(fluidPage(
	titlePanel("Dynamic Plot"),
	fluidRow(
		h3("rCharts"),
		h5("Population bar chart:"),
		showOutput("populationBarChart", "nvd3"),
		h5("Population with heart diseases line chart:"),
		showOutput("diseaseLineChart", "polycharts"),
		h5("Obese treatement by country bar chart:"),
		showOutput("diseaseBarChart", "nvd3"),
		h5("Obesity distribution dimple:"),
		showOutput("obeseDistributionChart","dimple")
	),
	fluidRow(
		h3("leaflet-shiny"),
	   	leafletMap(
		    "map", "100%", "700px",
		    options=list(
		      	center = c(0, 0),
		      	zoom = 3,
		      	maxBounds = list(list(-85, -180), list(85, 180))
		    )
		)
   	)
))

shinyApp(ui = ui, server = server)
