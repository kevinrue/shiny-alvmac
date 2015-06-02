# GOexpress (alvmac)
Example of a shiny app wrapped around the output object of the
[GOexpress](http://master.bioconductor.org/packages/devel/bioc/html/GOexpress.html)
Bioconductor package.

## GOexpress: Gene Ontology for expression data

GOexpress is a software package designed for the visualisation of gene
expression profiles, and the identification of robust molecular functions
(gene ontologies) associated with genes best clustering groups of
experimental samples.

### Visualisation

Gene expression profiles may be visualised for individual sample series,
summarised by groups of samples, or summarised by gene ontology. We
called those three types of plots 'expression\_profiles', 'expression\_plot',
and 'heatmap_GO', respectively.

### Scoring and ranking

The identification of interesting genes and gene ontologies is performed
using a supervised clustering approach called the random forest, subsequently
summarised at the gene ontology level by averaging the results of all genes
associated with a common ontology.

## Data

Here, we created a small app using the results of a study where we seeked
the genes and gene ontologies best clustering bovine alveolar macrophages
experimentally infected with _M. bovis_, _M. tuberculosis_, or negative
controls left uninfected.

To limit the size of this sample app, we first filtered out all gene
ontologies associated with fewer than 10 genes or more than 100 genes, and 
then all genes not annotated to any remaining gene ontologies.