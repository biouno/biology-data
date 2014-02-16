#Structure

[Website](http://pritchardlab.stanford.edu/structure.html)

The program structure is a free software package for using multi-locus genotype data to investigate population structure. Its uses include inferring the presence of distinct populations, assigning individuals to populations, studying hybrid zones, identifying migrants and admixed individuals, and estimating population allele frequencies in situations where many individuals are migrants or admixed. It can be applied to most of the commonly-used genetic markers, including SNPS, microsatellites, RFLPs and AFLPs.

## How to run

    mkdir out
    structure -i structure.infile -o out/output_2 -K 1
    structure -i structure.infile -o out/output_2 -K 2
    structure -i structure.infile -o out/output_3 -K 3