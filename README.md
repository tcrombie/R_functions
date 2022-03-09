# R_functions
*a set of useful R functions for genomic analysis*

## checkDivergent Function
*An R function for checking whether loci are divergent in a set of strains.*

### Notes
This function uses `GenomicRange` and `IRanges` packages to look for intersections between user provided loci and the Andersen Lab `divegent_regions_strain.bed` file. Users can also specify which strains they would like to search within. Loci are passed in the form of a range `III:999124-999168`.

```r
# set parameters
strains <- c("JU310", "MY2693")
loci <- c("III:999129-999250", "II:999129-999250", "I:1208020-1208021", "I:1208024-1208025")
bedPath <- "data/divergent_regions_strain.bed"

# example run
run <- checkDiv(strains = strains, loci = loci, bedPath = bedPath)
```

