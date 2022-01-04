task hisat2 {
    File FileName1
    File? FileName2
    String reference
    Array[File]+ indexFiles
    String sampleName 
    String outdir
    String outputBam = outdir + sampleName + ".bam"
    String Factor
    String summaryFilePath = outdir + sampleName + ".bam" + ".summary.txt"
    Int sortThreads
    Int threads
    
    command {
        set -e -o pipefail
	    mkdir -p "${outdir}"
        echo "Running hisat2 ${sampleName}"
	    
        hisat2 \
        -p ${threads} \
        -x ${reference} \
        ${true="-1" false="-U" defined(FileName2)} ${FileName1} \
        ${"-2" + FileName2} \
        --rg-id ${Factor} \
        --rg 'SM:${sampleName}' \
        --new-summary \
        --summary-file ${summaryFilePath} \
        | samtools sort \
        ${"-@ " + sortThreads} \
        -o ${outputBam} 
        
        samtools index \
        -b ${outputBam} \
        ${outputBam}.bai
        
        echo "hisat2 ${sampleName} Done!"
    }       
    output {
        File bamFile = outputBam
        File bamIndexFile = "${outputBam}.bai"
        File summaryFile = summaryFilePath
    }
    meta {
        author: "Daniela Cassol"
        email: "danicassol@gmail.com"
        description: "hisat2 command-line"
    }
    parameter_meta { ## TODO: Add
        ## FileName1
        ## FileName2
        ## reference
        ## indexFiles
        ## sampleName 
        ## outdir
        ## outputBam 
        ## Factor
        ## summaryFilePath 
        ## sortThreads
        ## threads
    }
}

