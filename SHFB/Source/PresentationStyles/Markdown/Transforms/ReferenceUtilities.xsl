<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								version="2.0"
								xmlns:msxsl="urn:schemas-microsoft-com:xslt"
								xmlns:ddue="http://ddue.schemas.microsoft.com/authoring/2003/5"
								xmlns:xlink="http://www.w3.org/1999/xlink"
>
	<!-- ======================================================================================== -->

	<!-- ============================================================================================
	Parameters - key parameter is the API identifier string
	============================================================================================= -->

	<xsl:param name="key"/>
	<xsl:param name="maxVersionParts" />
	<xsl:param name="includeEnumValues" select="string('true')" />

	<!-- ============================================================================================
	Global Variables
	============================================================================================= -->

	<xsl:variable name="g_typeTopicId">
		<xsl:choose>
			<xsl:when test="/document/reference/topicdata[@group='api'] and /document/reference/apidata[@group='type']">
				<xsl:value-of select="$key"/>
			</xsl:when>
			<xsl:when test="/document/reference/topicdata/@typeTopicId">
				<xsl:value-of select="/document/reference/topicdata/@typeTopicId"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/document/reference/containers/type/@api"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="g_topicGroup" select="/document/reference/topicdata/@group"/>
	<xsl:variable name="g_apiGroup" select="/document/reference/apidata/@group"/>
	<xsl:variable name="g_apiTopicGroup">
		<xsl:choose>
			<xsl:when test="/document/reference/topicdata/@group = 'api'">
				<xsl:value-of select="/document/reference/apidata/@group"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/document/reference/topicdata/@group"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="g_topicSubGroup" select="/document/reference/topicdata/@subgroup"/>
	<xsl:variable name="g_apiSubGroup" select="/document/reference/apidata/@subgroup"/>
	<xsl:variable name="g_apiTopicSubGroup">
		<xsl:choose>
			<xsl:when test="/document/reference/topicdata/@group = 'api'">
				<xsl:value-of select="/document/reference/apidata/@subgroup"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/document/reference/topicdata/@subgroup"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="g_apiSubSubGroup" select="/document/reference/apidata/@subsubgroup"/>
	<xsl:variable name="g_apiTopicSubSubGroup">
		<xsl:choose>
			<xsl:when test="/document/reference/topicdata/@group = 'api'">
				<xsl:value-of select="/document/reference/apidata/@subsubgroup"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/document/reference/topicdata/@subsubgroup"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="g_namespaceName" select="/document/reference/containers/namespace/apidata/@name"/>

	<!-- ============================================================================================
	Document body
	============================================================================================= -->

	<xsl:template match="/">
		<document>
<xsl:text>---
layout: technical-article
categories: docs technical
slug: </xsl:text><xsl:value-of select="/document/reference/file/@name" />
<xsl:text>
title: </xsl:text><xsl:call-template name="t_topicTitlePlain"/>
<xsl:text>
---
</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<!-- This is used by the Save Component to get the filename.  It won't end up in the final result. -->
			<file>
				<xsl:attribute name="name">
          <xsl:value-of select="/document/reference/file/@name" />
				</xsl:attribute>
			</file>
			<xsl:text>&#xa;</xsl:text>
			<!--<xsl:text># </xsl:text>
			<include item="boilerplate_pageTitle">
				<parameter>
					<xsl:call-template name="t_topicTitleDecorated"/>
				</parameter>
			</include>-->
			<span id="PageHeader">
				<xsl:text> </xsl:text>
			</span>
			<xsl:text>&#xa;</xsl:text>
			<include item="header"/>
			<xsl:text>&#xa;</xsl:text>
			<xsl:call-template name="t_body"/>
		</document>
	</xsl:template>

	<!-- ============================================================================================
	The plain-text title used in the TOC 
	============================================================================================= -->

	<xsl:template name="t_topicTitlePlain">
		<xsl:param name="p_qualifyMembers" select="false()"/>
		<include>
			<xsl:attribute name="item">
				<xsl:text>topicTitle_</xsl:text>
				<xsl:choose>
					<!-- api topic titles -->
					<xsl:when test="$g_topicGroup='api'">
						<!-- the subsubgroup, subgroup, or group determines the title -->
						<xsl:choose>
							<xsl:when test="string($g_apiSubSubGroup)">
								<xsl:choose>
									<!-- topic title for op_explicit and op_implicit members -->
									<xsl:when test="$g_apiSubSubGroup='operator' and (document/reference/apidata/@name = 'Explicit' or document/reference/apidata/@name = 'Implicit')">
										<xsl:value-of select="'typeConversion'"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$g_apiSubSubGroup"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="string($g_apiSubGroup)">
								<xsl:value-of select="$g_apiSubGroup"/>
							</xsl:when>
							<xsl:when test="string($g_apiGroup)">
								<xsl:value-of select="$g_apiGroup"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<!-- overload topic titles -->
					<xsl:when test="$g_topicSubGroup='overload'">
						<!-- the api subgroup (e.g. "property") determines the title; do we want to use the subsubgoup name when it is available? -->
						<xsl:choose>
							<!-- topic title for overload op_explicit and op_implicit members -->
							<xsl:when test="$g_apiSubSubGroup = 'operator' and (document/reference/apidata/@name='Explicit' or document/reference/apidata/@name='Implicit')">
								<xsl:value-of select="'conversionOperator'"/>
							</xsl:when>
							<!-- topic title for overload operator members -->
							<xsl:when test="$g_apiSubSubGroup='operator'">
								<xsl:value-of select="$g_apiSubSubGroup"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$g_apiSubGroup"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!-- list topic titles -->
					<xsl:when test="$g_topicGroup='list'">
						<!-- the topic subgroup (e.g. "methods") determines the title -->
						<xsl:choose>
							<xsl:when test="$g_topicSubGroup='Operators'">
								<xsl:variable name="v_operators"
															select="document/reference/elements/element[not(apidata[@name='Explicit' or @name='Implicit'])]"/>
								<xsl:variable name="v_conversions"
															select="document/reference/elements/element[apidata[@name='Explicit' or @name='Implicit']]"/>
								<xsl:choose>
									<!-- v_operators + type v_conversions -->
									<xsl:when test="count($v_operators) &gt; 0 and count($v_conversions) &gt; 0">
										<xsl:value-of select="'OperatorsAndTypeConversions'"/>
									</xsl:when>
									<!-- no v_operators + type v_conversions -->
									<xsl:when test="not(count($v_operators) &gt; 0) and count($v_conversions) &gt; 0">
										<xsl:value-of select="'TypeConversions'"/>
									</xsl:when>
									<!-- v_operators + no type v_conversions -->
									<xsl:otherwise>
										<xsl:value-of select="$g_topicSubGroup"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$g_topicSubGroup"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!-- overload root titles  -->
					<xsl:when test="$g_topicGroup='root'">
						<xsl:value-of select="$g_topicGroup"/>
					</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<parameter>
				<xsl:call-template name="t_shortNamePlain">
					<xsl:with-param name="p_qualifyMembers"
													select="$p_qualifyMembers"/>
				</xsl:call-template>
			</parameter>
			<parameter>
				<!-- show parameters only for overloaded members -->
				<xsl:if test="document/reference/memberdata/@overload or ($g_apiSubSubGroup = 'operator' and (document/reference/apidata/@name='Explicit' or document/reference/apidata/@name='Implicit'))">
					<xsl:choose>
						<xsl:when test="$g_apiSubSubGroup = 'operator' and (document/reference/apidata/@name='Explicit' or document/reference/apidata/@name='Implicit')">
							<xsl:for-each select="/document/reference">
								<xsl:call-template name="t_operatorTypesPlain"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="/document/reference">
								<xsl:call-template name="t_parameterTypesPlain"/>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</parameter>
		</include>
	</xsl:template>

	<!-- when positioned on a parameterized api, produces a (plain) comma-seperated list of parameter types -->
	<xsl:template name="t_parameterTypesPlain">
		<xsl:if test="parameters/parameter">
			<xsl:text>(</xsl:text>
			<xsl:for-each select="parameters/parameter">
				<xsl:apply-templates select="type|arrayOf|pointerTo|referenceTo|template" mode="plain"/>
				<xsl:if test="position() != last()">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="proceduredata[@varargs='true']">
				<xsl:text>, ...</xsl:text>
			</xsl:if>
			<xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- Produces parameter and return types in (plain) format:(Int32 to Decimal) for operator members -->
	<xsl:template name="t_operatorTypesPlain">
		<xsl:if test="count(parameters/parameter/*) = 1 or count(returns/*) = 1">
			<xsl:text>(</xsl:text>
		</xsl:if>
		<xsl:if test="count(parameters/parameter/*) = 1">
			<xsl:apply-templates select="parameters/parameter[1]/type|parameters/parameter[1]/arrayOf|parameters/parameter[1]/pointerTo|
                               parameters/parameter[1]/referenceTo|parameters/parameter[1]/template"
													 mode="plain"/>
		</xsl:if>
		<xsl:if test="count(parameters/parameter/*) = 1 and count(returns/*) = 1">
			<xsl:text> to </xsl:text>
		</xsl:if>
		<xsl:if test="count(returns/*) = 1">
			<xsl:apply-templates select="returns[1]/type|returns[1]/arrayOf|returns[1]/pointerTo|returns[1]/referenceTo|
                               returns[1]/template"
													 mode="plain"/>
		</xsl:if>
		<xsl:if test="count(parameters/parameter/*) = 1 or count(returns/*) = 1">
			<xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- ======================================================================================== -->

	<xsl:template name="t_shortNamePlain">
		<xsl:param name="p_qualifyMembers" select="false()"/>
		<xsl:choose>
			<!-- type overview pages and member list pages get the type name -->
			<xsl:when test="($g_topicGroup='api' and $g_apiGroup='type') or ($g_topicGroup='list' and not($g_topicSubGroup='overload'))">
				<xsl:for-each select="/document/reference[1]">
					<xsl:call-template name="t_typeNamePlain"/>
				</xsl:for-each>
			</xsl:when>
			<!-- constructors and member list pages also use the type name -->
			<xsl:when test="($g_topicGroup='api' and $g_apiSubGroup='constructor') or ($g_topicSubGroup='overload' and $g_apiSubGroup='constructor')">
				<xsl:for-each select="/document/reference/containers/type[1]">
					<xsl:call-template name="t_typeNamePlain"/>
				</xsl:for-each>
			</xsl:when>
			<!-- member pages use the member name, qualified if the qualified flag is set -->
			<xsl:when test="($g_topicGroup='api' and $g_apiGroup='member') or ($g_topicSubGroup='overload' and $g_apiGroup='member')">
				<!-- check for qualify flag and qualify if it is set -->
				<xsl:if test="$p_qualifyMembers">
					<xsl:for-each select="/document/reference/containers/type[1]">
						<xsl:call-template name="t_typeNamePlain"/>
					</xsl:for-each>
					<xsl:choose>
						<xsl:when test="$g_apiSubSubGroup='operator' and (document/reference/apidata/@name='Explicit' or document/reference/apidata/@name='Implicit')">
							<xsl:text>&#xa0;</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>.</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:choose>
					<!-- EII names are interfaceName.interfaceMemberName, not memberName -->
					<xsl:when test="document/reference[memberdata[@visibility='private'] and proceduredata[@virtual = 'true']]">
						<xsl:for-each select="/document/reference/implements/member">
							<xsl:for-each select="type">
								<xsl:call-template name="t_typeNamePlain"/>
							</xsl:for-each>
							<xsl:text>.</xsl:text>
							<!-- EFW - If the API element is not present (unresolved type), show the type name from the type element -->
							<xsl:choose>
								<xsl:when test="apidata/@name">
									<xsl:value-of select="apidata/@name" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="t_getTrimmedLastPeriod">
										<xsl:with-param name="p_string" select="@api" />
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:apply-templates select="templates" mode="plain"/>
						</xsl:for-each>
					</xsl:when>
					<!-- Use just the plain, unadorned api name for overload pages with templates -->
					<xsl:when test="$g_topicGroup='list' and $g_topicSubGroup='overload' and /document/reference/templates">
						<xsl:value-of select="/document/reference/apidata/@name"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- but other members just use the name -->
						<xsl:for-each select="/document/reference[1]">
							<xsl:value-of select="apidata/@name"/>
							<xsl:apply-templates select="templates" mode="plain"/>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- namespace, member (and any other) topics just use the name -->
			<xsl:when test="/document/reference/apidata/@name = ''">
				<include item="defaultNamespace"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/document/reference/apidata/@name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============================================================================================
	The language-variant, marked-up topic title	used as the big title at the top of the page
	============================================================================================= -->

	<xsl:template name="t_topicTitleDecorated">
		<include>
			<xsl:attribute name="item">
				<xsl:text>topicTitle_</xsl:text>
				<xsl:choose>

					<!-- api topic titles -->
					<xsl:when test="$g_topicGroup='api'">
						<xsl:choose>
							<xsl:when test="string($g_apiSubSubGroup)">
								<xsl:choose>
									<!-- topic title for op_explicit and op_implicit members -->
									<xsl:when test="$g_apiSubSubGroup='operator' and (document/reference/apidata/@name = 'Explicit' or document/reference/apidata/@name = 'Implicit')">
										<xsl:value-of select="'typeConversion'"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$g_apiSubSubGroup"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="string($g_apiSubGroup)">
								<xsl:value-of select="$g_apiSubGroup"/>
							</xsl:when>
							<xsl:when test="string($g_apiGroup)">
								<xsl:value-of select="$g_apiGroup"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>

					<!-- overload topic titles -->
					<xsl:when test="$g_topicSubGroup='overload'">
						<!-- the api subgroup (e.g. "property") determines the title; do we want to use the subsubgoup name when it is available? -->
						<xsl:choose>
							<!-- topic title for overload op_explicit and op_implicit members -->
							<xsl:when test="$g_apiSubSubGroup = 'operator' and (document/reference/apidata/@name='Explicit' or document/reference/apidata/@name='Implicit')">
								<xsl:value-of select="'conversionOperator'"/>
							</xsl:when>
							<!-- topic title for overload operator members -->
							<xsl:when test="$g_apiSubSubGroup='operator'">
								<xsl:value-of select="$g_apiSubSubGroup"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$g_apiSubGroup"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>

					<!-- list topic titles -->
					<xsl:when test="$g_topicGroup='list'">
						<!-- the topic subgroup (e.g. "methods") determines the title -->
						<xsl:choose>
							<xsl:when test="$g_topicSubGroup='Operators'">
								<xsl:variable name="v_operators"
															select="document/reference/elements/element[not(apidata[@name='Explicit' or @name='Implicit'])]"/>
								<xsl:variable name="v_conversions"
															select="document/reference/elements/element[apidata[@name='Explicit' or @name='Implicit']]"/>
								<xsl:choose>
									<!-- operators + type conversions -->
									<xsl:when test="count($v_operators) &gt; 0 and count($v_conversions) &gt; 0">
										<xsl:value-of select="'OperatorsAndTypeConversions'"/>
									</xsl:when>
									<!-- no operators + type conversions -->
									<xsl:when test="not(count($v_operators) &gt; 0) and count($v_conversions) &gt; 0">
										<xsl:value-of select="'TypeConversions'"/>
									</xsl:when>
									<!-- operators + no type conversions -->
									<xsl:otherwise>
										<xsl:value-of select="$g_topicSubGroup"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$g_topicSubGroup"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>

					<!-- overload root titles  -->
					<xsl:when test="$g_topicGroup='root'">
						<xsl:value-of select="$g_topicGroup"/>
					</xsl:when>
				</xsl:choose>

			</xsl:attribute>
			<parameter>
				<xsl:call-template name="t_shortNameDecorated"/>
			</parameter>
			<parameter>
				<!-- show parameters only from overloaded members -->
				<xsl:if test="document/reference/memberdata/@overload or ($g_apiSubSubGroup= 'operator' and (document/reference/apidata/@name='Explicit' or document/reference/apidata/@name='Implicit'))">
					<xsl:choose>
						<xsl:when test="$g_apiSubSubGroup = 'operator' and (document/reference/apidata/@name='Explicit' or document/reference/apidata/@name='Implicit')">
							<xsl:for-each select="/document/reference">
								<xsl:call-template name="t_operatorTypesDecorated"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="/document/reference">
								<xsl:call-template name="t_parameterTypesDecorated"/>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</parameter>
		</include>
	</xsl:template>

	<!-- When positioned on a generic API, produces a (decorated) comma-separated list of template names -->
	<xsl:template name="t_parameterTypesDecorated">
		<xsl:if test="parameters/parameter">
			<xsl:text>(</xsl:text>
			<xsl:for-each select="parameters/parameter">
				<xsl:apply-templates select="type|arrayOf|pointerTo|referenceTo|template" mode="decorated"/>
				<xsl:if test="position() != last()">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="proceduredata[@varargs='true']">
				<xsl:text>, ...</xsl:text>
			</xsl:if>
			<xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- Produces parameter and return types in (decorated) format:(Int32 to Decimal) for operator members -->
	<xsl:template name="t_operatorTypesDecorated">
		<xsl:if test="count(parameters/parameter/*) = 1 or count(returns/*) = 1">
			<xsl:text>(</xsl:text>
		</xsl:if>
		<xsl:if test="count(parameters/parameter/*) = 1">
			<xsl:apply-templates select="parameters/parameter[1]/type|parameters/parameter[1]/arrayOf|parameters/parameter[1]/pointerTo|
                               parameters/parameter[1]/referenceTo|parameters/parameter[1]/template"
													 mode="decorated"/>
		</xsl:if>
		<xsl:if test="count(parameters/parameter/*) = 1 and count(returns/*) = 1">
			<xsl:text> to </xsl:text>
		</xsl:if>
		<xsl:if test="count(returns/*) = 1">
			<xsl:apply-templates select="returns[1]/type|returns[1]/arrayOf|returns[1]/pointerTo|returns[1]/referenceTo|
                               returns[1]/template"
													 mode="decorated"/>
		</xsl:if>
		<xsl:if test="count(parameters/parameter/*) = 1 or count(returns/*) = 1">
			<xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- ======================================================================================== -->

	<xsl:template name="t_shortNameDecorated">
		<xsl:choose>
			<!-- type overview pages and member list pages get the type name -->
			<xsl:when test="($g_topicGroup='api' and $g_apiGroup='type') or ($g_topicGroup='list' and not($g_topicSubGroup='overload'))">
				<xsl:for-each select="/document/reference[1]">
					<xsl:call-template name="t_typeNameDecorated"/>
				</xsl:for-each>
			</xsl:when>
			<!-- constructors and member list pages also use the type name -->
			<xsl:when test="($g_topicGroup='api' and $g_apiSubGroup='constructor') or ($g_topicSubGroup='overload' and $g_apiSubGroup='constructor')">
				<xsl:for-each select="/document/reference/containers/type[1]">
					<xsl:call-template name="t_typeNameDecorated"/>
				</xsl:for-each>
			</xsl:when>
			<!-- eii members -->
			<xsl:when test="document/reference[memberdata[@visibility='private'] and proceduredata[@virtual = 'true']]">
				<xsl:for-each select="/document/reference/containers/type[1]">
					<xsl:call-template name="t_typeNameDecorated"/>
				</xsl:for-each>
				<xsl:text>.</xsl:text>
				<xsl:for-each select="/document/reference/implements/member">
					<xsl:for-each select="type">
						<xsl:call-template name="t_typeNameDecorated"/>
					</xsl:for-each>
					<xsl:text>.</xsl:text>
					<!-- EFW - If the API element is not present (unresolved type), show the type name from the type element -->
					<xsl:choose>
						<xsl:when test="apidata/@name">
							<xsl:value-of select="apidata/@name" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="t_getTrimmedLastPeriod">
								<xsl:with-param name="p_string" select="@api" />
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates select="templates" mode="decorated"/>
				</xsl:for-each>
			</xsl:when>
			<!-- Use just the plain, unadorned type.api name for overload pages with templates -->
			<xsl:when test="$g_topicGroup='list' and $g_topicSubGroup='overload' and /document/reference/templates">
				<xsl:for-each select="/document/reference/containers/type[1]">
					<xsl:call-template name="t_typeNameDecorated"/>
				</xsl:for-each>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="/document/reference/apidata/@name"/>
			</xsl:when>
			<!-- normal member pages use the qualified member name -->
			<xsl:when test="($g_topicGroup='api' and $g_apiGroup='member') or ($g_topicSubGroup='overload' and $g_apiGroup='member')">
				<xsl:for-each select="/document/reference/containers/type[1]">
					<xsl:call-template name="t_typeNameDecorated"/>
				</xsl:for-each>
				<xsl:if test="not($g_apiSubSubGroup='operator'and (document/reference/apidata/@name='Explicit' or document/reference/apidata/@name='Implicit'))">
					<xsl:text>.</xsl:text>
				</xsl:if>
				<xsl:for-each select="/document/reference[1]">
					<xsl:choose>
						<xsl:when test="$g_apiSubSubGroup='operator' and (apidata/@name='Explicit' or apidata/@name='Implicit')">
							<xsl:text>&#xa0;</xsl:text>
							<xsl:value-of select="apidata/@name"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="apidata/@name"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates select="templates" mode="decorated"/>
				</xsl:for-each>
			</xsl:when>
			<!-- namespace (and any other) topics just use the name -->
			<xsl:when test="/document/reference/apidata/@name = ''">
				<include item="defaultNamespace"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/document/reference/apidata/@name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============================================================================================
	Elements processing
	============================================================================================= -->

	<xsl:template match="elements" mode="root" name="t_rootElements">
		<xsl:if test="count(element) > 0">
			<xsl:call-template name="t_putSectionInclude">
				<xsl:with-param name="p_titleInclude" select="'title_namespaces'"/>
				<xsl:with-param name="p_content">
					<xsl:text>&#xa;</xsl:text>
					<table>
						<tr>
							<th>
								<include item="header_namespaceName"/>
							</th>
							<th>
								<include item="header_namespaceDescription"/>
							</th>
						</tr>
						<xsl:apply-templates select="element" mode="root">
							<xsl:sort select="apidata/@name"/>
						</xsl:apply-templates>
					</table>
					<xsl:text>&#xa;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="elements" mode="namespace" name="t_namespaceElements">

		<xsl:if test="element/apidata/@subgroup = 'class'">
			<xsl:call-template name="t_putNamespaceSection">
				<xsl:with-param name="p_listSubgroup" select="'class'"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="element/apidata/@subgroup = 'structure'">
			<xsl:call-template name="t_putNamespaceSection">
				<xsl:with-param name="p_listSubgroup" select="'structure'"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="element/apidata/@subgroup = 'interface'">
			<xsl:call-template name="t_putNamespaceSection">
				<xsl:with-param name="p_listSubgroup" select="'interface'"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="element/apidata/@subgroup = 'delegate'">
			<xsl:call-template name="t_putNamespaceSection">
				<xsl:with-param name="p_listSubgroup" select="'delegate'"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="element/apidata/@subgroup = 'enumeration'">
			<xsl:call-template name="t_putNamespaceSection">
				<xsl:with-param name="p_listSubgroup" select="'enumeration'"/>
			</xsl:call-template>
		</xsl:if>

	</xsl:template>

	<xsl:template match="elements" mode="namespaceGroup" name="t_namespaceGroupElements">
		<xsl:if test="count(element) > 0">
			<xsl:call-template name="t_putSectionInclude">
				<xsl:with-param name="p_titleInclude" select="'tableTitle_namespace'"/>
				<xsl:with-param name="p_content">
					<xsl:text>&#xa;</xsl:text>
					<table>
						<tr>
							<th>
								<include item="header_namespaceName"/>
							</th>
							<th>
								<include item="header_namespaceDescription"/>
							</th>
						</tr>
						<xsl:apply-templates select="element" mode="namespaceGroup">
							<xsl:sort select="substring-after(@api, ':')"/>
						</xsl:apply-templates>
					</table>
					<xsl:text>&#xa;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="element" mode="namespaceGroup" name="t_namespaceGroupElement">
		<tr>
			<td markdown="block">
				<referenceLink target="{@api}" qualified="false"/>
			</td>
			<td markdown="span">
				<xsl:call-template name="t_getElementDescription"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="elements" mode="enumeration" name="t_enumerationElements">
		<xsl:if test="count(element) > 0">
			<xsl:call-template name="t_putSectionInclude">
				<xsl:with-param name="p_titleInclude" select="'topicTitle_enumMembers'"/>
				<xsl:with-param name="p_content">
					<xsl:text>&#xa;</xsl:text>
					<table>
						<tr>
							<th>
								<xsl:text>&#160;</xsl:text>
							</th>
							<th>
								<include item="header_memberName"/>
							</th>
							<xsl:if test="$includeEnumValues='true'">
								<th>
									<include item="header_memberValue"/>
								</th>
							</xsl:if>
							<th>
								<include item="header_memberDescription"/>
							</th>
						</tr>
						<xsl:apply-templates select="element" mode="enumeration"/>
					</table>
					<xsl:text>&#xa;</xsl:text>
					<xsl:text>&#xa;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="elements" mode="member" name="t_memberElements">

		<!-- Filter out the Overload pages created by ApplyVSDocModel.xsl. -->
		<xsl:variable name="filteredOverloadElements"
									select="element[starts-with(@api, 'Overload:')]/element | element[not(starts-with(@api, 'Overload:'))]"/>

		<xsl:call-template name="t_memberIntroBoilerplate"/>

		<!-- Constructor table -->
		<xsl:call-template name="t_putMemberListSection">
			<xsl:with-param name="p_headerGroup">constructor</xsl:with-param>
			<xsl:with-param name="p_members" select="$filteredOverloadElements[apidata[@subgroup='constructor']][.//memberdata[@visibility='public' or @visibility='family' or @visibility='family or assembly' or @visibility='assembly'] or (.//memberdata[@visibility='private'] and not(.//proceduredata[@virtual = 'true']))]"/>
		</xsl:call-template>

		<!-- Property table -->
		<xsl:call-template name="t_putMemberListSection">
			<xsl:with-param name="p_headerGroup">property</xsl:with-param>
			<xsl:with-param name="p_members" select="$filteredOverloadElements[apidata[@subgroup='property' and not(@subsubgroup)]][.//memberdata[@visibility='public' or @visibility='family' or @visibility='family or assembly' or @visibility='assembly'] or (.//memberdata[@visibility='private'] and not(.//proceduredata[@virtual = 'true']))]"/>
		</xsl:call-template>

		<!-- Method table -->
		<xsl:call-template name="t_putMemberListSection">
			<xsl:with-param name="p_headerGroup">method</xsl:with-param>
			<xsl:with-param name="p_members" select="$filteredOverloadElements[apidata[@subgroup='method' and not(@subsubgroup)]][.//memberdata[@visibility='public' or @visibility='family' or @visibility='family or assembly' or @visibility='assembly'] or (.//memberdata[@visibility='private'] and not(.//proceduredata[@virtual = 'true']))]"/>
		</xsl:call-template>

		<!-- Event table -->
		<xsl:call-template name="t_putMemberListSection">
			<xsl:with-param name="p_headerGroup">event</xsl:with-param>
			<xsl:with-param name="p_members" select="element[apidata[@subgroup='event' and not(@subsubgroup)]][.//memberdata[@visibility='public' or @visibility='family' or @visibility='family or assembly' or @visibility='assembly'] or (.//memberdata[@visibility='private'] and not(.//proceduredata[@virtual = 'true']))]"/>
		</xsl:call-template>

		<!-- Operator table -->
		<xsl:call-template name="t_putMemberListSection">
			<xsl:with-param name="p_headerGroup">operator</xsl:with-param>
			<xsl:with-param name="p_members" select="$filteredOverloadElements[apidata[@subsubgroup='operator']][.//memberdata[@visibility='public' or @visibility='family' or @visibility='family or assembly' or @visibility='assembly'] or (.//memberdata[@visibility='private'] and not(.//proceduredata[@virtual = 'true']))]"/>
		</xsl:call-template>

		<!-- Field table -->
		<xsl:call-template name="t_putMemberListSection">
			<xsl:with-param name="p_headerGroup">field</xsl:with-param>
			<xsl:with-param name="p_members" select="element[apidata[@subgroup='field']][.//memberdata[@visibility='public' or @visibility='family' or @visibility='family or assembly' or @visibility='assembly'] or (.//memberdata[@visibility='private'] and not(.//proceduredata[@virtual = 'true']))]"/>
		</xsl:call-template>

		<!-- Attached property table -->
		<xsl:call-template name="t_putMemberListSection">
			<xsl:with-param name="p_headerGroup">attachedProperty</xsl:with-param>
			<xsl:with-param name="p_members" select="element[apidata[@subsubgroup='attachedProperty']]"/>
		</xsl:call-template>

		<!-- Attached event table -->
		<xsl:call-template name="t_putMemberListSection">
			<xsl:with-param name="p_headerGroup">attachedEvent</xsl:with-param>
			<xsl:with-param name="p_members" select="element[apidata[@subsubgroup='attachedEvent']]"/>
		</xsl:call-template>

		<!-- Extension method table -->
		<xsl:call-template name="t_putMemberListSection">
			<xsl:with-param name="p_headerGroup">extensionMethod</xsl:with-param>
			<xsl:with-param name="p_members" select="$filteredOverloadElements[apidata[@subsubgroup='extension']]"/>
		</xsl:call-template>

		<!-- EII table -->
		<xsl:call-template name="t_putMemberListSection">
			<xsl:with-param name="p_headerGroup">explicitInterfaceImplementation</xsl:with-param>
			<xsl:with-param name="p_members" select="$filteredOverloadElements[.//memberdata[@visibility='private'] and .//proceduredata[@virtual = 'true']]"/>
		</xsl:call-template>

	</xsl:template>

	<xsl:template match="elements" mode="type" name="t_typeElements">
		<xsl:apply-templates select="." mode="member"/>
	</xsl:template>

	<xsl:template match="elements" mode="derivedType">
		<xsl:if test="count(element) > 0">
			<xsl:call-template name="t_putSectionInclude">
				<xsl:with-param name="p_titleInclude" select="'derivedClasses'"/>
				<xsl:with-param name="p_content">
					<xsl:text>&#xa;</xsl:text>
					<table>
						<tr>
							<th>
								<include item="header_memberName"/>
							</th>
							<th>
								<include item="header_memberDescription"/>
							</th>
						</tr>
						<xsl:apply-templates select="element" mode="derivedType">
							<xsl:sort select="apidata/@name"/>
						</xsl:apply-templates>
					</table>
					<xsl:text>&#xa;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="elements" mode="overload" name="t_overloadElements">
		<xsl:if test="count(element) > 0">
			<xsl:call-template name="t_putMemberListSection">
				<xsl:with-param name="p_headerGroup" select="'overloadMembers'"/>
				<xsl:with-param name="p_members" select="element"/>
				<xsl:with-param name="p_showParameters" select="'true'"/>
				<xsl:with-param name="p_sort" select="false()"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:apply-templates select="element" mode="overloadSections">
			<xsl:sort select="apidata/@name"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="elements" mode="overloadSummary">
		<xsl:apply-templates select="element" mode="overloadSummary" >
			<xsl:sort select="apidata/@name"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ============================================================================================
	Elements helpers
	============================================================================================= -->

	<xsl:template name="t_putNamespaceSection">
		<xsl:param name="p_listSubgroup"/>

		<xsl:variable name="v_header" select="concat('tableTitle_', $p_listSubgroup)"/>
		<xsl:call-template name="t_putSectionInclude">
			<xsl:with-param name="p_titleInclude" select="$v_header"/>
			<xsl:with-param name="p_content">
				<xsl:call-template name="t_putNamespaceList">
					<xsl:with-param name="p_listSubgroup" select="$p_listSubgroup"/>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="t_putNamespaceList">
		<xsl:param name="p_listSubgroup"/>
		<xsl:text>&#xa;</xsl:text>
		<table>
			<tr>
				<th>
					<xsl:text>&#160;</xsl:text>
				</th>
				<th>
					<include item="header_{$p_listSubgroup}Name"/>
				</th>
				<th>
					<include item="header_typeDescription"/>
				</th>
			</tr>
			<xsl:apply-templates select="element[apidata/@subgroup=$p_listSubgroup]" mode="namespace">
				<xsl:sort select="@api"/>
			</xsl:apply-templates>
		</table>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>

	<xsl:template name="t_memberIntroBoilerplate">
		<xsl:if test="/document/reference/elements/element/memberdata[@visibility='public' or @visibility='family' or @visibility='family or assembly' or @visibility='assembly']">
			<!-- if there are exposed members, show a boilerplate intro p -->
			<xsl:variable name="v_introTextItemId">
				<xsl:choose>
					<xsl:when test="/document/reference/containers/type/templates">genericExposedMembersTableText</xsl:when>
					<xsl:otherwise>exposedMembersTableText</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:text>&#xa;</xsl:text>
			<include item="{$v_introTextItemId}">
				<parameter>
					<referenceLink target="{$g_typeTopicId}"/>
				</parameter>
				<parameter>
					<xsl:value-of select="concat ('text_',$g_apiTopicSubGroup,'Upper')"/>
				</parameter>
			</include>
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template name="t_putMemberListSection">
		<xsl:param name="p_members"/>
		<xsl:param name="p_headerGroup"/>
		<xsl:param name="p_showParameters" select="false()"/>
		<xsl:param name="p_sort" select="true()"/>

		<xsl:if test="count($p_members) &gt; 0">
			<xsl:variable name="v_header">
				<xsl:value-of select="concat('tableTitle_', $p_headerGroup)"/>
			</xsl:variable>

			<xsl:call-template name="t_putSectionInclude">
				<xsl:with-param name="p_titleInclude" select="$v_header"/>
				<xsl:with-param name="p_toplink" select="true()"/>
				<xsl:with-param name="p_content">
          <xsl:text>&#xa;</xsl:text>
          <table>
            <tr>
              <th>
                <xsl:text>&#160;</xsl:text>
              </th>
              <th>
                <include item="header_typeName"/>
              </th>
              <th>
                <include item="header_typeDescription"/>
              </th>
            </tr>          
						<!-- Add a row for each member of the current subgroup-visibility -->
						<xsl:choose>
							<xsl:when test="boolean($p_sort)">
								<xsl:apply-templates select="$p_members" mode="memberlistRow">
									<xsl:with-param name="p_showParameters" select="$p_showParameters"/>
									<xsl:sort select="topicdata/@eiiName | apidata/@name"/>
									<xsl:sort select="count(templates/*)"/>
								</xsl:apply-templates>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="$p_members" mode="memberlistRow">
									<xsl:with-param name="p_showParameters" select="$p_showParameters"/>
								</xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
          </table>
					<xsl:text>&#xa;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- ============================================================================================
	Element processing
	============================================================================================= -->

	<xsl:template match="element" mode="root" name="t_rootElement">
		<tr>
			<td markdown="span">
				<xsl:choose>
					<xsl:when test="apidata/@name = ''">
						<referenceLink target="{@api}" qualified="false">
							<include item="defaultNamespace"/>
						</referenceLink>
					</xsl:when>
					<xsl:otherwise>
						<referenceLink target="{@api}" qualified="false"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td markdown="span">
				<xsl:call-template name="t_getElementDescription"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="element" mode="namespace" name="t_namespaceElement">
		<xsl:variable name="v_typeVisibility">
			<xsl:choose>
				<xsl:when test="typedata/@visibility='family' or typedata/@visibility='family or assembly' or typedata/@visibility='assembly'">prot</xsl:when>
				<xsl:when test="typedata/@visibility='private'">priv</xsl:when>
				<xsl:otherwise>pub</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr>
			<td markdown="span">
				<xsl:call-template name="t_putTypeIcon">
					<xsl:with-param name="p_typeVisibility" select="$v_typeVisibility"/>
				</xsl:call-template>
			</td>
			<td markdown="span">
				<referenceLink target="{@api}" qualified="false"/>
			</td>
			<td markdown="span">
				<xsl:if test="attributes/attribute/type[@api='T:System.ObsoleteAttribute']">
					<xsl:text> </xsl:text>
					<include item="boilerplate_obsoleteShort"/>
				</xsl:if>
				<xsl:call-template name="t_getElementDescription"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="element" mode="enumeration" name="t_enumerationElement">
		<xsl:variable name="v_supportedOnXna">
			<xsl:call-template name="t_isMemberSupportedOnXna"/>
		</xsl:variable>
		<xsl:variable name="v_supportedOnCf">
			<xsl:call-template name="t_isMemberSupportedOnCf"/>
		</xsl:variable>
		<xsl:variable name="v_supportedOnSilverlightMobile">
			<xsl:call-template name="t_isMemberSupportedOnSilverlightMobile"/>
		</xsl:variable>
		<tr>
			<td markdown="span">
				<!-- Platform icons -->
				<xsl:if test="normalize-space($v_supportedOnCf)!=''">
					<xsl:text>![</xsl:text>
					<include item="altText_CompactFramework"/>
					<xsl:text>](</xsl:text>
					<include item="mediaPath">
						<parameter>CFW.gif</parameter>
					</include>
					<xsl:text> "</xsl:text>
					<include item="altText_CompactFramework"/>
					<xsl:text>")</xsl:text>
				</xsl:if>
				<xsl:if test="normalize-space($v_supportedOnXna)!=''">
					<xsl:text>![</xsl:text>
					<include item="altText_XNAFramework"/>
					<xsl:text>](</xsl:text>
					<include item="mediaPath">
						<parameter>xna.gif</parameter>
					</include>
					<xsl:text> "</xsl:text>
					<include item="altText_XNAFramework"/>
					<xsl:text>")</xsl:text>
				</xsl:if>
				<xsl:if test="normalize-space($v_supportedOnSilverlightMobile)!=''">
					<xsl:text>![</xsl:text>
					<include item="altText_SilverlightMobile"/>
					<xsl:text>](</xsl:text>
					<include item="mediaPath">
						<parameter>slMobile.gif</parameter>
					</include>
					<xsl:text> "</xsl:text>
					<include item="altText_SilverlightMobile"/>
					<xsl:text>")</xsl:text>
				</xsl:if>
			</td>
			<xsl:variable name="id" select="@api"/>
			<td target="{$id}" markdown="span">
				<xsl:text>**</xsl:text>
				<xsl:value-of select="apidata/@name"/>
				<xsl:text>**</xsl:text>
			</td>
			<xsl:if test="$includeEnumValues='true'">
				<td markdown="span">
					<xsl:value-of select="value"/>
				</td>
			</xsl:if>
			<td markdown="span">
				<xsl:if test="attributes/attribute/type[@api='T:System.ObsoleteAttribute']">
					<xsl:text> </xsl:text>
					<include item="boilerplate_obsoleteShort"/>
				</xsl:if>
				<xsl:call-template name="t_getEnumMemberDescription"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="element" mode="derivedType" name="t_derivedTypeElement">
		<tr>
			<td markdown="span">
				<xsl:choose>
					<xsl:when test="@display-api">
						<referenceLink target="{@api}" display-target="{@display-api}"/>
					</xsl:when>
					<xsl:otherwise>
						<referenceLink target="{@api}"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td markdown="span">
				<xsl:if test="attributes/attribute/type[@api='T:System.ObsoleteAttribute']">
					<xsl:text> </xsl:text>
					<include item="boilerplate_obsoleteShort"/>
				</xsl:if>
				<xsl:call-template name="t_getElementDescription"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="element" mode="members" name="t_membersElement">
		<xsl:param name="subgroup"/>
		<xsl:if test="memberdata[@visibility='public'] and apidata[@subgroup=$g_apiTopicSubGroup]">
			public;
		</xsl:if>
		<xsl:if test="memberdata[@visibility='family' or @visibility='family or assembly' or @visibility='assembly'] and apidata[@subgroup=$g_apiTopicSubGroup]">
			protected;
		</xsl:if>
		<xsl:if test="memberdata[@visibility='private'] and apidata[@subgroup=$g_apiTopicSubGroup] and not(proceduredata[@virtual = 'true'])">
			private;
		</xsl:if>
		<xsl:if test="memberdata[@visibility='private'] and proceduredata[@virtual = 'true']">
			explicit;
		</xsl:if>
	</xsl:template>

	<xsl:template match="element" mode="memberlistRow" name="t_memberlistRowElement">
		<xsl:param name="p_showParameters" select="'false'"/>
		<xsl:variable name="v_notsupportedOnNetfw">
			<xsl:call-template name="t_isMemberUnsupportedOnNetfw"/>
		</xsl:variable>
		<xsl:variable name="v_supportedOnXna">
			<xsl:call-template name="t_isMemberSupportedOnXna"/>
		</xsl:variable>
		<xsl:variable name="v_supportedOnCf">
			<xsl:call-template name="t_isMemberSupportedOnCf"/>
		</xsl:variable>
		<xsl:variable name="v_supportedOnSilverlight">
			<xsl:call-template name="t_isMemberSupportedOnSilverlight"/>
		</xsl:variable>
		<xsl:variable name="v_supportedOnSilverlightMobile">
			<xsl:call-template name="t_isMemberSupportedOnSilverlightMobile"/>
		</xsl:variable>
		<xsl:variable name="v_staticMember">
			<xsl:call-template name="t_isMemberStatic"/>
		</xsl:variable>
		<xsl:variable name="v_inheritedMember">
			<xsl:call-template name="t_isMemberInherited"/>
		</xsl:variable>
		<xsl:variable name="v_declaredMember">
			<xsl:call-template name="t_isMemberDeclared"/>
		</xsl:variable>
		<xsl:variable name="v_protectedMember">
			<xsl:call-template name="t_isMemberProtected"/>
		</xsl:variable>
		<xsl:variable name="v_publicMember">
			<xsl:call-template name="t_isMemberPublic"/>
		</xsl:variable>
		<xsl:variable name="v_privateMember">
			<xsl:call-template name="t_isMemberPrivate"/>
		</xsl:variable>
		<xsl:variable name="v_explicitMember">
			<xsl:call-template name="t_isMemberExplicit"/>
		</xsl:variable>
		<xsl:variable name="v_conversionOperator">
			<xsl:call-template name="t_isConversionOperator"/>
		</xsl:variable>
		<!-- Do not show non-static members of static types -->
		<xsl:if test=".//memberdata/@static='true' or not(/document/reference/typedata[@abstract='true' and @sealed='true'])">
      <xsl:text>&#xa;</xsl:text>
      <tr>
        <td markdown="span">
					<xsl:call-template name="t_putMemberIcons">
						<xsl:with-param name="p_memberVisibility">
							<xsl:choose>
								<xsl:when test="normalize-space($v_publicMember)!=''">pub</xsl:when>
								<xsl:when test="normalize-space($v_protectedMember)!=''">prot</xsl:when>
								<xsl:when test="memberdata/@visibility='private'">priv</xsl:when>
								<xsl:otherwise>pub</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="p_staticMember" select="normalize-space($v_staticMember)"/>
						<xsl:with-param name="p_supportedOnXna" select="normalize-space($v_supportedOnXna)"/>
						<xsl:with-param name="p_supportedOnCf" select="normalize-space($v_supportedOnCf)"/>
						<xsl:with-param name="p_supportedOnSilverlight" select="normalize-space($v_supportedOnSilverlight)"/>
						<xsl:with-param name="p_supportedOnSilverlightMobile" select="normalize-space($v_supportedOnSilverlightMobile)"/>
					</xsl:call-template>
        </td>
        <td markdown="span">
					<xsl:choose>
						<xsl:when test="normalize-space($v_conversionOperator)!=''">
							<referenceLink target="{@api}" show-parameters="true"/>
						</xsl:when>
						<xsl:when test="memberdata[@overload] or starts-with(../@api, 'Overload:')">
							<referenceLink target="{@api}" show-parameters="true"/>
						</xsl:when>
						<xsl:when test="@source='extension'">
							<xsl:call-template name="t_putExtensionMethodDisplayLink"/>
						</xsl:when>
						<xsl:when test="@display-api">
							<referenceLink target="{@api}" display-target="{@display-api}"
														 show-parameters="{$p_showParameters}"/>
						</xsl:when>
						<xsl:otherwise>
							<referenceLink target="{@api}" show-parameters="{$p_showParameters}"/>
						</xsl:otherwise>
					</xsl:choose>
        </td>
        <td markdown="span">
					<xsl:if test="attributes/attribute/type[@api='T:System.ObsoleteAttribute']">
						<xsl:text> </xsl:text>
						<include item="boilerplate_obsoleteShort"/>
					</xsl:if>
					<xsl:if test="topicdata[@subgroup='overload'] or @overload='true'">
						<include item="Overloaded"/>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:apply-templates select="element" mode="overloadSummary"/>
					<xsl:call-template name="t_getElementDescription"/>
					<xsl:choose>
						<xsl:when test="not(topicdata[@subgroup='overload'])">
							<xsl:choose>
								<xsl:when test="@source='extension' and containers/type">
									<xsl:text> </xsl:text>
									<include item="definedBy">
										<parameter>
											<xsl:apply-templates select="containers/type" mode="link"/>
										</parameter>
									</include>
								</xsl:when>
								<xsl:when test="normalize-space($v_inheritedMember)!=''">
									<xsl:text> </xsl:text>
									<include item="inheritedFrom">
										<parameter>
											<xsl:apply-templates select="containers/type" mode="link"/>
										</parameter>
									</include>
								</xsl:when>
								<xsl:when test="overrides/member">
									<xsl:text> </xsl:text>
									<include item="overridesMember">
										<parameter>
											<xsl:apply-templates select="overrides/member" mode="link"/>
										</parameter>
									</include>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>

					<!-- add boilerplate for other members in the signature set -->
					<xsl:if test="@signatureset and element">
						<xsl:variable name="primaryMember">
							<xsl:copy-of select="."/>
						</xsl:variable>
						<xsl:variable name="primaryFramework"
													select="versions/versions[1]/@name"/>
						<xsl:for-each select="versions/versions[@name!=$primaryFramework]">
							<xsl:variable name="secondaryFramework"
														select="@name"/>
							<xsl:if test="(msxsl:node-set($primaryMember)/*[not(@*[local-name()=$secondaryFramework])]) and (msxsl:node-set($primaryMember)/*[element[@*[local-name()=$secondaryFramework]]])">
								<xsl:for-each select="msxsl:node-set($primaryMember)/*/element[@*[local-name()=$secondaryFramework]][1]">
									<xsl:variable name="inheritedSecondaryMember">
										<xsl:call-template name="t_isMemberInherited"/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="overrides">
											<include item="boilerplate_secondaryFrameworkOverride">
												<parameter>
													<xsl:value-of select="$secondaryFramework"/>
												</parameter>
												<!--<parameter>
                          <xsl:value-of select="@*[local-name()=$secondaryFramework]"/>
                        </parameter>-->
												<parameter>
													<referenceLink target="{@api}"/>
												</parameter>
											</include>
										</xsl:when>
										<xsl:when test="normalize-space($inheritedSecondaryMember)!=''">
											<include item="boilerplate_secondaryFrameworkInherited">
												<parameter>
													<xsl:value-of select="$secondaryFramework"/>
												</parameter>
												<parameter>
													<xsl:value-of select="@*[local-name()=$secondaryFramework]"/>
												</parameter>
												<parameter>
													<xsl:text>.</xsl:text>
												</parameter>
												<parameter>
													<xsl:apply-templates select="containers/type" mode="link"/>
												</parameter>
												<parameter>
													<referenceLink target="{@api}"/>
												</parameter>
											</include>
										</xsl:when>
										<xsl:otherwise>
											<include item="boilerplate_secondaryFrameworkMember">
												<parameter>
													<xsl:value-of select="$secondaryFramework"/>
												</parameter>
												<parameter>
													<xsl:value-of select="@*[local-name()=$secondaryFramework]"/>
												</parameter>
												<parameter>
													<referenceLink target="{@api}"/>
												</parameter>
											</include>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:if>
        </td>
      </tr>
		</xsl:if>
	</xsl:template>

	<xsl:template match="element" mode="overloadSummary" name="t_overloadSummaryElement">
		<xsl:call-template name="t_getOverloadSummary"/>
	</xsl:template>

	<xsl:template match="element" mode="overloadSections" name="t_overloadSectionsElement">
		<xsl:call-template name="t_getOverloadSections"/>
	</xsl:template>

	<!-- ============================================================================================
	Element helpers
	============================================================================================= -->

	<xsl:template name="t_putTypeIcon">
		<xsl:param name="p_typeVisibility"/>

		<xsl:variable name="typeSubgroup" select="apidata/@subgroup"/>
		<xsl:text>![</xsl:text>
		<include item="{concat('altText_',$p_typeVisibility,$typeSubgroup)}"/>
		<xsl:text>](</xsl:text>
		<include item="mediaPath">
			<parameter>
				<xsl:value-of select="concat($p_typeVisibility,$typeSubgroup,'.gif')"/>
			</parameter>
		</include>
		<xsl:text> "</xsl:text>
		<include item="{concat('altText_',$p_typeVisibility,$typeSubgroup)}"/>
		<xsl:text>")</xsl:text>

		<xsl:if test=".//example">
			<xsl:text>![</xsl:text>
			<include item="altText_CodeExample"/>
			<xsl:text>](</xsl:text>
			<include item="mediaPath">
				<parameter>CodeExample.png</parameter>
			</include>
			<xsl:text> "</xsl:text>
			<include item="altText_CodeExample"/>
			<xsl:text>")</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template name="t_putMemberIcons">
		<xsl:param name="p_memberVisibility"/>
		<xsl:param name="p_staticMember"/>
		<xsl:param name="p_supportedOnXna"/>
		<xsl:param name="p_supportedOnCf"/>
		<xsl:param name="p_supportedOnSilverlightMobile"/>

		<xsl:variable name="v_memberSubgroup">
			<xsl:choose>
				<xsl:when test="apidata/@subgroup='constructor'">
					<xsl:text>method</xsl:text>
				</xsl:when>
				<xsl:when test="apidata/@subgroup='method'">
					<xsl:choose>
						<xsl:when test="apidata/@subsubgroup='operator'">
							<xsl:text>operator</xsl:text>
						</xsl:when>
						<xsl:when test="apidata/@subsubgroup='extension'">
							<xsl:text>extension</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>method</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="apidata/@subgroup"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- test for explicit interface implementations, which get the interface icon -->
		<xsl:if test="memberdata/@visibility='private' and proceduredata/@virtual='true'">
			<xsl:text>![</xsl:text>
			<include item="altText_ExplicitInterface"/>
			<xsl:text>](</xsl:text>
			<include item="mediaPath">
				<parameter>pubinterface.gif</parameter>
			</include>
			<xsl:text> "</xsl:text>
			<include item="altText_ExplicitInterface"/>
			<xsl:text>")</xsl:text>
		</xsl:if>

		<xsl:text>![</xsl:text>
		<xsl:choose>
			<xsl:when test="apidata/@subsubgroup">
				<include item="{concat('altText_',$p_memberVisibility,apidata/@subsubgroup)}"/>
			</xsl:when>
			<xsl:otherwise>
				<include item="{concat('altText_',$p_memberVisibility,$v_memberSubgroup)}"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>](</xsl:text>
		<include item="mediaPath">
			<parameter>
				<xsl:value-of select="concat($p_memberVisibility,$v_memberSubgroup,'.gif')"/>
			</parameter>
		</include>
		<xsl:text> "</xsl:text>
		<xsl:choose>
			<xsl:when test="apidata/@subsubgroup">
				<include item="{concat('altText_',$p_memberVisibility,apidata/@subsubgroup)}"/>
			</xsl:when>
			<xsl:otherwise>
				<include item="{concat('altText_',$p_memberVisibility,$v_memberSubgroup)}"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>")</xsl:text>

		<xsl:if test="$p_staticMember!=''">
			<xsl:text>![</xsl:text>
			<include item="altText_static"/>
			<xsl:text>](</xsl:text>
			<include item="mediaPath">
				<parameter>static.gif</parameter>
			</include>
			<xsl:text> "</xsl:text>
			<include item="altText_static"/>
			<xsl:text>")</xsl:text>
		</xsl:if>

		<xsl:if test="$p_supportedOnCf!=''">
			<xsl:text>![</xsl:text>
			<include item="altText_CompactFramework"/>
			<xsl:text>](</xsl:text>
			<include item="mediaPath">
				<parameter>CFW.gif</parameter>
			</include>
			<xsl:text> "</xsl:text>
			<include item="altText_CompactFramework"/>
			<xsl:text>")</xsl:text>
		</xsl:if>

		<xsl:if test="$p_supportedOnXna!=''">
			<xsl:text>![</xsl:text>
			<include item="altText_XNAFramework"/>
			<xsl:text>](</xsl:text>
			<include item="mediaPath">
				<parameter>xna.gif</parameter>
			</include>
			<xsl:text> "</xsl:text>
			<include item="altText_XNAFramework"/>
			<xsl:text>")</xsl:text>
		</xsl:if>

		<xsl:if test="$p_supportedOnSilverlightMobile!=''">
			<xsl:text>![</xsl:text>
			<include item="altText_SilverlightMobile"/>
			<xsl:text>](</xsl:text>
			<include item="mediaPath">
				<parameter>slMobile.gif</parameter>
			</include>
			<xsl:text> "</xsl:text>
			<include item="altText_SilverlightMobile"/>
			<xsl:text>")</xsl:text>
		</xsl:if>

		<xsl:if test=".//example">
			<xsl:text>![</xsl:text>
			<include item="altText_CodeExample"/>
			<xsl:text>](</xsl:text>
			<include item="mediaPath">
				<parameter>CodeExample.png</parameter>
			</include>
			<xsl:text> "</xsl:text>
			<include item="altText_CodeExample"/>
			<xsl:text>")</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template name="t_getEnumMemberDescription">
		<xsl:apply-templates select="summary[1]/node()"/>
		<!-- enum members may have additional authored content in the remarks node -->
		<xsl:apply-templates select="remarks[1]/node()"/>
	</xsl:template>

	<xsl:template name="t_putExtensionMethodDisplayLink">
		<xsl:variable name="v_showParameters">
			<xsl:choose>
				<xsl:when test="@overload='true'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<referenceLink target="{@api}" display-target="extension" show-parameters="{$v_showParameters}">
			<extensionMethod>
				<xsl:copy-of select="@*"/>
				<xsl:copy-of select="apidata|templates|parameters|containers"/>
			</extensionMethod>
		</referenceLink>
	</xsl:template>

	<!-- ============================================================================================
	Inheritance hierarchy
	============================================================================================= -->

	<xsl:template match="family" name="t_family">
		<xsl:param name="p_maxCount" select="number(5)" />
		<xsl:call-template name="t_putSectionInclude">
			<xsl:with-param name="p_titleInclude" select="'title_family'"/>
			<xsl:with-param name="p_id">
				<xsl:if test="$p_maxCount=0">
					<xsl:value-of select="'fullInheritance'"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="p_content">
				<xsl:variable name="ancestorCount" select="count(ancestors/*)"/>
				<xsl:variable name="childCount" select="count(descendents/*)"/>

				<xsl:for-each select="ancestors/type">
					<xsl:sort select="position()" data-type="number" order="descending"/>

					<xsl:call-template name="t_putBulletIndent">
						<xsl:with-param name="p_count" select="position()"/>
					</xsl:call-template>

					<xsl:apply-templates select="self::type" mode="link">
						<xsl:with-param name="qualified" select="true()"/>
					</xsl:apply-templates>

					<xsl:text>&#xa;</xsl:text>
				</xsl:for-each>

				<xsl:call-template name="t_putBulletIndent">
					<xsl:with-param name="p_count" select="$ancestorCount + 1"/>
				</xsl:call-template>
				<referenceLink target="{$key}" qualified="true"/>
        <xsl:text>&#xa;</xsl:text>

				<xsl:choose>
					<xsl:when test="descendents/@derivedTypes">
						<xsl:call-template name="t_putBulletIndent">
							<xsl:with-param name="p_count" select="$ancestorCount + 2"/>
						</xsl:call-template>
						<referenceLink target="{descendents/@derivedTypes}" qualified="true">
							<include item="derivedClasses"/>
						</referenceLink>
					</xsl:when>
					<xsl:when test="not($p_maxCount=0) and count(descendents/type) > $p_maxCount">
						<xsl:call-template name="t_putBulletIndent">
							<xsl:with-param name="p_count" select="$ancestorCount + 2"/>
						</xsl:call-template>
						<a href="#fullInheritance">
							<include item="text_moreInheritance"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="descendents/type">
							<xsl:sort select="@api"/>

							<xsl:if test="not(self::type/@api=preceding-sibling::*/self::type/@api)">
								<xsl:call-template name="t_putBulletIndent">
									<xsl:with-param name="p_count" select="$ancestorCount + 2"/>
								</xsl:call-template>

								<xsl:apply-templates select="self::type" mode="link">
									<xsl:with-param name="qualified" select="true()"/>
								</xsl:apply-templates>
                
                <xsl:text>&#xa;</xsl:text>
							</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="family" name="t_familyFull" mode="fullInheritance">
		<xsl:call-template name="t_family">
			<xsl:with-param name="p_maxCount" select="number(0)" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="implements" name="t_implements">
		<xsl:if test="member">
			<xsl:call-template name="t_putSubSection">
				<xsl:with-param name="p_title">
					<include item="title_implements"/>
				</xsl:with-param>
				<xsl:with-param name="p_content">
					<xsl:for-each select="member">
						<referenceLink target="{@api}" qualified="true"/>
						<xsl:text>&#xa;</xsl:text>
					</xsl:for-each>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- ============================================================================================
	Member attribute tests
	============================================================================================= -->

	<xsl:template name="t_isMemberUnsupportedOnNetfw">
		<xsl:if test="boolean(not(@netfw) and not(element/@netfw))">
			<xsl:text>unsupported</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- for testing CF and XNA support, check the signature variations of @signatureset elements -->
	<!-- for testing inherited/protected/etc, do not check the @signatureset variations; just go with the primary .NET Framework value -->
	<xsl:template name="t_isMemberSupportedOnXna">
		<xsl:choose>
			<xsl:when test="element">
				<xsl:for-each select="element">
					<xsl:call-template name="t_isMemberSupportedOnXna"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="v_platformFilterExcludesXna"
											select="boolean(platforms and not(platforms/platform[.='Xbox360']))"/>
				<xsl:if test="boolean(not($v_platformFilterExcludesXna) and (@xnafw or element/@xnafw))">
					<xsl:text>supported</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="t_isMemberSupportedOnCf">
		<xsl:choose>
			<xsl:when test="element">
				<xsl:for-each select="element">
					<xsl:call-template name="t_isMemberSupportedOnCf"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="v_platformFilterExcludesCF"
											select="boolean( platforms and not(platforms[platform[.='PocketPC'] or platform[.='SmartPhone'] or platform[.='WindowsCE']]) )"/>
				<xsl:if test="boolean(not($v_platformFilterExcludesCF) and (@netcfw or element/@netcfw))">
					<xsl:text>yes</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="t_isMemberSupportedOnSilverlightMobile">
		<xsl:choose>
			<xsl:when test="element">
				<xsl:for-each select="element">
					<xsl:call-template name="t_isMemberSupportedOnSilverlightMobile"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="platformFilterExcludesSilverlightMobile"
											select="boolean( platforms and not(platforms[platform[.='SilverlightPlatforms']]) )"/>
				<xsl:if test="boolean(not($platformFilterExcludesSilverlightMobile) and (@silverlight_mobile or element/@silverlight_mobile))">
					<xsl:text>yes</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="t_isMemberSupportedOnSilverlight">
		<xsl:choose>
			<xsl:when test="element">
				<xsl:for-each select="element">
					<xsl:call-template name="t_isMemberSupportedOnSilverlight"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="v_platformFilterExcludesSilverlight"
											select="boolean( platforms and not(platforms[platform[.='SilverlightPlatforms']]) )"/>
				<xsl:if test="boolean(not($v_platformFilterExcludesSilverlight) and (@silverlight or element/@silverlight))">
					<xsl:text>yes</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ======================================================================================== -->

	<xsl:template name="t_isMemberStatic">
		<xsl:choose>
			<xsl:when test="element and not(@signatureset)">
				<xsl:for-each select="element">
					<xsl:call-template name="t_isMemberStatic"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="apidata[@subsubgroup='attachedProperty' or @subsubgroup='attachedEvent']"/>
			<xsl:otherwise>
				<xsl:if test="memberdata/@static='true'">
					<xsl:text>yes</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- returns a non-empty string if the element is inherited, or for overloads if any of the overloads is inherited -->
	<xsl:template name="t_isMemberInherited">
		<xsl:choose>
			<xsl:when test="element and not(@signatureset)">
				<xsl:for-each select="element">
					<xsl:call-template name="t_isMemberInherited"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="containers/type[@api!=$g_typeTopicId]">
					<xsl:text>yes</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- returns a non-empty string if the element is declared, or for overloads if any of the overloads is declared -->
	<xsl:template name="t_isMemberDeclared">
		<xsl:choose>
			<xsl:when test="element and not(@signatureset)">
				<xsl:for-each select="element">
					<xsl:call-template name="t_isMemberDeclared"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="containers/type[@api=$g_typeTopicId]">
					<xsl:text>yes</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="t_isMemberPublic">
		<xsl:choose>
			<xsl:when test="element and not(@signatureset)">
				<xsl:for-each select="element">
					<xsl:call-template name="t_isMemberPublic"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="memberdata[@visibility='public']">
					<xsl:text>yes</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="t_isMemberProtected">
		<xsl:choose>
			<xsl:when test="element and not(@signatureset)">
				<xsl:for-each select="element">
					<xsl:call-template name="t_isMemberProtected"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="memberdata[@visibility='family' or @visibility='family or assembly' or @visibility='assembly']">
					<xsl:text>yes</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="t_isMemberPrivate">
		<xsl:choose>
			<xsl:when test="element and not(@signatureset)">
				<xsl:for-each select="element">
					<xsl:call-template name="t_isMemberPrivate"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="memberdata[@visibility='private'] and not(proceduredata[@virtual = 'true'])">
					<xsl:text>yes</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="t_isMemberExplicit">
		<xsl:choose>
			<xsl:when test="element">
				<xsl:for-each select="element">
					<xsl:call-template name="t_isMemberExplicit"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="memberdata[@visibility='private'] and proceduredata[@virtual = 'true']">
					<xsl:text>yes</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="t_isConversionOperator">
		<xsl:choose>
			<xsl:when test="element">
				<xsl:for-each select="element">
					<xsl:call-template name="t_isConversionOperator"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="apidata/@subsubgroup='operator' and (apidata/@name='Explicit' or apidata/@name='Implicit') and not(memberdata/@overload)">
					<xsl:text>yes</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============================================================================================
	Assembly information
	============================================================================================= -->

	<xsl:template name="t_putRequirementsInfo">
		<xsl:text>&#xa;</xsl:text>
		<include item="boilerplate_requirementsNamespace"/>
		<xsl:text>&#xa0;</xsl:text>
		<referenceLink target="{/document/reference/containers/namespace/@api}"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:call-template name="t_putAssembliesInfo"/>

		<!-- Show XAML xmlns for APIs that support XAML -->
		<xsl:if test="$omitXmlnsBoilerplate != 'true'">
			<!-- All topics that have auto-generated XAML syntax get an "XMLNS for XAML" line in the Requirements
					 section.  Topics with boilerplate XAML syntax, e.g. "Not applicable", do NOT get this line. -->
			<xsl:if test="boolean(/document/syntax/div[@codeLanguage='XAML']/div[
										@class='xamlAttributeUsageHeading' or @class='xamlObjectElementUsageHeading' or
										@class='xamlContentElementUsageHeading' or @class='xamlPropertyElementUsageHeading'])">
				<xsl:text>&#xa;</xsl:text>
				<include item="boilerplate_xamlXmlnsRequirements">
					<parameter>
						<xsl:choose>
							<xsl:when test="/document/syntax/div[@codeLanguage='XAML']/div[@class='xamlXmlnsUri']">
								<xsl:for-each select="/document/syntax/div[@codeLanguage='XAML']/div[@class='xamlXmlnsUri']">
									<xsl:if test="position()!=1">
										<xsl:text>, </xsl:text>
									</xsl:if>
									<xsl:value-of select="."/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<include item="boilerplate_unmappedXamlXmlns"/>
							</xsl:otherwise>
						</xsl:choose>
					</parameter>
				</include>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="t_putAssembliesInfo">
		<xsl:choose>
			<xsl:when test="count(/document/reference/containers/library)&gt;1">
				<include item="boilerplate_requirementsAssemblies"/>
				<xsl:for-each select="/document/reference/containers/library">
					<xsl:text>&#xa0;&#xa0;</xsl:text>
					<xsl:call-template name="t_putAssemblyNameAndModule">
						<xsl:with-param name="library" select="."/>
					</xsl:call-template>
					<xsl:text>&#xa;</xsl:text>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<include item="boilerplate_requirementsAssemblyLabel"/>
				<xsl:text>&#xa0;</xsl:text>
				<xsl:call-template name="t_putAssemblyNameAndModule"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="t_putAssemblyNameAndModule">
		<xsl:param name="library" select="/document/reference/containers/library"/>
		<include item="assemblyNameAndModule">
			<parameter>
				<xsl:value-of select="$library/@assembly"/>
			</parameter>
			<parameter>
				<xsl:value-of select="$library/@module"/>
			</parameter>
			<parameter>
				<xsl:choose>
					<xsl:when test="$library/@kind = 'DynamicallyLinkedLibrary'">
						<xsl:text>dll</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>exe</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</parameter>
			<parameter>
				<xsl:variable name="versionParts">
					<xsl:call-template name="t_tokenize">
						<xsl:with-param name="string" select="substring-before(concat($library/assemblydata/@version, ' '), ' ')" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="versionNodes" select="msxsl:node-set($versionParts)" />
				<!-- Limit version number length if requested -->
				<xsl:choose>
					<xsl:when test="$maxVersionParts = '2'">
						<xsl:value-of select="concat($versionNodes/token[1], '.', $versionNodes/token[2])" />
					</xsl:when>
					<xsl:when test="$maxVersionParts = '3'">
						<xsl:value-of select="concat($versionNodes/token[1], '.', $versionNodes/token[2], '.', $versionNodes/token[3])" />
					</xsl:when>
					<xsl:when test="$maxVersionParts = '4'">
						<xsl:value-of select="concat($versionNodes/token[1], '.', $versionNodes/token[2], '.', $versionNodes/token[3], '.', $versionNodes/token[4])" />
					</xsl:when>
					<xsl:otherwise>
						<!-- All parts including the assembly file version if present -->
						<xsl:value-of select="$library/assemblydata/@version"/>
					</xsl:otherwise>
				</xsl:choose>
			</parameter>
		</include>
	</xsl:template>

	<xsl:template name="t_tokenize">
		<xsl:param name="string"/>
		<xsl:param name="separator" select="'.'"/>

		<xsl:choose>
			<xsl:when test="contains($string, $separator)">
				<token>
					<xsl:value-of select="substring-before($string, $separator)"/>
				</token>
				<xsl:call-template name="t_tokenize">
					<xsl:with-param name="string" select="substring-after($string, $separator)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<token>
					<xsl:value-of select="$string"/>
				</token>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============================================================================================
	Platform information
	============================================================================================= -->

	<xsl:template match="platforms[platform]" name="t_platforms">
		<xsl:call-template name="t_putSectionInclude">
			<xsl:with-param name="p_titleInclude" select="'title_platforms'"/>
			<xsl:with-param name="p_content">
				<xsl:choose>
					<xsl:when test="/document/reference/versions/versions[@name='silverlight']//version">
						<xsl:text>&#xa;</xsl:text>
						<include item="boilerplate_silverlightPlatforms"/>
						<xsl:text>&#xa;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&#xa;</xsl:text>
						<xsl:for-each select="platform">
							<include item="{.}"/>
							<xsl:if test="position()!=last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
						<xsl:text>&#xa;</xsl:text>
						<xsl:if test="/document/reference/versions/versions[@name='netfw' or @name='netcfw']//version">
							<xsl:text>&#xa;</xsl:text>
							<include item="boilerplate_systemRequirementsLink"/>
							<xsl:text>&#xa;</xsl:text>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- ============================================================================================
	Version information
	============================================================================================= -->

	<xsl:template match="versions" name="t_versions">
		<xsl:if test="$omitVersionInformation != 'true'">
			<xsl:call-template name="t_putSectionInclude">
				<xsl:with-param name="p_titleInclude" select="'title_versions'"/>
				<xsl:with-param name="p_content">
					<xsl:call-template name="t_processVersions"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="t_processVersions">
		<xsl:param name="p_frameworkGroup" select="true()"/>
		<xsl:choose>
			<xsl:when test="versions and $p_frameworkGroup">
				<xsl:for-each select="versions">
					<!-- $v_platformFilterExcluded is based on platform filtering information -->
					<xsl:variable name="v_platformFilterExcluded"
												select="boolean(/document/reference/platforms and ( (@name='netcfw' and not(/document/reference/platforms/platform[.='PocketPC']) and not(/document/reference/platforms/platform[.='SmartPhone']) and not(/document/reference/platforms/platform[.='WindowsCE']) ) or (@name='xnafw' and not(/document/reference/platforms/platform[.='Xbox360']) ) ) )"/>
					<xsl:if test="not($v_platformFilterExcluded) and count(.//version) &gt; 0">
						<xsl:text>&#xa;</xsl:text>
						<xsl:text>&#xa;</xsl:text>
						<xsl:text>#### </xsl:text>
						<include item="{@name}"/>
						<xsl:text>&#xa;</xsl:text>
						<xsl:call-template name="t_processVersions">
							<xsl:with-param name="p_frameworkGroup" select="false()"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<!-- show the versions in which the api is supported, if any -->
				<xsl:variable name="v_supportedCount"
											select="count(version[not(@obsolete)] | versions[version[not(@obsolete)]])"/>
				<xsl:if test="$v_supportedCount &gt; 0">
					<include item="supportedIn_{$v_supportedCount}">
						<xsl:for-each select="version[not(@obsolete)] | versions[version[not(@obsolete)]]">
							<xsl:variable name="versionName">
								<xsl:choose>
									<!-- A versions[version] node at this level is for releases that had subsequent service packs. 
                       For example, versions for .NET 3.0 has version nodes for 3.0 and 3.0 SP1. 
                       We show only the first node, which is the one in which the api was first released, 
                       that is, we show 3.0 SP1 only if the api was introduced in SP1. -->
									<xsl:when test="local-name()='versions'">
										<xsl:value-of select="version[not(@obsolete)][not(preceding-sibling::version[not(@obsolete)])]/@name"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@name"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<parameter>
								<include item="{$versionName}"/>
							</parameter>
						</xsl:for-each>
					</include>
					<xsl:text>&#xa;</xsl:text>
				</xsl:if>
				<!-- show the versions in which the api is obsolete with a compiler warning, if any -->
				<xsl:for-each select=".//version[@obsolete='warning']">
					<include item="obsoleteWarning">
						<parameter>
							<include item="{@name}"/>
						</parameter>
					</include>
					<xsl:text>&#xa;</xsl:text>
				</xsl:for-each>
				<!-- show the versions in which the api is obsolete and does not compile, if any -->
				<xsl:for-each select=".//version[@obsolete='error']">
					<xsl:if test="position()=last()">
						<include item="obsoleteError">
							<parameter>
								<include item="{@name}"/>
							</parameter>
						</include>
						<xsl:text>&#xa;</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============================================================================================
	Syntax
	============================================================================================= -->

	<xsl:template match="parameters" name="t_parameters">
		<xsl:call-template name="t_putSubSection">
			<xsl:with-param name="p_title">
				<include item="title_parameters"/>
			</xsl:with-param>
			<xsl:with-param name="p_content">
				<xsl:text>&#xa;</xsl:text>
				<dl markdown="1">
					<xsl:for-each select="parameter">
						<dt>
							<xsl:value-of select="normalize-space(@name)"/>
							<xsl:if test="@optional = 'true'">
								<xsl:text> (Optional)</xsl:text>
							</xsl:if>
						</dt>
						<xsl:text>&#xa;</xsl:text>
						<dd>
							<include item="typeLink">
								<parameter>
									<xsl:apply-templates select="*[1]" mode="link">
										<xsl:with-param name="qualified" select="true()"/>
									</xsl:apply-templates>
								</parameter>
							</include>
							<xsl:text>&#xa;</xsl:text>
							<xsl:call-template name="t_getParameterDescription">
								<xsl:with-param name="name" select="normalize-space(@name)"/>
							</xsl:call-template>
						</dd>
						<xsl:text>&#xa;</xsl:text>
					</xsl:for-each>
				</dl>
				<xsl:text>&#xa;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- ======================================================================================== -->

	<!-- produces a (plain) comma-separated list of parameter types -->
	<xsl:template match="type" mode="link" name="t_typeLink">
		<xsl:param name="qualified" select="false()"/>
		<!-- we don't display outer types, because the link will show them -->
		<referenceLink target="{@api}" prefer-overload="false">
			<xsl:choose>
				<xsl:when test="specialization">
					<xsl:attribute name="show-templates">false</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="show-templates">true</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="$qualified">
				<xsl:attribute name="show-container">true</xsl:attribute>
			</xsl:if>
		</referenceLink>
		<xsl:apply-templates select="specialization" mode="link"/>
	</xsl:template>

	<!-- Produces a (plain) name; outer types are indicated by dot-separators; -->
	<!-- generic types are indicated by a keyword, because we can't show templates in a language-independent way -->
	<xsl:template match="type" mode="plain" name="t_typeNamePlain">
		<!-- EFW - Don't show the type name on list pages -->
		<xsl:if test="type|(containers/type) and not($g_topicGroup='list')">
			<xsl:apply-templates select="type|(containers/type)" mode="plain"/>
			<xsl:text>.</xsl:text>
		</xsl:if>
		<!-- EFW - If the API element is not present (unresolved type), show the type name from the type element -->
		<xsl:choose>
			<xsl:when test="apidata/@name">
				<xsl:value-of select="apidata/@name" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="t_getTrimmedLastPeriod">
					<xsl:with-param name="p_string" select="@api" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="specialization">
				<xsl:apply-templates select="specialization" mode="plain"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="templates" mode="plain"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="type" mode="decorated" name="t_typeNameDecorated">
		<!-- EFW - Don't show the type name on list pages -->
		<xsl:if test="type|(containers/type) and not($g_topicGroup='list')">
			<xsl:apply-templates select="type|(containers/type)" mode="decorated"/>
			<xsl:text>.</xsl:text>
		</xsl:if>
		<!-- EFW - If the API element is not present (unresolved type), show the type name from the type element -->
		<xsl:choose>
			<xsl:when test="apidata/@name">
				<xsl:value-of select="apidata/@name" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="t_getTrimmedLastPeriod">
					<xsl:with-param name="p_string" select="@api" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="specialization">
				<xsl:apply-templates select="specialization" mode="decorated"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="templates" mode="decorated"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ======================================================================================== -->

	<xsl:template match="specialization" mode="link" name="t_specializationLink">
		<xsl:text>(</xsl:text>
		<xsl:for-each select="*">
			<xsl:apply-templates select="." mode="link"/>
			<xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsl:template match="specialization" mode="plain" name="t_specializationPlain">
		<xsl:text>(</xsl:text>
		<xsl:for-each select="*">
			<xsl:apply-templates select="." mode="plain"/>
			<xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsl:template match="specialization" mode="decorated" name="t_specializationDecorated">
		<xsl:text>(</xsl:text>
		<xsl:for-each select="*">
			<xsl:apply-templates select="." mode="decorated"/>
			<xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>)</xsl:text>
	</xsl:template>

	<!-- ======================================================================================== -->

	<xsl:template match="template" mode="link" name="t_template_link">
		<xsl:choose>
			<xsl:when test="@api">
				<referenceLink target="{@api}">
					<xsl:text>*</xsl:text>
					<xsl:value-of select="@name"/>
					<xsl:text>*</xsl:text>
				</referenceLink>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>*</xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>*</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="template" mode="plain" name="t_templatePlain">
		<xsl:value-of select="@name"/>
	</xsl:template>

	<xsl:template match="template" mode="decorated" name="t_templateDecorated">
		<xsl:text>*</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>*</xsl:text>
	</xsl:template>

	<xsl:template match="templates" mode="link" name="t_templatesLink">
		<xsl:call-template name="t_specializationLink"/>
	</xsl:template>

	<xsl:template match="templates" mode="plain" name="t_templatesPlain">
		<xsl:call-template name="t_specializationPlain"/>
	</xsl:template>

	<xsl:template match="templates" mode="decorated" name="t_templatesDecorated">
		<xsl:call-template name="t_specializationDecorated"/>
	</xsl:template>

	<!-- ======================================================================================== -->

	<xsl:template match="arrayOf" mode="link" name="t_arrayOfLink">
		<xsl:param name="qualified" select="false()"/>
		<xsl:apply-templates mode="link">
			<xsl:with-param name="qualified" select="$qualified"/>
		</xsl:apply-templates>
		<xsl:text>[</xsl:text>
		<xsl:if test="number(@rank) &gt; 1">,</xsl:if>
		<xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template match="arrayOf" mode="plain" name="t_arrayOfPlain">
		<xsl:apply-templates select="type|arrayOf|pointerTo|referenceTo|template|specialization|templates" mode="plain"/>
		<xsl:text>[</xsl:text>
		<xsl:if test="number(@rank) &gt; 1">,</xsl:if>
		<xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template match="arrayOf" mode="decorated" name="t_arrayOfDecorated">
		<xsl:apply-templates select="type|arrayOf|pointerTo|referenceTo|template|specialization|templates" mode="decorated"/>
		<xsl:text>[</xsl:text>
		<xsl:if test="number(@rank) &gt; 1">,</xsl:if>
		<xsl:text>]</xsl:text>
	</xsl:template>

	<!-- ======================================================================================== -->

	<xsl:template match="pointerTo" mode="link" name="t_pointerToLink">
		<xsl:param name="qualified" select="false()"/>
		<xsl:apply-templates mode="link">
			<xsl:with-param name="qualified" select="$qualified"/>
		</xsl:apply-templates>
		<xsl:text>*</xsl:text>
	</xsl:template>

	<xsl:template match="pointerTo" mode="plain" name="t_pointerToPlain">
		<xsl:apply-templates select="type|arrayOf|pointerTo|referenceTo|template|specialization|templates" mode="plain"/>
		<xsl:text>*</xsl:text>
	</xsl:template>

	<xsl:template match="pointerTo" mode="decorated" name="t_pointerToDecorated">
		<xsl:apply-templates select="type|arrayOf|pointerTo|referenceTo|template|specialization|templates" mode="decorated"/>
	</xsl:template>

	<!-- ======================================================================================== -->

	<xsl:template match="referenceTo" mode="link" name="t_referenceToLink">
		<xsl:param name="qualified" select="false()"/>
		<xsl:apply-templates mode="link">
			<xsl:with-param name="qualified" select="$qualified"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="referenceTo" mode="plain" name="t_referenceToPlain">
		<xsl:apply-templates select="type|arrayOf|pointerTo|referenceTo|template|specialization|templates" mode="plain"/>
	</xsl:template>

	<xsl:template match="referenceTo" mode="decorated" name="t_referenceToDecorated">
		<xsl:apply-templates select="type|arrayOf|pointerTo|referenceTo|template|specialization|templates" mode="decorated"/>
	</xsl:template>

	<!-- ======================================================================================== -->

	<xsl:template match="member" mode="link" name="t_memberLink">
		<xsl:param name="qualified" select="true()"/>
		<xsl:choose>
			<xsl:when test="@display-api">
				<referenceLink target="{@api}" display-target="{@display-api}">
					<xsl:if test="$qualified">
						<xsl:attribute name="show-container">true</xsl:attribute>
					</xsl:if>
				</referenceLink>
			</xsl:when>
			<xsl:otherwise>
				<referenceLink target="{@api}">
					<xsl:if test="$qualified">
						<xsl:attribute name="show-container">true</xsl:attribute>
					</xsl:if>
				</referenceLink>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
