<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 

    exclude-result-prefixes="#all"
    
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
>
    
    <xsl:output method="xhtml" omit-xml-declaration="yes"/>
    <xsl:include href="siteUtilz.xsl"/>
    <xsl:include href="ctyUtilz.xsl"/>
    <xsl:variable name="configFile" select="document('../data/config.xml')/configuration"/>    
        
    <xsl:template match="/">
        <xsl:result-document href="../out/index.html">
            <html>
                <head><title>compare</title></head>
                <body>
                    <ul>                        
                    <xsl:for-each select="configurations/configuration">
                        
                        <xsl:variable name="outFile" select="out/@file" />
                        <xsl:variable name="reverseOutFile" select="replace(out/@file, '.html', '-reverse.html')"/>
                        
                        <xsl:variable name="sourceFile" select="source/@file" />
                        <xsl:variable name="targetFile" select="target/@file" />
                        <xsl:variable name="sourceTree" select="document($sourceFile)/extract" />
                        <xsl:variable name="targetTree" select="document($targetFile)/extract" />            
                        
                        <li><a href="{$outFile}"><xsl:value-of select="out/@name"/></a></li>
                        <li><a href="{$reverseOutFile}">reverse <xsl:value-of select="out/@name"/></a></li>
                        <xsl:result-document href="{$outFile}">
                            <xsl:call-template name="outputFile">
                                <xsl:with-param name="sourceFile" select="$sourceFile"/>
                                <xsl:with-param name="targetFile" select="$targetFile"/>
                                <xsl:with-param name="sourceTree" select="$sourceTree"/>
                                <xsl:with-param name="targetTree" select="$targetTree"/>
                            </xsl:call-template>
                        </xsl:result-document>
                        <xsl:result-document href="{$reverseOutFile}">
                            <xsl:call-template name="outputFile">
                                <xsl:with-param name="sourceFile" select="$targetFile"/>
                                <xsl:with-param name="targetFile" select="$sourceFile"/>
                                <xsl:with-param name="sourceTree" select="$targetTree"/>
                                <xsl:with-param name="targetTree" select="$sourceTree"/>
                            </xsl:call-template>
                        </xsl:result-document>                        
                    </xsl:for-each>
                    </ul>                   
                </body>                
            </html>            
        </xsl:result-document>
    </xsl:template>
        
    <xsl:template name="outputFile">  
        
        <xsl:param name="sourceFile" />
        <xsl:param name="targetFile" />
        <xsl:param name="sourceTree" />
        <xsl:param name="targetTree" />
        
        <html xmlns="http://www.w3.org/1999/xhtml" lang="no">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                <title>compare</title>
                <script type="text/javascript" src="http://code.jquery.com/jquery-1.7.1.min.js" />
                <script type="text/javascript" src="../web/compare.js" />
                <link rel="stylesheet" type="text/css" href="../web/compare.css" />
            </head>
            <body>                
                <div class="config">
                    <strong>Source system: </strong><xsl:value-of select="concat($configFile/source/@name, ' [', $sourceFile, ']')"/><br/>
                    <strong>Target system: </strong><xsl:value-of select="concat($configFile/target/@name, ' [', $targetFile, ']')"/>
                </div>
                <xsl:call-template name="siteProcessor">
                    <xsl:with-param name="sourceTree" select="$sourceTree" />
                    <xsl:with-param name="targetTree" select="$targetTree" />                         
                </xsl:call-template>
                <!--xsl:call-template name="contentTypeProcessor">
                    <xsl:with-param name="sourceTree" select="$sourceTree" />
                    <xsl:with-param name="targetTree" select="$targetTree" />                         
                </xsl:call-template-->                                
            </body>
        </html>
        
    </xsl:template>
          
</xsl:stylesheet>