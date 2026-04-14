process version_control_nextclade {

    storeDir "${params.outDir}/version-control/"

    conda params.env_nextclade

    input:
        val(runID)

    output:
        file("nextclade.yml")

    script:

        """
        conda export > nextclade.yml
        """
}