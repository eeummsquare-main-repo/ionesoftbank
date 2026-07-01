<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim BBsCode
Dim UploadForm

Server.ScriptTimeOut=7200
Set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/board/")

BBsCode = uf_getRequest(UploadForm("bbscode"),"int","","")

'============ 게시판 권한/환경변수 셋팅======================
Call HK_BBSSetup(BBsCode)
topMenuCode = HK_BBS_TopMenuCode : subMenuCode = HK_BBS_SubMenuCode
'============================================================
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim ObjCmd,Result,i
Dim strLocation, Cmd, Writer, Page, Topyn, imgName(0), imgDel_Chk(0), testFileName(3), testFileDel_Chk(3)
Dim Idx, Sort, Title, Content, AlertTag, BoardSort
Dim editorYN, startdate, enddate, note1, note2, note3, note4, status, PublicYN, VodUrl
Dim ref, Relevel
Dim Filenames

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

Idx = uf_getRequestProc(UploadForm("idx"),"int","","")
Sort = uf_getRequestProc(UploadForm("sort"),"char","","")
Topyn = uf_getRequestProc(UploadForm("topyn"),"int","1","0")
isimp = uf_getRequestProc(UploadForm("isimp"),"int","1","0")
isDisplay = uf_getRequestProc(UploadForm("isDisplay"),"int","1","0")
imgDel_Chk(0) = uf_getRequestProc(UploadForm("imgDel_Chk"),"char","","")
imgName(0) = uf_getRequestProc(UploadForm("imgname"),"char","","")

artistidx = uf_getRequestProc(UploadForm("artistidx"),"int","","0")
startdate = uf_getRequestProc(UploadForm("startdate"),"date","","")
enddate = uf_getRequestProc(UploadForm("enddate"),"date","","")

status = uf_getRequestProc(UploadForm("status"),"int","","0")	
publicYN = uf_getRequestProc(UploadForm("publicYN"),"int","","0")

editorYN = uf_getRequestProc(UploadForm("editorYN"),"int","","0")
BoardSort = uf_getRequestProc(UploadForm("BoardSort"),"int","",null)
ref = uf_getRequestProc(UploadForm("ref"),"int","","")
ReLevel = uf_getRequestProc(UploadForm("ReLevel"),"char","","")
Writer = uf_getRequestProc(UploadForm("Writer"),"char","100","")
Title = uf_getRequestProc(UploadForm("title"),"char","200","")
VodUrl = uf_getRequestProc(UploadForm("VodUrl"),"char","200","")
viewdate = uf_getRequestProc(UploadForm("viewdate"),"date","",Date())
thumbContent = uf_getRequestProc(UploadForm("thumbContent"),"char","","")
readnum = uf_getRequestProc(UploadForm("readnum"),"int","","0")	

Content = UploadForm("content")

Note1 = uf_getRequestProc(UploadForm("note1"),"char","","")
Note2 = uf_getRequestProc(UploadForm("note2"),"char","","")
Note3 = uf_getRequestProc(UploadForm("note3"),"char","","")
Note4 = uf_getRequestProc(UploadForm("note4"),"char","","")
Note5 = uf_getRequestProc(UploadForm("note5"),"char","","")
Note6 = uf_getRequestProc(UploadForm("note6"),"char","","")
Note7 = uf_getRequestProc(UploadForm("note7"),"char","","")
Note8 = uf_getRequestProc(UploadForm("note8"),"char","","")
Note9 = uf_getRequestProc(UploadForm("note9"),"char","","")
Note10 = uf_getRequestProc(UploadForm("note10"),"char","","")
Note11 = uf_getRequestProc(UploadForm("note11"),"char","","")
Note12 = uf_getRequestProc(UploadForm("note12"),"char","","")
note13 = uf_getRequestProc(UploadForm("note13"),"char","","")

newWin1 = uf_getRequestProc(UploadForm("newWin1"),"int","1","0")
newWin2 = uf_getRequestProc(UploadForm("newWin2"),"int","1","0")

linkurl = uf_getRequestProc(UploadForm("linkurl"),"char","","")
setYear = uf_getRequestProc(UploadForm("setYear"),"int","",null)

isMain = uf_getRequestProc(UploadForm("isMain"),"int","1","0")
CateCode = uf_getRequestProc(UploadForm("CateCode"),"char","","")
filteridx = uf_getRequestProc(Replace(UploadForm("filteridx"),", ",","),"char","","")

bdiv1 = uf_getRequestProc(UploadForm("bdiv1"),"int","","0")
bdiv2 = uf_getRequestProc(UploadForm("bdiv2"),"int","","0")

always = uf_getRequestProc(UploadForm("always"),"int","1","0")
deadline = uf_getRequestProc(UploadForm("deadline"),"int","1","0")

edNonce = uf_getRequestProc(UploadForm("edNonce"),"char","","")

cate1 = uf_getRequestProc(UploadForm("cate1"),"char","","")
cate2 = uf_getRequestProc(UploadForm("cate2"),"char","","")
cate3 = uf_getRequestProc(UploadForm("cate3"),"char","","")

Dim ThumbFileName,tmpFileName
For i=1 To UploadForm("imgfiles").count
	IF imgDel_Chk(i-1)<>"0" And imgName(i-1)<>"" Then
		ImgDelete imgName(i-1),UploadForm.DefaultPath
		ImgDelete getImageThumbFilename(imgName(i-1)),UploadForm.DefaultPath
	End IF

	IF imgDel_Chk(i-1)<>"0" Or Sort="" Then 
		IF UploadForm("imgfiles")(i)<>"" Then 
			imgName(i-1)=ImgSaves(UploadForm("imgfiles")(i),uploadform.defaultpath,30720000)
			IF imgName(i-1)=False Then Result=1

			IF Result=1 Then
				Set UploadForm=Nothing
				DBcon.Close
				Set DBcon=Nothing
				Response.Write ExecJavaAlert("업로드 허용용량(30M)을 초과하여 업로드를 실패하였습니다.",0)
				Response.End
			Else
				ThumbSaves 500 , 500 , UploadForm("imgfiles")(i) , uploadform.DefaultPath, imgName(i-1), "thumbs"
			End IF
		Else
			imgName(i-1)=""
		End IF
	End IF
Next

'=======시험관련 파일====================
testFileName(1)=UploadForm("testFilename1")
testFileDel_Chk(1)=UploadForm("testDel_Chk1")
testFileName(2)=UploadForm("testFilename2")
testFileDel_Chk(2)=UploadForm("testDel_Chk2")
testFileName(3)=UploadForm("testFilename3")
testFileDel_Chk(3)=UploadForm("testDel_Chk3")

For i=1 To UploadForm("testfiles").count
	IF testFileDel_Chk(i)<>"" And testFileName(i)<>"" Then
		ImgDelete testFileName(i),UploadForm.DefaultPath
	End IF

	IF testFileDel_Chk(i)<>"" Or Sort="" Then 
		IF UploadForm("testfiles")(i)<>"" Then 
			testFileName(i)=ImgSaves(UploadForm("testfiles")(i),uploadform.defaultpath,3072000000)
			IF testFileName(i)=False Then Result=1

			IF Result=1 Then
				Set UploadForm=Nothing
				DBcon.Close
				Set DBcon=Nothing
				Response.Write ExecJavaAlert("업로드 허용용량(3000M)을 초과하여 업로드를 실패하였습니다.",0)
				Response.End
			End IF
		Else
			testFileName(i)=""
		End IF
	End IF
Next
'=======================================

Dim FileUploadSuccess : FileUploadSuccess = True
Dim UploadComCnt : UploadComCnt = 0
Dim removeFileCnt : removeFileCnt = 0
Dim UploadComFile()	 : ReDim UploadComFile(UploadComCnt) 	'업로드 완료파일 배열
Dim removeFile() : ReDim removeFile(removeFileCnt)				'삭제될 파일 배열

'###### BEFORE & AFTER 파일 저장 #############
ON ERROR RESUME NEXT

bFilenames = "" : aFilenames = ""
For i=1 To UploadForm("bfiles").count
	bFileName = UploadForm("bFileName")(i)
	aFileName = UploadForm("aFileName")(i)

	IF UploadForm("bfiledelchk")(i)="1" Then
		IF bFileName<>"" Then
			ReDim Preserve removeFile(removeFileCnt)
			removeFile(removeFileCnt) = bFileName
			removeFileCnt = removeFileCnt + 1
		End IF

		IF UploadForm("bfiles")(i)="" Then
			bFileName = ""
		Else
			bFileName = ImgSaves(UploadForm("bfiles")(i),uploadform.defaultpath,3072000000)
			IF bFileName = False Then
				FileUploadSuccess = False
				Exit For
			Else
				ReDim Preserve UploadComFile(UploadComCnt)
				UploadComFile(UploadComCnt) = bFileName
				UploadComCnt = UploadComCnt + 1
			End IF
		End IF
	End IF

	IF UploadForm("afiledelchk")(i)="1" Then
		IF aFileName<>"" Then
			ReDim Preserve removeFile(removeFileCnt)
			removeFile(removeFileCnt) = aFileName
			removeFileCnt = removeFileCnt + 1
		End IF

		IF UploadForm("afiles")(i)="" Then
			aFileName = ""
		Else
			aFileName = ImgSaves(UploadForm("afiles")(i),uploadform.defaultpath,3072000000)
			IF aFileName = False Then
				FileUploadSuccess = False
				Exit For
			Else
				ReDim Preserve UploadComFile(UploadComCnt)
				UploadComFile(UploadComCnt) = aFileName
				UploadComCnt = UploadComCnt + 1
			End IF
		End IF
	End IF

	bFilenames = bFilenames & bFileName & "^|^"
	aFilenames = aFilenames & aFileName & "^|^"

	IF DBCON.Errors.Count>0 OR CStr(Err.Number)<>"0"  Then
		FileUploadSuccess = False
		Exit For
	End IF
Next

IF FileUploadSuccess Then
	'### 업데이트 및 삭제파일 삭제처리 ###########
	For i=0 To Ubound(removeFile)
		IF removeFile(i)<>"" Then
			ImgDelete removeFile(i), UploadForm.DefaultPath
		End IF
	Next
	'### 업데이트 및 삭제파일 삭제처리 ###########
Else
	'### 오류시 업로드된 파일 삭제처리 ###########
	For i=0 To Ubound(UploadComFile)
		IF UploadComFile(i)<>"" Then
			ImgDelete UploadComFile(i), UploadForm.DefaultPath
		End IF
	Next
	'### 오류시 업로드된 파일 삭제처리 ###########

	Response.Write ExecJavaAlert("파일처리중 오류가 발생했습니다.",0)
	Response.End
End IF

On Error goto 0
'###### BEFORE & AFTER 파일 저장 #############

oriidx = ""
IF Sort="edit" Then
	IF ReLevel="A" Then
		Sql="Update BBsList Set BoardSort="&ChangeStrNull(BoardSort)&", sortdate='"&viewdate&"' Where ref="&Idx
		DBcon.Execute Sql
	Else
		Sql = "SELECT ref FROM bbslist Where idx="&idx
		Set Rs=DBcon.Execute(Sql)
		IF Not(Rs.Bof Or Rs.Eof) Then
			oriidx = Rs("ref")
		End IF
	End IF
	Sql="UPDATE BBsList Set topYN="&Topyn&", isimp="&isimp&", publicYN="&publicYN&" Where ref="&ref
	DBcon.Execute Sql

	isMain = uf_getRequestProc(UploadForm("isMain"),"int","1","0")
	CateCode = uf_getRequestProc(UploadForm("CateCode"),"char","","")
	filteridx = uf_getRequestProc(Replace(UploadForm("filteridx"),", ",","),"char","","")

	AlertTag="수정"
	Sql="Update bbslist Set cate1=?, cate2=?, cate3=?, newWin1=?, newWin2=?, always=?, deadline=?, edNonce=?, bdiv1=?, bdiv2=?, CateCode=?, filteridx=?, isDisplay=?, setYear=?, readnum=?, linkurl=?, viewdate=?, artistidx=?, editorYN=?, status=?, note1=?, note2=?, note3=?, note4=?, note5=?, note6=?, note7=?, note8=?, note9=?, note10=?, note11=?, note12=?, note13=?, VodUrl=?, startdate=?, enddate=?, boardSort=?, writer=?, Title=?, thumbContent=?, Content=?, wip=?, imgnames=?, testFile1=?, testFile2=?, testFile3=?, bFilenames=?, aFilenames=? Where idx="&idx
Else
	AlertTag="등록"
	Sql="INSERT INTO bbslist(cate1, cate2, cate3, newWin1, newWin2, always, deadline, edNonce, bdiv1, bdiv2, CateCode, filteridx, isDisplay, setYear, readnum, linkurl, viewdate, artistidx, editorYN, status, note1, note2, note3, note4, note5, note6, note7, note8, note9, note10, note11, note12, note13, VodUrl, startdate, enddate, BoardSort, writer, Title, thumbContent, Content, wip, regdate, imgnames, boardidx, useridx, pwd, isimp, topyn, publicYN, submit, adwrite, testFile1, testFile2, testFile3, bFilenames, aFilenames) "
	Sql = Sql & "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, getdate()  ,?,?,null,null,?,?,?,1,1,?,?,?,?,?)"
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 100, cate1)
	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 100, cate2)
	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 100, cate3)
	.Parameters.Append .CreateParameter("@newWin1", adTinyint, adParamInput, 1, newWin1)
	.Parameters.Append .CreateParameter("@newWin2", adTinyint, adParamInput, 1, newWin2)
	.Parameters.Append .CreateParameter("@always", adTinyint, adParamInput, 1, always)
	.Parameters.Append .CreateParameter("@deadline", adTinyint, adParamInput, 1, deadline)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, edNonce)
	.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, bdiv1)
	.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, bdiv2)
	.Parameters.Append .CreateParameter("@CateCode", adVarWchar, adParamInput, 50, CateCode)
	.Parameters.Append .CreateParameter("@filteridx", adVarWchar, adParamInput, 2147483647, filteridx)
	.Parameters.Append .CreateParameter("@isDisplay", adTinyint, adParamInput, 1, isDisplay)
	.Parameters.Append .CreateParameter("@setYear", adBigint, adParamInput, 8, setYear)
	.Parameters.Append .CreateParameter("@readnum", adBigint, adParamInput, 8, readnum)
	.Parameters.Append .CreateParameter("@linkurl", adVarchar, adParamInput, 2000, linkurl)
	.Parameters.Append .CreateParameter("@viewdate", adVarchar, adParamInput, 10, viewdate)
	.Parameters.Append .CreateParameter("@artistidx", adBigint, adParamInput, 8, artistidx)
	.Parameters.Append .CreateParameter("@editorYN", adTinyint, adParamInput, 1, editorYN)
	.Parameters.Append .CreateParameter("@status", adTinyint, adParamInput, 1, status)
	.Parameters.Append .CreateParameter("@note1", adVarWchar, adParamInput, 800, note1)
	.Parameters.Append .CreateParameter("@note2", adVarWchar, adParamInput, 800, note2)
	.Parameters.Append .CreateParameter("@note3", adVarWchar, adParamInput, 800, note3)
	.Parameters.Append .CreateParameter("@note4", adVarWchar, adParamInput, 800, note4)
	.Parameters.Append .CreateParameter("@note5", adVarWchar, adParamInput, 800, note5)
	.Parameters.Append .CreateParameter("@note6", adVarWchar, adParamInput, 4000, note6)
	.Parameters.Append .CreateParameter("@note1", adVarWchar, adParamInput, 4000, note7)
	.Parameters.Append .CreateParameter("@note1", adVarWchar, adParamInput, 4000, note8)
	.Parameters.Append .CreateParameter("@note1", adVarWchar, adParamInput, 4000, note9)
	.Parameters.Append .CreateParameter("@note1", adVarWchar, adParamInput, 4000, note10)
	.Parameters.Append .CreateParameter("@note1", adVarWchar, adParamInput, 4000, note11)
	.Parameters.Append .CreateParameter("@note1", adVarWchar, adParamInput, 4000, note12)
	.Parameters.Append .CreateParameter("@note1", adVarWchar, adParamInput, 4000, note13)
	.Parameters.Append .CreateParameter("@VodUrl", adVarWchar, adParamInput, 2000, VodUrl)
	.Parameters.Append .CreateParameter("@startdate", adVarchar, adParamInput, 10, startdate)
	.Parameters.Append .CreateParameter("@enddate", adVarchar, adParamInput, 10, enddate)
	.Parameters.Append .CreateParameter("@BoardSort", adInteger, adParamInput, 4, BoardSort)
	.Parameters.Append .CreateParameter("@Writer", adVarWchar, adParamInput, 100, Writer)
	.Parameters.Append .CreateParameter("@title", adVarWchar, adParamInput, 200, title)
	
	.Parameters.Append .CreateParameter("@thumbContent", adVarWchar, adParamInput, 2147483647, thumbContent)
	.Parameters.Append .CreateParameter("@content", adVarWchar, adParamInput, 2147483647, content)
	.Parameters.Append .CreateParameter("@Wip", adVarChar, adParamInput, 50, WIP)
	.Parameters.Append .CreateParameter("@imgNames", adVarWchar, adParamInput, 100, imgName(0))
	IF Sort<>"edit" Then
	.Parameters.Append .CreateParameter("@BoardIdx", adInteger, adParamInput, 4, BBsCode)
	.Parameters.Append .CreateParameter("@Topyn", adBoolean, adParamInput, 1, isimp)
	.Parameters.Append .CreateParameter("@Topyn", adBoolean, adParamInput, 1, Topyn)
	.Parameters.Append .CreateParameter("@PublicYN", adBoolean, adParamInput, 1, PublicYN)
	End IF
	.Parameters.Append .CreateParameter("@testFile1", adVarWchar, adParamInput, 100, testFileName(1))
	.Parameters.Append .CreateParameter("@testFile2", adVarWchar, adParamInput, 100, testFileName(2))
	.Parameters.Append .CreateParameter("@testFile3", adVarWchar, adParamInput, 100, testFileName(3))

	.Parameters.Append .CreateParameter("@testFile3", adVarWchar, adParamInput, 4000, bFilenames)
	.Parameters.Append .CreateParameter("@testFile3", adVarWchar, adParamInput, 4000, aFilenames)
	.Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

Dim bIdx,MaxIdx
IF Sort="edit" Then
	bIdx=Idx

	Sql="UPDATE bbslist SET status="&status&" Where ref="&idx
	DBcon.Execute Sql
Else
	Sql = "Select Max(Idx) From BBsList"
	MaxIdx=DBcon.Execute(Sql)
	bIdx=MaxIdx(0)
	
	Sql="UPDATE BBsList Set Ref="&MaxIdx(0)&",ReLevel='A', sortdate='"&viewdate&"' Where idx="&MaxIdx(0)
	DBcon.Execute Sql
End IF

'====================첨부파일 업로드 작업==========================================================
For i=1 To UploadForm("files").count
	IF Sort<>"edit" Then 
		IF UploadForm("files")(i)<>"" Then 
			Filenames=ImgSaves(UploadForm("files")(i),uploadform.defaultpath,3072000000)
			IF Filenames=False Then Result=1

			IF Result=1 Then
				Set UploadForm=Nothing
				DBcon.Close
				Set DBcon=Nothing
				Response.Write ExecJavaAlert("업로드 허용용량(3000M)을 초과하여 업로드를 실패하였습니다.",0)
				Response.End
			Else
				Sql="INSERT INTO BBSData(bidx,filenames,regdate) values("&bIdx&",'"&Filenames&"',getdate())"
				DBcon.Execute Sql
			End IF
		End IF
	Else
		IF UploadForm("filedel_idx")(i)<>"" Then
			IF UploadForm("filedel_idx")(i)<>"0" Then
				Sql="Select filenames From BBSData WHERE idx="&UploadForm("filedel_idx")(i)
				Set Rs=DBcon.Execute(Sql)
				IF Not(Rs.Bof Or Rs.Eof) Then
					ImgDelete Rs("filenames"),UploadForm.DefaultPath
				End IF
				Set Rs=NOthing

				IF UploadForm("files")(i)="" Then
					Sql="DELETE BBSData WHERE idx="&UploadForm("filedel_idx")(i)
					DBcon.Execute Sql
				Else
					filenames=ImgSaves(UploadForm("files")(i),uploadform.defaultpath,3072000000)
					IF filenames=False Then Result=1

					IF Result=1 Then
						Set UploadForm=Nothing
						DBcon.Close
						Set DBcon=Nothing
						Response.Write ExecJavaAlert("업로드 허용용량(3000M)을 초과하여 업로드를 실패하였습니다.",0)
						Response.End
					Else
						Sql="Update BBSData Set filenames='"&filenames&"',regdate=getdate() Where idx="&UploadForm("filedel_idx")(i)
						DBcon.Execute Sql
					End IF
				End IF
			Else
				IF UploadForm("files")(i)<>"" Then 
					filenames=ImgSaves(UploadForm("files")(i),uploadform.defaultpath,3072000000)
					IF filenames=False Then Result=1

					IF Result=1 Then
						Set UploadForm=Nothing
						DBcon.Close
						Set DBcon=Nothing
						Response.Write ExecJavaAlert("업로드 허용용량(3000M)을 초과하여 업로드를 실패하였습니다.",0)
						Response.End
					Else
						Sql="INSERT INTO BBSData(bidx,filenames,regdate) values("&idx&",'"&filenames&"',getdate())"
						DBcon.Execute Sql
					End IF
				End IF
			End IF
		End IF
	End IF
Next
'===============================================================================================

'###### 에디터 ID 등록처리 ##########
Call edNonceReg(edNonce)
'###### 에디터 ID 등록처리 ##########

Set Cmd=Nothing

IF CStr(oriidx)="" Then

	'#### 메일 발송 ##########
	IF bbscode="30" AND AlertTag="등록" Then
		Sql = "SELECT email FROM members WHERE emailYN=1 AND outmember=0 AND email<>'' AND email is Not Null"
		Set Rs = DBcon.Execute(Sql)
		IF Not(Rs.Bof Or Rs.Eof) Then
			toEmail = "아이원소프트뱅크<ione@duzon119.co.kr>" '보내는사람
			emailTitle = "[아이원소프트뱅크][공지] "&TITLE

			Set fso = Server.CreateObject("Scripting.FileSystemObject")
			Set f = fso.OpenTextFile(Server.MapPath("/mail/")&"/notiMail.html",1,false,-1)
			MailBody = f.ReadAll
			MailBody=Replace(MailBody, "__%LINKURL%__", "https://duzon119.co.kr/customer/notice.asp?mode=view&idx="&bIdx)

			Do Until Rs.Eof
				ReEmail = Rs("email")

				Call subSendMailSMTP(toEmail, ReEmail, emailTitle, MailBody, 0, "")
				Rs.MoveNext()
			Loop
		End IF
	End IF
	'#### 메일 발송 ##########

	strLocation=PageLink&"?page="&Page&"&"&PageStr
	Response.Write ExecJavaAlert("게시물이 "&AlertTag&"되었습니다.",2)
Else
	strLocation="bbsView.asp?idx="&oriidx&"&page="&Page&"&"&PageStr
	Response.Write ExecJavaAlert("답변이 수정 되었습니다.",2)
End IF

DBcon.Close
Set DBcon=Nothing
%>