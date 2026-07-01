<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "align" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%

Dim Brcode,Special,Num,i,CateIdx,strLocation

Brcode=Request("brcode")
Special=Request("special")
CateIdx=Request("cateidx")
Brcode=Split(Brcode,", ")

Rs=DBcon.Execute("SELECT IsNull(Max(mainidx),0) FROM productAlignTB WHERE mainsort='"&Special&"'")
Num=Rs(0)+1

For i=0 To Ubound(Brcode)
	Sql="SELECT Top 1 * FROM productAlignTB Where itemidx="&Brcode(i)&" AND mainsort='"&Special&"'"
	Set Rs=DBcon.Execute(Sql)
	IF Rs.Bof Or Rs.Eof Then
		Num=Num+1
		DBcon.Execute ("INSERT INTO productAlignTB(mainsort,mainidx,itemidx) values('"&Special&"',"&Num&","&Brcode(i)&")")
	End IF
Next

DBcon.Close
Set DBcon=Nothing

strLocation="productAlign.asp?special="&Special&"&cateidx="&CateIdx
Response.Write ExecJavaAlert("선택하신 게시물이 선택코너로 진열되었습니다.",2)
%>