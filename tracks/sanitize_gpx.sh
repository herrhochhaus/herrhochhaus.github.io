#!/usr/bin/env bash
# Make sure to have xmlstarlet installed, e.g. using brew install xmlstarlet
# Thanks to Ole Begemann for providing the steps for cleaning up gpx files
# https://oleb.net/2020/sanitizing-gpx/

if [ $# -eq 0 ]
  then
    echo "Run this using"
    echo "bash sanitize_gpx.sh INPUTFILE.gpx OUTPUTFILE.gpx"
    exit 1
fi

INPUTFILE=$1
OUTPUTFILE=$2

echo "Step 1 - Sanitizing gpx file"
xmlstarlet ed \
  -d "//_:extensions" \
  -d "/_:gpx/_:metadata/_:time" \
  -d "/_:gpx/_:trk/_:type" \
  -d "//_:trkpt/_:time" \
  -d "//_:trkpt/_:hdop" \
  -d "//_:trkpt/_:vdop" \
  -d "//_:trkpt/_:pdop" \
  -u "/_:gpx/@creator" -v "Stephan Hochhaus" \
  $INPUTFILE \
  | xmlstarlet tr remove-unused-namespaces.xslt - \
  | xmlstarlet ed -u "/_:gpx/@xsi:schemaLocation" -v "http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd" \
  | xmllint --c14n11 --pretty 2 - \
  > $OUTPUTFILE

echo "Step 2 - Validating outout file"

xmlstarlet val --err --xsd \
  http://www.topografix.com/GPX/1/1/gpx.xsd \
  $OUTPUTFILE
