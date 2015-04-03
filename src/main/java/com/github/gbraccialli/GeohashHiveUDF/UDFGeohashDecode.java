package com.github.gbraccialli.GeohashHiveUDF;

import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.hadoop.hive.serde2.io.DoubleWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;

import com.github.davidmoten.geo.GeoHash;
import com.github.davidmoten.geo.LatLong;

public class UDFGeohashDecode extends UDF {
	
	public Text evaluate(Text geohash) {

		if (geohash == null) {
			return null;
		}
		
		LatLong location = GeoHash.decodeHash(geohash.toString());

        return new Text(location.getLat() + "," + location.getLon());
	}
	
}
