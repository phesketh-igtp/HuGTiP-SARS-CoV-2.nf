process data_transfer {

    publishDir "${params.dataDir}/M${runID}/", mode: 'copy'

    input:
        val(runID)
        val(dataDir)
        val(minion_password)
        val(minion_ip)

    output:
        path("md5sum.txt"), emit: data_md5sum
    
    script:
        """
        sshpass -p "${minion_password}" rsync -aP minit@${minion_ip}:/data/run_${runID}/ "${dataDir}/"
        md5sum "${dataDir}/" > md5sum.txt
        """
}