import pandas as pd
import argparse

# Set up argument parser
def parse_args():
    parser = argparse.ArgumentParser(description="Process an Excel file and export selected columns to CSV")
    parser.add_argument('--xlsx', type=str, required=True, help="Input Excel file (.xlsx)")
    parser.add_argument('--csv', type=str, required=True, help="Output CSV file")
    return parser.parse_args()

# Process Excel file
def process_excel(xlsx_file, csv_file):
    # Load Excel file into pandas DataFrame with headers
    df = pd.read_excel(xlsx_file, engine='openpyxl')

    # Define the column mapping based on headers
    required_columns = ['Barcode', 'sample_id', 'RunID']

    # Check if the required columns exist in the DataFrame
    if all(col in df.columns for col in required_columns):
        # Select the relevant columns
        selected_columns = df[['Barcode', 'sample_id', 'RunID']].copy()

        # Rename columns to match the desired output
        selected_columns.columns = ['barcode', 'sampleID', 'type']

        # Create alias column by duplicating sampleID
        selected_columns['alias'] = selected_columns['sampleID']

        # Prefix 'barcode' to the barcode column values
        selected_columns['barcode'] = 'barcode' + selected_columns['barcode'].astype(str)

        # Prefix 'M' to the 'type' column values
        selected_columns['type'] = 'M' + selected_columns['type'].astype(str)

        # Reorder columns as specified: barcode, sampleID, alias, type
        selected_columns = selected_columns[['barcode', 'sampleID', 'alias', 'type']]

        # Save to CSV without the index
        selected_columns.to_csv(csv_file, index=False)
        print(f"Data exported to {csv_file}")
    else:
        print(f"Error: The required columns ({', '.join(required_columns)}) were not found in the Excel file.")

# Main function to run the script
def main():
    args = parse_args()
    process_excel(args.xlsx, args.csv)

if __name__ == "__main__":
    main()
