task trimmomatic {
    String trimmomatic_path 
	String seqType
	Int TRIM_threads
	String Phred
	File fastq_1
	File? fastq_2
	String sampleName 
	File truseq_pe_adapter
	File? trueseq_se_adapter
	Int leading
	Int trailing
	Int window
	Int quality
	Int minLength
	String outdir

	command {
        mkdir -p "${outdir}"
        echo "Trimming ${sampleName}";
        ${trimmomatic_path} \
        ${seqType} -threads ${TRIM_threads} ${Phred} \
        ${fastq_1} ${fastq_2} \
        ${outdir}${sampleName}_R1_paired.fq.gz ${outdir}${sampleName}_R1_unpaired.fq.gz \
        ${outdir}${sampleName}_R2_paired.fq.gz ${outdir}${sampleName}_R2_unpaired.fq.gz \
        ILLUMINACLIP:${truseq_pe_adapter}:2:30:10:2:True \
        LEADING:${leading} TRAILING:${trailing} SLIDINGWINDOW:${window}:${quality} MINLEN:${minLength};
        echo "Trimming ${sampleName} Done!"
	}
    output {
        File outFwdPaired="${outdir}${sampleName}_R1_paired.fq.gz"
        File outRevPaired="${outdir}${sampleName}_R2_paired.fq.gz"
        File outFwdUnpaired="${outdir}${sampleName}_R1_unpaired.fq.gz"
        File outRevUnpaired="${outdir}${sampleName}_R2_unpaired.fq.gz"
    }
    meta {
        author: "Daniela Cassol"
        email: "danicassol@gmail.com"
        description: "hisat2 command-line"
    }
    parameter_meta { ## TODO: Add
        ## trimmomatic_path 
    	## seqType
    	## TRIM_threads
    	## Phred
    	## fastq_1
    	## fastq_2
    	## sampleName 
    	## truseq_pe_adapter
    	## trueseq_se_adapter
    	## leading
    	## trailing
    	## window
    	## quality
    	## minLength
    	## outdir
    }
}


