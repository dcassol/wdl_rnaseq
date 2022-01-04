task deg {
    File targets
    File outputcountDF
    String DEGcounts 
    File script_deg

    command {
        echo "Running deg"
        Rscript ${script_deg} --targets ${targets} --outputcountDF ${outputcountDF} --DEGcounts ${DEGcounts} 
        echo "deg Done!"
    }
    output {
        File DEGcountsDF = outputcountDF 
    }
    meta {
        author: "Daniela Cassol"
        email: "danicassol@gmail.com"
        description: "deg - Deseq2 command-line"
    }
    parameter_meta { ## TODO: Add
        ## targets
        ## outputcountDF
        ## DEGcounts 
        ## script_deg
    }
}
