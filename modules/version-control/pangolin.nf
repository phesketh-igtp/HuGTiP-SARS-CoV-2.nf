process version_control_pangolin {

    storeDir "${params.outDir}/version-control/"

    conda params.env_pangolin

    input:
        val(runID)

    output:
        file("pangolin.yml")

    script:

        """
        conda export > pangolin.yml
        """
}