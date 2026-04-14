process version_control_proovframe {

    storeDir "${params.outDir}/version-control/"

    conda params.env_general

    input:
        val(runID)

    output:
        file("proovframe.yml")

    script:

        """
        conda export > proovframe.yml
        """
}