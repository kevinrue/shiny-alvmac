library(shiny)
library(GOexpress)

# Load ExpressionSet
alvmac.eSet = readRDS(file = "data/alvmac.eset.0h.rds")
# Instead of the entire GOexpress result and annotations:
# Load the gene name annotations 
AlvMac.external_gene_name = readRDS(file = "data/external_gene_names.rds")
genes_choices <- sort(unique(AlvMac.external_gene_name))
default_gene = 'IRF1'
# Load the gene ontology annotations
go_choices = readRDS(file = 'data/go_choices.rds')
go_choices <- go_choices[sort(names(go_choices))]
default_go = go_choices[[1]]
# Prepare the individual animal choices
animals_choices <- sort(unique(as.character(alvmac.eSet$Animal)))
# Prepare the individual time-points choices
hours_choices <- levels(alvmac.eSet$Time)
# Maximal filter of minimal count of genes associated with a GO term
max.GO.total = 1E3

shinyUI(fluidPage(
    
    titlePanel("AlvMac sample app"),
    
    navlistPanel(
        widths = c(3, 9),
        
        "Genes",
        
        tabPanel(
            "Expression profiles",
            h3("Expression profiles"),
            sidebarLayout(
                sidebarPanel(
                    selectInput(
                        inputId = "external_gene_name",
                        label = "Gene name:",
                        choices = genes_choices,
                        selected = default_gene),
                    
                    checkboxGroupInput(
                        inputId = "animals",
                        label = "Animals:",
                        choices = animals_choices,
                        selected = animals_choices,
                        inline = TRUE),
                    
                    checkboxGroupInput(
                        inputId = "infection",
                        label = "Infection:",
                        choices = list(
                            "Control"="CN",
                            "M. tuberculosis"="TB",
                            "M. bovis"="MB"),
                        selected = c("CN", "TB", "MB"),
                        inline = TRUE),
                    
                    checkboxGroupInput(
                        inputId = "hours",
                        label = "Hours post-infection:",
                        choices = hours_choices,
                        selected = hours_choices[-1],
                        inline = TRUE),
                    
                    sliderInput(
                        inputId = "linesize",
                        label = "Line size",
                        min = 0,
                        max = 2,
                        value = 1.5,
                        step = 0.25
                    ),
                    
                    numericInput(
                        inputId = "index",
                        label = "Plot index: (0 for all plots)",
                        value = 0,
                        min = 0,
                        step = 1
                    )
                    
                ), # end of sidebarPanel
                
                mainPanel(
                    tabsetPanel(
                        type = 'pills',
                        tabPanel(
                            "Sample series",
                            plotOutput(
                                "exprProfiles",
                                width = "100%", height = "600px"
                            )
                        ), 
                        tabPanel(
                            "Sample groups",
                            plotOutput(
                                "exprPlot",
                                width = "100%", height = "600px"
                            )
                        )
                        
                    )
                    
                ) #  end of mainPanel
                
            ) # end of sidebarLayout
            
            
        ), # end of tabPanel
        
        tabPanel(
            "Scoring table",
            h3("Scoring table"),
            dataTableOutput('genesScore')
        ),
        
        "Gene ontologies",
        
        tabPanel(
            "Heatmap",
            h3("Heatmap"),
            sidebarLayout(
                sidebarPanel(
                    selectInput(
                        inputId = "go_id",
                        label = "GO id:",
                        choices = go_choices,
                        selected = default_go
                    ),
                    
                    checkboxGroupInput(
                        inputId = "hours.GO",
                        label = "Hours post-infection:",
                        choices = hours_choices,
                        selected = hours_choices,
                        inline = TRUE),
                    
                    checkboxGroupInput(
                        inputId = "infection.GO",
                        label = "Infection:",
                        choices = list(
                            "Control"="CN",
                            "M. tuberculosis"="TB",
                            "M. bovis"="MB"),
                        selected = c("CN", "TB", "MB"),
                        inline = TRUE),
                    
                    checkboxGroupInput(
                        inputId = "animal.GO",
                        label = "Animals:",
                        choices = animals_choices,
                        selected = animals_choices,
                        inline = TRUE),
                    
                    sliderInput(
                        inputId = "cexRow.GO",
                        label = "Row label size:",
                        min = 0.5,
                        max = 2,
                        value = 0.8,
                        step = 0.1
                    )
                    
                    
                ),
                mainPanel(
                    plotOutput(
                        "heatmap",
                        width = "100%", height = "700px"
                    )
                )
            )
            ),
        
        tabPanel(
            "Scoring table",
            h3("Scoring table"),
            fluidRow(
                column(width = 1,
                       numericInput(
                           inputId = "min.total",
                           label = "Min. total_count:",
                           min = 0,
                           max = max.GO.total,
                           value = 15
                       )
                ),
                column(width = 1,
                       numericInput(
                           inputId = "max.pval",
                           label = "Max. p.val:",
                           min = 0,
                           max = 1,
                           value = 0.05,
                           step = 0.001
                       )
                )
            ),
            dataTableOutput('GOscores')
            ),
        
        "-----",
        
        tabPanel(
            "Samples info",
            h3("Sample phenotypic information"),
            dataTableOutput('Adataframe')
        )
        
    )
))

