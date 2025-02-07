<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
								xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns:msxsl="urn:schemas-microsoft-com:xslt"
>

	<!-- ============================================================================================
	Globals
	============================================================================================= -->

	<xsl:variable name="g_allUpperCaseLetters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="g_allLowerCaseLetters">abcdefghijklmnopqrstuvwxyz</xsl:variable>

	<!-- ============================================================================================
	String formatting
	============================================================================================= -->

	<!-- indent by 2*n spaces -->
	<xsl:template name="t_putIndent">
		<xsl:param name="p_count" />
		<xsl:if test="$p_count &gt; 1">
			<xsl:text>  </xsl:text>
			<xsl:call-template name="t_putIndent">
				<xsl:with-param name="p_count" select="$p_count - 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Gets the substring after the last occurrence of a period in a given string -->
	<xsl:template name="t_getTrimmedLastPeriod">
		<xsl:param name="p_string" />

		<xsl:choose>
			<xsl:when test="contains($p_string, '.')">
				<xsl:call-template name="t_getTrimmedLastPeriod">
					<xsl:with-param name="p_string" select="substring-after($p_string, '.')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$p_string" />
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

  <!-- Indent by 2*n points and insert final bullet point -->
  <xsl:template name="t_putBulletIndent">
    <xsl:param name="p_count" />
    <xsl:if test="$p_count &gt; 1">
      <xsl:text>  </xsl:text>
      <xsl:call-template name="t_putBulletIndent">
        <xsl:with-param name="p_count" select="$p_count - 1" />
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$p_count = 1">
      <xsl:text>* </xsl:text>
    </xsl:if>
  </xsl:template>
  
	<!-- ============================================================================================
	Text handling
	============================================================================================= -->

	<!-- This is used for most text which needs normalizing to remove extra whitespace -->
	<xsl:template match="text()">
		<xsl:call-template name="t_normalize"><xsl:with-param name="p_text" select="."/></xsl:call-template>
	</xsl:template>

	<!-- This is used to keep extra whitespace and line breaks intact for things like code blocks -->
	<xsl:template match="text()" mode="preserveFormatting">
		<xsl:value-of select="." />
	</xsl:template>

	<!-- Space normalization with handling for inserting a space before and/or after if there are preceding and/or
			 following elements. -->
	<xsl:template name="t_normalize">
		<xsl:param name="p_text" />

		<!-- If there is a preceding sibling and the text started with whitespace, add a leading space -->
		<xsl:if test="preceding-sibling::* and starts-with(translate($p_text, '&#x20;&#x9;&#xD;&#xA;', '&#xFF;&#xFF;&#xFF;&#xFF;'), '&#xFF;')">
			<xsl:text> </xsl:text>
		</xsl:if>

		<xsl:value-of select="normalize-space($p_text)"/>

		<!-- If there is a following sibling and the text ended with whitespace, add a trailing space -->
		<xsl:if test="following-sibling::* and substring(translate($p_text, '&#x20;&#x9;&#xD;&#xA;', '&#xFF;&#xFF;&#xFF;&#xFF;'), string-length($p_text)) = '&#xFF;'">
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- ============================================================================================
	SeeAlso links
	============================================================================================= -->

	<xsl:template match="referenceLink">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="referenceLink" mode="preserveFormatting">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template name="t_autogenSeeAlsoLinks">
		<!-- A link to the containing type on all list and member topics -->
		<xsl:if test="($g_apiTopicGroup='member' or $g_apiTopicGroup='list')">
			<xsl:variable name="v_typeTopicId">
				<xsl:choose>
					<xsl:when test="/document/reference/topicdata/@typeTopicId">
						<xsl:value-of select="/document/reference/topicdata/@typeTopicId"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/document/reference/containers/type/@api"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<referenceLink target="{$v_typeTopicId}" display-target="format">
				<include item="boilerplate_seeAlsoTypeLink">
					<parameter>{0}</parameter>
					<parameter>
						<xsl:choose>
							<xsl:when test="/document/reference/topicdata/@typeTopicId">
								<xsl:value-of select="/document/reference/apidata/@subgroup"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/document/reference/containers/type/apidata/@subgroup"/>
							</xsl:otherwise>
						</xsl:choose>
					</parameter>
				</include>
			</referenceLink>
			<br />
		</xsl:if>

		<!-- A link to the type's All Members list -->
		<xsl:variable name="v_allMembersId">
			<xsl:choose>
				<xsl:when test="/document/reference/topicdata/@allMembersTopicId">
					<xsl:value-of select="/document/reference/topicdata/@allMembersTopicId"/>
				</xsl:when>
				<xsl:when test="$g_apiTopicGroup='member' or ($g_apiTopicGroup='list' and $g_apiTopicSubGroup='overload')">
					<xsl:value-of select="/document/reference/containers/type/topicdata/@allMembersTopicId"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space($v_allMembersId) and not($v_allMembersId=$key)">
			<referenceLink target="{$v_allMembersId}" display-target="format">
				<include item="boilerplate_seeAlsoMembersLink">
					<parameter>{0}</parameter>
				</include>
			</referenceLink>
			<br />
		</xsl:if>

		<!-- A link to the overload topic -->
		<xsl:variable name="v_overloadId">
			<xsl:value-of select="/document/reference/memberdata/@overload"/>
		</xsl:variable>
		<xsl:if test="normalize-space($v_overloadId)">
			<referenceLink target="{$v_overloadId}" display-target="format" show-parameters="false">
				<include item="boilerplate_seeAlsoOverloadLink">
					<parameter>{0}</parameter>
				</include>
			</referenceLink>
			<br />
		</xsl:if>

		<!-- A link to the namespace topic -->
		<xsl:variable name="v_namespaceId">
			<xsl:value-of select="/document/reference/containers/namespace/@api"/>
		</xsl:variable>
		<xsl:if test="normalize-space($v_namespaceId)">
			<referenceLink target="{$v_namespaceId}" display-target="format">
				<include item="boilerplate_seeAlsoNamespaceLink">
					<parameter>{0}</parameter>
				</include>
			</referenceLink>
			<br />
		</xsl:if>

	</xsl:template>

	<!-- ============================================================================================
	Section headers
	============================================================================================= -->

	<xsl:template name="t_putSection">
		<xsl:param name="p_title" />
		<xsl:param name="p_content" />
		<xsl:param name="p_toplink" select="false()" />
		<xsl:param name="p_id" select="''" />

		<xsl:if test="normalize-space($p_title)">
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>## </xsl:text>
			<xsl:copy-of select="$p_title" />
			<xsl:if test="normalize-space($p_id)">
				<span>
					<xsl:attribute name="id">
						<xsl:value-of select="$p_id"/>
					</xsl:attribute>
					<xsl:text> </xsl:text>
				</span>
			</xsl:if>
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>

		<xsl:copy-of select="$p_content" />

		<xsl:if test="boolean($p_toplink)">
			<a href="#PageHeader">
				<include item="top"/>
			</a>
		</xsl:if>
	</xsl:template>

	<xsl:template name="t_putSectionInclude">
		<xsl:param name="p_titleInclude" />
		<xsl:param name="p_content" />
		<xsl:param name="p_toplink" select="false()" />
		<xsl:param name="p_id" select="''" />

		<xsl:if test="normalize-space($p_titleInclude)">
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>## </xsl:text>
			<include item="{$p_titleInclude}"/>
			<xsl:if test="normalize-space($p_id)">
				<span>
					<xsl:attribute name="id">
						<xsl:value-of select="$p_id"/>
					</xsl:attribute>
					<xsl:text> </xsl:text>
				</span>
			</xsl:if>
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>

		<xsl:copy-of select="$p_content" />

		<xsl:if test="boolean($p_toplink)">
			<a href="#PageHeader">
				<include item="top"/>
			</a>
		</xsl:if>
	</xsl:template>

	<xsl:template name="t_putSubSection">
		<xsl:param name="p_title" />
		<xsl:param name="p_content" />
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>#### </xsl:text>
		<xsl:copy-of select="$p_title" />
		<xsl:text>&#xa;</xsl:text>
		<xsl:copy-of select="$p_content" />
	</xsl:template>

	<!-- ============================================================================================
	Alerts
	============================================================================================= -->

	<xsl:template name="t_putAlert">
		<xsl:param name="p_alertClass" select="@class"/>
		<xsl:param name="p_alertContent" select="''"/>
		<xsl:variable name="v_title">
			<xsl:choose>
				<xsl:when test="$p_alertClass='note'">
					<xsl:text>alert_title_note</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='tip'">
					<xsl:text>alert_title_tip</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='caution' or $p_alertClass='warning'">
					<xsl:text>alert_title_caution</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='security' or $p_alertClass='security note'">
					<xsl:text>alert_title_security</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='important'">
					<xsl:text>alert_title_important</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='vb' or $p_alertClass='VB' or $p_alertClass='VisualBasic' or $p_alertClass='visual basic note'">
					<xsl:text>alert_title_visualBasic</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='cs' or $p_alertClass='CSharp' or $p_alertClass='c#' or $p_alertClass='C#' or $p_alertClass='visual c# note'">
					<xsl:text>alert_title_visualC#</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='cpp' or $p_alertClass='c++' or $p_alertClass='C++' or $p_alertClass='CPP' or $p_alertClass='visual c++ note'">
					<xsl:text>alert_title_visualC++</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='JSharp' or $p_alertClass='j#' or $p_alertClass='J#' or $p_alertClass='visual j# note'">
					<xsl:text>alert_title_visualJ#</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='implement'">
					<xsl:text>text_NotesForImplementers</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='caller'">
					<xsl:text>text_NotesForCallers</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='inherit'">
					<xsl:text>text_NotesForInheritors</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>alert_title_note</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="v_altTitle">
			<xsl:choose>
				<xsl:when test="$p_alertClass='note' or $p_alertClass='implement' or $p_alertClass='caller' or $p_alertClass='inherit'">
					<xsl:text>alert_altText_note</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='tip'">
					<xsl:text>alert_altText_tip</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='caution' or $p_alertClass='warning'">
					<xsl:text>alert_altText_caution</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='security' or $p_alertClass='security note'">
					<xsl:text>alert_altText_security</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='important'">
					<xsl:text>alert_altText_important</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='vb' or $p_alertClass='VB' or $p_alertClass='VisualBasic' or $p_alertClass='visual basic note'">
					<xsl:text>alert_altText_visualBasic</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='cs' or $p_alertClass='CSharp' or $p_alertClass='c#' or $p_alertClass='C#' or $p_alertClass='visual c# note'">
					<xsl:text>alert_altText_visualC#</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='cpp' or $p_alertClass='c++' or $p_alertClass='C++' or $p_alertClass='CPP' or $p_alertClass='visual c++ note'">
					<xsl:text>alert_altText_visualC++</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='JSharp' or $p_alertClass='j#' or $p_alertClass='J#' or $p_alertClass='visual j# note'">
					<xsl:text>alert_altText_visualJ#</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>alert_altText_note</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="v_noteImg">
			<xsl:choose>
				<xsl:when test="$p_alertClass='note' or $p_alertClass='tip' or $p_alertClass='implement' or $p_alertClass='caller' or $p_alertClass='inherit'">
					<xsl:text>AlertNote.png</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='caution' or $p_alertClass='warning'">
					<xsl:text>AlertCaution.png</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='security' or $p_alertClass='security note'">
					<xsl:text>AlertSecurity.png</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='important'">
					<xsl:text>AlertCaution.png</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='vb' or $p_alertClass='VB' or $p_alertClass='VisualBasic' or $p_alertClass='visual basic note'">
					<xsl:text>AlertNote.png</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='cs' or $p_alertClass='CSharp' or $p_alertClass='c#' or $p_alertClass='C#' or $p_alertClass='visual c# note'">
					<xsl:text>AlertNote.png</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='cpp' or $p_alertClass='c++' or $p_alertClass='C++' or $p_alertClass='CPP' or $p_alertClass='visual c++ note'">
					<xsl:text>AlertNote.png</xsl:text>
				</xsl:when>
				<xsl:when test="$p_alertClass='JSharp' or $p_alertClass='j#' or $p_alertClass='J#' or $p_alertClass='visual j# note'">
					<xsl:text>AlertNote.png</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>AlertNote.png</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#160;</xsl:text>
		<table>
			<tr>
				<th>
					<xsl:text>![</xsl:text>
					<include item="{$v_title}"/>
					<xsl:text>](</xsl:text>
					<include item="mediaPath">
						<parameter>
							<xsl:value-of select="$v_noteImg"/>
						</parameter>
					</include>
					<xsl:text>) </xsl:text>
					<include item="{$v_title}"/>
				</th>
			</tr>
			<tr>
				<td markdown="span">
					<xsl:choose>
						<xsl:when test="$p_alertContent=''">
							<xsl:apply-templates/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$p_alertContent"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</table>
		<xsl:text>&#160;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>

	<!-- ============================================================================================
	Pass through HTML tags
	============================================================================================= -->

	<xsl:template match="p|ol|ul|li|dl|dt|dd|table|tr|th|td|a|img|b|i|strong|em|del|sub|sup|br|hr|h1|h2|h3|h4|h5|h6|pre|div|span|blockquote|abbr|acronym|u|font|map|area">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<!-- ============================================================================================
	Debugging template for showing an element in comments
	============================================================================================= -->

	<xsl:template name="t_dumpContent">
		<xsl:param name="indent" select="''"/>
		<xsl:param name="content" select="."/>
		<xsl:for-each select="msxsl:node-set($content)">
			<xsl:choose>
				<xsl:when test="self::text()">
					<xsl:comment>
						<xsl:value-of select="$indent"/>
						<xsl:value-of select="."/>
					</xsl:comment>
				</xsl:when>
				<xsl:otherwise>
					<xsl:comment>
						<xsl:value-of select="$indent"/>
						<xsl:value-of select="'«'"/>
						<xsl:value-of select="name()"/>
						<xsl:for-each select="@*">
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="name()"/>
							<xsl:value-of select="'='"/>
							<xsl:value-of select="."/>
						</xsl:for-each>
						<xsl:choose>
							<xsl:when test="./node()">
								<xsl:value-of select="'»'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'/»'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:comment>
					<xsl:for-each select="node()">
						<xsl:call-template name="t_dumpContent">
							<xsl:with-param name="indent"
															select="concat($indent,'  ')"/>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:if test="./node()">
						<xsl:comment>
							<xsl:value-of select="$indent"/>
							<xsl:value-of select="'«/'"/>
							<xsl:value-of select="name()"/>
							<xsl:value-of select="'»'"/>
						</xsl:comment>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
