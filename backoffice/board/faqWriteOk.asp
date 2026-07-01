<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "support" : subMenuCode = "sub01" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim strLocation,Page
Dim Idx,BoardSort,Sort,Title,Content,AlertTag
Dim ObjCmd
Dim serDate1, serDate2, seritem, serStr, pageSize

langmode = Request("langmode")
serboardsort = Request("serboardsort")
sersubsort = Request("sersubsort")
serDate1 = Request("serDate1")
serDate2 = Request("serDate2")
pageSize = Request("PageSize")
seritem = Request("seritem")
serStr = Request("serStr")

Page=Request("page")
BoardSort=Request("BoardSort")
Title=Trim(Request("title"))
Content = Replace(Request("content"),"http://"&Request.Servervariables("Server_name")&"/","/")
Idx=Request("idx")
Sort=Request("sort")
isDisplay=Request("isDisplay")
subSort=Request("subSort")
edNonce = uf_getRequestProc(Request("edNonce"),"char","","")

IF BoardSort<>1 Then subSort=0

IF Sort="edit" Then
	AlertTag="수정"
	Sql="Update faq Set edNonce=?, langmode=?, BoardSort=?, Title=?,Content=?,isdisplay=?, subsort=? Where idx="&idx
Else
	AlertTag="등록"
	Sql="INSERT INTO faq(edNonce, langmode,BoardSort,Title,Content,isdisplay,subsort) VALUES(?, ?, ?, ?, ?, ?, ?)"
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, edNonce)
	.Parameters.Append .CreateParameter("@langmode", adTinyInt, adParamInput, 1, SpaceToZero(langmode))
	.Parameters.Append .CreateParameter("@BoardSort", adTinyInt, adParamInput, 1, SpaceToZero(BoardSort))
	.Parameters.Append .CreateParameter("@title", adVarWChar, adParamInput, 200, title)
	.Parameters.Append .CreateParameter("@content", adVarWChar, adParamInput, 2147483647, content)
	.Parameters.Append .CreateParameter("@isdisplay", adTinyInt, adParamInput, 1, SpaceToZero(isdisplay))
	.Parameters.Append .CreateParameter("@subsort", adTinyInt, adParamInput, 1, SpaceToZero(subsort))
	.Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

'###### 에디터 ID 등록처리 ##########
Call edNonceReg(edNonce)
'###### 에디터 ID 등록처리 ##########

DBcon.Close
Set DBcon=Nothing

strLocation="Faqlist.asp?page="&Page&"&langmode="&langmode&"&serboardsort="&serboardsort&"&sersubsort="&sersubsort&"&serDate1="&serDate1&"&serDate2="&serDate2&"&seritem="&seritem&"&pageSize="&pageSize&"&serStr="&serStr
Response.Write ExecJavaAlert("게시물이 "&AlertTag&"되었습니다.",2)
%>