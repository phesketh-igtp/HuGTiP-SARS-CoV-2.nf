process data_transfer {

    publishDir "${params.dataDir}/M${run_ID}/", mode: 'copy'

    input:
        val(run_ID)
        val(data_dir)
        val(minion_pass)
        val(minion_ip)

    output:
        path "md5sum.txt", emit: data_transfer_handover
    
    script:

    """
    sshpass -p "${minion_pass}" rsync -aP minit@${minion_ip}:/data/run_${run_ID} ${data_dir}

    md5sum ${data_dir} > md5sum.txt
    """
}