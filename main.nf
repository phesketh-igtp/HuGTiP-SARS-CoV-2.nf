#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

/*
Import modules and workflows
*/

include { WORKFLOW_ONE }                from '../workflows/workflow_one.nf'
include { WORKFLOW_TWO }                from '../workflows/workflow_two.nf'

workflow {

    def color_purple = '\u001B[35m'
    def color_green = '\u001B[32m'
    def color_red = '\u001B[31m'
    def color_reset = '\u001B[0m'

    log.info """
    ${color_purple}
    SARS-CoV-2 Surveilance at Can Ruti Hospital [version 1.0.0]${color_reset}
    """

    // Create channel from sample sheet
        if (params.mncov_template == null) {
            error "Please provide a samplesheet XLSX file with --samplesheet (i.e. path to sample template XLSX)"
        }

    // Create channel from sample sheet
        if (params.relecov_template == null) {
            error "Please provide a samplesheet XLSX file with --relecov (i.e. path to relecov template XLSX)"
        }

    // Check if RunID is provided
        if (params.runID == null ) {
            error "Please provide a RunID using --runID (numeric value)"
        }

    // Check if minionID is provided
        if (params.minionID == null) {
            error "Please provide a Minion identity using --minionID (options: 1. 'MC-112755' or 2. 'MC-115292')"
        }

        // Set ip_address based on minionID
            if (params.minionID == 'MC-112755') {
                minion_ip = '' // Replace with actual IP address for MC-112755
            } else if (params.minionID == 'MC-115292') {
                minion_ip = '' // Replace with actual IP address for MC-115292
            } else {
                error "Invalid MinION ID. Please use --minionID MC-112755 or --minionID MC-115292"
            }

    // Check if RunID is provided
        if (params.workflow == null ) {
            error "Please select a workflow, (1) workflow-1 for the initial download,
                mapping to reference genomes, ARTIC analysis, multiple-sequence alignment, or
                 (2) workflow-2 post frame-shit correction, submission to GISAID, and generation of 
                 results XLSX for submission to RELECOV and MINCOVSEQ ( numeric, options: 1 or 2 )"
        }

    // Main workflow

        if (params.workflow == 1) {

                WORKFLOW_ONE(   params.minion,
                                params.mncov_template,
                                params.runID,
                                minion_ip
                            )

        } else if (params.workflow == 2) {

                WORKFLOW_TWO(   params.relecov_template,
                                params.runID
                            )

        } else {

            error "Invalid workflow parameter. Please use --workflow 1 or --workflow 2"

        }




    


}



