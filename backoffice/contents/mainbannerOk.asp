<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "banner" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Server.ScriptTimeOut=7200
Set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/mainbanner/")

Dim langTitle, langmode
langmode=UploadForm("langmode")
Call getLangModeTitle(langmode)

title=UploadForm("title")

linkurlBtnNm=UploadForm("linkurlBtnNm")
linkurl=UploadForm("linkurl")
linkurlNewWin = uf_getRequestProc(UploadForm("linkurlNewWin"), "int", "1", "0")

linkurlBtnNm1=UploadForm("linkurlBtnNm1")
linkurl1=UploadForm("linkurl1")
linkurlNewWin1 = uf_getRequestProc(UploadForm("linkurlNewWin1"), "int", "1", "0")

vodlinkurl=UploadForm("vodlinkurl")
filevodlinkurl=UploadForm("filevodlinkurl")

Bansort=UploadForm("Bansort")
thumbContent=UploadForm("thumbContent")

Idx=UploadForm("idx")
Sort=UploadForm("sort")

StartDate = uf_getRequestProc(Replace(UploadForm("sDate"),"-",""), "char", "8", "")
EndDate = uf_getRequestProc(Replace(UploadForm("eDate"),"-",""), "char", "8", "")
sHour = addZero(uf_getRequestProc(UploadForm("sHour"), "int", "23", "0"))
eHour = addZero(uf_getRequestProc(UploadForm("eHour"), "int", "23", "0"))
sMinute = addZero(uf_getRequestProc(UploadForm("sMinute"), "int", "59", "0"))
eMinute = addZero(uf_getRequestProc(UploadForm("eMinute"), "int", "59", "0"))

note1 = uf_getRequestProc(UploadForm("note1"), "char", "1000", "")
note2 = uf_getRequestProc(UploadForm("note2"), "char", "1000", "")
note3 = uf_getRequestProc(UploadForm("note3"), "char", "1000", "")

titleColor = uf_getRequestProc(UploadForm("titleColor"), "char", "10", "")
color1 = uf_getRequestProc(UploadForm("color1"), "char", "10", "")
color2 = uf_getRequestProc(UploadForm("color2"), "char", "10", "")
color3 = uf_getRequestProc(UploadForm("color3"), "char", "10", "")
color4 = uf_getRequestProc(UploadForm("color4"), "char", "10", "")
bgColor = uf_getRequestProc(UploadForm("bgColor"), "char", "10", "")

IF StartDate<>"" AND EndDate<>"" Then
	sDate = StartDate & sHour & sMinute
	eDate = EndDate & eHour & eMinute
End IF

isDisplay = uf_getRequest(UploadForm("isDisplay"),"int","1","1")

Dim Filename() : ReDim Filename(2)	

For i=1 To UploadForm("files").count
	ReDim Preserve Filename(i+1)
	Filename(i) = UploadForm("filename")(i)
	filedelchk = uf_getRequestProc(UploadForm("filedelchk")(i), "int", "", "0")

	IF filedelchk="1" And Filename(i)<>"" Then
		ImgDelete Filename(i), UploadForm.DefaultPath
		ImgDelete getImageThumbFilename(Filename(i)), UploadForm.DefaultPath
	End IF

	IF filedelchk="1" Then 
		IF UploadForm("files")(i)<>"" Then 
			Filename(i)=ImgSaves(UploadForm("files")(i),uploadform.defaultpath,51200000)
			IF Filename(i)=False Then Result=1

			IF Result=1 Then
				Set UploadForm=Nothing
				DBcon.Close
				Set DBcon=Nothing
				Response.Write ExecJavaAlert("업로드 허용용량(50M)을 초과하여 업로드를 실패하였습니다.",0)
				Response.End
			Else
				ThumbSaves 500,500,UploadForm("files")(i),uploadform.DefaultPath,Filename(i), "thumbs"
			End IF
		Else
			Filename(i)=""
		End IF
	End IF
Next

IF Sort="edit" Then
	Sql="Update mainbannerAdmin Set isDisplay=?, langmode=?, sDate=?, eDate=?, note1=?, note2=?, note3=?, bansort=?, title=?, filenames=?, filenames1=?, linkurlBtnNm=?, linkurl=?, linkurlNewWin=?, linkurlBtnNm1=?, linkurl1=?, linkurlNewWin1=?, vodlinkurl=?, filevodlinkurl=?, thumbContent=?, titleColor=?, color1=?, color2=?, color3=?, color4=?, bgColor=? Where idx="&idx
Else
	Sql="Insert INTO mainbannerAdmin(isDisplay, langmode, sDate, eDate, note1, note2, note3, bansort, title, filenames, filenames1, linkurlBtnNm, linkurl, linkurlNewWin, linkurlBtnNm1, linkurl1, linkurlNewWin1, vodlinkurl, filevodlinkurl, thumbContent, titleColor, color1, color2, color3, color4, bgColor) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@isDisplay", adTinyint, adParamInput, 1, isDisplay)
	.Parameters.Append .CreateParameter("@langmode", adTinyint, adParamInput, 1, langmode)
	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 12, sDate)
	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 12, eDate)
	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 400, note1)
	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 200, note2)
	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 200, note3)
	.Parameters.Append .CreateParameter("@bansort", adBigint, adParamInput, 8, bansort)
	.Parameters.Append .CreateParameter("@title", adVarWChar, adParamInput, 100, title)
	.Parameters.Append .CreateParameter("@Filenames", adVarWChar, adParamInput, 100, Filename(1))
	.Parameters.Append .CreateParameter("@Filenames", adVarWChar, adParamInput, 100, Filename(2))
	
	.Parameters.Append .CreateParameter("@linkurl", adVarWChar, adParamInput, 200, linkurlBtnNm)
	.Parameters.Append .CreateParameter("@linkurl", adVarWChar, adParamInput, 2000, linkurl)
	.Parameters.Append .CreateParameter("@linkurlNewWin", adTinyint, adParamInput, 1, linkurlNewWin)
	.Parameters.Append .CreateParameter("@linkurl", adVarWChar, adParamInput, 200, linkurlBtnNm1)
	.Parameters.Append .CreateParameter("@linkurl", adVarWChar, adParamInput, 2000, linkurl1)
	.Parameters.Append .CreateParameter("@linkurlNewWin", adTinyint, adParamInput, 1, linkurlNewWin1)
	
	.Parameters.Append .CreateParameter("@vodlinkurl", adVarWChar, adParamInput, 200, vodlinkurl)
	.Parameters.Append .CreateParameter("@vodlinkurl", adVarWChar, adParamInput, 200, filevodlinkurl)
	.Parameters.Append .CreateParameter("@thumbContent", adVarWchar, adParamInput, 2147483647, thumbContent)

	.Parameters.Append .CreateParameter("@PAR", adVarWChar, adParamInput, 10, titleColor)
	.Parameters.Append .CreateParameter("@PAR", adVarWChar, adParamInput, 10, color1)
	.Parameters.Append .CreateParameter("@PAR", adVarWChar, adParamInput, 10, color2)
	.Parameters.Append .CreateParameter("@PAR", adVarWChar, adParamInput, 10, color3)
	.Parameters.Append .CreateParameter("@PAR", adVarWChar, adParamInput, 10, color4)
	.Parameters.Append .CreateParameter("@PAR", adVarWChar, adParamInput, 10, bgColor)
	.Execute,,adExecuteNoRecords
End With

Set objCmd = Nothing
DBcon.Close
Set DBcon=Nothing

IF Sort="edit" Then
	strLocation="mainbanner.asp?langmode="&langmode&"&Bansort="&Bansort
	Response.Write ExecJavaAlert("게시물이 수정 되었습니다.",2)
Else
	strLocation="mainbanner.asp?langmode="&langmode&"&Bansort="&Bansort
	Response.Write ExecJavaAlert("게시물이 추가 되었습니다.",2)
End IF
%>