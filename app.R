library(shiny)
library(readr)
library(plotly)


filepath <- "data/dummydata.csv"

df <- read_csv(filepath) %>% 
    mutate(Dates = lubridate::date(DateTime),
           Lawn = as.character(Lawn)
           ) %>% 
    select(-key)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Croquet Lawn Speeds"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("clubs",
                        label = "Select croquet club",
                        choices = unique(df$Club),
                        selected = first(df$Club)),
            div(
                p("Lawn speeds calculated as per ", a(href = "https://www.croquet.org.uk/?p=games/clubs/info/LawnSpeed", "Lawn Speed Calculations")
                )
            ),
            div(
                p(strong("Want your club's lawn speed data listed?")),
                p("Contact joebloggs@internet.com")
            )
        ),
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("speedPlot")
        )
    )
)

server <- function(input, output) {
    
    output$speedPlot <- renderPlot({
        
        # generate plot
        df %>% 
            ggplot(aes(x = Dates, y = speed, color = Lawn)) +
            geom_point() + geom_line()
        # # generate bins based on input$bins from ui.R
        # x    <- faithful[, 2]
        # bins <- seq(min(x), max(x), length.out = input$bins + 1)
        # 
        # # draw the histogram with the specified number of bins
        # hist(x, breaks = bins, col = 'darkgray', border = 'white')
        
    })
    
}

shinyApp(ui = ui, server = server)
