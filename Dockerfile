## Docker wdl_rnaseq
FROM bioconductor/bioconductor_docker:devel

RUN apt-get update && \
    apt-get install -y hisat2 bowtie bowtie2 bwa samtools vim fastqc trim-galore && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/project/RNAseq/

COPY --chown=rstudio:rstudio . /home/project/RNAseq/

RUN apt-get update &&\ 
    mkdir /tools &&\
    cd /tools &&\
    ## trimmomatic
    wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip &&\
    unzip Trimmomatic-0.39.zip -d /opt/ &&\
    rm -rf Trimmomatic-0.39.zip &&\
    chmod +x /opt/Trimmomatic-0.39/trimmomatic-0.39.jar &&\
    echo "#!/bin/bash" >> /opt/trimmomatic &&\
    echo "exec java -jar /opt/Trimmomatic-0.39/trimmomatic-0.39.jar """"$""@"""" " >> /opt/trimmomatic &&\
    chmod +x /opt/trimmomatic &&\
    ## Cromwell
    wget -P /opt/ https://github.com/broadinstitute/cromwell/releases/download/72/cromwell-72.jar &&\
    chmod +x /opt/cromwell-72.jar &&\
    echo "#!/bin/bash" >> /opt/cromwell &&\ 
    echo "exec java -jar /opt/cromwell-72.jar """"$""@"""" " >> /opt/cromwell &&\
    chmod +x /opt/cromwell 
    
ENV PATH="${PATH}:/opt/"

## Update Bioconductor packages from devel version
#RUN Rscript --vanilla -e "options(repos = c(CRAN = 'https://cran.r-project.org')); BiocManager::install(ask=FALSE)"

## Install required Bioconductor packages from devel version

## Metadata
LABEL name="dcassol/wdl_rnaseq" \
      version="wdl_rnaseq:latest" \
      url="https://github.com/dcassol/wdl_rnaseq" \
      vendor="WDL RNAseq Workflow" \
      maintainer="danicassol@gmail.com" \
      description="WDL RNAseq Workflow docker image" \
      license="Artistic-2.0"
 
