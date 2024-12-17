process ARTIC_ANALYSIS {

    tag "$sampleid"

    publishDir "${params.analysisDir}/consensus/"

    input:
        tuple val(sampleid), val(alias), path(read_dir)

    output:

    script:
        """
        artic guppyplex \\
            --skip-quality-check \\
            --min-length ${params.min_len} \\
            --max-length ${params.max_len} \\
            --directory ${read_dir} \\
            --prefix ${alias} >
            ${sampleid}_${alias}.fastq

        artic minion --medaka \\
            --normalise ${params.normalise} \\
            --threads ${params.cpu} \\
            --read-file ${sampleid}_${alias}.fastq \\
            --medaka-model ${params.medaka_model} \\
            --scheme-directory ${params.scheme_dir} \\
            --scheme-version ${params.scheme_version} \\
            --max-softclip-length ${params.max_softclip_length} \\
            ${params.scheme_name} ${sampleid}

        # rename the consensus sequence
        sed -i "s/^>\S*/>${sample_name}/" "${sampleid}.consensus.fasta"

        # calculate depth stats. Final output is single file annotated with primer set and sample name
        samtools view -r ${i} -b ${sampleid}.primertrimmed.rg.sorted.bam > ${sampleid}.primertrimmed.rg.sorted.bam
        samtools index ${sampleid}.primertrimmed.rg.sorted.bam

        stats_from_bam ${sampleid}.primertrimmed.rg.sorted.bam > "${sampleid}.stats" || echo "stats_from_bam failed, probably no alignments"
            coverage_from_bam -s 20 -p ${bam} ${bam}
        
        # TODO: we're assuming a single reference sequence here
            awk 'BEGIN{OFS="\t"}{if(NR==1){print $0, "sample_name", "primer_set"}else{print $0, "'${sampleid}'", "'${i}'"}}' *${bam}*".depth.txt" > "${sampleid}.depth.${i}.txt"
            rm -rf ${sampleid}.primertrimmed.rg.sorted.bam ${sampleid}.primertrimmed.rg.sorted.bam.bai
        done
        
        cat "${sampleid}.depth.1.txt" <(tail -n+2 "${sampleid}.depth.2.txt") > "${sampleid}.depth.txt"

        """


}