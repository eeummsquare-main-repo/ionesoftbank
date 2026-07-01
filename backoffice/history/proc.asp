<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
langmode = uf_getRequest(Request("langmode"), "int", "1", "0")
topMenuCode = "company" : subMenuCode = "history"
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim ErrorRMsg : ErrorRMsg = ""

'=====form 전송을 위한 변수 셋팅============================
regdiv = uf_getRequest(Request("regdiv"), "int", "3", "0")
PageLink = "index.asp"
PageStr = "langmode="&langmode&"&regdiv="& regdiv
'=====form 전송을 위한 변수 셋팅============================

DBCon.BEGINTRANS

Sql = "DELETE historyAdmin WHERE LANGMODE="&LANGMODE&" AND REGDIV="&regdiv
DBcon.Execute(Sql)

For i=1 To Request("sYear").Count()
	sYear = uf_getRequestProc(Request("sYear")(i), "int", "", null)
	'sMonth = uf_getRequestProc(Request("sMonth")(i), "int", "", null)
	Title = uf_getRequestProc(Request("Title")(i), "char", "200", "")

	listNum = 0
	IF sYear<>"" OR sMonth<>"" OR Title<>"" Then

		Sql = "INSERT INTO historyAdmin(LANGMODE, REGDIV, SYEAR, SMONTH, TITLE, LISTNUM) VALUES(?, ?, ?, ?, ?, ?)"
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection = DBcon
			.CommandType = adCmdText
			.CommandText = Sql

			.Parameters.Append .CreateParameter("@Par", adInteger, adParamInput, 4, LANGMODE)
			.Parameters.Append .CreateParameter("@Par", adInteger, adParamInput, 4, REGDIV)
			.Parameters.Append .CreateParameter("@Par", adInteger, adParamInput, 4, sYear)
			.Parameters.Append .CreateParameter("@Par", adInteger, adParamInput, 4, sMonth)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, Title)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, listNum)
			.Execute,,adExecuteNoRecords
		End With

		listNum = CLng(listNum) + 1
	End IF
Next

DBCon.COMMITTRANS()

Set objCmd = Nothing

strLocation = PageLink&"?"&pageStr
Response.Write ExecJavaAlert("저장되었습니다.",2)
%>