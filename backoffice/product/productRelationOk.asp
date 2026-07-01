<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
itemidx=uf_getRequestProc(Request("itemidx"), "int", "", "")

'=====form 전송을 위한 변수 셋팅============================
Page = uf_getRequest(Request("Page"),"int","","1")
seritemstat = uf_getRequest(Request("seritemstat"),"int","1","")
serSellYn = uf_getRequest(Request("serSellYn"),"int","1","")
searchStr = uf_getRequest(Request("searchStr"),"char","","")
sercatecode1 = uf_getRequest(Request("sercatecode1"),"char","","")
sercatecode2 = uf_getRequest(Request("sercatecode2"),"char","","")
sercatecode3 = uf_getRequest(Request("sercatecode3"),"char","","")

PageStr="langmode="&langmode&"&sercatecode1="&sercatecode1&"&sercatecode2="&sercatecode2&"&sercatecode3="&sercatecode3&"&seritemstat="&seritemstat&"&serSellYn="&serSellYn&"&searchStr="&searchStr
'=====form 전송을 위한 변수 셋팅============================

idx=uf_getRequestProc(Request("selidx"), "char", "", "")

arridx = Split(idx, ",")

For i =0 To Ubound(arridx)
	idx = uf_getRequestProc(arridx(i), "int", "", "")
	IF idx <> "" Then
		Sql = "SELECT Top 1 * FROM productRelation WHERE itemidx="&itemidx&" AND relationidx='"&idx&"'"
		Set Rs = DBcon.Execute(Sql)
		IF Rs.Bof Or Rs.Eof Then

			Sql="Insert INTO productRelation(itemidx, relationidx) values(?,?)"
			Set objCmd = Server.CreateObject("ADODB.Command")
			With objCmd
				.ActiveConnection = DBcon
				.CommandType = adCmdText
				.CommandText = Sql

				.Parameters.Append .CreateParameter("@par", adBigint, adParamInput, 8, itemidx)
				.Parameters.Append .CreateParameter("@par", adVarchar, adParamInput, 50, idx)
				.Execute,,adExecuteNoRecords
			End With

		End IF
	End IF
Next

Set objCmd = Nothing
DBcon.Close
Set DBcon=Nothing

Response.Write "complete"
%>