<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="header.jsp">
		<jsp:param name="checkLogin" value="N" />
	</jsp:include>
	<body>	
		<DIV id=contentFrame style="width:100%;height:100%">
		<jsp:include page="title.jsp">
			<jsp:param name="title" value="Contact Us"/>
			<jsp:param name="checkLogin" value="N" />
		</jsp:include>
		<table border="0">
			<tr>
				<td>
					地點：香港司徒拔道四十號港安大廈三樓B
				</td>
			</tr>
			<tr>
				<td>
					電話：2835-0555
				</td>
			</tr>
			<tr>
				<td>
					傳真：3651-8800
				</td>
			</tr>
			<tr>
				<td>
					電郵：<a href="mailto:lmc@hkah.org.hk">lmc@hkah.org.hk</a>
				</td>
			</tr>
			<tr>
				<td>
					辦公時間：星期一至五：早上9時至下午5時
				</td>
			</tr>
			<tr>
				<td>
					星期六、日及公眾假期 休息
				</td>
			</tr>
			<tr>
				<td>
					**若以傳真或鄱寄方式與我們聯絡，請於信封/文件上註明：健康生活促進中心 **
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>
					<hr>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>
					Location: Room B, 3/F, La Rue Building, 40 Stubbs Road, Hong Kong
				</td>
			</tr>
			<tr>
				<td>
					Phone: 2835-0555
				</td>
			</tr>
			<tr>
				<td>
					Fax: 3651-8800
				</td>
			</tr>
			<tr>
				<td>
					Email: lmc@hkah.org.hk
				</td>
			</tr>
			<tr>
				<td>
					Office Hour: Monday to Friday, 9am – 5pm
				</td>
			</tr>
			<tr>
				<td>
					Saturday, Sunday and Public Holiday: closed
				</td>
			</tr>
			<tr>
				<td>
					** If you contact us with fax or mail, please indicate: Lifestyle Management Center **
				</td>
			</tr>
		</table>
		</DIV>
	</body>
</html:html>