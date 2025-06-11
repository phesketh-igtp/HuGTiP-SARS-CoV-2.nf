#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

/*
Import modules and workflows
*/
include { guppyplex }   from './modules/guppyplex.nf'
include { artic }       from './modules/artic.nf'
include { coverage }    from './modules/coverage.nf'
include { proovframe }  from './modules/proovframe.nf'
include { concatenate_consensus } from './modules/concatenate_consensus.nf'
include { alignment }   from './modules/align_corr_consensus_with_ref.nf'
include { nextclade }   from './modules/nextclade.nf'
include { pangolin }    from './modules/pangolin.nf'

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
        if (params.dataDir == null) {
            error "Please provide full path to directory containing ONT results using --dataDir"
        }

    // Create the data channel from the metadata
    samples_ch = Channel
                .fromPath(params.metadata)
                .splitCsv(header: true)

    /// Run Artic workflows
        guppyplex( samples_ch )
        artic( guppyplex.out.guppyplex_out )

    /// Run proofframe to correct frameshifts
        proovframe( artic.out.artic_consensus )

    /// Collect all the consensus sequenced into a single file
        concatenate_consensus(proovframe.out.corr_consensus.collect())
        corr_consensus = concatenate_consensus.out.consensus_cat

    /// Align consensus genomes with reference
        alignment( corr_consensus )
        nextclade( corr_consensus )
        pangolin( corr_consensus )

    /// Calculate coverage and plot coverage mapping 
        coverage( artic.out.artic_coverage )
        
        /// Concatenate the outputs
            coverage.out.coverage_res
            .collectFile(
                name: 'coverage_mean.csv',
                keepHeader: true,
                skip: 1,
                storeDir: "${params.outDir}"
            )

    /// 

}



