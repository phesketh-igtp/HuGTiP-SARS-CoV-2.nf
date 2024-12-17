include { DATA_TRANSFER }        from '../modules/local/data_transfer.nf' // complete
include { collectMetadata }      from '../modules/local/collect_metadata.nf' // complete
include { wf_artic }             from '../modules/github/artic.nf' // wip
include { PANGOLIN_ANALYSIS }    from '../modules/github/pangolin.nf' // tbd
include { NEXTCLADE_ANALYSIS }   from '../modules/github/nextclade.nf' // tbd

process WORKFLOW_ONE {

    take:
        runID
        mncov_template
        minion_ip

    main:

        // Download the minion data
            DATA_TRANSFER(runID, minion_ip)

        // Transform the metadata to grep just the barcode ids and aliases
            COLLECT_METADATA(mncov_template)

            // create channel with the converted samples_csv
            samples_ch = COLLECT_METADATA.out.samples_csv
                .splitCsv(header: true)
                .map { row -> 
                    // Create a tuple with the values you need
                    tuple(row.barcode, row.sampleID, row.alias, row.type)
                }

        // Run artic modules
            ARTIC_ANALYSIS(samples_ch,
                            DATA_TRANSFER.out.data_transfer_handover
                            )

        // Run PANGOLIN 
            PANGOLIN_ANALYSIS(  runID, 
                                ARTIC_ANALYSIS.out.consensus_genomes
                            )

        // Rune NextClade 
            NEXTCLADE_ANALYSIS(  runID, 
                                ARTIC_ANALYSIS.out.consensus_genomes
                            )

}

/*
    emit:
        consensus_genomes           = ARTIC_ANALYSIS.out.consensus_genomes
        pangolin_out                = PANGOLIN_ANALYSIS.pangolin_out
        nextclade_out               = NEXTCLADE_ANALYSIS.nextclade.out
*/