# pindel

This is the MC3 TCGA implementation of `pindel`. See https://github.com/ucscCancer/mc3 for details.

The `pindel_wrapper` is based on code originally from https://testtoolshed.g2.bx.psu.edu/view/jeremie/pindel_test

Pindel documentation can be accessed at http://gmt.genome.wustl.edu/packages/pindel/quick-start.html

## Inputs
Required: `samtools` indexed bamfiles, the genome fasta that was used to create the bam files, and a list of tags (e.g. TUMOR and NORMAL). Samtools is present in the docker image and can be called as a command line tool.

For optional inputs, see the `pindel.cwl` file in this directory. 

## Outputs

Two [VCF format] (https://samtools.github.io/hts-specs/VCFv4.1.pdf) files and a raw output in pindel's own format. The output files can be named by the user, but the default VCF filenames are `out.vcf` and `somatic.vcf`. The `somatic.vcf` file is filtered from `out.vcf` by pindel.

## Notes

The MC3 TCGA workflow changed a few parameters from the pindel default settings, specifically:
```
--balance_cutoff is set to 0 instead of 100
--report_breakpoints True (pindel False)
--max_range_index: 4 instead of pindel's 2
--minimum_support_for_event 3 instead of 1

```
These defaults have been added to `pindel.cwl` as default settings. 

All pindel's options are available through `pindel.cwl` and the `pindel_wrapper`

The bam, bamindex, and tag inputs to the cwl workflow are arrays. Below is a JSON example of the input to these arrays
``` 
  "bamfile": [{
    "path": "/mnt/data/tumor.bam",
    "class": "File"
  },{
    "path": "/mnt/data/normal.bam",
    "class": "File"
  }],
  "tag": ["TUMOR", "NORMAL"],
  (...)
```

