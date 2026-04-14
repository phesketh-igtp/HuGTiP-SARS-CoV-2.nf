process version_control_artic {

    storeDir "${params.outDir}/version-control/"

    conda params.env_artic

    input:
        val(runID)
    output:
        file("artic.yml")
        
    script:

    """
    # Export conda environment
    conda export > artic.yml  
    """
}
