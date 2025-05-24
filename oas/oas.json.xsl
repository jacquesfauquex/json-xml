<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="4.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:map="http://www.w3.org/2005/xpath-functions/map"
	xmlns:array="http://www.w3.org/2005/xpath-functions/array"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	exclude-result-prefixes="#all"
	expand-text="yes">
	
	<xsl:output indent="yes"/>
	
	<xsl:template match=".[. instance of map(*)]"><!-- object -->
		<xsl:param name="key"/>
		<object>
			<xsl:if test="$key"><xsl:attribute name="key" select="$key"/></xsl:if>
			<xsl:variable name="keysvalues" select="."/>
			
			<xsl:iterate select="map:keys($keysvalues)">   
				<xsl:variable name="childkey" select="."/>
				<xsl:choose>
					<xsl:when test="not(exists($keysvalues(.)))">
						<string>
							<xsl:attribute name="key" select="$childkey"/>
							<xsl:attribute name="type" select="'null'"/>
						</string>	
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$keysvalues(.)">
							<xsl:with-param name="key" select="$childkey"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:iterate>
		</object>
	</xsl:template>
	
	<xsl:template match=".[. instance of array(*)]">
		<xsl:param name="key"/>
		<array>
			<xsl:if test="$key"><xsl:attribute name="key" select="$key"/></xsl:if>
			<xsl:call-template name="loop">
				<xsl:with-param name="array" select="."/>
				<xsl:with-param name="top" select="array:size(.)"/>
				<xsl:with-param name="counter" select="1"/>				
			</xsl:call-template>
		</array>
	</xsl:template>
	
	<xsl:template name="loop">
		<xsl:param name="array"></xsl:param>
		<xsl:param name="top">0</xsl:param>
		<xsl:param name="counter">1</xsl:param>
		<xsl:if test="$counter &lt;= $top">
			<xsl:choose>
				<xsl:when test="not(exists($array($counter)))"><string type="null"/></xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="$array($counter)">
						<xsl:with-param name="key"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="loop">
				<xsl:with-param name="array" select="$array"/>
				<xsl:with-param name="top" select="$top"/>
				<xsl:with-param name="counter" select="$counter + 1"/>				
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
		
	<!--number  true false null are processed as string-->
	<xsl:template match=".[. castable as xs:string]">
		<xsl:param name="key"/>		
		<string>
			<xsl:if test="$key"><xsl:attribute name="key" select="$key"/></xsl:if>
			<xsl:choose>
				<xsl:when test=". instance of xs:double"><xsl:attribute name="type" select="'number'"/><xsl:value-of select="."/></xsl:when>
				<xsl:when test=".[. instance of xs:boolean] = true()"><xsl:attribute name="type" select="'true'"/></xsl:when>
				<xsl:when test=".[. instance of xs:boolean] = false()"><xsl:attribute name="type" select="'false'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</string>
	</xsl:template>
	
</xsl:stylesheet>