    /*
    Import modules
    */

import { DATA_TRANSFERE }       from '../modules/data_transfere.nf'
import { COLLECT_METADATA }     from '../modules/collect_metadata.nf'
import { ARTIC_ANALYSIS }       from '../modules/github/artic.nf'
import { PANGOLIN_ANALYSIS }    from '../modules/github/pangolin.nf'
import { NEXTCLADE_ANALYSIS }   from '../modules/github/nextclade.nf'

process WORKFLOW_ONE {

    take:

        runID
        samplesheet

    main:

        // Download the minion data
            DATA_TRANSFERE(runID,
                            minion_pass,
                            minion_ip,
                            data_dir
                            analysis_dir)

        // Transform the metadata to grep just the barcode ids and aliases
            COLLECT_METADATA(samplesheet)

        // Run artic modules
            ARTIC_ANALYSIS(COLLECT_METADATA.out.samples_csv,
                            data_transfere_handover
                            )

        // Run PANGOLIN 
            PANGOLIN_ANALYSIS(ARTIC_ANALYSIS.out.consensus_genomes)

        // Rune NextClade 
            NEXTCLADE_ANALYSIS(ARTIC_ANALYSIS.out.consensus_genomes)

    emit:
        consensus_genomes           = ARTIC_ANALYSIS.out.consensus_genomes
        pangolin_out                = PANGOLIN_ANALYSIS.pangolin_out
        nextclade_out               = NEXTCLADE_ANALYSIS.nextclade.out

}