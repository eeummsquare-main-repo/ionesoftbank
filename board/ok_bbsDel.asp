<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim UploadForm,strLocation
Dim Page,Search,searchStr,Idx,InputPwd,BBsCode,serboardsort
Dim pwd,useridx,Ref,ReLevel,AlertMsg,AdWrite,imgnames
Dim souchk : souchk=0
Dim ThumbFileName,tmpFileName

prepage=Request("prepage")
Page=Request("page")
seritemidx=Request("seritemidx")
serstoreidx=Request("serstoreidx")
serboardsort=Request("serboardsort")
Search=Request("Search")
searchStr=Request("searchStr")
pageSize=Request("pageSize")
idx=Request("idx")
BBsCode=Cint(Request("bbscode"))
inputPwd=Session("boardPass")
Session.Contents.Remove("boardPass")

Call HK_BBSSetup(BBsCode)

Sql="SELECT pwd,IsNull(UserIdx,0) As Useridx,Ref,ReLevel,AdWrite,imgnames FROM bbslist WHERE idx="&Idx
Rs=DBcon.Execute(Sql)

Pwd=Rs("pwd") : UserIdx=Rs("useridx")
Ref=Rs("Ref") : ReLevel=Rs("ReLevel") : AdWrite=Rs("AdWrite") : imgnames=Rs("imgnames")

IF AdWrite="False" Then
	IF inputPwd="" Then
		IF CStr(UserIdx)=CStr(Session("useridx")) THen souchk=souchk+1
		AlertMsg = Langpack_AuthErrorMsg
	Else
		IF inputPwd=Pwd THen souchk=souchk+1
		AlertMsg = Langpack_PassErrorMsg
	End IF
Else
	AlertMsg = Langpack_AuthErrorMsg
End IF

IF souchk=false Then
	Response.Write ExecJavaalert(AlertMsg,0)
	Response.End
End IF

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/board/")

IF imgnames<>"" Then
	ImgDelete imgnames,UploadForm.DefaultPath
	ImgDelete getImageThumbFilename(imgnames),UploadForm.DefaultPath
End IF

'=====================첨부파일 삭제======================
Sql="SELECT filenames FROM BBSData WHERE bidx="&idx
Set FileRs=DBcon.Execute(Sql)
IF Not(FileRs.Bof Or FileRs.Eof) Then
	Do Until FileRs.Eof
		If FileRs("filenames")<>""  Then ImgDelete FileRs("filenames"),UploadForm.DefaultPath
		FileRs.MoveNext()
	Loop
End IF
Sql="DELETE BBSData WHERE bidx="&idx
DBcon.Execute Sql
'========================================================

Sql="Select idx,ReLevel From bbslist Where Ref="&Ref&" AND ReLevel Like '"&ReLevel&"_'"
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Dim i

	Sql="DELETE bbslist WHERE idx="&Idx
	DBcon.Execute Sql

	For i=Len(ReLevel)-1 To i=1 step i-1
		Sql="Select idx From bbslist Where Ref="&Ref&" And ReLevel like '"&Left(ReLevel,i)&"%' AND DelYN<>1 AND idx<>"&IDx
		Set Rs=DBcon.Execute(Sql)

		IF Rs.Bof Or Rs.Eof Then
			Sql="Delete bbslist Where Ref="&Ref&" And ReLevel Like '"&Left(ReLevel,i)&"%'"
			DBcon.Execute Sql
		Else
			Exit For
		End IF
	Next
Else
	Sql="Update bbslist Set DelYN=1 Where idx="&Idx
	DBcon.Execute Sql
End IF

Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation=prepage&"?page="&Page&"&seritemidx="&seritemidx&"&serstoreidx="&serstoreidx&"&serboardsort="&serboardsort&"&Search="&Search&"&pageSize="&pageSize&"&searchStr="&searchStr

Response.Write ExecJavaAlert(Langpack_RemoveComMsg, 2)
%>