<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "intra" : subMenuCode = "intra01" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->

<!--#include virtual = _lib/json/JSON_2.0.4.asp-->
<!--#include virtual = _lib/json/JSON2.asp-->
<%
Dim retErrorMsg : retErrorMsg = ""

Server.ScriptTimeOut=7200
set uploadform = server.CreateObject("DEXT.FileUpload")
uploadform.AutoMakeFolder = True
uploadform.DefaultPath = Server.MapPath("/upload/")

procMode = uf_getRequestProc(uploadform("procMode"),"char","","")

IF procMode="ADD" Then
	data = uf_getRequestProc(uploadform("data"),"char","","")
	strYear = uf_getRequestProc(uploadform("year"),"int","","")

	Dim jsonData  : Set jsonData = JSON.parse(join(array(data)))

	ON ERROR RESUME NEXT
	idx = uf_getRequestProc(ChangeBlank(jsonData.id),"int","","")
	pMonth = uf_getRequestProc(ChangeBlank(jsonData.pMonth),"int","",null)
	pNo = uf_getRequestProc(ChangeBlank(jsonData.pNo),"int","",null)
	pDiv = uf_getRequestProc(ChangeBlank(jsonData.pDiv),"char","","")
	pNm = uf_getRequestProc(ChangeBlank(jsonData.pNm),"char","","")
	pOrder = uf_getRequestProc(ChangeBlank(jsonData.pOrder),"char","","")
	pFloor = uf_getRequestProc(ChangeBlank(jsonData.pFloor),"char","","")
	pArea = uf_getRequestProc(ChangeBlank(jsonData.pArea),"char","","")
	estAmount = uf_getRequestProc(ChangeBlank(jsonData.estAmount),"int","",null)
	setAmount = uf_getRequestProc(ChangeBlank(jsonData.setAmount),"int","",null)
	outAmount = uf_getRequestProc(ChangeBlank(jsonData.outAmount),"int","",null)
	outCompany = uf_getRequestProc(ChangeBlank(jsonData.outCompany),"char","","")
	coldate1 = uf_getRequestProc(ChangeBlank(jsonData.coldate1),"date","","")
	coldate2 = uf_getRequestProc(ChangeBlank(jsonData.coldate2),"date","","")
	coldate3 = uf_getRequestProc(ChangeBlank(jsonData.coldate3),"date","","")
	coldate4 = uf_getRequestProc(ChangeBlank(jsonData.coldate4),"date","","")
	coldate5 = uf_getRequestProc(ChangeBlank(jsonData.coldate5),"date","","")
	colamount1 = uf_getRequestProc(ChangeBlank(jsonData.colamount1),"int","",null)
	colamount2 = uf_getRequestProc(ChangeBlank(jsonData.colamount2),"int","",null)
	colamount3 = uf_getRequestProc(ChangeBlank(jsonData.colamount3),"int","",null)
	colamount4 = uf_getRequestProc(ChangeBlank(jsonData.colamount4),"int","",null)
	colamount5 = uf_getRequestProc(ChangeBlank(jsonData.colamount5),"int","",null)
	isReg = uf_getRequestProc(ChangeBlank(jsonData.isReg),"char","","")

	IF isReg="true" Then
		isReg="1"
	Else
		isReg="0"
	End IF
	ON ERROR GOTO 0

	IF idx="" OR strYear="" Then retErrorMsg = "잘못된 접근입니다."
ElseIF procMode="DELETE" Then
	idx = uf_getRequestProc(uploadform("id"),"int","","")
	strYear = uf_getRequestProc(uploadform("year"),"int","","")

	IF idx="" OR strYear="" Then retErrorMsg = "잘못된 접근입니다."
Else
	idx = uf_getRequestProc(uploadform("idx"),"int","","")
	setColumn = uf_getRequestProc(uploadform("setColumn"),"char","","")
	strYear = uf_getRequestProc(uploadform("year"),"int","","")

	IF idx="" OR strYear="" OR setColumn="" Then
		retErrorMsg = "잘못된 접근입니다."
	Else

		IF setColumn="pMonth" Then
			setVal = uf_getRequestProc(uploadform("setVal"),"int","",null)
			IF Not(isNull(setVal)) Then
				IF (CLng(setVal)<1 OR CLng(setVal)>12) Then retErrorMsg = "월은 1~12까지 입력 가능합니다."
			End IF
		ElseIF setColumn="pNo" OR setColumn="estAmount" OR setColumn="setAmount" OR setColumn="outAmount" OR setColumn="colamount1" OR setColumn="colamount2" OR setColumn="colamount3" OR setColumn="colamount4" OR setColumn="colamount5" Then
			setVal = uf_getRequestProc(uploadform("setVal"),"int","",null)
		ElseIF setColumn="coldate1" OR setColumn="coldate2" OR setColumn="coldate3" OR setColumn="coldate4" OR setColumn="coldate5" Then
			setVal = uf_getRequestProc(uploadform("setVal"),"date","","")
		ElseIF setColumn="isReg" Then
			setVal = uf_getRequestProc(uploadform("setVal"),"char","","")

			IF setVal="true" Then
				setVal="1"
			Else
				setVal="0"
			End IF
		Else
			setVal = uf_getRequestProc(uploadform("setVal"),"char","","")
		End IF

		IF setVal = "undefined" Then setVal=null
	End IF
End IF

ON ERROR RESUME NEXT
DBCon.BEGINTRANS

IF retErrorMsg="" Then
	IF procMode="ADD" Then
		Sql = "INSERT INTO businessData(year, id, pMonth, pNo, pDiv, pNm, pOrder, pFloor, pArea, estAmount, setAmount, outAmount, outCompany ,coldate1 ,coldate2 ,coldate3 ,coldate4 ,coldate5 ,colamount1 ,colamount2 ,colamount3 ,colamount4 ,colamount5 ,isReg) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection = DBcon
			.CommandType = adCmdText
			.CommandText = Sql

			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, strYear)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, idx)
			.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, pMonth)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, pNo)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, pDiv)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, pNm)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, pOrder)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, pFloor)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, pArea)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, estAmount)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, setAmount)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, outAmount)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, outCompany)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 10, coldate1)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 10, coldate2)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 10, coldate3)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 10, coldate4)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 10, coldate5)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, colamount1)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, colamount2)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, colamount3)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, colamount4)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, colamount5)
			.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, isReg)
			.Execute,,adExecuteNoRecords
		End With
		Set objCmd = Nothing
	ElseIF procMode="DELETE" Then
		Sql = "DELETE businessData WHERE year=? AND id=?"
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection = DBcon
			.CommandType = adCmdText
			.CommandText = Sql

			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, strYear)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, idx)
			.Execute,,adExecuteNoRecords
		End With
		Set objCmd = Nothing
	Else
		Sql = "UPDATE businessData SET "&setColumn&"=? WHERE id=? AND year=?"
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection = DBcon
			.CommandType = adCmdText
			.CommandText = Sql

			IF setColumn="pMonth" OR setColumn="isReg" Then
				.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, setVal)
			ElseIF setColumn="pNo" OR setColumn="estAmount" OR setColumn="setAmount" OR setColumn="outAmount" OR setColumn="colamount1" OR setColumn="colamount2" OR setColumn="colamount3" OR setColumn="colamount4" OR setColumn="colamount5" Then
				.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, setVal)
			Else
				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, setVal)
			End IF
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, idx)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, strYear)
			.Execute,,adExecuteNoRecords
		End With
		Set objCmd = Nothing

	End IF
End IF

IF CStr(Err.Number)<>"0" Then retErrorMsg = "DB 처리중 오류가 발생했습니다."

ON ERROR GOTO 0

IF retErrorMsg="" Then
	DBcon.CommitTrans()
	Response.Write "OK|"
Else
	DBcon.RollbackTrans()
	Response.Write "ERROR|"&retErrorMsg
End IF

DBcon.Close()
Set DBcon = Nothing
%>