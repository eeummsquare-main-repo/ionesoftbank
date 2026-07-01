<%
IF pageSize="" Then 
	pageSize=uf_getRequest(Request("pageSize"),"int","","10")
End IF
page=uf_getRequest(Request("page"),"int","","1")
seritemidx=uf_getRequest(Request("seritemidx"),"int","","")
artistidx=uf_getRequest(Request("artistidx"),"int","","")
search=uf_getRequest(Request("search"),"int","","0")
searchStr=uf_getRequest(Request("searchStr"),"char","50","")
serboardsort=uf_getRequest(Request("serboardsort"),"int","","")

IF isSetBSort=True Then
	serboardsort = CheckBoardsortAndRedim(BBsCode,serBoardSort)
End IF

IF BBsCode="" Or BBsCode=false Then BBsCode=1
IF seritemidx<>"" Then StrWhere = " AND itemidx="&seritemidx&" "
IF serboardsort<>"" Then StrWhere = " AND boardsort="&serboardsort&" "
IF artistidx<>"" Then StrWhere = " AND artistidx="&artistidx&" "
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

PageStr="pageSize="&pageSize&"&seritemidx="&seritemidx&"&artistidx="&artistidx&"&serboardsort="&serboardsort&"&search="&search&"&searchStr="&searchStr

Call HK_BBSSetup(BBsCode)
'BBsViewModeChk("list")

TopSortListTag = GetBoardSortList(BBsCode,serBoardSort)
BBsSelectField = GetBoardSortSh(BBsCode,serboardsort)

IF BBsSelectField<>"" Then isListSortHidden = False

Sql="SELECT Top "&PageSize&" bbsList.idx, title, viewdate, writer, readnum, sortName, filenames, content, note1, linkurl, newWin1 FROM View_BBslistWithFileData AS bbsList Left Outer Join BoardSort ON boardsort=boardsort.idx WHERE isDisplay=1 AND relevel='A' AND bbsList.boardidx="&BBsCode & StrWhere&" And bbsList.idx NOT IN (select top "&(Page-1)*PageSize&" idx from bbsList where isDisplay=1 AND relevel='A' AND boardidx="&BBsCode & StrWhere&" order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, Idx DESC) order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, bbsList.Idx DESC"

Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(1) from bbslist where isDisplay=1 AND relevel='A' AND boardidx="&BBsCode & StrWhere)
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
	Allrec=Rs.GetRows
	Count=Record_Cnt(0)
Else
	Count=0
	TotalPage=1
End If
Rs.Close

Dim basicColumnCnt : basicColumnCnt = 4		'기본 TD 수
IF isListWriterHidden = False Then basicColumnCnt = basicColumnCnt + 1

'<img src="../images/front/icon_hot.png" class="icon" alt="hot" /><img src="../images/front/icon_file.png" class="icon" alt="file" />
Function PT_BoardList
	Dim i,Num,Depth,j,TitleView,TopTag,NewIcon
	Num=GetTextNumDesc(Page,Pagesize,Count)
	IF IsArray(Allrec) Then
		Dim idx, title, viewdate, writer, readnum, sortName, filenames, content, note1, linkurl, newWin1
		For i=0 To UBound(Allrec,2)
			idx = changeBlank(Allrec(0,i))
			title = changeBlank(Allrec(1,i))
			viewdate = changeBlank(Allrec(2,i))
			writer = changeBlank(Allrec(3,i))
			readnum = changeBlank(Allrec(4,i))
			sortName = changeBlank(Allrec(5,i))
			filenames = changeBlank(Allrec(6,i))
			content = changeBlank(Allrec(7,i))
			note1 = changeBlank(Allrec(8,i))
			linkurl = changeBlank(Allrec(9,i))
			newWin1 = changeBlank(Allrec(10,i))

			downTag = "" : LinkTag = ""
			IF filenames<>"" Then downTag = "<a href=""/_lib/download.asp?downfile="&filenames&"&path=board"" download=""""><img src=""/images/sub/online__dw.png"" alt=""""></a>"
			IF linkurl<>"" Then LinkTag = "<a href="""&linkurl&""" target="""&iif_compare(newWin1, 1, "_blank")&"""><img src=""/images/sub/online__link.png"" alt=""""></a>"

			Response.Write "<li>"&Vbcrlf
			Response.Write "	<div class=""qWrap"">"&Vbcrlf
			Response.Write "		<div class=""wd1"">"&Num&"</div>"&Vbcrlf
			Response.Write "		<div class=""wd2"">"&ReplaceNoHtml(sortName)&"</div>"&Vbcrlf
			Response.Write "		<div class=""wd3"">"&ReplaceNoHtml(note1)&"</div>"&Vbcrlf
			Response.Write "		<div class=""wd4"">"&Vbcrlf
			Response.Write "			<p>"&ReplaceNoHtml(title)&"</p>"&Vbcrlf
			Response.Write "		</div>"&Vbcrlf
			Response.Write "		<div class=""wd5"">"&downTag&"</div>"&Vbcrlf
			Response.Write "		<div class=""wd6"">"&LinkTag&"</div>"&Vbcrlf
			Response.Write "	</div>"&Vbcrlf
			Response.Write "	<div class=""aWrap"">"&Vbcrlf
			Response.Write "		<div class=""q"">"&ReplaceNoHtml(title)&"</div>"&Vbcrlf
			Response.Write "		<div class=""a"">"&content&"</div>"&Vbcrlf
			Response.Write "	</div>"&Vbcrlf
			Response.Write "</li>"&Vbcrlf

			Num=Num-1
		Next
	Else
		Response.Write "<li class=""tr noPost""><p>"&LangPack_PostNotFoundMsg&"</p></li>"&Vbcrlf
	End IF
End Function
%>