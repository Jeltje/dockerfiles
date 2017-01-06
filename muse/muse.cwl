#!/usr/bin/env cwl-runner
#
# Author: Jeltje van Baren jeltje.van.baren@gmail.com

cwlVersion: v1.0
class: CommandLineTool
baseCommand: []

doc: "Runs MuSEv1.0rc SNP caller on split chromosomes (MuSE call) then creates final calls in VCF format (MuSE sump)"

hints:
  DockerRequirement:
    dockerPull: quay.io/jeltje/muse

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 8
    ramMin: 60000

inputs:
  mode:
    type: string
    doc: |
      Input is whole genome or exome {wgs,wxs}
    inputBinding:
      position: 2
      prefix: --mode

  input_tumor:
    type: File
    doc: |
      TUMOR_BAM
    inputBinding:
      position: 2
      prefix: --tumor-bam

  input_tumor_index:
    type: File
    doc: |
      TUMOR_BAM_INDEX
    inputBinding:
      position: 2
      prefix: --tumor-bam-index

  input_normal:
    type: File
    doc: |
      NORMAL_BAM
    inputBinding:
      position: 2
      prefix: --normal-bam

  input_normal_index:
    type: File
    doc: |
      NORMAL_BAM_INDEX
    inputBinding:
      position: 2
      prefix: --normal-bam-index

  refseq:
    type: File
    doc: |
     faidx indexed reference sequence file
    inputBinding:
      position: 2
      prefix: -f
    secondaryFiles:
      - .fai

  blocksize:
    type: int?
    doc: |
      Parallel Block Size (50000000)
    inputBinding:
      position: 2
      prefix: -b

  out_vcf:
    type: string
    default: "out.vcf"
    doc: |
      output file name
    inputBinding:
      position: 2
      prefix: -O

  dbsnp:
    type: File?
    doc: |
      uncompressed dbSNP vcf file (will be bgzip compressed and tabix indexed)
    inputBinding:
      position: 2
      prefix: -D

  ncpus:
    type: int?
    doc: |
      number of cpus (8) 
    inputBinding:
      position: 2
      prefix: --cpus

  workdir:
    type: string?
    doc: |
      working directory (./)
    inputBinding:
      position: 2
      prefix: --workdir

  no-clean:
    type: boolean?
    doc: |
      Flag, leave temporary output (default false)
    inputBinding:
      position: 2
      prefix: --no-clean

outputs:

  mutations:
    type: File
    outputBinding:
      glob: $(inputs.out_vcf)


