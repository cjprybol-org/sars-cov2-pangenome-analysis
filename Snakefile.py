# https://papermill.readthedocs.io/en/latest/usage-cli.html
# run `snakemake some_target --delete-all-output` to clean outputs from target
# run `snakemake --delete-all-output --cores all` to clean all outputs
# run `snakemake --cores all` to run whole workflow
# run `snakemake some_target --cores all` to run up to and through target

# snakemake --lint

import os

# https://snakemake.readthedocs.io/en/v6.0.3/executing/cli.html#visualization
# snakemake document --cores 1
rule document:
    output:
        "dag.pdf"
    shell:
        """
        snakemake --forceall --dag | dot -Tpdf > dag.pdf
        """

# snakemake download_ncbi_dataset_zip --cores 1
# too large to work with on the machine I had access to
# rule download_ncbi_dataset_zip:
#     output:
#         "data/sars-cov-2.zip"
#     shell:
#         """
#         datasets download virus genome taxon SARS-CoV-2 --filename {output}
#         """

# # snakemake unzip_ncbi_dataset_zip --cores 1
# rule unzip_ncbi_dataset_zip:
#     input:
#         "data/sars-cov-2.zip"
#     output:
#         "data/ncbi_dataset"
#     shell:
#         """
#         unzip -d data/ {input}
#         """

# raw export from above was too large to work with and I can't download de-hydrated, so will subsample instead

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
    
