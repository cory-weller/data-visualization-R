#!/usr/bin/env Rscript

library(data.table)
library(ggplot2)

dat <- fread('GSE.tsv')

gs_order_ranked <- dat[order(log2fc)]$gs_name

dat[, gs_name := factor(gs_name, levels=gs_order_ranked)]

ggplot(dat, aes(x=log2fc, y=gs_name, size=size, color=-1*log10(padj))) +
geom_point()
