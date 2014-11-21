## app.R

library(RCurl)
library(maps)
library(leaflet)


server <- function(input, output, session) {

	doc_url <- "https://docs.google.com/spreadsheets/d/1mzlXYuJ3RBdr_X94dhrHasndG1uoSD2VvjIq7nBDbaQ/export?gid=0&format=csv"
	doc_csv <- getURL(doc_url,.opts=list(ssl.verifypeer=FALSE))
	data <- read.csv(textConnection(doc_csv))

	map <- createLeafletMap(session, 'map')

	observe({
	    map$clearMarkers()
	   
		input$map_zoom

		for ( i in 1:nrow(data) ) {
		  	point <- data[i,]  
		   	map$addMarker(
		        point$Latitude,
		        point$Longitude,
		        point$Location,
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
