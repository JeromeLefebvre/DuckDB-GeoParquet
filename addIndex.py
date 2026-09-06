import pandas as pd

# Read the Parquet file
df = pd.read_parquet('maps/oneCenturyCompressed.parquet')

df.index
# Set the desired column as the index
df.set_index('time', inplace=True)

# Save the DataFrame back to a Parquet file
df.to_parquet('maps/oneCenturyCompressedIndex.parquet')
