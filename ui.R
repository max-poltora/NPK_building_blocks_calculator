library(shiny)
library(gtools)
library(Rsolnp)
library(shinythemes)

shinyUI(
tagList(
	fluidPage(
		tags$head(includeHTML(("google-analytics.html"))),
		theme=shinytheme("spacelab"),
		titlePanel("NPK building blocks calculator by UFCL"),
		sidebarLayout(sidebarPanel(
			h3("Enter desired values for N, P, K and S"),
			splitLayout(align="center",
				numericInput("N", "N", value=25),
				numericInput("P", "P", value=5),
				numericInput("K", "K", value=10),
				numericInput("S", "S", value=3)
			),
			h3("Enter volume in metric tons"),
			numericInput("vol", label=NULL, value=8000),
			actionButton("generate", "Click to find NPK combination", class = "btn-primary")
		),
		mainPanel(
			fluidRow(column(10,
				fluidRow(style='border: 1px solid grey; border-radius: 5px; background-color: #E2EFDA; margin-bottom: 1%',
					column(5, align="center", style='width: 50%', h4(strong("Two-component blend recipe 1")),
					tableOutput("table_1.1")),
					column(5, align="center", style='width: 50%', h4(strong("Chemical composition of the blend 1")),
					tableOutput("table_1.2"))
				),
				fluidRow(style='border: 1px solid grey; border-radius: 5px; background-color: #D9E1F2; margin-bottom: 1%',
					column(5, align="center", style='width: 50%', h4(strong("Two-component blend recipe 2")),
					tableOutput("table_2.1")),
					column(5, align="center", style='width: 50%', h4(strong("Chemical composition of the blend 2")),
					tableOutput("table_2.2"))
				),
				fluidRow(style='border: 1px solid grey; border-radius: 5px; background-color: #FCE4D6; margin-bottom: 1%',
					column(5, align="center", style='width: 50%', h4(strong("Two-component blend recipe 3")),
					tableOutput("table_3.1")),
					column(5, align="center", style='width:50%', h4(strong("Chemical composition of the blend 3")),
					tableOutput("table_3.2"))
				)
			))
		))
	)
)
)