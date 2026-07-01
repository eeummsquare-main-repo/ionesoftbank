<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "support" : subMenuCode = "sub08" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Server.ScriptTimeOut=7200
Set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/excel/")

IF UploadForm("files")<>"" Then 
	FileName=ImgSaves(UploadForm("files"),uploadform.defaultpath,512000000)
	IF FileName=False Then Result=1

	IF Result=1 Then
		Set UploadForm=Nothing
		DBcon.Close
		Set DBcon=Nothing
		Response.Write ExecJavaAlert("업로드 허용용량(500M)을 초과하여 업로드를 실패하였습니다.",0)
		Response.End
	End IF
Else
	FileName=""
End IF

IF FileName="" Then
	Response.Write ExecJavaAlert("업로드된 파일이 없습니다",0)
	Response.End
End IF

strFilePath = Server.MapPath("/upload/excel/")&"/"&FileName

Set XlsConn = Server.CreateObject("ADODB.Connection")
XlsConn.Open "PROVIDER=MICROSOFT.ACE.OLEDB.12.0;DATA SOURCE=" & strFilePath &";Mode=ReadWrite|Share Deny None; Extended Properties='Excel 12.0; HDR=YES;IMEX=1';Persist Security Info=False"

Set Rs = Server.CreateObject("ADODB.RecordSet")
xSQL = "SELECT * FROM [Sheet1$]"
Rs.Open xSQL, XlsConn, 1, 3

IF Not(Rs.Bof Or Rs.Eof) Then
	ExcelData=Rs.GetRows()
Else
	Rs.Close
	Set Rs=Nothing
	XlsConn.Close
	Set XlsConn=Nothing

	Response.Write ExecJavaAlert("엑셀정보를 읽을수 없습니다. 형식에 맞는 엑셀파일을 업로드 하셨는지 확인 후 다시 시도해주십시오.",0)
	Response.End
End IF

Rs.Close : Set Rs=Nothing
XlsConn.Close : Set XlsConn=Nothing

ON Error Resume Next
DBCon.BeginTrans

InsertCnt=0

For i=0 To UBound(ExcelData,2)
	listnum = 0
	isDisplay = uf_getRequestProc(changeBlank(ExcelData(0,i)),"int","1","0")
	title = uf_getRequestProc(changeBlank(ExcelData(1,i)),"char","100","")
	zipcode = uf_getRequestProc(changeBlank(ExcelData(2,i)),"char","5","")
	addr1 = uf_getRequestProc(changeBlank(ExcelData(3,i)),"char","100","")
	addr2 = uf_getRequestProc(changeBlank(ExcelData(4,i)),"char","100","")
	addr1_ji = uf_getRequestProc(changeBlank(ExcelData(5,i)),"char","100","")
	addr2_ji = uf_getRequestProc(changeBlank(ExcelData(6,i)),"char","100","")
	note1 = uf_getRequestProc(changeBlank(ExcelData(7,i)),"char","100","")
	note2 = uf_getRequestProc(changeBlank(ExcelData(8,i)),"char","100","")
	tel = uf_getRequestProc(changeBlank(ExcelData(9,i)),"char","1000","")

	IF title<>"" AND addr1<>"" Then
		Sql="INSERT INTO storeAdmin(isDisplay, regUseridx, regUserName, listnum, title, zipcode, addr1, addr2, addr1_ji, addr2_ji, note1, note2, tel) "
		Sql = Sql & "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection = DBcon
			.CommandType = adCmdText
			.CommandText = Sql

			.Parameters.Append .CreateParameter("@isDisplay", adTinyint, adParamInput, 1, isDisplay)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, Session("acountidx"))
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, Session("acountname"))
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, listnum)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, title)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 5, zipcode)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, addr1)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, addr2)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, addr1_ji)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, addr2_ji)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, note1)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, note2)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 1000, tel)
			.Execute,,adExecuteNoRecords
		End With
		Set objCmd = Nothing
		
		InsertCnt=InsertCnt+1
	End IF
Next

StrMsg="["&InsertCnt&"]건의 게시물이 등록되었습니다."

ImgDelete FileName,UploadForm.DefaultPath

IF DBCon.errors.count > 0 then
	DBCon.rollbackTrans
	Response.Write ExecJavaAlert("입력중 에러가 발생하였습니다.업데이트 내역이 없습니다.",0)
else
	'DBCon.rollbackTrans
	DBCon.commitTrans
	strLocation="top.location.reload();"
	Response.Write ExecJavaAlert(StrMsg,3)
end if

DBcon.Close
Set DBcon=Nothing
%>