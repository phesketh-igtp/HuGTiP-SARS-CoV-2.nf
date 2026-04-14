process version_control_general {

    storeDir "${params.outDir}/version-control/"

    conda params.env_general

    input:
        val(runID)

    output:
        file("general.yml")

    script:

        """
        conda export > general.yml
        """
}