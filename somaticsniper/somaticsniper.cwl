#!/usr/bin/env cwl-runner
#
# Author: Jeltje van Baren jeltje.van.baren@gmail.com

cwlVersion: v1.0
class: CommandLineTool
baseCommand: []

doc: "Runs somatic sniper snp caller on input bam files"

hints:
  DockerRequirement:
    dockerPull: quay.io/jeltje/somaticsniper

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 8
    ramMin: 60000

inputs:
  
#bam-somaticsniper [options] -f <ref.fasta> <tumor.bam> <normal.bam> <snp_output_file>

  tumorbam:
    type: File
    doc: |
      tumor bamfile 
    inputBinding:
      position: 3

  normalbam:
    type: File
    doc: |
      normal bamfile 
    inputBinding:
      position: 4

  outfile:
    type: string
    doc: |
      Name of output file 
    inputBinding:
      position: 5

  refseq:
    type: File
    doc: |
      reference sequence in the FASTA format
    inputBinding:
      position: 2
      prefix: -f
    secondaryFiles:
      - .fai

  minmapqual:
    type: int?
    doc: |
         filtering reads with mapping quality less than [0]
    inputBinding:
      position: 2
      prefix: -q

  snvqual:
    type: int?
    doc: |
         filtering somatic snv output with somatic quality less than  [15]
    inputBinding:
      position: 2
      prefix: -Q

  noLOH:
    type: boolean?
    doc: |
        do not report LOH variants as determined by genotypes
    inputBinding:
      position: 2
      prefix: -L

  noGainOfRef:
    type: boolean?
    doc: |
        do not report Gain of Reference variants as determined by genotypes
    inputBinding:
      position: 2
      prefix: -G

  noSomaticPriors:
    type: boolean?
    doc: |
        disable priors in the somatic calculation. Increases sensitivity for solid tumors
    inputBinding:
      position: 2
      prefix: -p

  doPriors:
    type: boolean?
    doc: |
        Use prior probabilities accounting for the somatic mutation rate
    inputBinding:
      position: 2
      prefix: -J

  priorProb:
    type: float?
    doc: |
       prior probability of a somatic mutation (implies -J) [0.010000]
    inputBinding:
      position: 2
      prefix: -s

  theta:
    type: float?
    doc: |
       theta in maq consensus calling model (for -c/-g) [0.850000]
    inputBinding:
      position: 2
      prefix: -T

  numHaplotypes:
    type: int?
    doc: |
         number of haplotypes in the sample (for -c/-g) [2]
    inputBinding:
      position: 2
      prefix: -N

  haptypesPrior:
    type: float?
    doc: |
       prior of a difference between two haplotypes (for -c/-g) [0.001000]
    inputBinding:
      position: 2
      prefix: -r

  normalID:
    type: string?
    doc: |
      normal sample id (for VCF header) [NORMAL]
    inputBinding:
      position: 2
      prefix: -n

  tumorID:
    type: string?
    doc: |
      tumor sample id (for VCF header) [TUMOR]
    inputBinding:
      position: 2
      prefix: -t

  outputFormat:
    type: string?
    doc: |
      select output format from classic, vcf, or bed [classic]
    inputBinding:
      position: 2
      prefix: -F


outputs:

  mutations:
    type: File?
    outputBinding:
      glob: $(inputs.outfile)

