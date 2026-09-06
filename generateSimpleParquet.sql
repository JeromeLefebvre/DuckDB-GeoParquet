load spatial;

-- Create a simple geoparquet file
copy (
    from range(1,876576)
    select
        ST_AsWKB(st_point(0,0)) as geometry,
        date'1900-01-01 00:00:00' + interval (range) hours as time,
        range % 10 as OneToTen 
) to 'Maps/oneCenturyCompressed.parquet' (format 'parquet', COMPRESSION 'zstd', ROW_GROUP_SIZE 160);
