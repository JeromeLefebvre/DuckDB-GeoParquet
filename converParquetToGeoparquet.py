import geopandas as gpd
import pandas as pd

df = pd.read_parquet("Maps/dayAsWKB.parquet")

# convert WKT to
gpd.GeoSeries.from_wkb(df.pointWKB)

gdf = gpd.GeoDataFrame(
    df, geometry=gpd.GeoSeries.from_wkb(df.pointWKB), crs="EPSG:4326"
)

gdf

gdf = gdf.drop(['pointWKB'], axis=1)
gdf.to_parquet('day.parquet')

gdf = gpd.read_parquet("Maps/day.parquet", columns=['point'])
