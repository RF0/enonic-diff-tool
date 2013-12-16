<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    exclude-result-prefixes="#all"
    
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    >
    
    <xsl:template name="contentTypeProcessor">
        <xsl:param name="sourceTree" />
        <xsl:param name="targetTree" />
        <xsl:variable name="sourceContentTypeCount" select="count($sourceTree/content-types/content-type)"/>
        <xsl:variable name="targetContentTypeCount" select="count($targetTree/content-types/content-type)"/>
        Number of content types in [source/target]: <xsl:value-of select="concat('[', $sourceContentTypeCount, '/', $targetContentTypeCount, ']')" />        
        
        <xsl:for-each select="$sourceTree/content-types/content-type">
            <xsl:variable name="sourceContentTypeName" select="@name"/>
            <xsl:variable name="targetContentType" select="$targetTree/content-types/content-type[@name=$sourceContentTypeName]" />
            <div class="contenttype">
                <h3><xsl:value-of select="@name" /> [key: <xsl:value-of select="@key"/>]</h3>
                <xsl:choose>
                    <xsl:when test="$targetContentType">
                        <!-- config, indexparams, browse -->
                        Config: <xsl:value-of select="
                            if (moduledata/config) then
                                if ($targetContentType/moduledata/config) then
                                    @name
                                else
                                    'no content type config in target'
                            else
                                'no config element present.'
                        "/>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="error">No content type in target exists with this name.</span>
                    </xsl:otherwise>
                </xsl:choose>
            </div>        
        </xsl:for-each>
        
    </xsl:template>

</xsl:stylesheet>