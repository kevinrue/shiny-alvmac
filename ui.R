library(shiny)
library(GOexpress)

alvmac.eSet = readRDS(file = "data/alvmac.eset.0h.rds")

AlvMac.external_gene_name = readRDS(file = "data/external_gene_names.rds")

genes_choices <- sort(unique(AlvMac.external_gene_name))

animals_choices <- sort(unique(as.character(alvmac.eSet$Animal)))

hours_choices <- levels(alvmac.eSet$Time)

shinyUI(
    fluidPage(
        
        title = 'Alveolar macrophages shiny app',
        
        fluidRow(
            
            column(
                width = 12,
                sidebarLayout(
                    sidebarPanel(
                        selectInput(
                            inputId = "external_gene_name",
                            label = "Gene name:",
                            choices = genes_choices,
                            selected = "IRF1"),
                        
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
                            tabPanel(
                                "Expression profiles",
                                plotOutput("exprProfiles", width = "800px", height = "600px")
                            ), 
                            tabPanel(
                                "Expression plot",
                                plotOutput("exprPlot", width = "800px", height = "600px")
                            ),
                            tabPanel(
                                "Samples info",
                                dataTableOutput('Adataframe'))
                        )
                    ) #  end of mainPanel 
                    
                ) # end of sidebarLayout
                
            ) # end of columnn (12)
            
        ) # end of fluidRow
        
    ) # End of fluidPage
    
) # End of shinyUI
