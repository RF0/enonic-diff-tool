<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    exclude-result-prefixes="#all"
    
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
>
    
    <xsl:template name="siteProcessor">
        <xsl:param name="sourceTree" />
        <xsl:param name="targetTree" />
        <xsl:for-each select="$sourceTree/site">
            <xsl:variable name="sourceSiteName" select="@name"/>
            <xsl:variable name="sourcePortletCount" select="count(.//portlet)" />
            <xsl:variable name="targetPortletCount" select="count($targetTree/site[@name=$sourceSiteName]//portlet)" />
            <xsl:variable name="sourcePageTemplateCount" select="count(.//page-template)" />
            <xsl:variable name="targetPageTemplateCount" select="count($targetTree/site[@name=$sourceSiteName]//page-template)" />
            <div class="site">
                <h3>Site: <xsl:value-of select="@name"/></h3>
                <xsl:choose>
                    <xsl:when test="$targetTree/site[@name=$sourceSiteName] or $sourcePageTemplateCount != $targetPageTemplateCount">
                        <xsl:if test="$sourcePortletCount != $targetPortletCount">
                            <span class="error">
                                <xsl:value-of select="concat('Number of portlets in [source/target] : [', $sourcePortletCount, '/', $targetPortletCount, ']')" />
                                <br/>
                                <xsl:value-of select="concat('Number of page templates in [source/target] : [', $sourcePageTemplateCount, '/', $targetPageTemplateCount,']')" />
                            </span>
                        </xsl:if>
                            <xsl:call-template name="portletProcessor">
                            <xsl:with-param name="sourcePortlets" select=".//portlet" />
                            <xsl:with-param name="targetPortlets" select="$targetTree/site[@name=$sourceSiteName]//portlet" />
                        </xsl:call-template>
                        <xsl:call-template name="pageTemplateProcessor">
                            <xsl:with-param name="sourcePageTemplates" select=".//page-template" />
                            <xsl:with-param name="targetPageTemplates" select="$targetTree/site[@name=$sourceSiteName]//page-template" />                            
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="error">No site in target exists with this name.</span>
                    </xsl:otherwise>
                </xsl:choose>                
            </div>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="portletProcessor">
        <xsl:param name="sourcePortlets" />
        <xsl:param name="targetPortlets" />
        <xsl:for-each select="$sourcePortlets">
            <xsl:variable name="sourcePortletName" select="@name"/>
            <xsl:variable name="sourceDatasourceCount" select="count($sourcePortlets[@name=$sourcePortletName]/datasources/datasource)" />
            <xsl:variable name="targetDatasourceCount" select="count($targetPortlets[@name=$sourcePortletName]/datasources/datasource)" />
            <div class="portlet">
                <h3>Portlet: <xsl:value-of select="./@name" /></h3>
                <!--
                    Number of datasources in [source/target]: <xsl:value-of select="concat('[', $sourceDatasourceCount, '/', $targetDatasourceCount ,']')" /><br/>
                -->
                <xsl:choose>
                    <xsl:when test="$targetPortlets[@name=$sourcePortletName]">
                        <xsl:call-template name="datasourceProcessor">
                            <xsl:with-param name="sourceDatasources" select="./datasources/datasource" />
                            <xsl:with-param name="targetDatasources" select="$targetPortlets[@name=$sourcePortletName]/datasources/datasource" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="error">No portlet exists in target with this name.</span> 
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="pageTemplateProcessor">
        <xsl:param name="sourcePageTemplates" />
        <xsl:param name="targetPageTemplates" />
        <xsl:for-each select="$sourcePageTemplates">
            <xsl:variable name="sourcePageTemplateName" select="@name" />            
            <xsl:variable name="sourcePageTemplateCount" select="count($sourcePageTemplates[@name=$sourcePageTemplateName]/datasources/datasource)" />
            <xsl:variable name="targetPageTemplateCount" select="count($targetPageTemplates[@name=$sourcePageTemplateName]/datasources/datasource)" />            
            <div class="pagetemplate">
                <h3>Page template: <xsl:value-of select="@name" /></h3>
                <xsl:if test="$sourcePageTemplateCount != $targetPageTemplateCount">
                    <span class="error">
                        <xsl:value-of select="concat('Number of datasources in [source/target] : [', $sourcePageTemplateCount, '/', $targetPageTemplateCount ,']')" />
                    </span>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$targetPageTemplates[@name=$sourcePageTemplateName]">                        
                        <xsl:call-template name="datasourceProcessor">
                            <xsl:with-param name="sourceDatasources" select="./datasources/datasource" />
                            <xsl:with-param name="targetDatasources" select="$targetPageTemplates[@name=$sourcePageTemplateName]/datasources/datasource" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="error">No page template exists in target with this name.</span> 
                    </xsl:otherwise>
                </xsl:choose>                
            </div>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="datasourceProcessor">
        <xsl:param name="sourceDatasources" />
        <xsl:param name="targetDatasources" />               
        <xsl:for-each select="$sourceDatasources">            
            <div class="datasource">                
                <xsl:variable name="currentPosition" select="position()" />                
                <xsl:variable name="sourceMethodName" select="@name" />
                <xsl:variable name="sourceResultElementName" select="@result-element" />
                <xsl:variable name="sourceParams" select="
                    if(@result-element) then
                        .[@result-element=$sourceResultElementName and @name=$sourceMethodName]/parameter
                    else
                        .[not(@result-element) and @name=$sourceMethodName]/parameter
                    "/>
                <!-- TBD: this is somewhat buggy ... else(no result element) loops in order -->
                <xsl:variable name="targetParams" select="
                    if(@result-element) then
                        $targetDatasources[@result-element=$sourceResultElementName and @name=$sourceMethodName][$currentPosition]/parameter
                    else
                        $targetDatasources[$currentPosition]/parameter
                    " />
                <xsl:variable name="sourceParamCount" select="count($sourceParams)" />
                <xsl:variable name="targetParamCount" select="count($targetParams)" />                
                <h3><xsl:value-of select="@name"/></h3>
                <xsl:value-of select="if(@result-element) then concat('Result element: ', @result-element) else ''"/>
                <!-- 
                    Number of parameters in [source/target]: <xsl:value-of select="concat('[', $sourceParamCount, '/', $targetParamCount, ']')" /><br/>
                -->               
                <xsl:choose>
                    <xsl:when test="$targetDatasources[@name=$sourceMethodName]">
                        <xsl:call-template name="paramProcessor">
                            <xsl:with-param name="sourceParams" select="$sourceParams" />
                            <xsl:with-param name="targetParams" select="$targetParams" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="error">No datasource exists in target with this name.</span>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:for-each>        
    </xsl:template>
    
    <xsl:template name="paramProcessor">
        <xsl:param name="sourceParams" />
        <xsl:param name="targetParams" />
        <table>
            <thead>
                <td>Name</td>
                <td>Source value</td>
                <td>Target value</td>
            </thead>
            <xsl:for-each select="$sourceParams">
                <xsl:variable name="sourceParamName" select="@name" />                                
                <tr>
                    <xsl:if test=". != $targetParams[@name=$sourceParamName]">
                        <xsl:attribute name="class">error</xsl:attribute>
                    </xsl:if>
                    <td><xsl:value-of select="$sourceParamName" /></td>
                    <td><xsl:value-of select="."/></td>
                    <td><xsl:value-of select="$targetParams[@name=$sourceParamName]" /></td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>
    
    
</xsl:stylesheet>