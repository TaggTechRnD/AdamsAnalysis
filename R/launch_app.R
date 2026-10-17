#' Launch AdamsAnalysis
#'
#' Opens the AdamsAnalysis Shiny application locally.
#'
#' @export
launch_app <- function() {

  ui <- shiny::fluidPage(
    shiny::titlePanel("AdamsAnalysis"),

    shiny::p("Welcome to AdamsAnalysis!"),

    shiny::sliderInput(
      "test", "Test slider:",
      min = 1, max = 10, value = 5
    ),

    shiny::textOutput("result")
  )

  server <- function(input, output, session) {

    output$result <- shiny::renderText({
      paste("Selected value:", input$test)
    })

  }

  shiny::runApp(
    shiny::shinyApp(ui, server),
    launch.browser = TRUE
  )
}
