library(shiny)
library(GOexpress)

alvmac.eSet = readRDS(file = "data/alvmac.eset.0h.rds")
gox.pval.subsetted = readRDS(file = "data/gox.pval.sub_manual.rds")

shinyServer(
    function(input, output) {
        
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
        
        # Generate a heatmap of the requested GO identifier
        output$heatmap <- renderPlot({
            heatmap_GO(
                go_id = input$go_id,
                result = gox.pval.subsetted,
                eSet = alvmac.eSet,
                subset=list(
                    Time=input$hours.GO,
                    Infection=input$infection.GO
                    ),
                cexRow = input$cexRow.GO
            )
        })
        
        # Turn the AnnotatedDataFrame into a data-table
        output$Adataframe <- renderDataTable(
            pData(alvmac.eSet),
            options = list(
                pageLength = 20)
        )
        
        output$GOscores <- renderDataTable(
            gox.pval.subsetted$GO,
            options = list(
                pageLength = 20)
        )
        
        output$genesScore <- renderDataTable(
            gox.pval.subsetted$genes,
            options = list(
                pageLength = 20)
        )
    }
)
