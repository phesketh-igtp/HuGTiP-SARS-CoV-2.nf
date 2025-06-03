#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

/*
Import modules and workflows
*/
include { data_transfer }   from './modules/data_transfer.nf'
include { artic }           from './modules/artic.nf'
include { coverage }        from './modules/coverage.nf'
include { proovframe }      from './modules/proovframe.nf'
include { alignment }       from './modules/align_corr_consensus_with_ref.nf'
include { nextclade }       from './modules/nextclade.nf'
include { pangolin }        from './modules/pangolin.nf'

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
        if (params.metadata == null) {
            error "Please provide a samplesheet XLSX file with --samplesheet (i.e. path to samplesheet-artic.csv)"
        }

    // Check if RunID is provided
        if (params.runID == null ) {
            error "Please provide a RunID using --runID (numeric value)"
        }

    // Check if minionID is provided
        if (params.minionID == null) {
            error "Please provide a Minion identity using --minionID (options: 1 or 2 )"
        }

        // Set ip_address based on minionID
            if (params.minionID == 'MC-112755') {
                minion_ip = '' // Replace with actual IP address for MC-112755
            } else if (params.minionID == 'MC-115292') {
                minion_ip = '' // Replace with actual IP address for MC-115292
            } else {
                error "Invalid MinION ID. Please use --minionID MC-112755 or --minionID MC-115292"
            }

    // Create the data channel from the metadata
    samples_ch = Channel
                .fromPath(params.metadata)
                .splitCsv(header: true)
                .view()

    // Main workflow

    /// Download the data
        data_transfer( params.runID,
                        params.dataDir,
                        params.minion_pass,
                        minion_ip
        )

    /// Run Artic
        artic(samples_ch,
                data_transfer.out.data_transfer_handover )

    /// Run proofframe to correct frameshifts
        proovframe( artic.out.artic_consensus )

    /// Collect all the consensus sequenced into a single file
        corr_consensus = proovframe.out.corr_consensus.collect()

    /// Align consensus genomes with reference
        alignment( corr_consensus )
        nextclade( corr_consensus )
        pangolin( corr_consensus )

    /// Calculate coverage and plot coverage mapping 
        coverage( artic.out.artic_coverage )

}



