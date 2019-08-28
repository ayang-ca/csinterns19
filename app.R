install.packages('shiny')
install.packages('civis')
library(shiny)
library(dplyr)
library(civis)

#toy df
object_id = c(123, 456, 789)
object_type = c('job', 'notebook', 'workflow')
manager_id = c(111,222,333)
manager_username = c('jdoe', 'jsmith', 'jsmith')
managers_df1 = data.frame(object_id,object_type,manager_id,manager_username)

#a massive redshift table
my_table <- "selfserv_sharing.managers_shiny"
managers_df = read_civis(my_table, database="redshift-general")


ui <- fluidPage(
  titlePanel("Manager Finder"),
  sidebarLayout(numericInput("idInput", "Object ID", managers_df$object_id),
                radioButtons("typeInput", "Object type",choices = c('job','notebook','workflow',
                                                                    'template','project','report')
                               )),
    mainPanel(tableOutput('managers'),width = 500)
)

server <- function(input, output) {
  managers_df = read.csv('Downloads/manager_sample1.csv')
  tbl_filter = reactive({ managers_df %>% filter(object_id == input$idInput,
                                                 object_type==input$typeInput)
      })
  output$managers = renderTable({tbl_filter()})
}

shinyApp(ui = ui, server = server)


