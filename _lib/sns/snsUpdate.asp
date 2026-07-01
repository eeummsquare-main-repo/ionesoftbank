<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
sort = uf_getRequest(Request("sort"), "char", "", "connect")
sns = uf_getRequest(Request("sns"), "char", "", "")
snsID = uf_getRequest(Request("snsID"), "char", "", "")

IF sort="connect" Then
	IF sns="" Or snsID="" Or Session("useridx")="" Then
		Response.Write "Fail"
		Response.END
	End IF
Else
	IF sns="" Or Session("useridx")="" Then
		Response.Write "Fail"
		Response.END
	End IF
End IF

IF sns="naver" Then
	Sql = "UPDATE members Set naverAuthKey='"&snsID&"' Where idx="&Session("useridx")
ElseIF sns="kakao" Then
	Sql = "UPDATE members Set kakaoAuthKey='"&snsID&"' Where idx="&Session("useridx")
End IF
DBcon.Execute(Sql)

DBcon.Close
Set DBcon = Nothing

Response.Write "success"
%>