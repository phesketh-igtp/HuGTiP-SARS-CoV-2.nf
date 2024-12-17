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
        if (params.samplesheet == null) {
            error "Please provide a samplesheet XLSX file with --samplesheet (i.e. path to sample template XLSX)"
        }

    // Create channel from sample sheet
        if (params.relecov == null) {
            error "Please provide a samplesheet XLSX file with --relecov (i.e. path to relecov template XLSX)"
        }

    // Check if RunID is provided
        if (params.runID == null ) {
            error "Please provide a RunID using --runID (numeric value)"
        }

    // Check if RunID is provided
        if (params.minionID == null ) {
            error "Please provide a Minion identity using --minionID ( options: 1. 'MC-112755' or 2. MC-115292 )"
        }

    WORKFLOW_ONE(
        samplesheet,
        runID
    )

    WORKFLOW_TWO()


}