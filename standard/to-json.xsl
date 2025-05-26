<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:j="http://www.w3.org/2013/XSLT/xml-to-json"
  exclude-result-prefixes="xs fn j" 
  default-mode="j:xml-to-json" 
  version="3.0">
  <xsl:output omit-xml-declaration="true"/>
  
  <xsl:template match="/">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="array">
    <xsl:if test="position()>1">,</xsl:if>
    <xsl:text>[</xsl:text>
    <xsl:apply-templates select="*"/>
    <xsl:text>]</xsl:text> 
  </xsl:template>
  
  <xsl:template match="map">
    <xsl:if test="position()>1">,</xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:apply-templates select="*"/>
    <xsl:text>}</xsl:text>       
  </xsl:template>
  
  <xsl:template match="true">
    <xsl:if test="position()>1">,</xsl:if>
    <xsl:if test="@key">
      <xsl:text>"</xsl:text>
      <xsl:value-of select="@key"/>
      <xsl:text>":</xsl:text>           
    </xsl:if>
    <xsl:text>true</xsl:text>
  </xsl:template>
  
  <xsl:template match="false">
    <xsl:if test="position()>1">,</xsl:if>
    <xsl:if test="@key">
      <xsl:text>"</xsl:text>
      <xsl:value-of select="@key"/>
      <xsl:text>":</xsl:text>           
    </xsl:if>
    <xsl:text>false</xsl:text>
  </xsl:template>
  
  <xsl:template match="null">
    <xsl:if test="position()>1">,</xsl:if>
    <xsl:if test="@key">
      <xsl:text>"</xsl:text>
      <xsl:value-of select="@key"/>
      <xsl:text>":</xsl:text>           
    </xsl:if>
    <xsl:text>null</xsl:text>
  </xsl:template>
  
  <xsl:template match="number">
    <xsl:if test="position()>1">,</xsl:if>
    <xsl:if test="@key">
      <xsl:text>"</xsl:text>
      <xsl:value-of select="@key"/>
      <xsl:text>":</xsl:text>           
    </xsl:if>
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="string">
    <xsl:if test="position()>1">,</xsl:if>
    <xsl:if test="@key">
      <xsl:text>"</xsl:text>
      <xsl:value-of select="@key"/>
      <xsl:text>":</xsl:text>           
    </xsl:if>
    <xsl:text>"</xsl:text>           
    <xsl:value-of select="j:escape(.)"/>
    <xsl:text>"</xsl:text>           
  </xsl:template>
  
  <!-- Function to escape special characters -->
  <xsl:function name="j:escape" as="xs:string">
    <xsl:param name="in" as="xs:string"/>
    <xsl:value-of>
      <xsl:for-each select="string-to-codepoints($in)">
        <xsl:choose>
          <xsl:when test=". gt 65535">
            <xsl:value-of select="concat('\u', j:hex4((. - 65536) idiv 1024 + 55296))"/>
            <xsl:value-of select="concat('\u', j:hex4((. - 65536) mod 1024 + 56320))"/>
          </xsl:when>
          <xsl:when test=". = 34">\"</xsl:when>
          <xsl:when test=". = 92">\\</xsl:when>
          <xsl:when test=". = 08">\b</xsl:when>
          <xsl:when test=". = 09">\t</xsl:when>
          <xsl:when test=". = 10">\n</xsl:when>
          <xsl:when test=". = 12">\f</xsl:when>
          <xsl:when test=". = 13">\r</xsl:when>
          <xsl:when test=". lt 32 or (. ge 127 and . le 160)">
            <xsl:value-of select="concat('\u', j:hex4(.))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="codepoints-to-string(.)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:value-of>
  </xsl:function>
  
  <!-- Function to convert a UTF16 codepoint into a string of four hex digits -->
  <xsl:function name="j:hex4" as="xs:string">
    <xsl:param name="ch" as="xs:integer"/>
    <xsl:variable name="hex" select="'0123456789abcdef'"/>
    <xsl:value-of>
      <xsl:value-of select="substring($hex, $ch idiv 4096 + 1, 1)"/>
      <xsl:value-of select="substring($hex, $ch idiv 256 mod 16 + 1, 1)"/>
      <xsl:value-of select="substring($hex, $ch idiv 16 mod 16 + 1, 1)"/>
      <xsl:value-of select="substring($hex, $ch mod 16 + 1, 1)"/>
    </xsl:value-of>
  </xsl:function>
  
</xsl:stylesheet>