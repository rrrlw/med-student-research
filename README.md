# A tool to track medical student research output using Google Scholar
### Raoul R. Wadhwa, Bruce Spevak, Neil B. Mehta

### Cleveland Clinic Lerner College of Medicine of Case Western Reserve University

## Purpose

Tracking educational outcomes of medical students is important to ensure that they are receiving a quality education.
One relevant educational outcome in the field of academic medicine is research output during the medical school years.
Google Scholar provides a convenient central database that automatically updates as students publish their research.
This tool thus provides educators and education researchers with a straightforward method to track research outcomes for medical students.
Note that the functionality can easily be extended to track the research output of any member of academia with a Google Scholar profile.

## Getting Started

Once students have created Google Scholar profiles and provided their unique IDs, the collective data needs to be formatted in the style shown in the sample dataset, [Data.csv](https://github.com/rrrlw/med-student-research/blob/master/Data.csv).
The following lines of code can be typed into a Unix Terminal to collect cross-sectional data ([Data.csv](https://github.com/rrrlw/med-student-research/blob/master/Data.csv) file).

**N.B.** R and git need to be installed beforehand.

```
git clone https://github.com/rrrlw/med-student-research.git
cd med-student-research.git
Rscript collectPubs.R
Rscript collectProfiles.R
```

The code above should generate two CSV files:

* *Pubs.csv* contains the list of publications for the authors listed in *Data.csv* as shown on Google Scholar
* *Profiles.csv* contains the profile information (h-index, number of citations, etc.) for the authors listed in *Data.csv*, one line per author

## Reference Tools

This work used the following tools:

* [R programming language](https://www.R-project.org/)
* [scholar](https://CRAN.R-project.org/package=scholar) package for R
* [Google Scholar](https://scholar.google.com)