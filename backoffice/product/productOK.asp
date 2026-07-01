<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Server.ScriptTimeOut=7200
set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/product/")

langmode = uf_getRequest(UploadForm("langmode"),"int","3","0")

'=====form 전송을 위한 변수 셋팅============================
Page = uf_getRequest(UploadForm("Page"),"int","","")
serSelCate = uf_getRequest(UploadForm("serSelCate"),"int","1","")
sercatecode = uf_getRequest(UploadForm("sercatecode"),"char","50","")
searchOB = uf_getRequest(UploadForm("searchOB"),"int","3","")
seritemstat = uf_getRequest(UploadForm("seritemstat"),"int","1","")
serSellYn = uf_getRequest(UploadForm("serSellYn"),"int","1","")
searchStr = uf_getRequest(UploadForm("searchStr"),"char","","")
sercatecode1 = uf_getRequest(UploadForm("sercatecode1"),"char","","")
sercatecode2 = uf_getRequest(UploadForm("sercatecode2"),"char","","")
sercatecode3 = uf_getRequest(UploadForm("sercatecode3"),"char","","")

PageStr="langmode="&langmode&"&serSelCate="&serSelCate&"&sercatecode1="&sercatecode1&"&sercatecode2="&sercatecode2&"&sercatecode3="&sercatecode3&"&sercatecode="&sercatecode&"&searchOB="&searchOB&"&seritemstat="&seritemstat&"&serSellYn="&serSellYn&"&searchStr="&searchStr
'=====form 전송을 위한 변수 셋팅============================

Mode=UploadForm("mode")

display=UploadForm("display")
itemname=UploadForm("itemname")

Note1=UploadForm("Note1")
Note2=UploadForm("Note2")
Note3=UploadForm("Note3")
Note4=UploadForm("Note4")
Note5=UploadForm("Note5")
Note6=UploadForm("Note6")
Note7=UploadForm("Note7")

Idx=UploadForm("Idx")

Dim FileDel_Chk(7),FileName(7)
FileDel_Chk(0)=UploadForm("FileDel_Chk")
FileDel_Chk(1)=UploadForm("FileDel_Chk1")
FileDel_Chk(2)=UploadForm("FileDel_Chk2")
FileDel_Chk(3)=UploadForm("FileDel_Chk3")
FileDel_Chk(4)=UploadForm("FileDel_Chk4")
FileDel_Chk(5)=UploadForm("FileDel_Chk5")
FileDel_Chk(6)=UploadForm("FileDel_Chk6")
FileDel_Chk(7)=UploadForm("FileDel_Chk7")
FileName(0)=UploadForm("filename")
FileName(1)=UploadForm("filename1")
FileName(2)=UploadForm("filename2")
FileName(3)=UploadForm("filename3")
FileName(4)=UploadForm("filename4")
FileName(5)=UploadForm("filename5")
FileName(6)=UploadForm("filename6")
FileName(7)=UploadForm("filename7")

thumbContent = UploadForm("thumbContent")

mainCatecode = uf_getRequest(UploadForm("mainCatecode"),"char","","")
selCatecode  = uf_getRequest(UploadForm("selCatecode"),"char","","")
brandidx = uf_getRequest(UploadForm("brandidx"),"int","",null)

Content = Replace(UploadForm("content"),"http://"&Request.Servervariables("Server_name")&"/","/")

Price=uf_getRequestProc(UploadForm("Price"), "int", "", "0")

pricesort=spaceToZero(UploadForm("pricesort"))
txtNote1=UploadForm("txtNote1")
txtNote2=UploadForm("txtNote2")
isFreeAS=UploadForm("isFreeAS")
affDiscount=UploadForm("affDiscount")

edNonce = uf_getRequestProc(UploadForm("edNonce"),"char","","")

IF Mode<>"edit" Then Idx=0

For i=1 To UploadForm("files").count
	IF FileDel_Chk(i-1)<>"" And FileName(i-1)<>"" Then
		ImgDelete FileName(i-1),UploadForm.DefaultPath
		ImgDelete getImageThumbFilename(FileName(i-1)),UploadForm.DefaultPath
	End IF

	IF FileDel_Chk(i-1)<>"" Or Mode="" Then
		IF UploadForm("files")(i)<>"" Then
			FileName(i-1)=ImgSaves(UploadForm("files")(i),uploadform.defaultpath,30720000)
			IF FileName(i-1)=False Then Result=1

			IF Result=1 Then
				Set UploadForm=Nothing
				DBcon.Close
				Set DBcon=Nothing
				Response.Write ExecJavaAlert("업로드 허용용량(30M)을 초과하여 업로드를 실패하였습니다.",0)
				Response.End
			End IF
		Else
			FileName(i-1)=""
		End IF
	End IF
Next

'On Error Resume Next
DBcon.BeginTrans

	SET Cmd = CreateCommand(DBCON,"SAp_ItemProc",adCmdStoredProc)
	With Cmd
		.Parameters.Append CreateInputParameter("@Idx",adBigint,8,Idx)
		.Parameters.Append CreateInputParameter("@langmode",adTinyint,1,langmode)
		.Parameters.Append CreateInputParameter("@Mode",adVarchar,10,Mode)
		.Parameters.Append CreateInputParameter("@DisPlay",adTinyint,1,DisPlay)
		.Parameters.Append CreateInputParameter("@brandidx", adBigint, 8, brandidx)
		.Parameters.Append CreateInputParameter("@ItemName",adVarWchar,200,ItemName)
		.Parameters.Append CreateInputParameter("@Note1",adVarWchar,100,Note1)
		.Parameters.Append CreateInputParameter("@Note2",adVarWchar,100,Note2)
		.Parameters.Append CreateInputParameter("@Note3",adVarWchar,100,Note3)
		.Parameters.Append CreateInputParameter("@Note4",adVarWchar,100,Note4)
		.Parameters.Append CreateInputParameter("@Note5",adVarWchar,100,Note5)
		.Parameters.Append CreateInputParameter("@Note6",adVarWchar,100,Note6)
		.Parameters.Append CreateInputParameter("@Price",adInteger,4,Price)
		.Parameters.Append CreateInputParameter("@ListImg",adVarWchar,100,FileName(0))
		.Parameters.Append CreateInputParameter("@FileName1",adVarWchar,100,FileName(1))
		.Parameters.Append CreateInputParameter("@FileName2",adVarWchar,100,FileName(2))
		.Parameters.Append CreateInputParameter("@FileName3",adVarWchar,100,FileName(3))
		.Parameters.Append CreateInputParameter("@FileName4",adVarWchar,100,FileName(4))
		.Parameters.Append CreateInputParameter("@FileName5",adVarWchar,100,FileName(5))
		.Parameters.Append CreateInputParameter("@FileName6",adVarWchar,100,FileName(6))
		.Parameters.Append CreateInputParameter("@FileName7",adVarWchar,100,FileName(7))
		.Parameters.Append CreateInputParameter("@thumbContent", adVarWchar, 2147483647, thumbContent)
		.Parameters.Append CreateInputParameter("@content", adVarWchar, 2147483647, content)

		.Parameters.Append CreateInputParameter("@pricesort",adTinyint,1,pricesort)
		.Parameters.Append CreateInputParameter("@txtNote1",adVarWchar,2147483647,txtNote1)
		.Parameters.Append CreateInputParameter("@txtNote2",adVarWchar,2147483647,txtNote2)
		.Parameters.Append CreateInputParameter("@isFreeAS",adTinyint,1,spaceToZero(isFreeAS))
		.Parameters.Append CreateInputParameter("@affDiscount",adVarWchar,50,affDiscount)
		.Parameters.Append CreateInputParameter("@Par", adVarWchar, 50, edNonce)

		.Parameters.Append CreateOutputParameter("@resultidx",adBigint,8)
		.Execute
	End With

	IF Mode<>"edit" Then idx=Cmd.Parameters("@resultidx").Value

	'====================제품 SPEC 작업===============================================
	IF Mode="edit" Then
		Sql = "DELETE productSpec WHERE itemidx="&idx
		DBcon.Execute(Sql)
	End IF

	For i=1 To UploadForm("ititle").count
		ititle = ReplaceNoHtml(uf_getRequestProc(UploadForm("ititle")(i),"char","",""))
		icontent = ReplaceNoHtml(uf_getRequestProc(UploadForm("icontent")(i),"char","",""))

		IF icontent<>"" OR ititle<>"" Then

			Sql="Insert INTO productSpec(itemidx, ititle, icontent) values(?,?,?)"
			Set objCmd = Server.CreateObject("ADODB.Command")
			With objCmd
				.ActiveConnection = DBcon
				.CommandType = adCmdText
				.CommandText = Sql

				.Parameters.Append .CreateParameter("@itemidx", adBigint, adParamInput, 8, idx)
				.Parameters.Append .CreateParameter("@ititle", adVarWChar, adParamInput, 400, ititle)
				.Parameters.Append .CreateParameter("@icontent", adVarWChar, adParamInput, 400, icontent)
				.Execute,,adExecuteNoRecords
			End With

		End IF
	Next
	'====================제품 SPEC 작업===============================================

	'====================제품 MODEL 작업===============================================
	IF Mode="edit" Then
		Sql = "DELETE productModel WHERE pidx="&idx
		DBcon.Execute(Sql)
	End IF

	For i=1 To UploadForm("mtitle").count
		mtitle = ReplaceNoHtml(uf_getRequestProc(UploadForm("mtitle")(i),"char","",""))
		mContent = uf_getRequestProc(UploadForm("mContent")(i),"char","","")

		IF mtitle<>"" Then
			Sql="Insert INTO productModel(pidx, mtitle, mContent) values(?,?,?)"
			Set objCmd = Server.CreateObject("ADODB.Command")
			With objCmd
				.ActiveConnection = DBcon
				.CommandType = adCmdText
				.CommandText = Sql

				.Parameters.Append .CreateParameter("@pidx", adBigint, adParamInput, 8, idx)
				.Parameters.Append .CreateParameter("@mtitle", adVarWChar, adParamInput, 400, mtitle)
				.Parameters.Append .CreateParameter("@mContent", adVarWChar, adParamInput, 2147483647, mContent)
				.Execute,,adExecuteNoRecords
			End With
		End IF
	Next
	'====================제품 MODEL 작업===============================================

	IF mainCatecode <> "" Then
		Sql = "SELECT * FROM productCategory WHERE pidx="&idx&" AND catecode='"&ReplaceEnSine(mainCatecode)&"' AND isMain=1"
		Set Rs = DBcon.Execute(Sql)
		IF Rs.Bof Or Rs.Eof Then
			Sql = "DELETE productCategory WHERE pidx="&idx&" AND isMain=1"
			DBcon.Execute Sql

			Sql = "INSERT INTO productCategory(pidx, catecode, isMain) VALUES(?,?,1)"
			Set objCmd = Server.CreateObject("ADODB.Command")
			With objCmd
				.ActiveConnection = DBcon
				.CommandType = adCmdText
				.CommandText = Sql

				.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, idx)
				.Parameters.Append .CreateParameter("@Par", adVarchar, adParamInput, 50, mainCatecode)
				.Execute,,adExecuteNoRecords
			End With
			Set objCmd = Nothing
		End IF
	End IF

	For i=1 To UploadForm("selCatecode").count
		Sql = "SELECT * FROM productCategory WHERE pidx="&idx&" AND catecode='"&ReplaceEnSine(UploadForm("selCatecode")(i))&"' AND isMain=0"
		Set Rs = DBcon.Execute(Sql)
		IF Rs.Bof Or Rs.Eof Then
			Sql = "INSERT INTO productCategory(pidx, catecode, isMain) VALUES(?,?,0)"
			Set objCmd = Server.CreateObject("ADODB.Command")
			With objCmd
				.ActiveConnection = DBcon
				.CommandType = adCmdText
				.CommandText = Sql

				.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, idx)
				.Parameters.Append .CreateParameter("@Par", adVarchar, adParamInput, 50, UploadForm("selCatecode")(i))
				.Execute,,adExecuteNoRecords
			End With
			Set objCmd = Nothing
		End IF
	Next

	IF UploadForm("selCatecode")="" Then
		Sql = "DELETE productCategory WHERE pidx="&idx&" AND isMain=0"
		DBcon.Execute Sql
	Else
		Sql = "DELETE productCategory WHERE pidx="&idx&" AND isMain=0 AND catecode NOT IN ("&UploadForm("selCatecode")&")"
		DBcon.Execute Sql
	End IF

IF CStr(Err.Number)<>"0" then
	ErrorYN = True
	DBcon.RollbackTrans()
Else
	DBcon.Committrans()
End IF

'###### 에디터 ID 등록처리 ##########
Call edNonceReg(edNonce)
'###### 에디터 ID 등록처리 ##########

Set Cmd=Nothing
Set uploadform=nothing
dbcon.close
Set dbcon=nothing

IF ErrorYN=True Then
	alertMsg="등록중 오류가 발생했습니다.\n등록정보를 확인해주세요."
	alertEditMsg="수정중 오류가 발생했습니다.\n등록정보를 확인해주세요."
	strLocation=""
Else
	alertMsg="제품이 등록되었습니다."
	alertEditMsg="제품정보가 수정되었습니다."
	strLocation="top.location.reload();"
End IF

IF Mode="edit" Then
	Response.Write ExecJavaAlert(alertEditMsg,3)
Else
	Response.Write ExecJavaAlert(alertMsg,3)
End IF
%>