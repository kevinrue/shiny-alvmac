library(shiny)
library(GOexpress)

alvmac.eSet = readRDS(file = "data/alvmac.eset.0h.rds")
gox.pval.subsetted = readRDS(file = "data/gox.pval.sub_manual.rds")

shinyServer(
    function(input, output) {
        
        # Compute the forumla text in a reactive expression since it is 
        # shared by the output$caption and output$mpgPlot expressions
        formulaText <- reactive({
            paste("Expression profile for ", input$external_gene_name)
        })
        
        # Return the formula text for printing as a caption
        output$caption <- renderText({
            formulaText()
        })
        
        # Generate a plot of the requested gene symbol by individual sample series
        output$exprProfiles <- renderPlot({
            expression_profiles_symbol(
                gene_symbol = input$external_gene_name,
                result = gox.pval.subsetted,
                eSet = alvmac.eSet,
                x_var = "Timepoint",
                seriesF = "Animal.Infection",
                subset = list(
                    Animal=input$animals,
                    Time=input$hours,
                    Infection=input$infection
                ),
                colourF = "Infection",
                #linetypeF = "Infection",
                line.size = input$linesize,
                index = input$index,
                xlab="Hours post-infection",
            )
        })
        
        # Generate a plot of the requested gene symbol by sample groups
        output$exprPlot <- renderPlot({
            expression_plot_symbol(
                gene_symbol = input$external_gene_name,
                result = gox.pval.subsetted,
                eSet = alvmac.eSet,
                x_var = "Timepoint",
                subset = list(
                    Animal=input$animals,
                    Time=input$hours,
                    Infection=input$infection
                ),
                index = input$index,
                xlab="Hours post-infection",
            )
        })
        
        # Turn the AnnotatedDataFrame into a data-table
        output$Adataframe <- renderDataTable(
            pData(alvmac.eSet),
            options = list(
                pageLength = 20)
        )
    }
)
