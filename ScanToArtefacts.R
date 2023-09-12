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
## Testing section ----
## 

cat(errorArgsNumber)
print("")
cat(errorInputMissing)
print("")
cat(errorFileExists)


## 
## End section ----
## 


