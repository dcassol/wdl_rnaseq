## RNA-Seq Workflow 01/03/2022
## Daniela Cassol

## Updated on 01/03/2022

## import tasks
import "./tasks/fastqc.wdl" as fastqc
import "./tasks/trimmomatic.wdl" as trimmomatic
import "./tasks/hisat2_build.wdl" as hisat2_build
import "./tasks/hisat2.wdl" as hisat2
import "./tasks/pre_quant.wdl" as pre_quant
import "./tasks/quantification.wdl" as quantification
import "./tasks/deg.wdl" as deg

workflow rnaseq {
    String outdir_fastqc
    String outdir_trimmomatic
    String outdir_hs2b
    String outdir_hisat2
    File inputSamplesFile
    Array[Array[File]] inputSamples = read_tsv(inputSamplesFile)
  
    String trimmomatic_path 
    String seqType
    Int TRIM_threads
    String Phred
    File truseq_pe_adapter
    File? trueseq_se_adapter
    Int leading
    Int trailing
    Int window
    Int quality
    Int minLength

    File reference

    Int sortThreads
    Int hisat2threads
    
    File gff
    String dataSource
    String db_path 
    String outputcountDF 
    String outputrpkm 
    File script_quant
    
    File targets
    String DEGcounts 
    File script_deg

    call hisat2_build.hisat2_build {
        input:
            reference = reference,
            outdir_hs2b = outdir_hs2b
    }
    
    Array[File] indexFiles2 = read_lines(hisat2_build.hs2b_list)
    
    scatter (sample in inputSamples) {
        call fastqc.fastqc {
            input:
            fastq=sample[0],
            outdir=outdir_fastqc,
            sampleName=sample[2]
        }
    }

    scatter (sample in inputSamples) {
        call trimmomatic.trimmomatic {
            input:
            trimmomatic_path = trimmomatic_path,
          	seqType = seqType,
          	TRIM_threads = TRIM_threads,
          	Phred = Phred,
          	fastq_1 = sample[0],
          	fastq_2 = sample[1],
          	sampleName = sample[2],
          	truseq_pe_adapter = truseq_pe_adapter,
          	leading = leading,
          	trailing = trailing,
          	window = window,
          	quality = quality,
          	minLength = minLength,
          	outdir = outdir_trimmomatic
        }

    call hisat2.hisat2 {
        input:
        FileName1 = trimmomatic.outFwdPaired,
        FileName2 = trimmomatic.outRevPaired,
        indexFiles = indexFiles2,
        outdir = outdir_hisat2,
        reference = hisat2_build.hs2b_reference,
        sampleName = sample[2],
        Factor = sample[3],
        sortThreads = sortThreads,
        threads = hisat2threads
        }
    }
    
    call pre_quant.pre_quant {
        input:
        outputBam = hisat2.bamFile
    }

    call quantification.quantification {
        input:
        gff = gff,
        dataSource = dataSource,
        db_path = db_path,
        outputBam = pre_quant.out,
        outputcountDF = outputcountDF,
        outputrpkm = outputrpkm,
        script_quant = script_quant
    }    

    call deg.deg {
        input:
        targets = targets,
        outputcountDF = quantification.countDF,
        DEGcounts = DEGcounts,
        script_deg = script_deg
    }    

    output {
        Array[File] fastqc = fastqc.results
		Array[File] trimmomatic_p1 = trimmomatic.outFwdPaired
		Array[File] trimmomatic_p2 = trimmomatic.outRevPaired
		Array[File] trimmomatic_up1 = trimmomatic.outFwdUnpaired
		Array[File] trimmomatic_up2 = trimmomatic.outRevUnpaired
		File hs2b = hisat2_build.hs2b
		Array[File] hisat2_bamFile = hisat2.bamFile
        Array[File] bamIndexFile = hisat2.bamIndexFile
        Array[File] summaryFile = hisat2.summaryFile
        File countDF = quantification.countDF 
        File rpkm =  quantification.rpkm
        File DEGcountsDF = deg.DEGcountsDF 
    }
}
