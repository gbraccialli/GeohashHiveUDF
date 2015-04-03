--wget https://github.com/gbraccialli/GeohashHiveUDF/raw/master/target/GeohashHiveUDF-1.0-SNAPSHOT-jar-with-dependencies.jar
add jar /jars/GeohashHiveUDF-1.0-SNAPSHOT-jar-with-dependencies.jar;

CREATE TEMPORARY FUNCTION GeohashEncode as 'com.github.gbraccialli.GeohashHiveUDF.UDFGeohashEncode';
CREATE TEMPORARY FUNCTION GeohashDecode as 'com.github.gbraccialli.GeohashHiveUDF.UDFGeohashDecode';