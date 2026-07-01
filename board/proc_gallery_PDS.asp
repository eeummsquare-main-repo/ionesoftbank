<%
IF pageSize="" Then
	pageSize=uf_getRequest(Request("pageSize"),"int","","8")
End IF
page=uf_getRequest(Request("page"),"int","","1")
seritemidx=uf_getRequest(Request("seritemidx"),"int","","")
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

Sql="select top "&PageSize&" bbslist.idx, title, viewdate, writer, TopYn, readnum, imgnames, note1, startdate, enddate, content, sortName, vodUrl, thumbContent, filenames FROM View_BBslistWithFileData AS bbsList Left Outer Join BoardSort ON boardsort=boardsort.idx WHERE isDisplay=1 AND bbsList.boardidx="&BBsCode & StrWhere&" And bbslist.idx NOT IN (select top "&(Page-1)*PageSize&" idx from bbsList where isDisplay=1 AND boardidx="&BBsCode & StrWhere&" order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, Idx DESC) order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, bbslist.Idx DESC"

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

		Dim idx, title, viewdate, writer, TopYn, readnum, imgnames, note1, startdate, enddate, content, sortName, filenames

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
			filenames = changeBlank(Allrec(14,i))

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

			DownTag = ""
			IF filenames<>"" Then DownTag = "href='/_lib/download.asp?downfile="&filenames&"&path=board'"

			Response.Write "<li>"&Vbcrlf
			Response.Write "	<a "&DownTag&" class=""gall_cont"" download="""">"&Vbcrlf
			Response.Write "		<div class=""thumb"">"&Vbcrlf
			Response.Write "			"&imgTag&"<p class=""over move""><b><img src=""/images/sub/dw.png"" alt=""다운로드""></b><span>DOWNLOAD</span></p>"&Vbcrlf
			Response.Write "		</div>"&Vbcrlf
			Response.Write "		<div class=""area"">"&Vbcrlf
			IF sortName<>"" Then
				Response.Write "			<p class=""tt cate"">["&ReplaceNoHtml(sortName)&"]</p>"&Vbcrlf
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