#!/usr/bin/env Rscript
library(tidyverse)

checkDivergent <- function(strains, loci, bedPath) {
  # import the divergent region bed file
  divDf <- data.table::fread(glue::glue("{bedPath}")) %>%
    dplyr::mutate(chrom = V1, start = V2, end = V3, strain = V4) %>%
    dplyr::filter(strain %in% strains)
  
  
  # convert to divDf to list of dGRanges objects of divergent regions for each strain
  divRange <- lapply(split(divDf, divDf$strain), function(i){
    GenomicRanges::GRanges(seqnames = i$chrom,
                           ranges = IRanges::IRanges(start = i$start,
                                                     end = i$end,
                                                     names = i$strain))
  })
  
  # make GRanges object for loci vector
  lociRange <- tibble::tibble(loci = loci) %>% # make a tibble of loci vector
    tidyr::separate(loci, into = c("chrom", "start", "stop")) %>% # breakup the loci format to bed format
    as(., "GRanges") # make it a GRanges object
  
  # look at intersection between loci and divergent regions for each strain
  intersectsGr <- lapply(divRange, function(i){
    GenomicRanges::intersect(x = i, y = lociRange) 
  })
  
  #pull out intersections
  intersectsDfList <- lapply(intersectsGr, function(i){
    locus <- as.character(i)
    out <- data.table::data.table(locus = locus)
    return(out)
  })
  
  ## bind divergent intersects to Df
  intersectsDf <- dplyr::bind_rows(intersectsDfList, .id = 'strain') %>%
    tidyr::separate(locus, into = c("chrom", "start", "end"), remove = F) %>%
    dplyr::mutate(divergent = T) %>%
    dplyr::select(chrom, start, end, locus, strain, divergent)
  
  # output
  return(intersectsDf)
}

#=================================================#
# example
#=================================================#
# # set working directory
# setwd(glue::glue("{dirname(rstudioapi::getActiveDocumentContext()$path)}/.."))
# 
# # set parameters
# strains <- c("JU310", "MY2693")
# loci <- c("III:999129-999250", "II:999129-999250", "I:1208020-1208021", "I:1208024-1208025")
# bedPath <- "data/divergent_regions_strain.bed"

# example run
#run <- checkDiv(strains = strains, loci = loci, bedPath = bedPath)
