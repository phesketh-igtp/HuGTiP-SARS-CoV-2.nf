process ARTIC_ANALYSIS {

    tag

    publishDir "${params.outDir}/artic-results/${sampleid}/"

    input:
        tuple val(sampleid), val(alias), path(read_dir)

    output


    shell:
        """
        artic guppyplex \\
            --skip-quality-check \\
            --min-length ${params.min_len} \\
            --max-length ${params.max_len} \\
            --directory ${read_dir} \\
            --prefix ${sampleid} >
            ${sampleid}.fastq

        # download the models (if not already downloaded)
        artic_get_models

        artic minion --medaka \\
            --normalise ${params.normalise} \\
            --threads ${params.cpu} \\
            --read-file ${sampleid}_${alias}.fastq \\
            --medaka-model ${medaka_model} \\
            --scheme-directory ${params.scheme_dir} \\
            --scheme-name ${params.scheme_name} \\
            --scheme-version ${params.scheme_version} \\
            --max-softclip-length ${params.max_softclip_length} \\
            --min-mapq ${params.min_mapq} \\
            --linearise-fasta \\
            ${sampleid}

        # rename the consensus sequence
        sed -i "s/^>\S*/>${sample_name}/" "${sampleid}.consensus.fasta"

        # calculate depth stats. Final output is single file annotated with primer set and sample name
        samtools view -r ${i} -b ${sampleid}.primertrimmed.rg.sorted.bam > ${sampleid}.primertrimmed.rg.sorted.bam
        samtools index ${bam}

        stats_from_bam ${bam} > "${bam}.stats" || echo "stats_from_bam failed, probably no alignments"
            coverage_from_bam -s 20 -p ${bam} ${bam}
        
        # TODO: we're assuming a single reference sequence here
            awk 'BEGIN{OFS="\t"}{if(NR==1){print $0, "sample_name", "primer_set"}else{print $0, "'${sample_name}'", "'${i}'"}}' *${bam}*".depth.txt" > "${sample_name}.depth.${i}.txt"
            rm -rf ${bam} ${bam}.bai
        done
        cat "${sample_name}.depth.1.txt" <(tail -n+2 "${sample_name}.depth.2.txt") > "${sample_name}.depth.txt"

        """


}