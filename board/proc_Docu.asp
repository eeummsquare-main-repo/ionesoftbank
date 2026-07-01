<%
IF pageSize="" Then
	pageSize=uf_getRequest(Request("pageSize"),"int","","8")
End IF
page=uf_getRequest(Request("page"),"int","","1")
seritemidx=uf_getRequest(Request("seritemidx"),"int","","")
serYear=uf_getRequest(Request("serYear"),"int","","")
search=uf_getRequest(Request("search"),"int","","0")
searchStr=uf_getRequest(Request("searchStr"),"char","50","")
serboardsort=uf_getRequest(Request("serboardsort"),"int","","")
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
IF serYear<>"" Then StrWhere = StrWhere & " AND setYear="&serYear&" "
IF searchStr <> "" Then
	IF Search = "1" Then
		StrWhere = StrWhere & " AND title Like '%"&searchStr&"%'"
	ElseIF Search = "2" Then
		StrWhere = StrWhere & " AND writer Like '%"&searchStr&"%'"
	ElseIF Search = "3" Then
		StrWhere = StrWhere & " AND content Like '%"&searchStr&"%'"
	Else
		StrWhere = StrWhere & " AND (title Like '%"&searchStr&"%' OR thumbContent Like '%"&searchStr&"%' OR writer Like '%"&searchStr&"%')"
	End IF
End IF
PageStr="pageSize="&pageSize&"&seritemidx="&seritemidx&"&serYear="&serYear&"&serboardsort="&serboardsort&"&search="&search&"&searchStr="&Server.UrlEncode(oSearchStr)

Sql="select top "&PageSize&" bbslist.idx, title, viewdate, writer, TopYn, readnum, imgnames, note1, startdate, enddate, content, sortName, vodUrl, thumbContent, note2, note3, testfile1 FROM bbsList AS bbsList Left Outer Join BoardSort ON boardsort=boardsort.idx WHERE isDisplay=1 AND bbsList.boardidx="&BBsCode & StrWhere&" And bbslist.idx NOT IN (select top "&(Page-1)*PageSize&" idx from bbsList where isDisplay=1 AND boardidx="&BBsCode & StrWhere&" order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, Idx DESC) order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, bbslist.Idx DESC"

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
			note2 = changeBlank(Allrec(14,i))
			note3 = changeBlank(Allrec(15,i))
			testfile1 = changeBlank(Allrec(16,i))

			IF thumbContent = "" Then thumbContent = Content

			TopTag=Num : NewIcon=""
			
			altText = Replace(ReplaceNoHtml(title), """", "&quot;")
			imgTag = "<img class=""noIMG ofi thb"" alt="""&altText&""">"
			IF CDate(viewdate)>DateAdd("d",-2,Date()) Then NewIcon="<p class=""icon new""></p>"

			IF imgnames<>"" Then
				imgTag = "<img src=""/upload/board/"&(imgnames)&""" class=""ofi thb"" alt="""&altText&""" />"
			ElseIF vodUrl<>"" Then
				imgTag = "<img src="""&getYoutubeIMGUrlOnly(vodUrl)&""" class=""ofi thb"" alt="""&altText&""" />"
			Else
				editorimgName = getImageTags(1, content)
				IF editorimgName<>"" Then
					imgTag = "<img src="""&editorimgName&""" class=""ofi thb"" alt="""&altText&""" />"
				End IF
			End IF

			Response.Write "<li>"&Vbcrlf
			Response.Write "	<div class=""thumbArea"">"&imgTag&"</div>"&Vbcrlf
			Response.Write "	<div class=""textArea"">"&Vbcrlf
			Response.Write "		<p class=""category"">"&ReplaceNoHtml(sortName)&"</p>"&Vbcrlf
			Response.Write "		<p class=""title"">"&ReplaceNoHtml(title)&"</p>"&Vbcrlf
			Response.Write "		<p class=""info"">"&Vbcrlf
			IF note1<>"" Then
				Response.Write "			<span>"&ReplaceNoHtml(note1)&"</span>"&Vbcrlf
			End IF
			IF note2<>"" Then
				Response.Write "			<span>"&ReplaceNoHtml(note2)&"</span>"&Vbcrlf
			End IF
			IF note3<>"" Then
				Response.Write "			<span>"&ReplaceNoHtml(note3)&"</span>"&Vbcrlf
			End IF
			Response.Write "		</p>"&Vbcrlf
			Response.Write "		<p class=""etc"">"&getString(REMOVETAGS(thumbContent),1000)&"</p>"&Vbcrlf
			IF testfile1<>"" Then
				Response.Write "		<a href=""/upload/board/"&testfile1&""" class=""download"" target=""_blank""><p>다운로드</p></a>"&Vbcrlf
			End IF
			Response.Write "	</div>"&Vbcrlf
			Response.Write "</li>"&Vbcrlf
			Num=Num-1
		Next
	Else
		Response.Write "<li class=""noPost"">"&LangPack_PostNotFoundMsg&"</li>"&Vbcrlf
	End IF
End Function
%>