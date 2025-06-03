process COLLECT_METADATA {

    tag "${runID}"

    publishDir "${params.analysisDir}/M${runID}/"

    input:
        val runID
        path mncov_template

    output:
        tuple val(runID), path("sample_sheet_wf-artic-run${runID}.csv"),      emit: samples_csv

    shell:
    
        """
        # Convert MNCOV Excel template to CSV format
            python ${params.scriptDir}/bin/convert_mncov_xlsx2csv.py \\
                                        --xlsx ${mncov_template} \\
                                        --csv sample_sheet_wf-artic-run${runID}.csv

        # Check if the output file was created successfully
            if [ ! -f sample_sheet_wf-artic-run${runID}.csv ]; then
                echo "Error: Failed to create sample sheet CSV file"
                exit 1
            fi
        """

}