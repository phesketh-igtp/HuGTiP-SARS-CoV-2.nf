process DATA_TRANSFERE {

    publishDir "${params.analysis_dir}/M${runID}/",         mode: 'copy'

    input
        val minion_pass
        val minion_ip
        path data_dir
        path analysis_dir

    output:
        path "data-transfer.out",                           emit: data_transfere_handover
    
    script:

    """
    #!/bin/bash

    {

        # Initialize previous directory size

        PREVIOUS_SIZE=0

        sshpass -p "${params.minion_pass}" rsync -aP minit@${params.minion_ip}:/data/run_${params.runID} ${params.data_dir}

        while true; do

            # Get the current total size of the directory (in bytes)
            CURRENT_SIZE=\$(du -sb "${params.data_dir}/run_${params.runID}" | cut -f1)

            # Check if the directory size has changed
            if [[ "\$CURRENT_SIZE" != "\$PREVIOUS_SIZE" ]]; then
                PREVIOUS_SIZE=\$CURRENT_SIZE

                echo "Directory size has changed. Waiting 5 minutes before resuming downloading data to:
                        ${params.data_dir}/run_${params.runID}.
                "

                # Wait before checking again
                sleep 5m  # Wait 5 mins before repeating the loop
                sshpass -p "${params.minion_pass}" rsync -aP minit@${params.minion_ip}:/data/run_${params.runID} ${params.data_dir}
            else
                echo -e "Directory size remains the same. Halting download and proceeding with analysis."
                break
            fi
        done

    } > ${runID}_data-transfer.out 2>&1

    """
}