# jupyter-repo2docker https://github.com/cjprybol/sars-cov2-pangenome-analysis.git \
#     --image-name sas-cov2-pangenome-analysis-$(date +"%Y%m%d%H%M%S")

jupyter-repo2docker \
    --no-run \
    --push \
    --image-name sas-cov2-pangenome-analysis-$(date +"%Y%m%d%H%M%S") \
    --target-repo-dir workspace \
    .