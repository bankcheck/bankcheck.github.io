<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.ehr.common.FactoryBase"%>
<%@ page import="com.hkah.constant.ConstantsEhr"%>
<%@ page import="java.io.*"%>
<%@ page import="jcifs.smb.*" %>
<%!
public File openPathNative(String path) throws Exception {
	File f= new File(path);
	return f;
}

public SmbFile openPathSamba(String path) throws Exception {
	String loginUser = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_SMB_USERNAME);
	String loginPassword = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_SMB_PASSWORD);
	
	return openPathSamba(path, loginUser, loginPassword);
}

public SmbFile openPathSamba(String path, String loginUser, String loginPassword) throws Exception {
	NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication("",loginUser, loginPassword);
	SmbFile smbFile = new SmbFile("smb:" + path.replaceAll("\\\\", "/"), auth);
	return smbFile;
}
	
%>
<%
String systemDefaultLoginUser = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_SMB_USERNAME);
String loginUser = request.getParameter("loginUser");
String loginPassword = request.getParameter("loginPassword");
String path = request.getParameter("path");
String method = request.getParameter("method");
File f = null;
SmbFile fsmb = null;
String eMsg = null;
StackTraceElement[] eStack = null;
if (path != null) {
	try {
		if ("samba".equals(method)) {
			if (loginUser == null || loginUser.isEmpty()) {
				fsmb = openPathSamba(path);
			} else {
				fsmb = openPathSamba(path, loginUser, loginPassword);
			}
		} else {
			f = openPathNative(path);
		}
	} catch (Exception e) {
		e.printStackTrace();
		eMsg = e.getMessage();
		eStack = e.getStackTrace();
	}
}

%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Samba Config and Testing</title>
</head>
<body>
	<h2>List file</h2>
	<form name="form1" action="samba.jsp" method="post">
		<table border="1">
			<tr>
				<td>Get File Method</td>
				<td><div><input type="radio" name="method" value="native" <%=!"samba".equals(method) ? "checked" : "" %>>Native</div>
  					<div><input type="radio" name="method" value="samba" <%="samba".equals(method) ? "checked" : "" %>>Samba</div>
  				</td>
			</tr>
			<tr>
				<td>Samba Login User<br />(Leave blank to use system default user: <%=systemDefaultLoginUser %>)</td>
				<td><input type="text" name="loginUser" size="50"/><br /><%=loginUser == null ? "" : loginUser %></td>
			</tr>
			<tr>
				<td>Samba Login Password</td>
				<td><input type="password" name="loginPassword" size="50"/></td>
			</tr>
			<tr>
				<td>Input Path</td>
				<td><input type="text" name="path" size="50"/><br /><%=path == null ? "" : path %></td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="submit" name="go">Go</button>
				</td>
			</tr>
		</table>
	</form>
	<div>Result:</div>
	<table border="1">
		<tr>
			<td valign="top">Path param</td>
			<td><%=path %></td>
		</tr>
<% if ("samba".equals(method)) { %>
		<tr>
			<td valign="top">SmbFile path</td>
			<td><%=fsmb == null ? "file object is null" : fsmb.getPath() %>
			</td>
		</tr>
	<% if (fsmb != null) { %>
		<tr>
			<td valign="top">isDirectory</td>
			<td>
				<% try { %>
				<%=fsmb.isDirectory() %><br />
				<%
					String[] nameList = fsmb.list();
				%>
				<br />List size: <%=(nameList == null ? "empty" : nameList.length) %>
				<%
					if (nameList != null) {
						for (String name : nameList) {
				%>
				<br /> <%=name %>
				<%
						}
					}
				%>
				<% } catch (SmbException smbE) { %>
					<%=smbE.getMessage() %>
				<div>
					<% 
						StackTraceElement[] smbEStack = smbE.getStackTrace();
						if (smbE.getStackTrace() != null) {
							for (StackTraceElement ste : smbEStack) {
					%>
						<%="at " + ste.getMethodName() + "(" + ste.getClassName() + ":" + ste.getLineNumber() + ")" %><br />
					<%
							}
						}
						
					%>
				</div>
				<% } %>
			</td>
		</tr>
		<tr>
			<td>isFile</td>
			<td>
				<% try { %>
				<%=fsmb.isFile() %><br />
				<% } catch (SmbException smbE) { %>
				<%=smbE.getMessage() %>
				<div>
					<% 
						StackTraceElement[] smbEStack = smbE.getStackTrace();
						if (smbE.getStackTrace() != null) {
							for (StackTraceElement ste : smbEStack) {
					%>
						<%="at " + ste.getMethodName() + "(" + ste.getClassName() + ":" + ste.getLineNumber() + ")" %><br />
					<%
							}
						}
						
					%>
				</div>
				<% } %>
			</td>
		</tr>
	<% } %>		
<% } else { %>
		<tr>
			<td valign="top">File object</td>
			<td><%=f %></td>
		</tr>
		<tr>
			<td valign="top">Exception</td>
			<td>
				<div><%=eMsg == null ? "" : eMsg %></div>
				<div><% 
						if (eStack != null) {
							for (StackTraceElement ste : eStack) {
					%>
						<%="at " + ste.getMethodName() + "(" + ste.getClassName() + ":" + ste.getLineNumber() + ")" %><br />
					<%
								// at java.util.concurrent.FutureTask$Sync.innerRun(FutureTask.java:315)
							}
						}
						
					%></div>
			</td>
		</tr>
	<% if (f != null) { %>
		<tr>
			<td valign="top">getPath</td>
			<td><%=f.getPath() %></td>
		</tr>
		<tr>
			<td valign="top">isDirectory</td>
			<td><%=f.isDirectory() %>
				<%
					String[] nameList = f.list();
				%>
				<br />List size: <%=(nameList == null ? "empty" : nameList.length) %>
				<%
					if (nameList != null) {
						for (String name : nameList) {
				%>
				<br /> <%=name %>
				<%
						}
					}
				%>
			</td>
		</tr>
		<tr>
			<td>isFile</td>
			<td><%=f.isFile() %></td>
		</tr>
	<% } %>
<% }%>	
	</table>

</body>
</html>