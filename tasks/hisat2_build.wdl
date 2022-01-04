task hisat2_build {
    File reference
    String outdir_hs2b
    String refName = basename(reference)
    
    command {
        mkdir -p "${outdir_hs2b}"
        echo "Running hisat2-build"
        hisat2-build ${reference} ${outdir_hs2b}${refName}
        cp -R ${reference} ${outdir_hs2b}
        ls -d $PWD/"${outdir_hs2b}"/* > "${outdir_hs2b}_list"
        echo "hisat2_build Done!"
    }
    output {
        File hs2b = outdir_hs2b 
        File hs2b_reference =  outdir_hs2b + basename(reference)
        File hs2b_list = "${outdir_hs2b}_list"
    }
    meta {
	      author: "Daniela Cassol"
        email: "danicassol@gmail.com"
	      description: "hisat2_build command-line"
    }
    parameter_meta { ## TODO: Add
        ## reference
        ## outdir_hs2b
        ## refName
    }
}
