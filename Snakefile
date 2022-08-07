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

# snakemake mount_storage --cores 1
rule mount_storage:
    output:
        "/home/jovyan/rclone-mounts/storage.mounted"
    shell:
        # https://forum.rclone.org/t/bad-file-descriptor-when-moving-files-to-rclone-mount-point/13936/2
        """
        mkdir -p /home/jovyan/rclone-mounts/storage-bucket
        rclone mount --vfs-cache-mode writes covid_omics:/covid-omics /home/jovyan/rclone-mounts/storage-bucket &
        sleep 5
        touch {output}
        """

# snakemake unmount_and_unlink_storage --cores 1 && snakemake link_storage --cores 1

# snakemake link_storage --cores 1
rule link_storage:
    input:
        "/home/jovyan/rclone-mounts/storage.mounted"
    output:
        "/home/jovyan/rclone-mounts/storage.mounted.linked"
    shell:
        """
        [ -d "/workspaces/$RepositoryName/data" ] && rm /workspaces/$RepositoryName/data
        [ -f "/workspaces/$RepositoryName/data" ] && rm /workspaces/$RepositoryName/data
        mkdir -p /home/jovyan/rclone-mounts/storage-bucket
        ln -s /home/jovyan/rclone-mounts/storage-bucket /workspaces/$RepositoryName/data
        touch {output}
        """

# snakemake unmount_and_unlink_storage --cores 1
rule unmount_and_unlink_storage:
    input:
        mounted="/home/jovyan/rclone-mounts/storage.mounted",
        linked="/home/jovyan/rclone-mounts/storage.mounted.linked"
    shell:
        """
        fusermount -u /home/jovyan/rclone-mounts/storage-bucket || echo "storage not mounted"
        rm -f {input.mounted}
        rm -f {input.linked}
        """