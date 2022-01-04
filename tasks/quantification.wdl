task quantification {
    File gff
    String dataSource
    String db_path 
    String outputBam 
    String outputcountDF 
    String outputrpkm 
    File script_quant
    
    command {
        echo "Running quantification"
        Rscript ${script_quant} --gff ${gff} --dataSource ${dataSource} --db_path ${db_path} --outputBam ${outputBam} --outputcountDF ${outputcountDF} --outputrpkm ${outputrpkm}
        echo "quantification Done!"
    }
    output {
        File countDF = outputcountDF 
        File rpkm =  outputrpkm
    }
    meta {
        author: "Daniela Cassol"
        email: "danicassol@gmail.com"
        description: "hisat2_build command-line"
    }
    parameter_meta { ## TODO: Add
        ## gff
        ## dataSource
        ## db_path 
        ## outputBam 
        ## outputcountDF 
        ## outputrpkm 
        ## script_quant
    }
}
