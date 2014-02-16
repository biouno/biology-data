# structureHarvester

[Website](http://users.soe.ucsc.edu/~dearl/software/structureHarvester/)

Python script to harvest data from STRUCTURE results folder

web example: http://taylor0.biology.ucla.edu/structureHarvester/completedJobs/H-5VV4-11WW-WCQB-XVZG/summary.html (till ~mar/2014)

## How to run

Running offline:

    structureHarvester.py --dir=../structure/out/ --out=out/ --clumpp

Sample output

-- cmd line output
root@chuva:/opt/structure-harvester# ./structureHarvester.py --dir=/tmp/structure/out/ --out=/tmp/structure/harvester-out/ --clumpp --evanno
Unable to perform Evanno method for the follow reason(s):
Stats: number of runs = 3, number of replicates = 1.00, minimum K tested = 1, maximum K tested = 3.
Test: You must test at least 3 values of K. PASS
Test: K values must be sequential. PASS
Test: The number of replicates per K > 1. FAIL
Test: Standard devation of est. Ln Pr(Data) is less than 0.0000001. FAIL for K = 2. The Evanno test requires division by the standard deviation of the est. Ln Pr(Data) values for all K between the first and last K value, and thus when the standard deviation is within Epsilon (0.000000) of zero we cannot perform the test. (Try running more replicates to hopefully increase the standard deviation for that value of  K.)