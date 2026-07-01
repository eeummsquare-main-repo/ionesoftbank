<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "align" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%

Dim Selcodes,Special,Num,i,CateIdx,strLocation

SelCodes=Request("selcodes")
Special=Request("special")
Selcodes=Split(Selcodes,",")
CateIdx=Request("cateidx")
	
Num=1
For i=0 To Ubound(SelCodes)
	Sql="UPDATE productAlignTB SET mainidx="&Num&" WHERE mainsort='"&Special&"' AND itemidx="&SelCodes(i)
	DBcon.Execute Sql
	Num=Num+1
Next

Dbcon.Close
Set Dbcon=Nothing

strLocation="productAlign.asp?special="&Special&"&cateidx="&CateIdx
Response.Write ExecJavaAlert("선택코너의 게시물진열순서가 변경되었습니다.",2)
%>
