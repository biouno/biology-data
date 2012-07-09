###############################################################################
# A simple script to plot summary graphs of a MrBayes execution. This script  #
# was adapted to be used in the BioUno [1] project.                           #
#                                                                             #
# The original script can be found at [2], written by Fredrik Ronquist.       #
#                                                                             #
# New features in this script:                                                #
#   -command line parsing                                                     #
#   -parameterized input file name                                            #
#   -parameterized number of runs                                             #
#   -parameterized number of chains                                           #
#   -parameterized working directory                                          #
#   -parameterized burn-in fraction value                                     #
#   -parameterized verbose output option                                      #
#   -one png file per graph, instead of a single pdf                          #
#                                                                             #
# [1] http://www.biouno.org                                                   #
# [2] http://people.sc.fsu.edu/~fronquis/mrbayes/                             #
#                                            RScript_SummarizeMrBayesFiles.r  #
#                                                                             #
# TODO: add a parameter that lets the user define the output format (PDF,     #
#       PDF, JPEG, ...)                                                       #
#                                                                             #
# @author: Brian P. Bourke                                                    #
# @author: Bruno P. Kinoshita <brunodepaulak@yahoo.com.br>                    #
# @see http://people.sc.fsu.edu/~fronquis/mrbayes/                            #
# @since 8-Jul-2012                                                           #
# @version 0.1                                                                #
###############################################################################

library("methods")
library("getopt")
library("optparse")

###############################################################################
# parse command line arguments                                                #
###############################################################################

option_list <- list (
  # input file name
  make_option(c("-i", "--input"), default="", metavar="input", 
              type="character", help="Input file. Usually 
              this file has no file extension (required)"),
  # burn-in fraction
  make_option(c("-b", "--burnin"), default=0.5, metavar="burnin", 
              type="double", help="Burn-in fraction. Default is %default"),
  # working directory
  make_option(c("-w", "--workingdirectory"), default="", 
              metavar="workingdirectory", type="character", 
              help=paste("Working directory (optional)")), 
  # number of runs
  make_option(c("-r", "--runs"), default=0, 
              metavar="runs", type="integer", 
              help=paste("Number of runs. Default is %default")),
  # number of chains
  make_option(c("-c", "--chains"), default=0, 
              metavar="chains", type="integer", 
              help=paste("Number of chains Default is %default")),
  # verbose output
  make_option(c("-v", "--verbose"), default=FALSE, metavar="verbose", 
              action="store_true", help="Outputs more information.
              Default is %default")
)
parser <-OptionParser(option_list=option_list)
args <- parse_args(parser, args = commandArgs(trailingOnly = TRUE), 
                   print_help_and_exit=TRUE, positional_arguments = FALSE)
# set input file name
if(nchar(args$input) <= 0) {
  print("Missing input file, aborting execution")
  quit("no")
}
input_root <- args$input
# set working directory
if(nchar(args$workingdirectory) > 0) {
  if(args$verbose) {
    print(paste("Setting working directory to ", args$workingdirectory))
  }
}
# set number of runs
numberofruns <- args$runs
# set number of chains
numberofchains <- args$chains
# set burn-in value
burninFrac <- args$burnin
# set verbose
verbose <- args$verbose

###############################################################################
# plot function                                                               #
###############################################################################

#general plotting function for MrBayes columns
plot_MrBayesStats<-function(x,y,xlabel="generations",ylabel,colour,burnin=0,
                            pasteMean=F,nameMean="mean =",pasteLast=F,
                            nameLast="last =",ylimited01=F){
  #shorten the data vectors if burnin is requested
  if (burnin>0){
    x<-x[burnin:length(x)]
    y<-y[burnin:length(y)]
  }
  if (ylimited01) {
    plot(x,y,type="p",xlab=xlabel,ylab=ylabel,col=colour,pch=20,ylim=c(0,1))
  } else plot(x,y,type="p",xlab=xlabel,ylab=ylabel,col=colour,pch=20)
  
  #if mean value should be pasted 
  # (adjust positioning in "text" function if necessary)
  if (pasteMean){
    addtext<-paste(nameMean,format(mean(y,na.rm=T),digits=2))
    text(x[length(x)-1],max(y)+0.2,labels=addtext,adj = c(1, 0))
  }
  if (pasteLast){
    addtext<-paste(nameLast,format(y[length(y)],digits=2))
    text(x[length(x)-1],0.5*max(y),labels=addtext,adj = c(1, 0))
  }
}

###############################################################################
# massaging and plotting mcmc file                                            #
###############################################################################

input_name<-paste(input_root,".mcmc",sep="")
if(verbose) {
  print(paste("Analysing MCMC file [", input_name, "]"))
}
mc2File<-read.table(file=input_name,header=T,comment.char="[",skip=6)
attach(mc2File)
skiplines<-burninFrac*length(mc2File[,1])

# plot!
if(verbose) {
  print(paste("Plotting MCMC file [", input_name, "] to generations.png"))
}
png("generations.png")
plot_MrBayesStats(Gen, AvgStdDev.s., xlabel="generations", 
                  ylabel="AvgStdDevSplitFreq", colour="black", burnin=0, 
                  pasteMean=F, nameMean="mean =", pasteLast=T, 
                  nameLast="final AvgStdDev =")
invisible(dev.off())

###############################################################################
# massaging and plotting LbL and LnL of run files                             #
###############################################################################

colour_vector <- gray(1:7/7)

for(i in seq(1, numberofruns, length=numberofruns)) {
  run_file_name <- paste(input_root, ".run",toString(i),".p",sep="")
  run_file <- read.table(file=run_file_name,header=T,comment.char="[")
  # LbL
  output_file <- paste("lbl_run",toString(i),"_graph",toString(i),
                       ".png",sep="")
  if(verbose) {
    print(paste("Plotting LbL of run file", toString(i), "to", output_file))
  }
  png(output_file)
  plot_MrBayesStats(run_file$Gen, run_file$LnL, 
                    ylabel=paste("LbL run", toString(i),sep=""), 
                    colour = colour_vector[2])
  invisible(dev.off())
  # LnL
  output_file <- paste("lnl_run",toString(i),"_graph",toString(i),
                       ".png",sep="")
  if(verbose) {
    print(paste("Plotting LnL of run file", toString(i), "to", output_file))
  }
  png(output_file)
  plot_MrBayesStats(run_file$Gen,run_file$LnL,
                    ylabel="LnL run1",colour=colour_vector[3],
                    burnin=skiplines)
  invisible(dev.off())
}

###############################################################################
# massaging and plotting chain files                                          #
###############################################################################

colour_vector <- gray(1:7/7)

left_chain <- NULL
right_chain <- NULL

for(r in seq(1, numberofruns, length=numberofruns)) {
  for(i in seq(1, numberofchains, length=numberofchains)) {
    next_value = i+1
    if(next_value <= numberofchains) {
      for(j in seq(next_value, numberofchains)) {
        output_file <- paste("chain_swaps_",toString(i),"_",toString(j),
                             "_run_",toString(r),".png",sep="")
        if(verbose) {
          print(paste("Plotting run", r, "chain swap file from", 
                      toString(i),"to",toString(j),"to file", output_file))
        }
        png(output_file)
        y_axis = eval(as.name(paste("Swap.",toString(i),"..",toString(j),
                                    "..acc.",toString(r),".", sep="")))
        plot_MrBayesStats(Gen,y_axis,ylabel="Chain swaps 1<->2 run 2",
                          colour=colour_vector[4], burnin=skiplines,
                          pasteMean=T,ylimited01=T)
        invisible(dev.off())
      }
    }
  }
}
