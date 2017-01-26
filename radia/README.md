# radia

This is the MC3 TCGA implementation of `radia` and `filterRadia`. See https://github.com/ucscCancer/mc3 for details.

Radia was partially rewritten for MC3, the original tool can be found at https://github.com/aradenbaugh/radia


## Inputs

Required: `samtools` indexed normal.bam and tumor.bam, the genome fasta that was used to create the bam files, and a patient ID. Samtools is present in the docker image and can be called as a command line tool.

These inputs are the same for both the `radia` and `filterRadia` wrappers. The `filterRadia` wrapper also takes the `radia` output vcf file.

For optional inputs, see the `cwl` files in this directory. 

## Outputs

[VCF format] (https://samtools.github.io/hts-specs/VCFv4.1.pdf) file

## Notes

Radia was designed to find mutations in short read data, specifically in combinations of exome (tumor and control) and RNA-seq (tumor), with an optional RNA-Seq file for the control sample. The MC3 TCGA implementation allows for all these inputs, but was actually run only on exome data. This is expected to lower Radia's specificity.

Radia and the filterRadia program are run using wrapper scripts. The `radia_wrapper` runs Radia on each input chromosome separately, then merges the files (this merge step is not part of the MC3 wrapper script radia.py). The `radia_filter_wrapper` also splits the input into chromosomes, then runs `filterRadia.py` and (when using the makeTCGAcompliant flag) significantly alters the VCF header and cleans up the body. It then runs radia's own `mergeChroms.py` script to merge the VCF files.

The MC3 TCGA workflow did not use several important `filterRadia.py` options, specifically:
- The blacklist bed files `--rnaGeneBlckFile --rnaGeneFamilyBlckFile --retroGenesDir --pseudoGenesDir`. These are used to remove any artifacts from the output data
- The whitelist bed files `--targetDir`. This restricts the (exome based) output to regions covered by the exome only. 

Not using these bed files is expected to reduce specificity.

The MC3 pipeline also did not include the VCF annotation options `--snpEffDir --dbSnpDir`. SnpEff predicts the effects of variants on genes (missense, silent, etc) and dbSNP is used to annotate known polymorphisms. The snpEff database is actually implemented in the Docker container and can be used.


All filterRadia options are implemented in the `radia_filter_wrapper` and can be used.
