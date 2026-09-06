load spatial;

create view example as
from parquet_metadata('GitHub/examples/example.parquet');

DESCRIBE example;
