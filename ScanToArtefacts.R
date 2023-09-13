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
## Environment variables and setting start ----
## 

warnStatus = getOption("warn")

options(warn = -1)

artefactFileNames = c("Licensing_Overview.md", 
                      "Licensing_Appendix_1.md", 
                      "Licensing_Appendix_2.md")

args = commandArgs(trailingOnly = T)

##
## End section ----
## 


## 
## Error message definitions start ----
## 

errorHeader = "\n\x1b[31;1mError.\x1b[0m Detail:\n\n"
errorFooter = "\n\n\x1b[31mteam@orcro.co.uk\x1b[0m\n\n"

#1
errorArgsNumber = paste0(errorHeader, 
                         "The arguments are not specified correctly.",
                         "The command should look like this:\n\n\t", 
                         "Rscript ScanToArtefacts.R \x1b[36mScanOut\x1b[0m.csv", 
                         "\n\nReplace \x1b[36mScanOut\x1b[0m ", 
                         "with the name of your data file.", 
                         errorFooter)
#2
errorFileExists = paste0(errorHeader, 
                         "An artefact output file(s) already exists. ", 
                         "To prevent data loss, move the existing file(s)", 
                         " out of this directory.", 
                         errorFooter)

#3
errorInputMissing = paste(errorHeader, 
                          "The specified scan result file does not exist.",
                          errorFooter) 

#all
errorMessages = c(errorArgsNumber, 
                  errorFileExists, 
                  errorInputMissing)


## 
## End section ----
## 


##
# File Content Start ----
##

overviewText = paste0("# Overview\n\nThis software contains a number of open source components. For a summary, see \n", 
                      "below. For the relevant licence texts, see Appendix A. For the relevant notices \n", 
                      "and attributions etc., see Appendix B.\n\n", 
                      "Not all components listed may be incorporated in, or may necessarily have \n", 
                      "generated derivative works which are incorporated in the firmware, but were \n", 
                      "used during the build process.\n\n", 
                      "Where a range of dates is given after a copyright notice, this should be taken \n", 
                      "to imply that copyright is asserted for every year within that range, inclusive \n", 
                      "of the years stated.\n\n", 
                      "## Components and Licences")

appendixAText = "# Appendix A: Licence Texts"
appendixBText = "# Appendix B: Notices and Attribution"

genericFileContent = c(overviewText, appendixAText, appendixBText)

##
# File Content End ----
##   


##
# Function Definitions Start ----
##

outputFile = function(fileText, fileName) {
    write(x = fileText, file = fileName)
}

generateOverviewText = function(softwareName, componentNames, licences) {
    
    dat = as.data.frame(cbind(softwareName, 
                              componentNames, 
                              licences))
    
    dat = split(dat, dat$softwareName)
    
    t = function(d) {
        header = paste0("\n\n### ", d[1, 1], "\n\n")
        
        rest = paste0(rep("Component: ", length(d[2])), 
                      unlist(d[2]), 
                      rep(" - Licence: ", length(d[3])), 
                      unlist(d[3]), 
                      rep("\n", 4), collapse = "")
        
        paste0(header, rest)
    }
    
    pre_out = lapply(dat, t)
    
    out = paste0(pre_out, collapse = "")
    
    paste0(overviewText, out)
}

generateArtefacts = function() {
    
    sca_data <- read.csv(args[1])
    
    sca_data <- sca_data[, c(1, 2, 4, 20)]
    
    print(names(sca_data))
    
    # data2 = read.csv(args[2])
    # 
    # outputFile(generateOverviewText(data[[1]], 
    #                                 data[[2]], 
    #                                 data[[4]]), 
    #            artefactFileNames[1])
    # 
    # outputFile(generateAppendixA(data[[4]], 
    #                              data[[8]]), 
    #            artefactFileNames[2])
    # 
    # outputFile(generateAppendixB(data2[[1]], 
    #                              data2[[19]], 
    #                              data2[[38]]), 
    #            artefactFileNames[3])
}

##
# Function Definitions End ----
##


##
# Program Logic Start ----
##

if (length(args) != 1) {
    cat(errorArgsNumber)
} else {
    generateArtefacts()
}

#if (length(args) != 2) {
#    cat(errorMessages[1])
#} else if (artefactFileNames %in% dir()) {
#    cat(errorMessages[2])
#} else if (file.exists(args)) {
#    generateArtefacts()
#} else {
#    cat(errorMessages[3])
#}

##
# Program Logic End ----
##


## 
## Testing and scratch ----
## 

#cat(errorArgsNumber)
#print("")
#cat(errorInputMissing)
#print("")
#cat(errorFileExists)

## 
## End section ----
## 


