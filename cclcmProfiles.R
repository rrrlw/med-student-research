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
scholar.data[scholar.data$Google.Scholar.ID == "v9UqDQAAAAJ", ]$Google.Scholar.ID <- "_v9UqDQAAAAJ"

#####PROCESSING#####
# save data into data frame
num.rows <- nrow(scholar.data)
profile.df <- data.frame(ID = scholar.data$Google.Scholar.ID,
                         Name = character(num.rows),
                         h.index = numeric(num.rows),
                         i10.index = numeric(num.rows),
                         total.cites = numeric(num.rows),
                         Class = scholar.data$Class.of)
profile.df$ID <- as.character(profile.df$ID)
profile.df$Name <- as.character(profile.df$Name)

# test code
vapply(X = 1:nrow(profile.df),
       FUN.VALUE = logical(1),
       FUN = function(i) {
         # get profile data from Google Scholar
         print(profile.df$ID[i])
         print(paste("Row", i, "out of", nrow(profile.df)))
         failed <- FALSE
         tryCatch(curr.prof <- get_profile(profile.df$ID[i]),
                  error = function(e) {failed <<- TRUE})
         if (failed) {
           profile.df$Name[i] <<- name.val(first = scholar.data$First.Name[i],
                                           middle = scholar.data$Middle.Name.or.Initial[i],
                                           last = scholar.data$Last.Name[i])
           
           return(FALSE)
         }
         print("Part 1")
         
         # store appropriate data into data frame
         profile.df$Name[i] <<- name.val(first = scholar.data$First.Name[i],
                                         middle = scholar.data$Middle.Name.or.Initial[i],
                                         last = scholar.data$Last.Name[i])
         print("Part 1.1")
         profile.df$h.index[i] <<- ifelse(length(curr.prof$h_index) == 0,
                                          0, curr.prof$h_index)
         print("Part 1.2")
         profile.df$i10.index[i] <<- ifelse(length(curr.prof$i10_index) == 0,
                                            0, curr.prof$i10_index)
         print("Part 1.3")
         profile.df$total.cites[i] <<- ifelse(length(curr.prof$total_cites) == 0,
                                              0, curr.prof$total_cites)
         print("Part 2")
         
         # print updates to screen
         cat("DONE WITH ", profile.df$Name[i], "\n", sep = "")
         
         print("Part 2.1")
         
         # return success value
         return(TRUE)
       }) -> temp # don't actually need to store

#####OUTPUT#####
write.table(x = profile.df,
            file = "CCLCMProfiles.csv",
            append = FALSE,
            col.names = TRUE,
            row.names = FALSE,
            sep = ",")
