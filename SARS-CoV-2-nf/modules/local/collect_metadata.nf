process COLLECT_METADATA {

    publishDir "${params.analysis_dir}/M${runID}/"

    input
        val runID
        path samplesheet

    output
        path("sample_sheet_wf-artic-run${runID}.csv"),          emit: samples_csv

    shell:
        """

        # Get sample sheets for analysis from template
        python /home/seqadmin/Bioinfo/06.python_cwd/Get_samplesheet.py -f ${samplesheet} 
        sed -i 's@sample_id@alias@g' sample_sheet_wf-artic-run${runID}.csv

        """

}