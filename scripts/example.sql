--wget https://github.com/nmaillard/Phoenix-Hive/blob/master/target/phoenix-hive-4.2.0-jar-with-dependencies.jar
--wget https://github.com/gbraccialli/GeohashHiveUDF/raw/master/target/GeohashHiveUDF-1.0-SNAPSHOT-jar-with-dependencies.jar


add jar /jars/GeohashHiveUDF-1.0-SNAPSHOT-jar-with-dependencies.jar;
add jar /jars/phoenix-hive-4.2.0-jar-with-dependencies.jar;
CREATE TEMPORARY FUNCTION GeohashEncode as 'com.github.gbraccialli.GeohashHiveUDF.UDFGeohashEncode';
CREATE TEMPORARY FUNCTION GeohashDecode as 'com.github.gbraccialli.GeohashHiveUDF.UDFGeohashDecode';
set hive.execution.engine=mr;

CREATE EXTERNAL TABLE IF NOT EXISTS crimes ( 
  id BIGINT, 
  case_number string, 
  date string, 
  block string, 
  iucr string, 
  primary_type string, 
  description string, 
  location_desc string, 
  arrest string, 
  domestic string, 
  beat string, 
  district string, 
  ward int, 
  community int, 
  fbi_code string, 
  x_coord BIGINT, 
  y_coord BIGINT, 
  year int, 
  updated string, 
  latitude DOUBLE, 
  longitude DOUBLE, 
  location string
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
location '/test/crimes/'
;

CREATE EXTERNAL TABLE crimes_phoenix(
  id BIGINT, 
  case_number string, 
  date string, 
  block string, 
  iucr string, 
  primary_type string, 
  description string, 
  location_desc string, 
  arrest string, 
  domestic string, 
  beat string, 
  district string, 
  ward int, 
  community int, 
  fbi_code string, 
  x_coord BIGINT, 
  y_coord BIGINT, 
  year int, 
  updated string, 
  latitude DOUBLE, 
  longitude DOUBLE, 
  location string,
  geohash string
)
 STORED BY  "org.apache.phoenix.hive.PhoenixStorageHandler"
 TBLPROPERTIES(
     'phoenix.hbase.table.name'='crimes_phoenix',
     'phoenix.zookeeper.znode.parent'='hbase-unsecure',
     'phoenix.rowkeys'='geohash',
     'autocreate'='true',
     'autodrop'='true'
 );

 
INSERT INTO TABLE crimes_phoenix
SELECT * FROM 
(
   SELECT crimes.*, GeohashEncode(latitude, longitude, 12) as geohash
   FROM crimes
) t1
where geohash is not null;


--option 2, using reflection instead of udf;
INSERT INTO TABLE crimes_phoenix
SELECT * FROM 
(
   SELECT crimes.*, reflect('com.github.davidmoten.geo.GeoHash', 'encodeHash', latitude, longitude, 12) as geohash
   FROM crimes
) t1
where geohash is not null;
