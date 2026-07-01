<%
pageSize=uf_getRequest(Request("pageSize"),"int","","10")
page=uf_getRequest(Request("page"),"int","","1")
serYear=uf_getRequest(Request("serYear"),"int","","")
search=uf_getRequest(Request("search"),"int","4","1")
searchStr=uf_getRequest(Request("searchStr"),"char","50","")
idx=uf_getRequest(Request("idx"),"int","","")
inputPwd=Session("boardPass")
serboardsort=uf_getRequest(Request("serboardsort"),"int","","")
oSearchStr = Request("searchstr")
serCate1=uf_getRequest(Request("serCate1"),"int","","")
serCate2=uf_getRequest(Request("serCate2"),"int","","")

IF isSetBSort=True Then
	serboardsort = CheckBoardsortAndRedim(BBsCode,serBoardSort)
End IF

IF serboardsort<>"" Then StrWhere = StrWhere & " AND boardsort="&serboardsort&" "
IF serYear<>"" Then StrWhere = StrWhere & " AND setYear="&serYear&" "
IF searchStr <> "" Then
	IF Search = "1" Then
		StrWhere = StrWhere & " AND title Like '%"&searchStr&"%'"
	ElseIF Search = "2" Then
		StrWhere = StrWhere & " AND writer Like '%"&searchStr&"%'"
	ElseIF Search = "3" Then
		StrWhere = StrWhere & " AND content Like '%"&searchStr&"%'"
	Else
		StrWhere = StrWhere & " AND (title Like '%"&searchStr&"%' OR content Like '%"&searchStr&"%' OR writer Like '%"&searchStr&"%')"
	End IF
End IF
IF serCate1<>"" Then StrWhere = StrWhere & " AND cate1="&serCate1
IF serCate2<>"" Then StrWhere = StrWhere & " AND cate2="&serCate2

PageStr="pageSize="&pageSize&"&seritemidx="&seritemidx&"&serYear="&serYear&"&serboardsort="&serboardsort&"&search="&search&"&searchStr="&Server.UrlEncode(oSearchStr)
IF serCate1<>"" Then PageStr = PageStr & "&serCate1="&serCate1
IF serCate2<>"" Then PageStr = PageStr & "&serCate2="&serCate2

IF BBsCode=false Or Idx="" Then
	Response.write ExecJavaAlert(Langpack_WrongMsg, 0)
	Response.End
End IF

Call HK_BBSSetup(BBsCode)
BBsViewModeChk("view")

Sql="Select title, writer, viewdate, content, Ref, ReLevel, pwd, TopYn, readNum, publicYN, IsNull(UserIdx,0) As Useridx, SortName, imgnames, WIP, vodUrl, editorYN, tel, note1, note2, note3, note4, note5, note6, note7, note4, startdate, enddate, always, deadline, testFile1, testFile2, sortdate, stars, itemidx, cate1 AS cateNm1, DBO.FN_CODENAME(cate1, cate2) AS cateNm2, DBO.FN_CODENAME(cate2, cate3) AS cateNm3, status, adMemo1, comDate, adMemo, statusChDate, memoFileNm, DBO.FN_CODENAME( CASE WHEN b.boardidx=5 THen 'amaCate' WHEN b.boardidx=15 THEN 'icubeCate' Else 'bizboxCate' END  , cate1) AS vodCateNm, LikeCnt FROM BBslist AS B Left Outer Join BoardSort AS S ON BoardSort=S.idx Where isDisplay=1 AND b.idx="&Idx & StrWhere
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
	title=Rs("title") : writer=Rs("writer") : regdate=Rs("viewdate")
	Ref=Rs("Ref") : ReLevel=Rs("ReLevel") : Pwd=Rs("pwd") : TopYn=Rs("TopYn")
	ReadNum=Rs("readNum") : PublicYN=Rs("publicYN") : UserIdx=Rs("UserIdx") : SortName=ChangeBlank(Rs("sortName")) : imgnames=Rs("imgnames")
	WIP=Rs("WIP") : vodUrl=Rs("vodUrl")
	startdate=changeBlank(Rs("startdate"))
	enddate=changeBlank(Rs("enddate"))
	always=changeBlank(Rs("always"))
	deadline=changeBlank(Rs("deadline"))

	testFile1=Rs("testFile1")
	testFile2=Rs("testFile2")
	sortdate=Rs("sortdate")
	stars=Rs("stars")
	itemidx=Rs("itemidx")

	note1 = ReplaceNoHtml(Rs("note1"))
	note2 = ReplaceNoHtml(Rs("note2"))
	note3 = ReplaceNoHtml(Rs("note3"))
	note4 = ReplaceNoHtml(Rs("note4"))
	note5 = ReplaceNoHtml(Rs("note5"))
	note6 = ReplaceNoHtml(Rs("note6"))
	note7 = ReplaceNoHtml(Rs("note7"))

	cateNm1 = ReplaceNoHtml(Rs("cateNm1"))
	cateNm2 = ReplaceNoHtml(Rs("cateNm2"))
	cateNm3 = ReplaceNoHtml(Rs("cateNm3"))
	vodCateNm = ReplaceNoHtml(Rs("vodCateNm"))

	status = ReplaceNoHtml(Rs("status"))
	adMemo = ReplaceNoHtml(Rs("adMemo"))
	adMemo1 = ReplaceNoHtml(Rs("adMemo1"))
	comDate = ReplaceNoHtml(Rs("comDate"))
	statusChDate = ReplaceNoHtml(Rs("statusChDate"))
	LikeCnt = ReplaceNoHtml(Rs("LikeCnt"))

	IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" Then
		cateNames = getBBSCateNm1(cateNm1)
	Else
		cateNames = vodCateNm
	End IF
	IF cateNames <> "" Then
		IF cateNm2<>"" Then
			cateNames = cateNames & " > "& cateNm2

			IF cateNm3<>"" Then
				cateNames = cateNames & " > "& cateNm3
			End IF
		End IF
	End IF

	'######### 답변 첨부파일 ##########
	memoFileNm = ChangeBlank(Rs("memoFileNm"))
	IF memoFileNm<>"" Then
		ARRMEMOFILENM = Split(memoFileNm,"|")
	End IF
	'######### 답변 첨부파일 ##########

	'=========에디터사용 여부에 따른 내용변경==========
	editorYN=Rs("editorYN") : content=Replace(Replace(changeBlank(Rs("content")),"https://www.incross.com","http://www.incross.com"),"https://incross.com","http://incross.com")

	IF editorYN = 0 Then Content = ReplaceBr(ReplaceNoHtml(Content))
	'==================================================

	IsConsule = False
	IF BBscode=1000 Then
		IF startdate="" OR enddate="" Then
			IsConsule = True
		Else
			IF startdate > CStr(Date()) Then
				statusIMG = "<span class=""icon end"">"&LangPack_Expected&"</span>"&Vbcrlf
			ElseIF startdate <= CStr(Date()) And enddate >= CStr(Date()) Then
				statusIMG = "<span class=""icon ing"">"&LangPack_Progress&"</span>"&Vbcrlf
				IsConsule = True
			Else
				statusIMG = "<span class=""icon end"">"&LangPack_Deadline&"</span>"&Vbcrlf
			End IF
		End IF
	End IF

	IF PublicYN="True" Then
		IF isNull(Pwd) Then
			IF CStr(UserIdx)=CStr(Session("useridx")) THen souchk=souchk+1
			AlertMsg = Langpack_AuthErrorMsg_View
		Else
			IF inputPwd=Pwd THen souchk=souchk+1
			AlertMsg = Langpack_EnterPassMsg
		End IF

		IF souchk=false Then
			Response.Write ExecJavaalert(AlertMsg, 0)
			Response.End
		End IF
	End IF

	' 조회수 증가 쿠키관련
	IF Request.Cookies("cpbview")(BBsCode&"st"&Idx)="" Then
		Sql="UPdate BBslist Set ReadNum=ReadNum+1 Where idx="&Idx
		DBcon.Execute Sql

		Response.Cookies("cpbview")(BBsCode&"st"&Idx) = Idx
		Response.cookies("cpbview").Expires = dateadd("h", 2, now())
		Response.Cookies("cpbview").Path = "/"
		ReadNum=ReadNum+1
	End IF

	'========================================이전/다음글 찾기 ====================================
	PreTag=Langpack_PrevNotFound : NextTag=Langpack_NextNotFound

	SQL="SELECT TOP 1 b.idx,title,ref,relevel,DelYN,TopYn,publicYN,pwd,writer,viewdate,sortname,linkurl FROM BBslist AS B Left Outer Join BoardSort AS S ON BoardSort=S.idx WHERE isDisplay=1 AND relevel='A' AND ((sortdate='"&sortdate&"' AND ref>'"&ref&"') OR sortdate>'"&Sortdate&"') AND b.idx<>"&idx&" AND TopYn="&BitToNumber(TopYn)&" AND b.boardidx="&BBsCode & StrWhere&" ORDER BY sortDate ASC, ref ASC, relevel DESC"
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		IF Rs(4)="True" Then
			PreTag=LangPack_PostDeletedMsg
		Else
			IF Rs(6)="True" AND Not(Rs(7)="" Or IsNull(Rs(7))) Then
				PreTag = "	<a onclick=""goPwdpage('view',"&Rs(0)&")"" style='cursor:pointer;'>"&ReplaceNoHtml(Rs(1))&"</a><p class=""day"">"&ReplaceNoHtml(Rs(9))&"</p>"&Vbcrlf
			Else
				PreTag = "	<a onclick=""location.href='?mode=view&page="&Page&"&idx="&Rs(0)&"&"&PageStr&"'"" style='cursor:pointer;'>"&ReplaceNoHtml(Rs(1))&"</a><p class=""day"">"&ReplaceNoHtml(Rs(9))&"</p>"&Vbcrlf
			End IF
		End IF
	End IF
	Rs.Close

	Sql="SELECT TOP 1 b.idx,title,ref,relevel,DelYN,TopYn,publicYN,pwd,writer,viewdate,sortname,linkurl FROM BBslist AS B Left Outer Join BoardSort AS S ON BoardSort=S.idx WHERE isDisplay=1 AND relevel='A' AND ((sortdate='"&sortdate&"' AND ref<'"&ref&"') OR sortdate<'"&Sortdate&"') AND b.idx<>"&idx&" AND TopYn="&BitToNumber(TopYn)&" AND b.boardidx="&BBsCode & StrWhere&" Order by sortDate DESC, ref DESC,relevel ASC"
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		IF Rs(4)="True" Then
			NextTag=LangPack_PostDeletedMsg
		Else
			IF Rs(6)="True" AND Not(Rs(7)="" Or IsNull(Rs(7))) Then
				NextTag = "	<a onclick=""goPwdpage('view',"&Rs(0)&")"" style='cursor:pointer;'>"&ReplaceNoHtml(Rs(1))&"</a><p class=""day"">"&ReplaceNoHtml(Rs(9))&"</p>"&Vbcrlf
			Else
				NextTag = "	<a onclick=""location.href='?mode=view&page="&Page&"&idx="&Rs(0)&"&"&PageStr&"'"" style='cursor:pointer;'>"&ReplaceNoHtml(Rs(1))&"</a><p class=""day"">"&ReplaceNoHtml(Rs(9))&"</p>"&Vbcrlf
			End IF
		End IF
	End IF
	Rs.Close
	'=============================================================================================

	'=======관련글(답변글) 카운트=============================
	Sql="SELECT COUNT(1) FROM BBSList WHERE ref = "&Ref
	Set Rs=DBcon.Execute(Sql)
	ReplyCnt = Rs(0)
	'=======================================================

	'=======관련글(답변글) ===================================
	Sql="SELECT title, content, writer, viewdate, editorYN FROM BBSList WHERE isDisplay=1 AND idx<>"&idx&" AND ref = "&Ref&" order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, Idx DESC"
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then ReplyRec = Rs.GetRows()
	'=======================================================

	Set Rs=Nothing
Else
	Response.write ExecJavaAlert(Langpack_WrongMsg,0)
	Response.End
End IF

IF TopYn="True" Then TopTag="["&LangPack_Notice&"]"

IF HK_PdsYN = "True" Then
	Set Rs=Server.CreateObject("ADODB.RecordSet")
	Sql="SELECT filenames FROM bbsData WHERE bidx="&idx
	Rs.Open Sql,DBcon,1
	If Not(Rs.Bof Or Rs.Eof) Then FileRec=Rs.GetRows()
	Rs.CLose()
End IF

Function PT_memoFileArea()
	Dim i
	IF IsArray(ARRMEMOFILENM) Then
		Response.Write "<div class=""view_file"">"&Vbcrlf
		For i=0 To UBound(ARRMEMOFILENM)
			IF ARRMEMOFILENM(i)<>"" Then
				Response.Write "		<a href=""/_lib/download.asp?downfile="&Server.UrlEncode(ARRMEMOFILENM(i))&"&path=board"">"&ARRMEMOFILENM(i)&"</a>"&Vbcrlf
			End IF
		Next
		Response.Write "</div>"&Vbcrlf
	End IF
End Function


Function PT_FileArea()
	IF IsArray(FileRec) Then

		Response.Write "<div class=""view_file"">"&Vbcrlf
		For i=0 To UBound(FileRec,2)
			Response.Write "		<a href=""/_lib/download.asp?downfile="&Server.UrlEncode(FileRec(0,i))&"&path=board"">"&FileRec(0,i)&"</a>"&Vbcrlf
		Next
		Response.Write "</div>"&Vbcrlf
	End IF
End Function

Function PT_ReplyList()
	IF IsArray(ReplyRec) Then
		For i=0 To Ubound(ReplyRec,2)
			IF ReplyRec(4,i)=0 Then
				Response.Write "<tr><td class=""answer""><p class=""tit"">"&LangPack_Reply&" <span class=""right"">"&ReplyRec(2,i)&" ("&ReplyRec(3,i)&")</span></p><p>"&ReplaceBr(ReplyRec(1,i))&"</p></td></tr>"&Vbcrlf
			Else
				Response.Write "<tr><td class=""answer""><p class=""tit"">"&LangPack_Reply&" <span class=""right"">"&ReplyRec(2,i)&" ("&ReplyRec(3,i)&")</span></p><div class=""ck-content"">"&ReplyRec(1,i)&"</div></td></tr>"&Vbcrlf
			End IF
		Next
	End IF
End Function

'########## 채용 게시판############
isRecruitConsule = False

IF isRecruit Then
	IF always="1" Then
		termTag="상시채용"
	ElseIF startdate="" AND enddate="" Then
		termTag="채용시까지"
	ElseIF enddate="" Then
		termTag=startDate& " ~ 채용시까지"
	Else
		termTag=startdate&" ~ "&enddate
	End IF

	IF deadline="1" Then
		termStatus = "<p class=""icon end"">마감</p>"
	ElseIF always="1" Then
		termStatus = "<p class=""icon"">모집중</p>"
		isRecruitConsule = True
	Else
		IF CStr(Date()) > CStr(enddate) AND enddate<>"" Then							'마감
			termStatus = "<p class=""icon end"">마감</p>"
		ElseIF CStr(Date()) < CStr(startdate) AND startdate<>"" Then						'예정
			termStatus = "<p class=""icon end"">예정</p>"
		Else																								'진행
			termStatus = "<p class=""icon"">모집중</p>"
			isRecruitConsule = True
		End IF
	End IF
End IF
'########## 채용 게시판############
%>