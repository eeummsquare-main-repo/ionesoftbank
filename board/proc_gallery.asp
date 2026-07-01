<%
IF pageSize="" Then
	pageSize=uf_getRequest(Request("pageSize"),"int","","8")
End IF
page=uf_getRequest(Request("page"),"int","","1")
seritemidx=uf_getRequest(Request("seritemidx"),"int","","")
search=uf_getRequest(Request("search"),"int","","0")
searchStr=uf_getRequest(Request("searchStr"),"char","50","")
serboardsort=uf_getRequest(Request("serboardsort"),"int","","")
serCate1=uf_getRequest(Request("serCate1"),"int","","")
serCate2=uf_getRequest(Request("serCate2"),"int","","")

oSearchStr = Request("searchstr")

IF isSetBSort=True Then
	serboardsort = CheckBoardsortAndRedim(BBsCode,serBoardSort)
End IF

Call HK_BBSSetup(BBsCode)
'BBsViewModeChk("list")

IF isCateTab THen
	TopSortListTag = GetBoardSortList(BBsCode,serBoardSort)
	'BBsSelectField = GetBoardSortSh(BBsCode,serboardsort)
End IF

IF BBsCode="" Or BBsCode=false Then BBsCode=1
IF seritemidx<>"" Then StrWhere = StrWhere & " AND itemidx="&seritemidx&" "
IF serboardsort<>"" Then StrWhere = StrWhere & " AND boardsort="&serboardsort&" "
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

PageStr="pageSize="&pageSize&"&seritemidx="&seritemidx&"&serboardsort="&serboardsort&"&search="&search&"&searchStr="&Server.UrlEncode(oSearchStr)

IF BBscode="5" OR BBscode="15" OR BBscode="25" Then
	IF serCate1<>"" Then StrWhere = StrWhere & " AND cate1="&serCate1
	IF serCate2<>"" Then StrWhere = StrWhere & " AND cate2="&serCate2

	IF serCate1<>"" Then PageStr = PageStr & "&serCate1="&serCate1
	IF serCate2<>"" Then PageStr = PageStr & "&serCate2="&serCate2

	IF serCate1<>"" THen
		Sql = "SELECT code, name From COMCODE WHERE groupCode='"&serCate1&"' Order By listNum ASC,idx ASC"
		Set Rs=DBcon.Execute(Sql)
		IF Not(Rs.Bof Or Rs.Eof) Then cate2Rec=Rs.GetRows()
		Set Rs=Nothing
	End IF
End IF

Function PT_cate2SelBox()
	Dim code, name
	IF isArray(cate2Rec) Then
		Response.Write "<select name=""sercate2"">"&Vbcrlf
		Response.Write "	<option value=''>- 분류 전체 -</option>"
		For i=0 To Ubound(cate2Rec,2)
			code = ChangeBlank(cate2Rec(0,i))
			name = ChangeBlank(cate2Rec(1,i))

			Response.write "<option value="""&code&""" "&iif_compare(code, sercate2, "selected")&">"&name&"</option>"&vbcrlf
		Next
		Response.Write "</select>"&Vbcrlf
	End IF
End FUnction

Sql="select top "&PageSize&" bbslist.idx, title, viewdate, writer, TopYn, readnum, imgnames, note1, startdate, enddate, content, sortName, vodUrl, thumbContent, cate1 AS cateNm1, DBO.FN_CODENAME(cate1, cate2) AS cateNm2, DBO.FN_CODENAME(cate2, cate3) AS cateNm3, DBO.FN_CODENAME( CASE WHEN bbslist.boardidx=5 THen 'amaCate' WHEN bbslist.boardidx=15 THEN 'icubeCate' Else 'bizboxCate' END  , cate1) AS vodCateNm FROM bbsList AS bbsList Left Outer Join BoardSort ON boardsort=boardsort.idx WHERE isDisplay=1 AND bbsList.boardidx="&BBsCode & StrWhere&" And bbslist.idx NOT IN (select top "&(Page-1)*PageSize&" idx from bbsList where isDisplay=1 AND boardidx="&BBsCode & StrWhere&" order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, Idx DESC) order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, bbslist.Idx DESC"

Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(1) from bbslist where isDisplay=1 AND boardidx="&BBsCode & StrWhere)
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
	Allrec=Rs.GetRows
	Count=Record_Cnt(0)
Else
	Count=0
	TotalPage=1
End If
Rs.Close

Function PT_BoardList
	Dim i, Num, Depth, j, TitleView, TopTag, NewIcon
	Num = GetTextNumDesc(Page,Pagesize,Count)
	IF IsArray(Allrec) Then

		Dim idx, title, viewdate, writer, TopYn, readnum, imgnames, note1, startdate, enddate, content, sortName

		For i=0 To UBound(Allrec,2)
			idx = changeBlank(Allrec(0,i))
			title = changeBlank(Allrec(1,i))
			viewdate = changeBlank(Allrec(2,i))
			writer = changeBlank(Allrec(3,i))
			TopYn = changeBlank(Allrec(4,i))
			readnum = changeBlank(Allrec(5,i))
			imgnames = changeBlank(Allrec(6,i))
			note1 = changeBlank(Allrec(7,i))
			startdate = changeBlank(Allrec(8,i))
			enddate = changeBlank(Allrec(9,i))
			content = changeBlank(Allrec(10,i))
			sortName = changeBlank(Allrec(11,i))
			vodUrl = changeBlank(Allrec(12,i))
			thumbContent = changeBlank(Allrec(13,i))

			IF BBscode="5" OR BBscode="15" OR BBscode="25" Then
				cateNm1 = changeBlank(Allrec(14,i))
				cateNm2 = changeBlank(Allrec(15,i))
				cateNm3 = changeBlank(Allrec(16,i))
				vodCateNm = changeBlank(Allrec(17,i))

				cateNames = vodCateNm
				IF cateNames <> "" Then
					IF cateNm2<>"" Then
						cateNames = cateNames & " > "& cateNm2

						IF cateNm3<>"" Then
							cateNames = cateNames & " > "& cateNm3
						End IF
					End IF
				End IF
			End IF

			IF thumbContent = "" Then thumbContent = Content

			TopTag=Num : NewIcon="" : imgTag=""
			
			IF CDate(viewdate)>DateAdd("d",-2,Date()) Then NewIcon="<p class=""icon new""></p>"

			altText = Replace(ReplaceNoHtml(title), """", "&quot;")
			IF imgnames<>"" Then imgTag = "<img src=""/upload/board/"&(imgnames)&""" class=""ofi thb"" alt="""&altText&""" />"
			IF imgTag="" AND vodUrl<>"" AND (InStr(vodUrl, "youtu.be")>0 OR InStr(vodUrl, "youtube.com")>0) Then imgTag = "<img src="""&getYoutubeIMGUrlOnly(vodUrl)&""" class=""ofi thb"" alt="""&altText&""" />"
			IF imgTag="" Then
				editorimgName = getImageTags(1, content)
				IF editorimgName<>"" Then imgTag = "<img src="""&editorimgName&""" class=""ofi thb"" alt="""&altText&""" />"
			End IF
			IF imgTag="" Then imgTag="<img class=""noIMG ofi thb"" alt="""&altText&""">"

			Response.Write "<li>"&Vbcrlf
			IF bbsClass = "photo_list video" Then
				Response.Write "	<a data-fancybox href='"&vodUrl&"' class=""gall_cont"">"&Vbcrlf
			Else
				Response.Write "	<a href='?mode=view&idx="&idx&"&page="&Page&"&"&PageStr&"' class=""gall_cont"">"&Vbcrlf
			End IF
			Response.Write "		<div class=""thumb"">"&Vbcrlf
			Response.Write "			"&imgTag&"<p class=""over move""><span>view</span></p>"&Vbcrlf
			Response.Write "		</div>"&Vbcrlf
			Response.Write "		<div class=""area"">"&Vbcrlf
			IF sortName<>"" Then
				Response.Write "			<p class=""tt cate"">"&ReplaceNoHtml(sortName)&"</p>"&Vbcrlf
			End IF

			IF BBscode="5" OR BBscode="15" OR BBscode="25" Then
				Response.Write "			<p class=""tt cate"">"&ReplaceNoHtml(cateNames)&"</p>"&Vbcrlf
			End IF

			Response.Write "			<div class=""tt title""><div class=""one"">"&ReplaceNoHtml(title)&"</div> "&NewIcon&"</div>"&Vbcrlf
			IF isListThumbCon Then
				Response.Write "			<div class=""tt txt two"">"&getString(REMOVETAGS(thumbContent),500)&"</div>"&Vbcrlf
			End IF
			IF isListWriterHidden = False Then
				Response.Write "			<div class=""tt""><span class=""sv_member"">"&ReplaceNoHtml(writer)&"</span></div>"&Vbcrlf
			End IF
			IF isListDateHidden = False Then
				Response.Write "			<div class=""tt day"">"&Left(Allrec(2,i),10)&"</div>"&Vbcrlf
			End IF
			Response.Write "		</div>"&Vbcrlf
			Response.Write "	</a>"&Vbcrlf
			Response.Write "</li>"&Vbcrlf

			Num=Num-1
		Next
	Else
		Response.Write "<li class=""noPost"">"&LangPack_PostNotFoundMsg&"</li>"&Vbcrlf
	End IF
End Function
%>