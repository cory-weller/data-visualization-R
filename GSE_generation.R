#!/usr/bin/env Rscript

library(data.table)
library(ggplot2)
set.seed(4)
dat <- fread('gsea.tsv')
sets <- dat$NAME
dat <- data.table('gene_set' = sets)


v <- abs(rnorm(mean=5, sd=2, n=100000))
v <- sort(v[v <= 1])

dat[, p.adj := sample(v, size=nrow(dat))]
dat[, ratio := 2**rnorm(nrow(dat))]
dat[, log2ratio := log2(ratio)]

v <- floor(rnorm(10000, mean=2)**2)
dat[, size := sample(v[v>0], size=nrow(dat))]
fwrite(dat, file='enrichment.tsv', sep='\t')

dat[p.adj < 0.05]
ggplot(dat[p.adj < 0.05], aes(x=log2ratio, y=gene_set, size=size, color=-1*log10(p.adj))) + geom_point()


library(clusterProfiler)
data("gcSample") # data for examples

# Need to remove duplicates for the examples
all_genes <- unlist(gcSample)
universe <- all_genes[Biobase::isUnique(all_genes)] # all unique genes

# List with only unique genes
gcUnique <- lapply(gcSample, function(group_i) {
  group_i[group_i %in% universe]
})

# MSigDB R package
library(msigdbr)
msigdbr::msigdbr_collections() # available collections
# Subset to Human GO-BP sets
BP_db <- msigdbr(species = "Homo sapiens", 
                 category = "C5", subcategory = "GO:BP")
head(BP_db)

# Convert to a list of gene sets
BP_conv <- unique(BP_db[, c("entrez_gene", "gs_exact_source")])
BP_list <- split(x = BP_conv$entrez_gene, f = BP_conv$gs_exact_source)
# First ~6 IDs of first 3 terms
lapply(head(BP_list, 3), head)

## Cluster GO-BP ORA with fgsea package
library(fgsea)
library(dplyr)

# For each cluster i, perform ORA
fgsea_ora <- lapply(seq_along(gcUnique), function(i) {
  fora(pathways = BP_list, 
       genes = gcUnique[[i]], # genes in cluster i
       universe = universe, # all genes
       minSize = 15, 
       maxSize = 500) %>% 
    mutate(cluster = names(gcUnique)[i]) # add cluster column
}) %>% 
  data.table::rbindlist() %>% # combine tables
  filter(padj < 0.05) %>% 
  arrange(cluster, padj) %>% 
  # Add additional columns from BP_db
  left_join(distinct(BP_db, gs_subcat, gs_exact_source, 
                     gs_name, gs_description),
            by = c("pathway" = "gs_exact_source")) %>% 
  # Reformat descriptions
  mutate(gs_name = sub("^GOBP_", "", gs_name),
         gs_name = gsub("_", " ", gs_name))

# First 6 rows
head(fgsea_ora)

fwrite(fgsea_ora, file='ORA.tsv', sep='\t')
dat <- fread('ORA.tsv', select=c(9,3,5))
dat <- dat[order(padj)]

ps <- dat$padj
tmp <- data.table('log2ratio' = rnorm(length(ps)))
tmp[, absratio := abs(log2ratio)]

dat[, 'log2fc' := tmp[order(-absratio)]$log2ratio]
dat[, size := floor(6+size^1.3/20)]

fwrite(dat, file='GSE.tsv', sep='\t')

gs_order_ranked <- dat[order(log2fc)]$gs_name

dat[, gs_name := factor(gs_name, levels=gs_order_ranked)]

ggplot(dat, aes(x=log2fc, y=gs_name, size=size, color=-1*log10(padj))) +
geom_point()

