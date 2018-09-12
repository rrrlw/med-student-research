#####SETUP#####
# utility function
name.val <- function(first, middle, last) {
  if (is.na(middle)) {
    return(paste(capitalize(tolower(first)),
                 capitalize(tolower(last))))
  } else {
    return(paste(capitalize(tolower(first)),
                 capitalize(tolower(middle)),
                 capitalize(tolower(last))))
  }
}

# load necessary libraries
suppressPackageStartupMessages(library("scholar"))
suppressPackageStartupMessages(library("R.utils"))

# data input
scholar.data <- read.csv("Data.csv",
                         stringsAsFactors = FALSE,
                         na.strings = c("", "NA"),
                         colClasses = c("character", "character",
                                        "character", "character",
                                        "integer", "character"))

# correct wrong IDs
if ("v9UqDQAAAAJ" %in% scholar.data$Google.Scholar.ID) {
  scholar.data[scholar.data$Google.Scholar.ID == "v9UqDQAAAAJ", ]$Google.Scholar.ID <- "_v9UqDQAAAAJ"
}
  
# open connection for data output and write header line
data.out <- file(description = "Pubs.csv", open = "w")
cat("title", "author", "journal", "number", "cites",
    "year", "cid", "pubid", "impactfactor", "eigenfactor",
    file = data.out, sep = ",", append = FALSE)
cat("\n", file = data.out, append = TRUE)

#####PROCESSING#####
# get data for each student in database and output to data.out connection
vapply(X = 1:nrow(scholar.data),
       FUN.VALUE = logical(1),
       FUN = function(curr.index) {
         # collect info from Google Scholar
         #curr.pubs <- get_publications(id = scholar.data$Google.Scholar.ID[curr.index],
         #                              pagesize = 100, flush = TRUE)
         curr.pubs <- tryCatch(get_publications(id = scholar.data$Google.Scholar.ID[curr.index],
                                                pagesize = 100, flush = TRUE),
                               error = function(e) {
                                 data.frame()
                               })
         
         # update that it's done
         cat(name.val(first = scholar.data$First.Name[curr.index],
                      middle= scholar.data$Middle.Name.or.Initial[curr.index],
                      last  = scholar.data$Last.Name[curr.index]),
             sep = "")
         
         # ignore if no publications
         if (nrow(curr.pubs) == 0) {
           cat("....NO PUBS OR WRONG ID\n")
           return(TRUE)
         }
         
         # add student name and date of data collection
         curr.pubs$Student <- name.val(first = scholar.data$First.Name[curr.index],
                                       middle= scholar.data$Middle.Name.or.Initial[curr.index],
                                       last  = scholar.data$Last.Name[curr.index])
         curr.pubs$Date <- Sys.Date()
         
         # add impact factor and eigenfactor
         impact <- get_impactfactor(journals = curr.pubs$journal, max.distance = 0.1)
         curr.pubs <- cbind(curr.pubs, impact$ImpactFactor, impact$Eigenfactor)
         #print(impact)
         
         # output data
         write.table(x = curr.pubs,
                     file = data.out,
                     append = TRUE,
                     sep = ",",
                     col.names = FALSE,
                     row.names = FALSE)
         
         cat("\n")
         
         # placeholder
         return(TRUE)
       }) -> temp
rm(temp)

close(data.out)
