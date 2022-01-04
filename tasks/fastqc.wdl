task fastqc {
    File fastq
    String outdir
    String sampleName
    
    command {
        mkdir -p "${outdir}${sampleName}"
        echo "Running fastqc ${sampleName}"
        fastqc ${fastq} -o ${outdir}${sampleName}
        echo "fastqc ${sampleName} Done!"
    }
    output {
        File results = outdir+sampleName
    }
    meta {
	      author: "Daniela Cassol"
        email: "danicassol@gmail.com"
	      description: "fastqc command-line"
    }
    parameter_meta { ## TODO: Add
        ## fastq
        ## outdir
        ## sampleName
    }
}

