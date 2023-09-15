##
## Comment header including readme ----
##

# ScanToArtefacts.R
# 
# SPDX-FileCopyrightText: 2023 Orcro Limited <team@orcro.co.uk>
#
# SPDX-License-Identifier: Apache-2.0
# 
# This script converts raw ScanCode output into OpenChain compliant artefacts, 
# including relevant legal boilerplate, and verbatim licence texts, for a 
# permissively licensed project.
# 
# Authored by Alex of Orcro Limited <alexander.murphy@orcro.co.uk> see above for
# copyright assignment.

# README
# 
# This script is intended to be run from the command line in a "dumb" fashion 
# using Rscript. You will need an installation of R to run this command, and it 
# is assumed that a unix environment is being used. The command to run this 
# script from a shell looks like this:
# 
# $ Rscript ScanToArtefacts.R ScanOut.csv
# 
# Note that *ScanOut* should be replaced by the name of your own file!
# 
# This script is *not* fully feature, i.e., the output does not produce a source
# code archive as required by some copyleft licences. It is for exclusively 
# permissively licensed projects only.
# 
# The working directory should look like this after the script completes:
# 
# $ ls
# .
# ..
# Licensing_Overview.md
# Licensing_Appendix_1.md
# Licensing_Appendix_2.md
# ScanOut.csv
# ScanToArtefacts.R
# 
# The three files produced (Licensing_*) are the minimal artefacts required by 
# OpenChain. The overview contains a miniature SBOM, legal boilerplate, et 
# cetera. Appendix 1 contains the copyright notices. Appendix 2 contains 
# verbatim licence texts.
# 
# Please note, there may be other obligations under the open source licences,
# such as BSD-3-Clause no advertising, which is not acknowledged (nor required)
# in the produced artefacts.
# 
# The script requires an internet connection to function.

##
## End section ----
##


##
## Environment variables and setting start ----
## 

warnStatus <- getOption("warn")

options(warn = (-1))

artefactFileNames <- c("Licensing_Overview.md", 
                       "Licensing_Appendix_A.md", 
                       "Licensing_Appendix_B.md")

args <- commandArgs(trailingOnly = T)

##
## End section ----
## 


## 
## Message definitions start ----
## 

errorHeader <- "\n\x1b[31;1mError.\x1b[0m Detail:\n\n"
errorFooter <- "\n\n\x1b[31mteam@orcro.co.uk\x1b[0m\n\n"

#1
errorArgsNumber <- paste0(errorHeader, 
                         "The arguments are not specified correctly.",
                         "The command should look like this:\n\n\t", 
                         "Rscript ScanToArtefacts.R \x1b[36mScanOut\x1b[0m.csv", 
                         "\n\nReplace \x1b[36mScanOut\x1b[0m ", 
                         "with the name of your data file.", 
                         errorFooter)
#2
errorFileExists <- paste0(errorHeader, 
                         "An artefact output file(s) already exists. ", 
                         "To prevent data loss, move the existing file(s)", 
                         " out of this directory.", 
                         errorFooter)

#3
errorInputMissing <- paste(errorHeader, 
                          "The specified scan result file does not exist.",
                          errorFooter) 

successMessage <- paste0("\n\x1b[32;1mSuccess!\x1b[0m Detail:\n\n",
                        "No problems detected, compliance artefacts are now in",
                        " the working directory.\n\n")

## 
## End section ----
## 


##
# File Content Start ----
##

# The overview text here may be modified to suit a specific use-case

overviewText <- paste0("# Overview\n\nThis software contains a number of open source components. For a summary, see \n", 
                       "below. For the relevant licence texts, see Appendix A. For the relevant notices \n", 
                       "and attributions et cetera, see Appendix B.\n\n", 
                       "Not all components listed may be incorporated in, or may necessarily have \n", 
                       "generated derivative works which are incorporated in the firmware, but were \n", 
                       "used during the build process.\n\n", 
                       "Where a range of dates is given after a copyright notice, this should be taken \n", 
                       "to imply that copyright is asserted for every year within that range, inclusive \n", 
                       "of the years stated.\n\n", 
                       "## Components and Licences")

appendixAText <- "# Appendix A: Licence Texts"
appendixBText <- "# Appendix B: Notices and Attribution"

genericFileContent <- c(overviewText, appendixAText, appendixBText)

##
# File Content End ----
##   


##
# Function Definitions Start ----
##

outputFile <- function(fileText, fileName) {
    
    write(x = fileText, file = fileName)
    
}

dataPrep <- function(raw_sca) {
    
    # subset only relevant fields (1, 4, 20)
    # then delete empty rows (will have contained now-unnecessary data)
    
    out <- raw_sca[!(raw_sca$detected_license_expression_spdx == "" & 
                  raw_sca$copyright == ""), c(1, 4, 20)]
    
    out[out == ''] <- NA
    
    aggregate(. ~ path, data = out, FUN = na.omit, na.action = "na.pass")
    
}

generateOverviewText <- function(tidy_data) {
    
    # This is hard-coded for convenience as it is known these artefacts are for
    # a single library
    
    component_name <- "\n\nOpenBlas"
    
    out_licence <- "BSD-3-Clause"
    
    out <- paste(component_name, out_licence, sep = " - ")
    
    paste0(overviewText, out, "\n")
    
}

generateAppendixA = function(tidy_data) {
    
    # tidying list of licences
    l <- unlist(strsplit(unlist(tidy_data$detected_license_expression_spdx), " AND "))
    l <- unique(l)
    l <- l[l != "N/A"]
    l <- l[-grep("License", l)]
    l <- gsub("[\\(|\\)]", "", l)
    
    # setup urls for downloading
    first <- rep("https://raw.githubusercontent.com/spdx/license-list-data/master/text/", length(l))
    last <- rep(".txt", length(l))
    dls <- paste0(first, l, last)
    
    # local "out" is a buffer, if one dl fails, the script will abort and may 
    # leave artefacts
    out <- appendixAText
    
    # user info
    cat("\n\n Licence texts will now be downloaded...\n\n")
    Sys.sleep(2)
    
    for (l in dls) {
        download.file(l, destfile = "licence.tmp", 
                      method = "wget", 
                      quite = TRUE)
        out = paste0(out, "\n\n--------------------\n\n", 
                     readChar("licence.tmp", file.info("licence.tmp")$size))
        file.remove("licence.tmp")
    }
    
    cat("\n\n Removing temporary files...\n\n")
    Sys.sleep(2)
    
    out
}

generateAppendixB = function(tidy_data) {
    
    out <- appendixBText
    
    # sloppy! but...
    for (i in 1:nrow(tidy_data)) {
        entry <- paste0("\n\n---------------\n", 
                       "\nFile: ", tidy_data[i, 1],
                       "\nCopyright statement(s): ", tidy_data[i, 3])
        out <- paste0(out, entry)
    }
    
    out
}

generateArtefacts = function() {
    
    sca_data <- dataPrep(read.csv(args[1])) # tidy the data
    
    # generate the artefacts - there is some unnecessary moving of data around 
    # in memory, but this simplifies the script a bit (and it's sufficiently
    # performant anyway)
    
    outputFile(generateOverviewText(sca_data), "Licensing_Overview.md")
    outputFile(generateAppendixA(sca_data), "Licensing_Appendix_A.md")
    outputFile(generateAppendixB(sca_data), "Licensing_Appendix_B.md")
    
}

##
# Function Definitions End ----
##


##
# Program Logic Start ----
##

if (length(args) != 1) { # incorrect number of cli arguments?
    
    cat(errorArgsNumber)
    
} else if (any(artefactFileNames %in% dir())) { # any pre-existing output files?
    
    cat(errorFileExists)
    
} else if (file.exists(args)) { # does the input data exist?
    
    generateArtefacts()
    
    cat(successMessage)
    
} else {
    
    cat(errorInputMissing) # if input data doesn't exist
    
}

##
# Program Logic End ----
##


##
# Environment Cleanup ----
##

options(warn = warnStatus)

rm(args, artefactFileNames, warnStatus, generateArtefacts, outputFile)

##
# Environment Cleanup End ----
##
