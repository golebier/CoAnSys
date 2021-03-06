#!/bin/bash

SCRIPT=$1
OUTPUT_PATH=$2
JARS=../../../../integration/src/main/oozie/full/workflow/lib/*.jar

hadoop fs -rm -r ${OUTPUT_PATH}

pig -p tfidfMinValue=0.5 -p tmpCompressionCodec=gz -p sample=0.1 -p similarityTopnDocumentPerDocument=20 -p commonJarsPath=${JARS} -p parallel=20 -p inputPath=full/hbase-dump/mproto-m*1 -p outputPath=${OUTPUT_PATH} -p mapredChildJavaOpts=-Xmx10000m -f ${SCRIPT}
