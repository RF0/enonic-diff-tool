#!/bin/sh
java -jar lib/saxon9he.jar -s:data/config.xml -xsl:xsl/compare.xsl -o:out/index.html