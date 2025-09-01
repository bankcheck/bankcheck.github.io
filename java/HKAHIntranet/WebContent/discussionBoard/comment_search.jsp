<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td class="title"><span><bean:message key="button.search" /> >></span></td></tr>
	<tr><td height="2" bgcolor="#840010"></td></tr>
	<tr><td height="10"></td></tr>
	<tr><td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr class="smallText">
				<td class="infoLabel">Search Topics</td>
				<td class="infoData">
					<select name="searchContactType">
						<option value="" selected><bean:message key="label.all" /></option>
						<option value="from"><bean:message key="prompt.from" /></option>
						<option value="to"><bean:message key="prompt.to" /></option>
						<option value="cc">CC</option>
					</select>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel">Date Range</td>
				<td class="infoData">
					<select name="searchDateRange">
						<option value="modifiedDate"><bean:message key="prompt.modifiedDate" /></option>
					</select>
					<br/>
					<bean:message key="prompt.from" /> :
				<input type="textfield" name="searchDateFrom" id="searchDateFrom" value="" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
				<br/>
				<bean:message key="prompt.to" /> :
				<input type="textfield" name="searchDateTo" id="searchDateTo" value="" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Sort by</td>
			<td class="infoData">
				<select name="searchSortBy">
					<option value="topic" selected><bean:message key="prompt.topic" /></option>
					<option value="modifiedDate"><bean:message key="prompt.modifiedDate" /></option>
				</select>
				<select name="ordering">
					<option value="ASC">Ascending</option>
					<option value="DESC">Decending</option>
				</select>
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Topic</td>
			<td class="infoData"><input type="textfield" name="searchTopic" value="" maxlength="20" size="20"></td>
		</tr>
		<tr class="smallText">
			<td class="infoData">&nbsp;</td>
			<td class="infoData">
				<button onclick="showSearch();return false;" class="btn-click"><bean:message key="button.search" /></button>
				</td>
			</tr>
		</table>
	</td></tr>
</table>