# CLUMPP

[Website](http://www.stanford.edu/group/rosenberglab/clumpp.html)

CLUMPP is a program that deals with label switching and multimodality problems in population-genetic cluster analyses. CLUMPP permutes the clusters output by independent runs of clustering programs such as structure, so that they match up as closely as possible. The user has the option of choosing one of three algorithms for aligning replicates, with a tradeoff of speed and similarity to the optimal alignment. A program note describing CLUMPP was published in Bioinformatics 23: 1801-1806 (2007).

## How to run

Copy the output from structureHarvester for one value of K (we used K=2 randomly) and prepare the paramfile accordingly. Then 

    clumpp paramfile0 -o K2.popq
    clumpp paramfile2 -o K2.indivq