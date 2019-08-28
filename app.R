install.packages('shiny')
install.packages('civis')
library(shiny)
library(dplyr)
library(civis)


ui <- fluidPage(
  titlePanel("Manager Finder"),
  sidebarLayout(numericInput("idInput", "Object ID", 0),
                radioButtons("typeInput", "Object type",choices = c("'job'","'notebook'","'workflow'",
                                                                    "'template'","'project'","'report','credential'")
                )),
  mainPanel(tableOutput('managers'),width = 500)
)

server <- function(input, output) {
  sqlInput = reactive({read_civis(sql(paste0('select * from selfserv_sharing.managers_shiny 
                         where managers_shiny.object_id =',input$idInput,'
                         and managers_shiny.object_type=',input$typeInput)), database = 'redshift-general')})
  
  output$managers = renderTable({sqlInput()})
}

options(shiny.sanitize.errors = TRUE)
shinyApp(ui = ui, server = server)



