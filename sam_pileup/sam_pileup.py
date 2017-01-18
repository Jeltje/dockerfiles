#! /usr/bin/python

# This tool is based on source: https://github.com/ucscCancer/mc3

"""
Creates a pileup file from a bam file and a reference.

usage: %prog [options]
   -p, --input1=p: samtools indexed bam file
   -o, --output1=o: Output pileup
   -O, --outputdir=O: Output pileup directory
   -g, --genome=g: Path of the indexed reference genome
   -s, --lastCol: Print the mapping quality as the last column
   -i, --indels: Only output lines containing indels
   -M, --mapqMin=i: Filter reads by min MAPQ
   -B, --nobaq: disable BAQ computation
   -c, --consensus: Call the consensus sequence using MAQ consensus model
   -T, --theta=T: Theta parameter (error dependency coefficient)
   -N, --hapNum=N: Number of haplotypes in sample
   -r, --fraction=r: Expected fraction of differences between a pair of haplotypes
   -I, --phredProb=I: Phred probability of an indel in sequencing/prep
   -C, --cpus=C: Number of CPUs to use (8)
   -w, --workdir=w: Working directory

"""

import os, shutil, subprocess, sys, tempfile
from multiprocessing import Pool
from functools import partial
from bx.cookbook import doc_optparse

def stop_err( msg ):
    sys.stderr.write( '%s\n' % msg )
    sys.exit()


def get_bam_seqs(inputBamFile, min_size=1):
	cmd = "samtools idxstats %s" % (inputBamFile)
	process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
	stdout, stderr = process.communicate()
	seqs = []
	for line in stdout.split("\n"):
		tmp = line.split("\t")
		if len(tmp) == 4 and int(tmp[2]) >= min_size and tmp[0] not in ['*']:
			seqs.append(tmp[0])
	return seqs

def run_cmd(cmd, tmpDir):
    tmp = tempfile.NamedTemporaryFile( dir=tmpDir ).name
    tmp_stderr = open( tmp, 'wb' )
    print "Running", cmd
    proc = subprocess.Popen( args=cmd, shell=True, cwd=tmpDir, stderr=tmp_stderr.fileno() )
    returncode = proc.wait()
    tmp_stderr.close()
    #did it succeed?
    # get stderr, allowing for case where it's very large
    tmp_stderr = open( tmp, 'rb' )
    stderr = ''
    buffsize = 1048576
    try:
        while True:
            stderr += tmp_stderr.read( buffsize )
            if not stderr or len( stderr ) % buffsize != 0:
                break
    except OverflowError:
        pass
    tmp_stderr.close()
    return (returncode, stderr)

def __main__():
    #Parse Command Line
    options, args = doc_optparse.parse( __doc__ )
    # output version # of tool
    try:
        tmp = tempfile.NamedTemporaryFile().name
        tmp_stdout = open( tmp, 'wb' )
        proc = subprocess.Popen( args='samtools 2>&1', shell=True, stdout=tmp_stdout )
        tmp_stdout.close()
        returncode = proc.wait()
        stdout = None
        for line in open( tmp_stdout.name, 'rb' ):
            if line.lower().find( 'version' ) >= 0:
                stdout = line.strip()
                break
        if stdout:
            sys.stdout.write( 'Samtools %s\n' % stdout )
        else:
            raise Exception
    except:
        sys.stdout.write( 'Could not determine Samtools version\n' )
    #prepare file names
    if options.workdir is None:
        tmpDir = tempfile.mkdtemp()
    else:
        tmpDir = tempfile.mkdtemp(dir=options.workdir)
    tmpf0 = tempfile.NamedTemporaryFile( dir=tmpDir )
    tmpf0_name = tmpf0.name
    tmpf0.close()
    tmpf0bam_name = '%s.bam' % tmpf0_name
    tmpf0bambai_name = '%s.bam.bai' % tmpf0_name
    tmpf1 = tempfile.NamedTemporaryFile( dir=tmpDir )
    tmpf1_name = tmpf1.name
    tmpf1.close()

    if options.outputdir is None or options.outputdir == './':
        options.outputdir = './'
    else:
        os.mkdir(options.outputdir)

    if not options.output1:
        raise Exception, "please add output filename --output1"
    outfile = os.path.join(os.path.abspath(options.outputdir), options.output1)
    #link bam and bam index to working directory (can't move because need to leave original)
    bamIndex = options.input1 + '.bai'
    if not os.path.exists(bamIndex):
        raise Exception, "cannot find bam index %s, please run samtools idx" % bamIndex
    os.symlink( os.path.abspath(options.input1), tmpf0bam_name )
    os.symlink( os.path.abspath(bamIndex), tmpf0bambai_name )
    #get parameters for pileup command
    if options.lastCol:
        lastCol = '-s'
    else:
        lastCol = ''
    if options.indels:
        indels = '-i'
    else:
        indels = ''
    #opts = '%s %s -M %s' % ( lastCol, indels, options.mapCap )
    opts = ''
    if options.nobaq:
        opts += " -B "
    if options.consensus:
        if not (options.theta and options.hapNum and options.fraction and options.phredProb):
            raise Exception, "When using the consensus option, you must set theta, hapNum, fractions and predProb"
        opts += ' -c -T %s -N %s -r %s -I %s' % ( options.theta, options.hapNum, options.fraction, options.phredProb )
    if options.mapqMin:
        opts += ' -q %s' % (options.mapqMin)
    #prepare basic pileup command
    cmd = 'samtools mpileup %s %s -f %s %s > %s'
    cmd_list = None
    outfiles = []
    try:
        # have to nest try-except in try-finally to handle 2.4
        try:
            #index reference if necessary and prepare pileup command
            if not os.path.exists( "%s.fai" % options.genome ):
                raise Exception, "Indexed genome %s not present, please run samtools faidx." % options.genome
            cmd_list = []
            genoseqs = get_bam_seqs(tmpf0bam_name, 0)
            for seq in genoseqs:
                outpileup = os.path.join(os.path.abspath(tmpDir), seq + '.mpileup')
                cmd_list.append( cmd % ( opts, "-r %s" % (seq), options.genome, tmpf0bam_name, outpileup ) )
                outfiles.append(outpileup)
            run_cmd_partial = partial(run_cmd, tmpDir=tmpDir)
            cpus = 8
            if options.cpus is not None:
                cpus = int(options.cpus)
            p = Pool(cpus)
            values = p.map(run_cmd_partial, cmd_list, 1)
            for returncode, stderr in values:
                if returncode != 0:
                    raise Exception, stderr
        except Exception, e:
            stop_err( 'Error running Samtools pileup tool\n' + str( e ) )

        # concatenate output
        sys.stdout.write("concatenating mpileup files...")
        with open(outfile, 'wb') as wfd:
            for f in outfiles:
                with open(f,'rb') as fd:
                    shutil.copyfileobj(fd, wfd, 1024*1024*10)
                    #10MB per writing chunk to avoid reading big file into memory.

    finally:

        #clean up temp files
        #if os.path.exists( tmpDir ):
        #    shutil.rmtree( tmpDir )
        pass
    # check that there are results in the output file
    if os.path.getsize( outfile ) > 0:
        sys.stdout.write( 'Converted BAM to pileup' )
    else:
        stop_err( 'The output file is empty. Your input file may have had no matches, or there may be an error with your input file or settings.' )

if __name__ == "__main__" : __main__()
