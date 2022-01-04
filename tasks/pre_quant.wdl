workflow wf {
    call pre_quant
}
task pre_quant {
    Array[File] outputBam

    command {
        echo "Running pre_quant"
        ./script --file-list=${write_lines(outputBam)} 
        echo "pre_quant Done!"
    }
  output {
    File out = write_lines(outputBam)
  }
    meta {
	    author: "Daniela Cassol"
        email: "danicassol@gmail.com"
	    description: "hisat2_build command-line"
    }
    parameter_meta { ## TODO: Add
        ## outputBam
    }
}


