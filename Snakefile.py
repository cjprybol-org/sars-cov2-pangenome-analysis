# https://papermill.readthedocs.io/en/latest/usage-cli.html
# run `snakemake some_target --delete-all-output` to clean outputs from target
# run `snakemake --delete-all-output --cores all` to clean all outputs
# run `snakemake --cores all` to run whole workflow
# run `snakemake some_target --cores all` to run up to and through target

# snakemake --lint

import os

# conda activate sars-cov2-pangenome-analysis

# to specificy conda env as part of the rule
# conda:
#     "environment.yaml"

# https://snakemake.readthedocs.io/en/v6.0.3/executing/cli.html#visualization
# snakemake document --cores 1
rule document:
    output:
        "dag.pdf"
    shell:
        """
        snakemake --forceall --dag | dot -Tpdf > dag.pdf
        """

################################################################################################
# FULL COVID DATASET
################################################################################################

# snakemake --snakefile Snakefile.py --cores 1 download_ncbi_dataset_zip
# very large
rule download_ncbi_dataset_zip:
    output:
        "data/sars-cov-2.zip"
    shell:
        """
        datasets download virus genome taxon SARS-CoV-2 --filename {output}
        """

# raw export was too large to work with on a 1Tb machine
# snakemake --snakefile Snakefile.py --cores 1 unzip_ncbi_dataset_zip
rule unzip_ncbi_dataset_zip:
    input:
        "data/sars-cov-2.zip"
    output:
        "data/ncbi_dataset"
    shell:
        """
        unzip -d data/ {input}
        """

################################################################################################
# ANNOTATED AND COMPLETE ONLY
################################################################################################

# snakemake --snakefile Snakefile.py --cores 1 download_covid_dataset_annotated_complete
rule download_covid_dataset_annotated_complete:
    output:
        "data/sars-cov-2.annotated.complete.zip"
    shell:
        """
        datasets download virus genome taxon SARS-CoV-2 --filename {output} --annotated --complete-only
        """
        
# snakemake --snakefile Snakefile.py --cores 1 unzip_covid_dataset_annotated_complete
rule unzip_covid_dataset_annotated_complete:
    input:
        "data/sars-cov-2.annotated.complete.zip"
    shell:
        """
        unzip -d data/sars-cov-2.annotated.complete {input}
        """

################################################################################################
# ANNOTATED AND COMPLETE REFSEQ ONLY
################################################################################################

# don't need to run
# datasets summary virus genome taxon sars-cov-2 --annotated --complete-only --refseq > dataset-summary.json
# because the data_report.jsonl in the download zip is the same content

# snakemake --snakefile Snakefile.py --cores 1 download_covid_dataset_annotated_complete_refseq
rule download_covid_dataset_annotated_complete_refseq:
    output:
        "data/sars-cov-2.annotated.complete.refseq.zip"
    shell:
        """
        datasets download virus genome taxon SARS-CoV-2 --filename {output} --annotated --complete-only --refseq
        """

# snakemake --snakefile Snakefile.py --cores 1 unzip_covid_dataset_annotated_complete_refseq
rule unzip_covid_dataset_annotated_complete_refseq:
    input:
        "data/sars-cov-2.annotated.complete.refseq.zip"
    shell:
        """
        unzip -d data/sars-cov-2.annotated.complete.refseq {input}
        """

# rule download_ncbi_tax_dump:
#     output:
#     shell:


# rule build_genome_from_dataset:
#     input:
#         "dataset_directory:"
#     shell:
#         """
#         # julia --project="./Project.toml" -e 'import Pkg; Pkg.instantiate()'
#         # julia --project="./Project.toml" -e 'import Mycelia; println(pathof(Mycelia))'
#         # papermill path_of_mycelia/build_pangenome.ipynb --data_directory={input}
#         """



    
