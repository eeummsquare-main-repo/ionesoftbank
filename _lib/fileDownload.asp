<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
idx = uf_getRequest(Request("idx"),"int","","")
filetb = uf_getRequest(Request("filetb"),"char","1","")

IF idx="" OR filetb="" Then
	Response.Write ExecJavaAlert("파일정보를 찾을수 없습니다.",0)
	Response.END
End IF

IF fileTB = "a" Then
	filepath = "approve" : Dim Filenames(10)
	index = uf_getRequest(Request("index"),"int","9","0")

	Sql = "SELECT filenames, filenames1, filenames2, filenames3, filenames4, filenames5, filenames6, filenames7, filenames8, filenames9, filenames10 FROM approveAdmin Where idx = "&idx
	Set Rs = DBcon.Execute(Sql)

	IF Not(Rs.Bof Or Rs.Eof) Then
		Filenames(0) =  Rs("filenames")
		Filenames(1) =  Rs("filenames1")
		Filenames(2) =  Rs("filenames2")
		Filenames(3) =  Rs("filenames3")
		Filenames(4) =  Rs("filenames4")
		Filenames(5) =  Rs("filenames5")
		Filenames(6) =  Rs("filenames6")
		Filenames(7) =  Rs("filenames7")
		Filenames(8) =  Rs("filenames8")
		Filenames(9) =  Rs("filenames9")
		Filenames(10) =  Rs("filenames10")

		Filename = Filenames(index)
	End IF
ElseIF fileTB = "t" Then
	filepath = "technology" : ReDim Filenames(10)
	index = uf_getRequest(Request("index"),"int","6","0")

	Sql = "SELECT filenames1, filenames2, filenames3, filenames4, filenames5, filenames6, filenames7 FROM technologyAdmin Where idx = "&idx
	Set Rs = DBcon.Execute(Sql)

	IF Not(Rs.Bof Or Rs.Eof) Then
		Filenames(0) =  Rs("filenames1")
		Filenames(1) =  Rs("filenames2")
		Filenames(2) =  Rs("filenames3")
		Filenames(3) =  Rs("filenames4")
		Filenames(4) =  Rs("filenames5")
		Filenames(5) =  Rs("filenames6")
		Filenames(6) =  Rs("filenames7")

		Filename = Filenames(index)
	End IF
Else
	IF fileTB = "c" Then
		dbTable = "certifyAdmin" : filepath = "certify/"&getLangFolder(langMode)
	ElseIF fileTB = "m" Then
		dbTable = "msdsAdmin" : filepath = "msds/"&getLangFolder(langMode)
	ElseIF fileTB = "r" Then
		dbTable = "referenceAdmin" : filepath = "reference/"&getLangFolder(langMode)
	ElseIF fileTB = "b" Then
		dbTable = "media" : filepath = "media"
	End IF

	IF dbTable<>"" Then
		Sql = "SELECT filenames FROM "&dbTable&" Where idx = "&idx
		Set Rs = DBcon.Execute(Sql)

		IF Not(Rs.Bof Or Rs.Eof) Then
			Filename =  Rs("filenames")

			Sql = "UPDATE "&dbTable&" SET readnum = readnum + 1 WHERE idx = "&idx
			DBCon.Execute Sql
		End IF
	End IF
End IF

IF Filename="" Then
	Response.Write ExecJavaAlert("파일정보를 찾을수 없습니다.",0)
	Response.END
Else
	'=================파일 다운로드==================
	Path = filepath
	DownFiles = Filename

	browser = Request.ServerVariables("HTTP_USER_AGENT")

	FILE_PATH = Server.MapPath("\upload\"&Path&"") & "\" & DownFiles

	IF InStr(LCase(browser),"chrome")=0 AND InStr(LCase(browser),"firefox")=0 Then
		Response.AddHeader "Content-Disposition","attachment;filename=" & Server.URLPathEncode(DownFiles)
	End IF

	set objFS =Server.CreateObject("Scripting.FileSystemObject") 
	set objF = objFS.GetFile(FILE_PATH) 
	Response.AddHeader "Content-Length", objF.Size 
	set objF = nothing 
	set objFS = nothing 

	Response.ContentType = "application/unknown"  
	Response.CacheControl = "public" 

	Set objDownload = Server.CreateObject("DEXT.FileDownload") 
	objDownload.Download FILE_PATH 
	Set objDownload = Nothing
	'===============================================
End IF
%>