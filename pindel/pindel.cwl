#!/usr/bin/env cwl-runner
#
# Author: Jeltje van Baren jeltje.van.baren@gmail.com

cwlVersion: v1.0
class: CommandLineTool
baseCommand: []

doc: "pindel mutation calling"

hints:
  DockerRequirement:
    dockerPull: quay.io/jeltje/pindel

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 8
    ramMin: 60000

inputs:
  refseq:
    type: File
    doc: |
      the reference file
    inputBinding:
      position: 2
      prefix: -r

  refseqName:
    type: string?
    doc: |
      the reference name (genome)
    inputBinding:
      position: 2
      prefix: -R

## The following argument results in -b <bamfile1> -b <bamfile2> etc
  bamfile:
    type:
      type: array
      items: File
      inputBinding:
        prefix: -b
        separate: true
    inputBinding:
      position: 2

  bamindex:
    type:
      type: array
      items: File
      inputBinding:
        prefix: -bi
        separate: true
    inputBinding:
      position: 2

  tag:
    type:
      type: array
      items: string
      inputBinding:
        prefix: -t
        separate: true
    inputBinding:
      position: 2

# insertsizes are optional (will be calculated if not entered), the other arrays are not
# however, adding '?' to array crashes the runner code, so uncomment if needed
#  insertSize:
#    type:
#      type: array
#      items: int
#      inputBinding:
#        prefix: -s
#        separate: true
#    inputBinding:
#      position: 2

  rawoutput:
    type: string
    default: raw.pindel
    doc: |
      the raw output from pindel
    inputBinding:
      position: 2
      prefix: -o1

  out_vcf:
    type: string
    default: out.vcf
    doc: |
      the output vcf
    inputBinding:
      position: 2
      prefix: -o2

  out_filter_vcf:
    type: string
    default: somatic.vcf
    doc: |
      the output somatic filtered vcf
    inputBinding:
      position: 2
      prefix: -o3

  number_of_procs:
    type: int
    default: 8
    doc: |
      Number of CPUs, this is also the number of parallel pindel jobs that will be run
    inputBinding:
      position: 2
      prefix: --number_of_procs

  number_of_threads:
    type: int?
    doc: |
      the number of threads Pindel will use (default 2).
    inputBinding:
      position: 2
      prefix: --number_of_threads

  somatic_vaf:
    type: float?
    doc: |
      SOMATIC_VAF (default 0.08)
    inputBinding:
      position: 2
      prefix: --somatic_vaf

  somatic_cov:
    type: int?
    doc: |
      SOMATIC_COV (default 20)
    inputBinding:
      position: 2
      prefix: --somatic_cov

  somatic_hom:
    type: int?
    doc: |
      SOMATIC_HOM (default 6)
    inputBinding:
      position: 2
      prefix: --somatic_hom

  workdir:
    type: string?
    doc: |
      WORKDIR (default ./)
    inputBinding:
      position: 2
      prefix: --workdir

  no_clean:
    type: boolean?
    doc: |
      Leave intermediate files (default False)
    inputBinding:
      position: 2
      prefix: --no_clean

  max_range_index:
    type: int
    default: 4
    doc: |
      the maximum size of structural variations to be detected; the higher  this number, the greater the number of SVs reported, but the  computational cost and memory requirements increase, as does the rate  of false positives. 1=128, 2=512, 3=2,048, 4=8,092, 5=32,368,  6=129,472, 7=517,888, 8=2,071,552, 9=8,286,208. (maximum 9, pindel default 2, MC3 workflow setting 4)
    inputBinding:
      position: 2
      prefix: --max_range_index

  window_size:
    type: int?
    doc: |
      for saving RAM, divides the reference in bins of X million bases and  only analyzes the reads that belong in the current bin, (default 5  (=5 million))
    inputBinding:
      position: 2
      prefix: --window_size

  sequencing_error_rate:
    type: float?
    doc: |
      the expected fraction of sequencing errors (default 0.01)
    inputBinding:
      position: 2
      prefix: --sequencing_error_rate

  sensitivity:
    type: float?
    doc: |
      Pindel only reports reads if they can be fit around an event within a  certain number of mismatches. If the fraction of sequencing errors is  0.01, (so we'd expect a total error rate of 0.011 since on average 1  in 1000 bases is a SNP) and pindel calls a deletion, but there are 4  mismatched bases in the new fit of the pindel read (100 bases) to the  reference genome, Pindel would calculate that with an error rate of  0.01 (=0.011 including SNPs) the chance that there are 0, 1 or 2  mismatched bases in the reference genome is 90%. Setting -E to .90  (=90%) will thereforethrow away all reads with 3 or more mismatches,  even though that means that you throw away 1 in 10 valid reads.  Increasing this parameter to say 0.99 will increase the sensitivity  of pindel though you may get more false positives, decreasing the  parameter ensures you only get very good matches but pindel may not  find as many events. (default 0.95)
    inputBinding:
      position: 2
      prefix: --sensitivity

  maximum_allowed_mismatch_rate:
    type: float?
    doc: |
      Only reads with more than this fraction of mismatches than the  reference genome will be considered as harboring potential SVs.  (default 0.02)
    inputBinding:
      position: 2
      prefix: --maximum_allowed_mismatch_rate

  NM:
    type: int?
    doc: |
      the minimum number of edit distance between reads and reference  genome (default 2). reads at least NM edit distance (>= NM) will be  realigned
    inputBinding:
      position: 2
      prefix: --NM

  report_inversions:
    type: boolean?
    default: True
    doc: |
      report inversions (default true)
    inputBinding:
      position: 2
      prefix: --report_inversions

  report_duplications:
    type: boolean?
    default: True
    doc: |
      report tandem duplications (default true)
    inputBinding:
      position: 2
      prefix: --report_duplications

  report_long_insertions:
    type: boolean?
    doc: |
      report insertions of which the full sequence cannot be deduced  because of their length (default false)
    inputBinding:
      position: 2
      prefix: --report_long_insertions

  report_breakpoints:
    type: boolean
    default: True
    doc: |
      report breakpoints (pindel default false, MC3 workflow setting True)
    inputBinding:
      position: 2
      prefix: --report_breakpoints

  report_close_mapped_reads:
    type: boolean?
    doc: |
      report reads of which only one end (the one closest to the mapped  read of the paired-end read) could be mapped. (default false)
    inputBinding:
      position: 2
      prefix: --report_close_mapped_reads

  report_only_close_mapped_reads:
    type: boolean?
    doc: |
      do not search for SVs, only report reads of which only one end (the  one closest to the mapped read of the paired-end read) could be  mapped (the output file can then be used as an input file for another  run of pindel, which may save size if you need to transfer files).  (default false)
    inputBinding:
      position: 2
      prefix: --report_only_close_mapped_reads

  report_interchromosomal_events:
    type: boolean?
    doc: |
      search for interchromosomal events. Note: will require the computer  to have at least 4 GB of memory (default false)
    inputBinding:
      position: 2
      prefix: --report_interchromosomal_events

  IndelCorrection:
    type: boolean?
    doc: |
      search for consensus indels to corret contigs (default false)
    inputBinding:
      position: 2
      prefix: --IndelCorrection

  NormalSamples:
    type: boolean?
    doc: |
      Turn on germline filtering, less sensistive and you may miss somatic  calls (default false)
    inputBinding:
      position: 2
      prefix: --NormalSamples

  exclude:
    type: File
    doc: |
      If you want Pindel to skip a set of regions, please provide a bed  file here: chr start end
    inputBinding:
      position: 2
      prefix: --exclude

  additional_mismatch:
    type: int?
    doc: |
      Pindel will only map part of a read to the reference genome if there  are no other candidate positions with no more than the specified  number of mismatches position. The bigger the value, the more  accurate but less sensitive. (minimum value 1, default value 1)
    inputBinding:
      position: 2
      prefix: --additional_mismatch

  min_perfect_match_around_BP:
    type: int?
    doc: |
      at the point where the read is split into two, there should at least  be this number of perfectly matching bases between read and reference  (default value 3)
    inputBinding:
      position: 2
      prefix: --min_perfect_match_around_BP

  min_inversion_size:
    type: int?
    doc: |
      only report inversions greater than this number of bases (default 50)
    inputBinding:
      position: 2
      prefix: --min_inversion_size

  min_num_matched_bases:
    type: int?
    doc: |
      only consider reads as evidence if they map with more than X bases to  the reference. (default 30)
    inputBinding:
      position: 2
      prefix: --min_num_matched_bases

  balance_cutoff:
    type: int
    default: 0
    doc: |
      the number of bases of a SV above which a more stringent filter is  applied which demands that both sides of the SV are mapped with  sufficiently long strings of bases (pindel default 100, workflow setting 0)
    inputBinding:
      position: 2
      prefix: --balance_cutoff

  anchor_quality:
    type: int?
    doc: |
      the minimal mapping quality of the reads Pindel uses as anchor If you  only need high confident calls, set to 30 or higher(default 0)
    inputBinding:
      position: 2
      prefix: --anchor_quality

  minimum_support_for_event:
    type: int
    default: 3
    doc: |
      Pindel only calls events which have this number or more supporting  reads (Pindel default 1, MC3 workflow setting 3)
    inputBinding:
      position: 2
      prefix: --minimum_support_for_event

# Pindel requires an input file for this argument, but the pindel_wrapper wrongly implements this as a boolean
#  input_SV_Calls_for_assembly:
#    type: boolean?
#    doc: |
#      A filename of a list of SV calls for assembling breakpoints   Types: DEL, INS, DUP, INV, CTX and ITX   File format: Type chrA posA Confidence_Range_A chrB posB  Confidence_Range_B   Example: DEL chr1 10000 50 chr2 20000 100
#    inputBinding:
#      position: 2
#      prefix: --input_SV_Calls_for_assembly

  detect_DD:
    type: boolean?
    doc: |
      Flag indicating whether to detect dispersed duplications. (default:  false)
    inputBinding:
      position: 2
      prefix: --detect_DD

  MAX_DD_BREAKPOINT_DISTANCE:
    type: int?
    doc: |
      Maximum distance between dispersed duplication breakpoints to assume  they refer to the same event. (default: 350)
    inputBinding:
      position: 2
      prefix: --MAX_DD_BREAKPOINT_DISTANCE

  MAX_DISTANCE_CLUSTER_READS:
    type: int?
    doc: |
      Maximum distance between reads for them to provide evidence for a  single breakpoint for dispersed duplications. (default: 100)
    inputBinding:
      position: 2
      prefix: --MAX_DISTANCE_CLUSTER_READS

  MIN_DD_CLUSTER_SIZE:
    type: int?
    doc: |
      Minimum number of reads needed for calling a breakpoint for dispersed  duplications. (default: 3)
    inputBinding:
      position: 2
      prefix: --MIN_DD_CLUSTER_SIZE

  MIN_DD_BREAKPOINT_SUPPORT:
    type: int?
    doc: |
      Minimum number of split reads for calling an exact breakpoint for  dispersed duplications. (default: 3)
    inputBinding:
      position: 2
      prefix: --MIN_DD_BREAKPOINT_SUPPORT

  MIN_DD_MAP_DISTANCE:
    type: int?
    doc: |
      Minimum mapping distance of read pairs for them to be considered  discordant. (default: 8000)
    inputBinding:
      position: 2
      prefix: --MIN_DD_MAP_DISTANCE

  DD_REPORT_DUPLICATION_READS:
    type: boolean?
    doc: |
      Report discordant sequences and positions for mates of reads mapping  inside dispersed duplications. (default: false)
    inputBinding:
      position: 2
      prefix: --DD_REPORT_DUPLICATION_READS


outputs:

  output:
    type: File
    outputBinding:
       glob: $(inputs.out_vcf)

  raw_output:
    type: File
    outputBinding:
       glob: $(inputs.rawoutput)

  somatic_output:
    type: File
    outputBinding:
       glob: $(inputs.out_filter_vcf)
