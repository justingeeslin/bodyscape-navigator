#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library('plotrix')

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Bodymaps Navigator"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            # radioButtons("where", "Where it should be worn:",
            #              c(
            #                 "You tell me" = "undetermined",
            #                 "Head" = "head",
            #                 "Arm - Upper" = "norm",
            #                 "Arm - Lower" = "unif",
            #                 "Wrist" = "lnorm",
            #                 "Shoulders" = "Shoulders",
            #                 "Waist" = "exp"
            #                )
            #              ),
            sliderInput("weight",
                        "Weight (lbs):",
                        min = 0.1,
                        max = 20,
                        value = 5),
            sliderInput("size",
                        "Size (cm):",
                        min = 1,
                        max = 50,
                        value = 30),
            checkboxGroupInput("dataCollection", 
                               "Data Collection & Biometrics:",
                               c("Whole Body Motion" = "cyl",
                                 "Limb Motion" = "am",
                                 "Movement within Environment" = "gear",
                                 "Heart monitoring",
                                 "Blood Pressure"
                                 )
                                ),
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        plot(
            1:5,
            seq(1,25,length=5),
            type="n",
            xlab="",
            ylab="",
            main="Body Map",
            axes=FALSE, 
            frame.plot=FALSE,
            labels = FALSE
            )
        
        ## -- Config --
        ## When to turn things yellow
        yellowThreshold = 0.75
        ## Color Scheme
        wearableColor = "green"
        warningColor = "yellow"
        unWearableColor = "red"
        
        ## Circle examples
        # draw.circle(2,4,c(1,0.66,0.33),border="purple",
        #             col=c("#ff00ff","#ff77ff","#ffccff"),lty=1,lwd=1)
        # draw.circle(2.5,8,0.6,border="red",lty=3,lwd=3)
        # draw.circle(3.5,8,0.8,border="blue",lty=2,lwd=2)
        
        ## Head
        headColor = wearableColor
        weightThreshold = 9
        if (input$weight >= weightThreshold) {
            headColor = unWearableColor    
        }
        else if (input$weight >= (weightThreshold * yellowThreshold) ) {
            headColor = warningColor    
        }
        draw.circle(3,23.5,0.1,border=headColor,col=headColor,lty=1,
                    density=5,angle=30,lwd=10)
        
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
