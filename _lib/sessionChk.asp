<%
IF Session("useridx")="" Then
'	Response.Write "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
'	Response.Write "<!--"&Vbcrlf
'	Response.Write "alert('로그인이 필요한 페이지 입니다.\n로그인 페이지로 이동합니다.');"&Vbcrlf
'	Response.Write "location.href='/member/login.asp?returnURL="&HK_returnURL&"';"&Vbcrlf
'	Response.Write "//-->"&Vbcrlf
'	Response.Write "</SCRIPT>"&Vbcrlf
	Response.Redirect GB_RootFld&"member/login.asp?returnURL="&HK_returnURL
	Response.End
End IF
%>