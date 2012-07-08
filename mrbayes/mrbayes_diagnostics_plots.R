
#######Only need to change this part########
setwd("C:/Users/Brian/Desktop/mrbayes")

input_root<-"Conc_strod_Gn_APRV_Run1" 

burninFrac<-0.5 
#############################################

input_name<-paste(input_root,".mcmc",sep="")
input_p1<-paste(input_root,".run1.p",sep="")
input_p2<-paste(input_root,".run2.p",sep="")

mc2File<-read.table(file=input_name,header=T,comment.char="[",skip=6)
attach(mc2File)

p1File<-read.table(file=input_p1,header=T,comment.char="[")
p2File<-read.table(file=input_p2,header=T,comment.char="[")


skiplines<-burninFrac*length(mc2File[,1])

#general plotting function for MrBayes columns
plot_MrBayesStats<-function(x,y,xlabel="generations",ylabel,colour,burnin=0,pasteMean=F,nameMean="mean =",pasteLast=F,nameLast="last =",ylimited01=F){
    #shorten the data vectors if burnin is requested
    if (burnin>0){
      x<-x[burnin:length(x)]
      y<-y[burnin:length(y)]
    }
    if (ylimited01) {
      plot(x,y,type="p",xlab=xlabel,ylab=ylabel,col=colour,pch=20,ylim=c(0,1))
    } else plot(x,y,type="p",xlab=xlabel,ylab=ylabel,col=colour,pch=20)
    
    #if mean value should be pasted (adjust positioning in "text" function if necessary)
    if (pasteMean){
        addtext<-paste(nameMean,format(mean(y,na.rm=T),digits=2))
        text(x[length(x)-1],max(y)+0.2,labels=addtext,adj = c(1, 0))
    }
    if (pasteLast){
      addtext<-paste(nameLast,format(y[length(y)],digits=2))
      text(x[length(x)-1],0.5*max(y),labels=addtext,adj = c(1, 0))
    }
}

windows(14,10,title="convergence diagnostics") #opens new graphics window of width 15 and height 10 inches
layout(matrix(c(1,1,0,0,2,3,4,5,6,6,7,7),4,3))

colourVector<-gray(1:7/7)   

plot_MrBayesStats(Gen,StdDev.s.,xlabel="generations",ylabel="AvgStdDevSplitFreq",colour="black",burnin=0,pasteMean=F,nameMean="mean =",pasteLast=T,nameLast="final AvgStdDev =")
              

plot_MrBayesStats(p1File$Gen,p1File$LnL,ylabel="LnL run1",colour=colourVector[2])
plot_MrBayesStats(p2File$Gen,p2File$LnL,ylabel="LnL run2",colour=colourVector[2])
plot_MrBayesStats(p1File$Gen,p1File$LnL,ylabel="LnL run1",colour=colourVector[3],burnin=skiplines)
plot_MrBayesStats(p2File$Gen,p2File$LnL,ylabel="LnL run2",colour=colourVector[3],burnin=skiplines)



plot_MrBayesStats(Gen,Swap.1.2..1.,ylabel="Chain swaps 1<->2 run 1",colour=colourVector[4],burnin=skiplines,pasteMean=T,ylimited01=T)
plot_MrBayesStats(Gen,Swap.1.2..2.,ylabel="Chain swaps 1<->2 run 2",colour=colourVector[4],burnin=skiplines,pasteMean=T,ylimited01=T)


