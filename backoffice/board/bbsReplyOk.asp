<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim BBsCode

Server.ScriptTimeOut=7200
set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/board/")

BBsCode=UploadForm("bbscode")

'============ 게시판 권한/환경변수 셋팅======================
Call HK_BBSSetup(BBsCode)
topMenuCode = HK_BBS_TopMenuCode : subMenuCode = HK_BBS_SubMenuCode
'============================================================
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Writer,Page
Dim Idx,Title,Content,Ref,ReLevel
Dim ObjCmd,UploadForm,Result
Dim FileName(1),i
Dim strLocation
Dim PublicYN,Useridx,Pwd,BoardSort
Dim editorYN, status, MaxIdx, bIdx

'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serDate1, serdate2

page = uf_getRequest(UploadForm("page"),"int","","1")
pageSize = uf_getRequest(UploadForm("pageSize"),"int","","")
serstatus = uf_getRequest(UploadForm("serstatus"),"int","","")
serisDisplay = uf_getRequest(UploadForm("serisDisplay"),"int","","")
serismain = uf_getRequest(UploadForm("serismain"),"int","","")
serboardsort = uf_getRequest(UploadForm("serboardsort"),"int","","")
seritem = uf_getRequest(UploadForm("seritem"),"int","","")
SearchStr = uf_getRequest(UploadForm("searchStr"),"char","","")
serDate1 = uf_getRequest(UploadForm("serDate1"),"date","","")
serDate2 = uf_getRequest(UploadForm("serDate2"),"date","","")
serCate1=uf_getRequest(UploadForm("serCate1"),"char","","")
serCate2=uf_getRequest(UploadForm("serCate2"),"char","","")
serCate3=uf_getRequest(UploadForm("serCate3"),"char","","")
oSearchStr = UploadForm("searchstr")

PageLink="bbslist.asp"
PageStr="BBscode="&BBscode&"&pagesize="&PageSize&"&serstatus="&serstatus&"&serisDisplay="&serisDisplay&"&serismain="&serismain&"&serboardsort="&serboardsort&"&serDate1="&serDate1&"&serdate2="&serdate2&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)

IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" OR BBscode="5" OR BBscode="15" OR BBscode="25" Then
	IF serCate1<>"" Then PageStr = PageStr & "&serCate1="&serCate1
	IF serCate2<>"" Then PageStr = PageStr & "&serCate2="&serCate2
	IF serCate3<>"" Then PageStr = PageStr & "&serCate3="&serCate3
End IF
'=============================================

editorYN = uf_getRequestProc(UploadForm("editorYN"),"int","","0")
Writer = uf_getRequestProc(UploadForm("Writer"),"char","20","")
Title = uf_getRequestProc(UploadForm("title"),"char","200","")
edNonce = uf_getRequestProc(UploadForm("edNonce"),"char","","")

Content = UploadForm("content")

Idx = uf_getRequestProc(UploadForm("idx"),"int","","")
ref = uf_getRequestProc(UploadForm("ref"),"int","","")
ReLevel = uf_getRequestProc(UploadForm("ReLevel"),"char","","")

Sql="Select Top 1 PublicYN,Useridx,Pwd,BoardSort,status,artistidx,sortdate FROM BBsList Where Ref="&Ref&" AND ReLevel='A'"
Set Rs=DBcon.Execute(Sql)
PublicYN=Rs(0) : Useridx=Rs(1) : Pwd=Rs(2) : BoardSort=Rs(3) : status=Rs(4) : artistidx=Rs(5) : oSortdate = Rs(6)

Dim MaxReLevelRec,MaxReLevel
Sql="Select Top 1 ReLevel From BBsList Where ref="&Ref&" And ReLevel Like '"&ReLevel&"_' Order By ReLevel DESC"
Set MaxReLevelRec=DBcon.Execute(Sql)

IF MaxReLevelRec.Eof Then
	MaxReLevel = ReLevel&"A"
Else
	MaxReLevel = ReLevel&Chr(ASC(Right(MaxReLevelRec(0),1))+1)
End IF

Set MaxReLevelRec=Nothing

Sql="INSERT INTO bbsList(editorYN,status,BoardSort,writer,Title,Content,wip,regdate,boardidx,useridx,pwd,ref,reLevel,submit,adwrite,PublicYN,artistidx,sortdate, edNonce) "
Sql = Sql & "VALUES( ?, ?, ?, ?, ?, ?, ?, Getdate() ,?,?,?,?,?,1,1,?,?,?,?)"

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql
	
	.Parameters.Append .CreateParameter("@editorYN", adTinyint, adParamInput, 1, editorYN)
	.Parameters.Append .CreateParameter("@status", adTinyint, adParamInput, 1, spaceToZero(status))
	.Parameters.Append .CreateParameter("@BoardSort", adInteger, adParamInput, 4, BoardSort)
	.Parameters.Append .CreateParameter("@Writer", adVarWchar, adParamInput, 20, Writer)
	.Parameters.Append .CreateParameter("@title", adVarWchar, adParamInput, 100, title)
	.Parameters.Append .CreateParameter("@content", adVarWchar, adParamInput, 2147483647, content)
	.Parameters.Append .CreateParameter("@Wip", adVarChar, adParamInput, 50, WIP)
	.Parameters.Append .CreateParameter("@BoardIdx", adInteger, adParamInput, 4, BBsCode)
	.Parameters.Append .CreateParameter("@UserIdx", adBigint, adParamInput, 8, UserIdx)
	.Parameters.Append .CreateParameter("@Pwd", adVarWchar, adParamInput, 10, Pwd)
	.Parameters.Append .CreateParameter("@Ref", adBigint, adParamInput, 8, Ref)
	.Parameters.Append .CreateParameter("@ReLevel", adVarChar, adParamInput, 50, MaxReLevel)
	.Parameters.Append .CreateParameter("@PublicYN", adBoolean, adParamInput, 1, PublicYN)
	.Parameters.Append .CreateParameter("@artistidx", adBigint, adParamInput, 8, artistidx)
	.Parameters.Append .CreateParameter("@sortdate", adVarChar, adParamInput, 10, oSortdate)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, edNonce)
	
	.Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

Sql="Select Max(Idx) From BBsList"
MaxIdx=DBcon.Execute(Sql)
bIdx=MaxIdx(0)

'====================첨부파일 업로드 작업==========================================================
For i=1 To UploadForm("files").count
	IF UploadForm("files")(i)<>"" Then 
		Filenames=ImgSaves(UploadForm("files")(i),uploadform.defaultpath,30720000)
		IF Filenames=False Then Result=1

		IF Result=1 Then
			Set UploadForm=Nothing
			DBcon.Close
			Set DBcon=Nothing
			Response.Write ExecJavaAlert("업로드 허용용량(30M)을 초과하여 업로드를 실패하였습니다.",0)
			Response.End
		Else
			Sql="INSERT INTO BBSData(bidx,filenames,regdate) values("&bIdx&",'"&Filenames&"',getdate())"
			DBcon.Execute Sql
		End IF
	End IF
Next
'===============================================================================================

'###### 에디터 ID 등록처리 ##########
Call edNonceReg(edNonce)
'###### 에디터 ID 등록처리 ##########

Set Rs = Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="bbsView.asp?idx="&ref&"&page="&Page&"&"&PageStr
Response.Write ExecJavaAlert("답변이 등록 되었습니다.",2)
%>