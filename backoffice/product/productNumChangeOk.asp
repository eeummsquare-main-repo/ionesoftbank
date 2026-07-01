<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "pnum" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Selcodes,Num,i,CateIdx,strLocation

langmode = uf_getRequest(Request("langmode"),"int","1","0")
sercatecode1 = uf_getRequest(Request("sercatecode1"),"char","","")
sercatecode2 = uf_getRequest(Request("sercatecode2"),"char","","")
sercatecode3 = uf_getRequest(Request("sercatecode3"),"char","","")

IF serCatecode3<>"" Then
	serCatecode = sercatecode3
	strWhere = " AND catecode='"&serCatecode3&"'"
	OBColumn = "listnum"
ElseIF serCatecode2<>"" Then
	serCatecode = sercatecode2
	strWhere = " AND MiddleCode='"&serCatecode2&"'"
	OBColumn = "listnum2St"
ElseIF serCatecode1<>"" Then
	serCatecode = sercatecode1
	strWhere = " AND Topcode='"&serCatecode1&"'"
	OBColumn = "listnum1St"
End IF

For i=1 To Request("dbidx").Count
	pidx = Request("dbidx")(i)

	Sql="UPDATE productCategory SET "&OBColumn&"="&i&" WHERE idx IN ( SELECT pcidx FROM VIEW_Product WHERE langmode="&langmode&" "&strWhere&" ) AND pidx="&pidx
	DBcon.Execute Sql
Next

Dbcon.Close
Set Dbcon=Nothing

strLocation="productNumChange.asp?langmode="&langmode&"&sercatecode1="&sercatecode1&"&sercatecode2="&sercatecode2&"&sercatecode3="&sercatecode3
Response.Write ExecJavaAlert("제품 순서가 변경되었습니다.",2)
%>
