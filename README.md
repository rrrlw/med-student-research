# A tool to track medical student research output using Google Scholar

## Purpose



## Getting Started

The following lines of code can be typed into a Unix Terminal to collect cross-sectional data using the sample dataset provided ([Data.csv](https://github.com/rrrlw/med-student-research/blob/master/Data.csv) file).

**N.B.** you need to have R and git installed beforehand.

```
git clone https://github.com/rrrlw/med-student-research.git
cd med-student-research.git
Rscript collectPubs.R
Rscript collectProfiles.R
```

## Reference Tools

This work used the following tools:

* [R programming language](https://www.R-project.org/)
* [scholar](https://CRAN.R-project.org/package=scholar) package for R
* [Google Scholar](https://scholar.google.com)