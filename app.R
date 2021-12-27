#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# https://www.clintzeagler.com/where-it-body-maps/
# https://commons.wikimedia.org/wiki/File:Langer%27s_lines_male_back_3d-shaded_lying.svg
# https://commons.wikimedia.org/wiki/File:Langer%27s_lines_female_front_3d-shaded.svg
# https://commons.wikimedia.org/wiki/File:Langer%27s_lines_female_back_3d-shaded.svg

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
           htmlOutput("bodymapSVG")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$bodymapSVG <- renderUI({
        
        ## -- Config --
        ## When to turn things yellow
        yellowThreshold = 0.75
        ## Color Scheme
        wearableColor = "#00FF50"
        warningColor = "yellow"
        unWearableColor = "red"

        
        ## Head
        headColor = wearableColor
        weightThreshold = 9
        if (input$weight >= weightThreshold) {
            headColor = unWearableColor    
        }
        else if (input$weight >= (weightThreshold * yellowThreshold) ) {
            headColor = warningColor    
        }
        
        ## Wrist
        wristColor = wearableColor
        weightThreshold = 0.5
        if (input$weight >= weightThreshold) {
            wristColor = unWearableColor    
        }
        else if (input$weight >= (weightThreshold * yellowThreshold) ) {
            wristColor = warningColor    
        }
        
        ## Feet
        footColor = wearableColor
        weightThreshold = 5
        if (input$weight >= weightThreshold) {
            footColor = unWearableColor    
        }
        else if (input$weight >= (weightThreshold * yellowThreshold) ) {
            footColor = warningColor    
        }
        
        
        return(HTML(paste0('
<svg width="609px" height="100vh" viewBox="0 0 609 1799" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <g id="Body" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="Male-Front" transform="translate(-76.000000, -2.000000)">
            <g id="Regions" transform="translate(77.000000, 2.000000)">
                <ellipse id="Head" fill="', headColor, '" cx="296.5" cy="36.5" rx="72.5" ry="36.5"></ellipse>
                <rect id="foot-l" stroke="#979797" fill="', footColor, '" x="100" y="1604" width="119" height="194"></rect>
                <rect id="foot-r" stroke="#979797" fill="', footColor, '" x="376" y="1604" width="119" height="194"></rect>
                <ellipse id="wrist-l" stroke="#979797" fill="', wristColor, '" cx="43.5" cy="834" rx="43.5" ry="46"></ellipse>
                <ellipse id="wrist-r" stroke="#979797" fill="', wristColor, '" cx="563.5" cy="834" rx="43.5" ry="46"></ellipse>
            </g>
        </g>
    </g>
</svg>
                    ')))
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
