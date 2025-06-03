process DATA_TRANSFER {

    publishDir "${params.data_dir}/M${runID}/",         mode: 'copy'

    input:
        val minion_pass
        val minion_ip
        path data_dir
        path analysis_dir

    output:
        path "data-transfer.out", emit: data_transfer_handover
    
    script:

    """
    sshpass -p "${params.minion_pass}" \\
        rsync -aP \\
        minit@${params.minion_ip}:/data/run_${params.runID} \\
        ${params.data_dir}
    """
}