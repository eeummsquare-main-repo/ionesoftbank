<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
langmode = uf_getRequest(Request("langmode"), "int", "1", "0")
topMenuCode = "bbs" : subMenuCode = "bbs03"
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim ErrorRMsg : ErrorRMsg = ""

'=====form 전송을 위한 변수 셋팅============================
regdiv = uf_getRequest(Request("regdiv"), "int", "2", "0")
PageLink = "index.asp"
PageStr = "langmode="&langmode&"&regdiv="& regdiv
'=====form 전송을 위한 변수 셋팅============================

DBCon.BEGINTRANS

Sql = "DELETE organizationAdmin WHERE LANGMODE="&LANGMODE&" AND REGDIV="&regdiv
DBcon.Execute(Sql)

For i=1 To Request("Title").Count()
	Title = uf_getRequestProc(Request("Title")(i), "char", "100", "")
	Note1 = uf_getRequestProc(Request("Note1")(i), "char", "200", "")
	Note2 = uf_getRequestProc(Request("Note2")(i), "char", "200", "")
	Note3 = uf_getRequestProc(Request("Note3")(i), "char", "200", "")
	Note4 = uf_getRequestProc(Request("Note4")(i), "char", "200", "")
	Note5 = uf_getRequestProc(Request("Note5")(i), "char", "200", "")
	Note6 = uf_getRequestProc(Request("Note6")(i), "char", "200", "")

	listNum = 0
	IF Title<>"" OR Note1<>"" OR Note2<>"" OR Note3<>"" OR Note4<>"" OR Note5<>"" OR Note6<>"" Then
		Sql = "INSERT INTO organizationAdmin(LANGMODE, REGDIV, Title, Note1, Note2, Note3, Note4, Note5, Note6, LISTNUM) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection = DBcon
			.CommandType = adCmdText
			.CommandText = Sql

			.Parameters.Append .CreateParameter("@Par", adInteger, adParamInput, 4, LANGMODE)
			.Parameters.Append .CreateParameter("@Par", adInteger, adParamInput, 4, REGDIV)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, Title)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, Note1)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, Note2)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, Note3)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, Note4)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, Note5)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, Note6)
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