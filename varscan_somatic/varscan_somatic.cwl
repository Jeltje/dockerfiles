#!/usr/bin/env cwl-runner
#
# Author: Jeltje van Baren jeltje.van.baren@gmail.com

cwlVersion: v1.0
class: CommandLineTool
baseCommand: []

doc: "Runs Varscan's SNP caller on mpileup inputs"

hints:
  DockerRequirement:
    dockerPull: quay.io/jeltje/varscan_somatic

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 8
    ramMin: 60000

inputs:
  min-coverage:
    type: int
    default: 3
    doc: |
      minimum coverage
    inputBinding:
      position: 2
      prefix: --min-coverage

  tumor_pileup:
    type: File
    doc: |
      input tumor pileup file
    inputBinding:
      position: 4

  normal_pileup:
    type: File
    doc: |
      input normal pileup file
    inputBinding:
      position: 3

  min-coverage-normal:
    type: int
    default: 8
    doc: |
      minimum coverage in the normal
    inputBinding:
      position: 2
      prefix: --min-coverage-normal

  min-coverage-tumor:
    type: int
    default: 6
    doc: |
      minimum coverage in the tumor
    inputBinding:
      position: 2
      prefix: --min-coverage-tumor

  min-var-freq:
    type: float
    default: 0.08
    doc: |
      minumum vaf for a variant
    inputBinding:
      position: 2
      prefix: --min-var-freq

  min-freq-for-hom:
    type: float
    default: 0.75
    doc: |
      minimum vaf to call a variant homozygous
    inputBinding:
      position: 2
      prefix: --min-freq-for-hom

  normal-purity:
    type: float
    default: 1.0
    doc: |
      normal purity
    inputBinding:
      position: 2
      prefix: --normal-purity

  tumor-purity:
    type: float
    default: 1.0
    doc: |
      tumor purity
    inputBinding:
      position: 2
      prefix: --tumor-purity

  p-value:
    type: float
    default: 0.99
    doc: |
      maximum p-value to call a variant
    inputBinding:
      position: 2
      prefix: --p-value

  somatic-p-value:
    type: float
    default: 0.05
    doc: |
      maximum p-value to call a somatic variant
    inputBinding:
      position: 2
      prefix: --somatic-p-value

  strand-filter:
    type: boolean
    default: False
    doc: |
      apply filter on strand bias
    inputBinding:
      position: 2
      prefix: --strand-filter

  validation:
    type: boolean
    default: False
    doc: |
      run in validation mode
    inputBinding:
      position: 2
      prefix: --validation

  jar-file:
    type: string?
    #default: "/opt/Varscan.jar"
    doc: |
      path to VarScan jar file
    inputBinding:
      position: 2
      prefix: --jar-file


outputs:

  snps:
    type: File
    outputBinding:
      glob: somatic_output.snp.vcf

  indels:
    type: File
    outputBinding:
      glob: somatic_output.indel.vcf

