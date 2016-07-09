# Tony O'Donoghue
# July 2016
#
# ui.R
#
# Linear Regression Application

library(shiny)
library(shinyjs)
library(corrplot)

Help.HTML <- paste(
    '<H1>Help for Linear Regression App</H1>',
    'This Linera Regression App allows the user to:<br/><br/>',
    '<ul><li>Create some random data by clicking <b>Generate Random Data</b></li>',
        '<li>Upload a text file containing numeric data with optional header by clicking <b>Choose File</b></li>',
        '<li>Displays data and user can perform linear regression.</li>',
    '</ul><br/>',
    'Before you upload a file or generate data you can limit the number of rows to between 2 and 1000 or the number ',
    'of columns to between 2 and 20.<br/>',
    'The absolute number of rows accepted is 1000 and the absolute number of columns accepted is 20.<br/>',
    'The text file can have an optional header (by ensuring the corresponding checkbox is checked), and the <u>data must be numeric</u>. N/A data is replaced by 0.<br/>',
    'The text file separator can be a comma, semicolan or a tab (specified by the radio button).',
    'Once the file is loaded or data generated, the user can view the data at the bottom of the <b>Main</b> tab.',
    '<br/>',
    '<br/>&nbsp;&nbsp;<b>Main Tab</b><br/>',
    'Displays the number of rows and number of columns of the data.<br/>',
    'To perform a linear regression follow these steps:',
    '<ul>',
    '<li>&nbsp;1. User must select  ONE or MANY independent/input variables from the drop-down</li>',
    '<li>&nbsp;2. User must select ONE variable as dependent/output variable from the drop-down</li>',
    '<li>&nbsp;3. User clicks on <b>Perform Linear Regression</b> button.</li>',
    '<li>&nbsp;4. Linear regression summary is then shown for the selected input/output variables.</li>',
    '<li>&nbsp;5. Correlation plot of all variables</li>',
    '</ul>',
    'Please note: when <b>Generate Random Data</b> is clicked or a file is uploaded, and the <b>Main</b> tab is clicked,',
    'please allow a few seconds before the data appears.'
    
)

shinyUI(fluidPage(
    tags$head(
        tags$style(HTML('#btnGenerate{background-color:#EEE}'))
    ),
    useShinyjs(),
    
    #This script is to clear the File upload HTML Element#
    tags$script('
        Shiny.addCustomMessageHandler("resetFileInputHandler", function(x) {   
                var el = $("#" + x);
                el.replaceWith(el = el.clone(true));
                var id = "#" + x + "_progress";     
                $(id).css("visibility", "hidden");
                });
                '),
    
    
  titlePanel("Linear Regression"),
  
  sidebarLayout(
    sidebarPanel(
      actionButton("btnGenerate", "Generate Random Data"),
      HTML("<br/> <b>Or upload a file ...</b></br/>"),
      fileInput('file1', 'Choose Text (CSV) File',
                accept=c('text/csv',
								 'text/comma-separated-values,text/plain',
								 '.csv')),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      numericInput("maxRows", "Limit Rows to:",500,2,1000,1),
      numericInput("maxCols", "Limit Cols to:",10,2,20,1)
    ),
    mainPanel(
        tabsetPanel(type = "tabs",
        tabPanel("Help",HTML(Help.HTML)
                    ),
        tabPanel("Main",
            textOutput('out_rowscols'),
            textOutput('Out_rand'),
            tags$hr(),
            uiOutput("independent_input"),
            uiOutput("dependent_output"),
            actionButton("btnLm", "Perform Linear Regression"),
            verbatimTextOutput('lmsummary'),
            HTML("<br/>"),
            plotOutput('corPlot'),
            tags$hr(),
    		tableOutput('contents')
        )
		
        )
    )
  )
  
))
