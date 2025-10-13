# SARS-CoV-2 Surveillance Pipeline - Can Ruti Hospital

**Version 1.0.0**

A comprehensive Nextflow DSL2 pipeline for SARS-CoV-2 genomic surveillance using Oxford Nanopore Technologies (ONT) sequencing data.

## Overview

This pipeline processes ONT sequencing data to generate high-quality SARS-CoV-2 consensus genomes and performs downstream analyses including variant calling, lineage assignment, and coverage analysis. It's specifically designed for surveillance activities at Can Ruti Hospital.

## Features

- **Quality Control**: Guppyplex filtering and quality assessment
- **Consensus Calling**: ARTIC workflow for robust consensus genome generation
- **Frameshift Correction**: ProovFrame integration to correct sequencing-induced frameshifts
- **Variant Analysis**: Nextclade for clade assignment and mutation detection
- **Lineage Assignment**: Pangolin for PANGO lineage classification
- **Coverage Analysis**: Comprehensive coverage statistics and visualization
- **Multi-sample Processing**: Batch processing with sample metadata management

## Requirements

### Software Dependencies
- Nextflow (≥ 22.04.0)
- Docker or Singularity/Apptainer
- Required tools (typically containerized):
  - Guppy/Guppyplex
  - ARTIC workflow tools
  - ProovFrame
  - Nextclade
  - Pangolin
  - Coverage analysis tools

### System Requirements
- Linux/macOS operating system
- Minimum 8 GB RAM (16+ GB recommended)
- 50+ GB free disk space for intermediate files

## Installation

1. **Install Nextflow**:
```bash
curl -s https://get.nextflow.io | bash
sudo mv nextflow /usr/local/bin/
```

2. **Clone the repository**:
```bash
git clone <repository-url>
cd sars-cov2-surveillance-pipeline
```

3. **Test installation**:
```bash
nextflow run main.nf --help
```

## Usage

### Quick Start

```bash
nextflow run main.nf \
  --metadata sample_metadata.csv \
  --runID 12345 \
  --dataDir /path/to/ont/data \
  --outDir results/
```

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `--metadata` | File | CSV file containing sample metadata with headers |
| `--runID` | Integer | Unique numeric identifier for the sequencing run |
| `--dataDir` | Directory | Full path to directory containing ONT sequencing results |

### Optional Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `--outDir` | `./results` | Output directory for results |

### Sample Metadata Format

Your metadata CSV file should contain the following headers:

```csv
sampleID,barcode,collection_date,location
Sample001,barcode01,2024-01-15,Ward_A
Sample002,barcode02,2024-01-15,Ward_B
Sample003,barcode03,2024-01-16,ICU
```

Required columns:
- `sampleID`: Unique sample identifier
- `barcode`: ONT barcode used for multiplexing
- Additional columns as needed for your analysis

## Workflow Steps

The pipeline executes the following main steps:

### 1. Data Preparation
- **Guppyplex**: Filters and demultiplexes ONT sequencing data
- Quality control and read filtering

### 2. Consensus Generation
- **ARTIC**: Generates consensus sequences using the ARTIC workflow
- Primer trimming and variant calling

### 3. Quality Correction
- **ProovFrame**: Corrects frameshift mutations introduced during sequencing
- Maintains reading frame integrity

### 4. Sequence Analysis
- **Alignment**: Aligns corrected consensus sequences with reference genome
- **Nextclade**: Performs clade assignment and mutation analysis
- **Pangolin**: Assigns PANGO lineages for epidemiological tracking

### 5. Coverage Analysis
- **Coverage**: Calculates depth and breadth of coverage
- Generates coverage plots and statistics
- Produces summary coverage report (`coverage_mean.csv`)

## Output Structure

```
results/
├── guppyplex/
│   └── [sample_id]/
│       └── filtered_reads.fastq
├── artic/
│   ├── consensus/
│   │   └── [sample_id].consensus.fasta
│   └── coverage/
│       └── [sample_id].coverage.txt
├── proovframe/
│   └── [sample_id]/
│       ├── corrected.fasta
│       └── corrections.tsv
├── alignment/
│   └── aligned_consensus.fasta
├── nextclade/
│   └── nextclade_results.tsv
├── pangolin/
│   └── pangolin_lineages.csv
├── coverage/
│   └── coverage_plots/
└── concatenated_consensus.fasta
└── coverage_mean.csv
```

## Key Output Files

- **`concatenated_consensus.fasta`**: All corrected consensus sequences in a single file
- **`coverage_mean.csv`**: Summary coverage statistics for all samples
- **`nextclade_results.tsv`**: Clade assignments and mutation profiles
- **`pangolin_lineages.csv`**: PANGO lineage assignments

## Configuration

### Profile Configuration

Create a `nextflow.config` file for your environment:

```groovy
profiles {
    docker {
        docker.enabled = true
        process {
            withName: 'guppyplex' {
                container = 'your-registry/guppyplex:latest'
            }
            withName: 'artic' {
                container = 'your-registry/artic:latest'
            }
            // Add other container configurations
        }
    }
    
    singularity {
        singularity.enabled = true
        // Singularity-specific configurations
    }
}
```

### Resource Configuration

Adjust process resources based on your system:

```groovy
process {
    withName: 'artic' {
        cpus = 4
        memory = '8 GB'
        time = '2h'
    }
    
    withName: 'coverage' {
        cpus = 2
        memory = '4 GB'
        time = '1h'
    }
}
```

## Troubleshooting

### Common Issues

1. **Missing metadata file**:
   ```
   Error: Please provide a samplesheet XLSX file with --samplesheet
   ```
   Solution: Ensure the `--metadata` parameter points to a valid CSV file.

2. **Missing RunID**:
   ```
   Error: Please provide a RunID using --runID
   ```
   Solution: Provide a numeric RunID with `--runID 12345`.

3. **Data directory not found**:
   ```
   Error: Please provide full path to directory containing ONT results
   ```
   Solution: Verify the `--dataDir` path exists and contains ONT data.


## Citation

If you use this pipeline in your research, please cite:

1. **Nextflow**: Di Tommaso, P., et al. (2017). Nextflow enables reproducible computational workflows. Nature Biotechnology, 35(4), 316-319.
2. **ARTIC**: Quick, J., et al. (2017). Multiplex PCR method for MinION and Illumina sequencing of Zika and other virus genomes directly from clinical samples. Nature Protocols, 12(6), 1261-1276. // https://artic.network/about
3. **ProovFrame**: Hackl, S., et al. ProovFrame: Correcting frameshift errors in viral genome assemblies.
4. **Nextclade**: Aksamentov, I., et al. (2021). Nextclade: clade assignment, mutation calling and quality control for viral genomes. Journal of Open Source Software, 6(67), 3773.
5. **Pangolin**: O'Toole, Á., et al. (2021). Assignment of epidemiological lineages in an emerging pandemic using the pangolin tool. Virus Evolution, 7(2), veab064.

## License

This pipeline is released under the [MIT License](LICENSE).
---

**Pipeline Version**: 1.0.0  
**Last Updated**: December 2024  
**Maintainer**: Can Ruti Hospital Bioinformatics Team
