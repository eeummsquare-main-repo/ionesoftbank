<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim BBsCode
BBSCode=Request("BBscode")

'============ 게시판 권한/환경변수 셋팅======================
Call HK_BBSSetup(BBsCode)
topMenuCode = HK_BBS_TopMenuCode : subMenuCode = HK_BBS_SubMenuCode
'============================================================
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim i
Dim UploadForm, strLocation
Dim Page, Idx
Dim imgnames, Ref, ReLevel
Dim FileRs

'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serDate1, serdate2

page = uf_getRequest(Request("page"),"int","","")
pageSize = uf_getRequest(Request("pageSize"),"int","","")
serstatus = uf_getRequest(Request("serstatus"),"int","","")
serisDisplay = uf_getRequest(Request("serisDisplay"),"int","","")
serismain = uf_getRequest(Request("serismain"),"int","","")
serboardsort = uf_getRequest(Request("serboardsort"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","","")
SearchStr = uf_getRequest(Request("searchStr"),"char","","")
serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serCate1=uf_getRequest(Request("serCate1"),"char","","")
serCate2=uf_getRequest(Request("serCate2"),"char","","")
serCate3=uf_getRequest(Request("serCate3"),"char","","")
oSearchStr = Request("searchstr")

PageLink="bbslist.asp"
PageStr="BBscode="&BBscode&"&pagesize="&PageSize&"&serstatus="&serstatus&"&serisDisplay="&serisDisplay&"&serismain="&serismain&"&serboardsort="&serboardsort&"&serDate1="&serDate1&"&serdate2="&serdate2&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)

IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" OR BBscode="5" OR BBscode="15" OR BBscode="25" Then
	IF serCate1<>"" Then PageStr = PageStr & "&serCate1="&serCate1
	IF serCate2<>"" Then PageStr = PageStr & "&serCate2="&serCate2
	IF serCate3<>"" Then PageStr = PageStr & "&serCate3="&serCate3
End IF
'=============================================

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/board/")

IF Request("delSort") = "group" Then
	idx = Request("chkidx")
Else
	idx = Request("idx")
End IF

idx = Split(idx,",")

For i=0 To Ubound(IDX)
	Sql="SELECT Ref,ReLevel FROM BBsList WHERE idx="&Idx(i)
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof OR Rs.Eof) Then
		Ref=Rs("Ref") : ReLevel=Rs("ReLevel")

		Sql="SELECT idx,imgnames,testFIle1,testFile2,testFile3, bFilenames, aFilenames, edNonce, memoFileNm From BBsList Where Ref="&Ref&" And ReLevel Like '"&ReLevel&"%'"
		SET Rs=DBcon.Execute(Sql)

		IF Not(Rs.Bof Or Rs.Eof) Then
			Do Until Rs.Eof
				imgnames=Rs("imgnames")
				testFIle1=Rs("testFIle1")
				testFile2=Rs("testFile2")
				testFile3=Rs("testFile3")
				bFilenames=Rs("bFilenames")
				aFilenames=Rs("aFilenames")
				edNonce = Rs("edNonce")
				memoFileNm = changeBlank(Rs("memoFileNm"))

				arrBFile = Split(bFilenames, "^|^")
				arrAFile = Split(aFilenames, "^|^")
				arrMemoFileNm = Split(memoFileNm, "|")

				For j=0 To Ubound(arrMemoFileNm)
					IF arrMemoFileNm(j)<>"" Then ImgDelete arrMemoFileNm(j),UploadForm.DefaultPath
				Next

				For j=0 To Ubound(arrBFile)
					IF arrBFile(j)<>"" Then ImgDelete arrBFile(j),UploadForm.DefaultPath
				Next
				For j=0 To Ubound(arrAFile)
					IF arrAFile(j)<>"" Then ImgDelete arrAFile(j),UploadForm.DefaultPath
				Next

				IF imgnames<>"" Then
					ImgDelete imgnames,UploadForm.DefaultPath
					ImgDelete getImageThumbFilename(imgnames),UploadForm.DefaultPath
				End IF
				IF testFIle1<>"" Then ImgDelete testFIle1,UploadForm.DefaultPath
				IF testFIle2<>"" Then ImgDelete testFIle2,UploadForm.DefaultPath
				IF testFIle3<>"" Then ImgDelete testFIle3,UploadForm.DefaultPath
				IF memoFileNm<>"" Then ImgDelete memoFileNm,UploadForm.DefaultPath
				
				Sql="SELECT filenames FROM BBSData WHERE bidx="&Rs("idx")
				Set FileRs=DBcon.Execute(Sql)
				IF Not(FileRs.Bof Or FileRs.Eof) Then
					Do Until FileRs.Eof
						If FileRs("filenames")<>""  Then ImgDelete FileRs("filenames"),UploadForm.DefaultPath
						FileRs.MoveNext()
					Loop
				End IF
				Sql="DELETE BBSData WHERE bidx="&Rs("idx")
				DBcon.Execute Sql

				'###### 에디터 등록이미지 삭제처리 ##########
				Call edNonceRemove(edNonce)
				'###### 에디터 등록이미지 삭제처리 ##########

				Rs.MoveNext()
			Loop
		End IF

		Sql="DELETE BBsList Where Ref="&Ref&" And ReLevel Like '"&ReLevel&"%'"
		DBcon.Execute Sql
	End IF
Next

Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

IF ReLevel="A" Then
	strLocation=PageLink&"?page="&Page&"&"&PageStr
	Response.Write ExecJavaAlert("선택하신 게시물이 삭제되었습니다.",2)
Else
	strLocation="bbsView.asp?idx="&Ref&"&page="&Page&"&"&PageStr
	Response.Write ExecJavaAlert("답변이 삭제되었습니다.",2)
End IF
%>