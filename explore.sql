load spatial;

create or replace view oneCentury as
select st_point(0,0), date'1900-01-01 00:00:00' + interval (range) hours as time, range % 10 from range(1,1000000);

copy oneCentury to 'Maps/oneCentury.gdb' with (format GDAL, driver 'OpenFileGDB', SRS 'EPSG:4326', GEOMETRY_TYPE 'point', layer_name 'Bug');

copy oneCentury to 'Maps/oneCentury.geojson' with (format GDAL, driver 'geojson', SRS 'EPSG:4326', GEOMETRY_TYPE 'point', layer_name 'NoBug');

copy (
select ST_AsWKB(st_point(0,0)) as geometry, date'1900-01-01 00:00:00' + interval (range) hours as time, range % 10 from range(1,1000000)
) to 'Maps/oneCentury.shp' with (format GDAL, driver 'ESRI Shapefile');

-- Naive
copy (
select ST_AsWKB(st_point(0,0)) as geometry, date'1900-01-01 00:00:00' + interval (range) hours as time, range % 10 as OneToTen from range(1,1000000)
) to 'Maps/oneCentury.parquet' (format 'parquet');

-- Add compression
copy (
select ST_AsWKB(st_point(0,0)) as geometry, date'1900-01-01 00:00:00' + interval (range) hours as time, range % 10 as OneToTen from range(1,1000000)
) to 'Maps/oneCenturyCompressed.parquet' (format 'parquet', COMPRESSION 'zstd', ROW_GROUP_SIZE 160);

.mode line
.mode duckbox

select row_group_num_rows from parquet_metadata('Maps/oneCenturyCompressed.parquet');

from st_read('Maps/oneCentury.gdb');
from st_read('Maps/oneCentury.geojson');

from 'Maps/Nobug.parquet';

describe from 'maps/oneCentury.parquet';
describe from 'maps/oneCenturyWithIndex.parquet';