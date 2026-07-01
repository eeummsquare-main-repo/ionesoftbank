<%
IF pageSize="" Then
	pageSize=uf_getRequest(Request("pageSize"),"int","","10")
End IF
page=uf_getRequest(Request("page"),"int","","1")
search=uf_getRequest(Request("search"),"int","","0")
searchStr=uf_getRequest(Request("searchStr"),"char","50","")
oSearchStr = Request("searchstr")
serboardsort=uf_getRequest(Request("serboardsort"),"int","","")

IF isSetBSort=True Then
	serboardsort = CheckBoardsortAndRedim(BBsCode,serBoardSort)
End IF

IF BBsCode="" Or BBsCode=false Then BBsCode=1
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

PageStr="pageSize="&pageSize&"&search="&search&"&serboardsort="&serboardsort&"&searchStr="&searchStr

Call HK_BBSSetup(BBsCode)
'BBsViewModeChk("list")

'TopSortListTag = GetBoardSortList(BBsCode,serBoardSort)
'BBsSelectField = GetBoardSortSh(BBsCode,serboardsort)

IF BBsSelectField<>"" Then isListSortHidden = False

Sql="SELECT Top "&PageSize&" idx, title, viewdate, writer, TopYn, readnum, publicYN, pwd, status, cate1, DBO.FN_CODENAME(cate1, cate2) AS cateNm2, comDate, statusChDate FROM BBSLIST WHERE isDisplay=1 AND relevel='A' AND boardidx="&BBsCode & StrWhere&" And idx NOT IN (select top "&(Page-1)*PageSize&" idx from bbsList where isDisplay=1 AND relevel='A' AND boardidx="&BBsCode & StrWhere&" order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, Idx DESC) order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, Idx DESC"

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
		For i=0 To UBound(Allrec,2)
			TopTag=Num : PublicIcon="" : NewIcon="" : LevelICon="" : LevelView="" : DownTag = "" : CommentCnt="" : TopClass="" : consultBtn=""

			idx = changeBlank(Allrec(0,i))
			title = changeBlank(Allrec(1,i))
			viewdate = changeBlank(Allrec(2,i))
			writer = changeBlank(Allrec(3,i))
			TopYn = changeBlank(Allrec(4,i))
			readnum = changeBlank(Allrec(5,i))
			publicYN = changeBlank(Allrec(6,i))
			pwd = changeBlank(Allrec(7,i))
			status = changeBlank(Allrec(8,i))
			cateNm1 = changeBlank(Allrec(9,i))
			cateNm2 = changeBlank(Allrec(10,i))
			comDate = changeBlank(Allrec(11,i))
			statusChDate = changeBlank(Allrec(12,i))

			IF TopYn="True" Then TopTag="<strong class=""notice_icon"">"&LangPack_Notice&"</strong>" : TopClass="notis"
			IF publicYN="True" Then PublicIcon="<img src=""../images/sub/lock_icon.png"" class=""icon"" alt=""secret"" /> "

			IF publicYN="True" AND Not(pwd="" Or IsNull(pwd)) Then
				LingTag="<a href='#jLink' onclick=""goPwdpage('view',"&idx&")"" class=""title onlyLine1"">"
			Else
				LingTag="<a href='?mode=view&page="&Page&"&"&PageStr&"&idx="&idx&"' class=""title onlyLine1"">"
			End IF

			Response.Write "<tr class="""&TopClass&""">"&Vbcrlf
			Response.Write "	<td class=""td_num2"">"&TopTag&"</td>"&Vbcrlf

			Response.Write "	<td class=""btm"">"&convertSpace(getBBSCateNm1(cateNm1),"-")&"</td>"&Vbcrlf
			Response.Write "	<td class=""btm"">"&convertSpace(ReplaceNoHtml(cateNm2),"-")&"</td>"&Vbcrlf

			Response.Write "	<td class=""td_subject"">"&Vbcrlf
			Response.Write "		"&LevelICon & LingTag & PublicIcon & ReplaceNoHtml(title) & "</a>"&Vbcrlf
			Response.Write "	</td>"&Vbcrlf
			Response.Write "	<td class=""btm""><span class=""sv_member"">"&ReplaceNoHtml(writer)&"</span></td>"&Vbcrlf
			Response.Write "	<td class=""btm"">"&uf_ConvertDateFormat(viewdate,91)&"</td>"&Vbcrlf
			Response.Write "	<td class=""btm"">"&convertSpace(uf_ConvertDateFormat(statusChDate,91),"-")&"</td>"&Vbcrlf
			Response.Write "	<td class=""btm"">"&convertSpace(uf_ConvertDateFormat(comDate,91),"-")&"</td>"&Vbcrlf

			IF status="0" Then
				Response.Write "<td class=""btm state""><span class=""icon ing"">"&getApplyStatus(status)&"</span></td>"&Vbcrlf
			Else
				Response.Write "<td class=""btm state""><span class=""icon end"">"&getApplyStatus(status)&"</span></td>"&Vbcrlf
			End IF
			Response.Write "</tr>"&Vbcrlf

			Num=Num-1
		Next
	Else
		Response.Write "<tr class=""tr noPost""><td class=""td"" colspan=""9""><p>"&LangPack_PostNotFoundMsg&"</p></td></tr>"&Vbcrlf
	End IF
End Function
%>