<?xml version="1.0"?>

<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>

<!--

This stylesheet is created for the NISP , and is
intended to create an overview of the starndard database.

Copyright (c) 2003, 2014  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default date saxon">


<xsl:output method="xml" indent="no" saxon:next-in-chain="p2-overview.xsl"/>

<xsl:param name="describe" select="''"/>


<xsl:strip-space elements="*"/>
  


<!-- If this param is set to one, only one headline is generated.
     You can therefore use the import the html file in a spreadsheet program 
     and use the freeze pane facility -->

<xsl:param name="excelXP" select="0"/>


<xsl:template match="standards">
  <xsl:message>Generating DB Overview.</xsl:message>
  <html>
    <head>
      <title>Overview of the NISP Standard Database</title>
      <style type="text/css">
        .head {background-color: #808080;  }
        .body,table {font-family: sans-serif;}
        .table {width: 100%;}
        .deleted { background-color: #FF5A41; color: white; font-weight: bold;}
        .missing { background-color: #FFFEA0;}
        .head { }
        .date {white-space: nowrap;}
      </style>
    </head>
    <body>

    <h1>Overview of the NISP Standard Database</h1>

    <xsl:variable name="date">
      <xsl:value-of select="date:date-time()"/>
    </xsl:variable>

    <xsl:variable name="formatted-date">
      <xsl:value-of select="date:month-abbreviation($date)"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="date:day-in-month()"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="date:year()"/>
      <xsl:text> - </xsl:text>
      <xsl:value-of select="substring-before(substring-after($date, 'T'),'+')"/>
    </xsl:variable>

    <p><xsl:text>Created on </xsl:text><xsl:value-of select="$formatted-date"/><xsl:text> using rev. </xsl:text><xsl:value-of select="$describe"/></p>
   
    <h2>Statistics</h2>

    <table border="0">
      <tr>
        <td><b>Rec</b></td>
        <td><b>Total</b></td>
        <td><b>Deleted</b></td>
        <td><b>Rejected</b></td>
      </tr>
      <tr>
        <td>standards</td>
        <td align="right"><xsl:value-of select="count(.//standard)"/></td>
        <td align="right"><xsl:value-of select="count(.//event[(@flag='deleted') and ancestor::standard])"/></td>
        <td align="right"><xsl:value-of select="count(.//standard[status='rejected'])"/></td>
      </tr>
      <tr>
        <td>profiles</td>
        <td align="right"><xsl:value-of select="count(.//profile)"/></td>
        <td align="right"><xsl:value-of select="count(.//event[(@flag='deleted') and ancestor::profile])"/></td>
        <td align="right"><xsl:value-of select="count(.//profile[status='rejected'])"/></td>
       </tr>
    </table>


  <h2>Standards</h2>

  <p>This page contains tables of all standards and profiles included in
  the database. The standards and profiles are sorted by the <emphasis>id</emphasis> attribute.</p>

  <p>In this overview, rows with a red background are represent 
  deleted standards and profiles. Cells with a yellow background, indicates that that we
  properly don't have the information for this field. It will be
  appreciated very much, if YOU will identify this information and send it to <a href="mailto:stavnstrup@mil.dk">me</a>.</p>


   <ul>
     <li><b>Rec</b> - The sorted position of the <i>standard</i> or <i>profile</i> in the database</li>
     <li><b>ID</b> - What ID is associated with this <i>standard</i></li>
     <li><b>Type</b> - Is this a <i>coverstandard</i> (CS), a <i>single standard</i> (S) or a <i>sub standard</i> (SS)</li>
     <li><b>Org</b> - What organisation have published this <i>standard</i></li>
     <li><b>Pubnum</b> - The publication number of the <i>standard</i></li>
     <li><b>Title</b> - The title of the <i>standard</i></li>
     <li><b>Date</b> - The publication date of the <i>standard</i></li>
     <li><b>Ver</b> - Version of the <i>standard</i> or <i>profile</i></li>
     <li><b>Correction</b> - Correction info for
        this <i>standard</i>. There might be multiple corrections
        records (Technical Correction, Ammentment etc.). Each record
        begins on a new line</li>
     <li><b>AKA</b> - (Also Known As) A standard can be published by
        another organisation. There might be multiple AKA record. Each
        record begins on a new line</li>
     <li><b>Tag</b> - What Tag is associated with this record</li>
     <li><b>Select</b> - Is this record selected by NATO (M : Mandatory, E: Emerging, F: fading)</li>

     <li><b>History</b> - What is the history of the record</li>
   </ul>

  <xsl:if test="$excelXP = 1">
    <table border="1" width="100%">
      <xsl:call-template name="htmlheader"/>
    </table>
  </xsl:if>

  <table class="overview" border="1">
    <xsl:call-template name="htmlheader"/>
    <xsl:apply-templates select="records/standard">
      <xsl:sort select="@id" order="ascending"/>
    </xsl:apply-templates>
  </table>

  <h2>Profiles</h2>
    
  <table class="overview" border="1">
    <xsl:call-template name="htmlheader"/>
    <xsl:apply-templates select="//profile">
      <xsl:sort select="@id" order="ascending"/>
    </xsl:apply-templates>
  </table>
  
  </body></html>
</xsl:template>


<xsl:template name="htmlheader">
  <tr class="head">
    <td><b>Rec</b></td>
    <td><b>ID</b></td>
    <td><b>Type</b></td>
    <td><b>Org</b></td>
    <td><b>PubNum</b></td>
    <td><b>Title</b></td>
    <td><b>Date</b></td>
    <td><b>Ver</b></td>
    <td><b>Correction</b></td>
    <td><b>AKA</b></td>
    <td><b>Tag</b></td>
    <td><b>Select</b></td>
    <td><b>History</b></td>
   </tr>
</xsl:template>


<xsl:template match="profile">
  <xsl:variable name="myid" select="@id"/>
  <tr>
    <xsl:if test=".//event[(position()=last()) and (@flag = 'deleted')]">
      <xsl:attribute name="class">deleted</xsl:attribute>
    </xsl:if>
    <td><xsl:value-of select="@id"/></td>
    <td align="center">
      <xsl:choose>
        <xsl:when test="@type='base'">BP</xsl:when>
        <xsl:when test="@type='coi'">C</xsl:when>
        <xsl:otherwise>CM</xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
      <xsl:if test="profilespec/@orgid =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="profilespec/@orgid"/>&nbsp;
    </td>
    <td>
      <xsl:if test="profilespec/@pubnum =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="profilespec/@pubnum"/>&nbsp;
    </td>
    <td>
      <xsl:if test="profilespec/@title =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="profilespec/@title"/>&nbsp;
      <xsl:apply-templates select="parts"/>
    </td>
    <td class="date">
      <xsl:if test="profilespec/@date =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="profilespec/@date"/>&nbsp;
    </td>        
    <td><xsl:value-of select="profilespec/@version"/>&nbsp;</td>        
    <td><xsl:apply-templates select="document/correction"/>&nbsp;</td>
    <td><xsl:apply-templates select="document/alsoknown"/>&nbsp;</td>
    <td>
      <xsl:if test="@tag =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="@tag"/>&nbsp;</td>
    <td align="center">
      <xsl:if test="/standards/lists//select[(@mode='mandatory') and (@id=$myid)]">M,</xsl:if>
      <xsl:if test="/standards/lists//select[(@mode='emerging') and (@id=$myid)]">E,</xsl:if>
      <xsl:if test="/standards/lists//select[(@mode='fading') and (@id=$myid)]">F,</xsl:if>
      &nbsp;
    </td>
    <td><xsl:apply-templates select=".//event"/>&nbsp;</td>
  </tr>
</xsl:template>

<xsl:template match="parts">
  <ul>
   <xsl:apply-templates/>
  </ul>
</xsl:template>


<xsl:template match="refstandard">
  <xsl:variable name="refid" select="@refid"/>
  <li>
    <xsl:text>(S: </xsl:text>
    <xsl:value-of select="@refid"/>
    <xsl:text>) </xsl:text>
    <xsl:apply-templates select="/standards/records/standard[@id=$refid]/document/@title"/>
  </li>
</xsl:template>

<xsl:template match="refprofile">
  <xsl:variable name="refid" select="@refid"/>
  <li>
    <xsl:text>(P: </xsl:text>
    <xsl:value-of select="@refid"/>
    <xsl:text>) </xsl:text>
    <xsl:apply-templates select="/standards/records/profile[@id=$refid]/profilespec/@title"/>
  </li>
</xsl:template>



<xsl:template match="standard">
  <xsl:variable name="myid" select="@id"/>
  <tr>
    <xsl:if test=".//event[(position()=last()) and (@flag = 'deleted')]">
      <xsl:attribute name="class">deleted</xsl:attribute>
    </xsl:if>
<!--
    <td align="right"><xsl:number from="records" count="standard" format="1" level="any"/></td>
-->
    <td><xsl:value-of select="@id"/></td>
    <td align="center">
      <xsl:choose>
        <xsl:when test="document/substandards">CS</xsl:when>
        <xsl:when test="//substandards/refstandard/@refid=$myid">SS</xsl:when>
        <xsl:otherwise>S</xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
      <xsl:if test="document/@orgid =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@orgid"/>
    </td>
    <td>
      <xsl:if test="document/@pubnum =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@pubnum"/>
    </td>
    <td>
      <xsl:if test="document/@title =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@title"/>
    </td>
    <td class="date">
      <xsl:if test="document/@date =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@date"/>
    </td>        
    <td><xsl:value-of select="document/@version"/>&nbsp;</td>        
    <td><xsl:apply-templates select="document/correction"/>&nbsp;</td>
    <td><xsl:apply-templates select="document/alsoknown"/>&nbsp;</td>
    <td>
      <xsl:if test="@tag =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>            
      <xsl:value-of select="@tag"/>&nbsp;</td>
    <td align="center">
      <xsl:if test="/standards/lists//select[(@mode='mandatory') and (@id=$myid)]">M,</xsl:if>
      <xsl:if test="/standards/lists//select[(@mode='emerging') and (@id=$myid)]">E,</xsl:if>
      <xsl:if test="/standards/lists//select[(@mode='fading') and (@id=$myid)]">F,</xsl:if>
      &nbsp;
    </td>
    <td class="date"><xsl:apply-templates select=".//event"/>&nbsp;</td>
  </tr>
</xsl:template>


<xsl:template match="correction">
  <xsl:if test="position()=1 and (@cpubnum = ''or @date = '')">
    <xsl:attribute name="bgcolor">yellow</xsl:attribute>
  </xsl:if>
  <xsl:value-of select="@cpubnum"/><xsl:text>:</xsl:text><xsl:value-of select="@date"/>
  <xsl:if test=".!=''"><xsl:text> (</xsl:text><xsl:value-of select="."/><xsl:text>)</xsl:text></xsl:if>
  <xsl:if test="following-sibling::correction[position()=1]"><br /></xsl:if>
</xsl:template>


<xsl:template match="alsoknown">
  <xsl:value-of select="@orgid"/><xsl:text>:</xsl:text><xsl:value-of 
       select="@pubnum"/><xsl:text>:</xsl:text><xsl:value-of select="@date"/>
  <xsl:if test="following-sibling::alsoknown[position()=1]"><br /></xsl:if>
</xsl:template>


<xsl:template match="event">
  <xsl:if test="position()=1 and (@date = '')">
    <xsl:attribute name="class">missing</xsl:attribute>
  </xsl:if>
  <xsl:value-of select="translate(substring(@flag,1,1), 'acd', 'ACD')"/>
  <xsl:text>:</xsl:text><xsl:value-of select="@date"/>
  <xsl:if test="following-sibling::event[position()=1]"><br /></xsl:if>
</xsl:template>


<xsl:template match="*"/>


</xsl:stylesheet>
