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
BBsSelectField = GetBoardSortSh(BBsCode,serboardsort)

IF BBsSelectField<>"" Then isListSortHidden = False

Sql="SELECT Top "&PageSize&" bbsList.idx, title, viewdate, writer, relevel, DelYN, TopYn, readnum, publicYN, pwd, sortName, (select Count(*) From CommentAdmin Where boardidx=bbsList.idx) AS CommentCnt, imgnames, filenames, startdate, enddate, thumbcontent, note1, note2, note3, note4, note5, always, deadline FROM View_BBslistWithFileData AS bbsList Left Outer Join BoardSort ON boardsort=boardsort.idx WHERE isDisplay=1 AND relevel='A' AND bbsList.boardidx="&BBsCode & StrWhere&" And bbsList.idx NOT IN (select top "&(Page-1)*PageSize&" idx from bbsList where isDisplay=1 AND relevel='A' AND boardidx="&BBsCode & StrWhere&" order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, Idx DESC) order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, bbsList.Idx DESC"

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

Function PT_BoardList
	Dim i,Num,Depth,j,TitleView,TopTag,NewIcon
	Num=GetTextNumDesc(Page,Pagesize,Count)
	IF IsArray(Allrec) Then
		For i=0 To UBound(Allrec,2)
			TopTag=Num : PublicIcon="" : NewIcon="" : LevelICon="" : LevelView="" : DownTag = "" : CommentCnt="" : TopClass="" : consultBtn="" : LinkTag=""

			startdate = changeBlank(Allrec(14,i))
			enddate = changeBlank(Allrec(15,i))
			note1 = changeBlank(Allrec(17,i))
			note2 = changeBlank(Allrec(18,i))
			note3 = changeBlank(Allrec(19,i))
			note4 = changeBlank(Allrec(20,i))
			note5 = changeBlank(Allrec(21,i))
			always = changeBlank(Allrec(22,i))
			deadline = changeBlank(Allrec(23,i))

			IF Allrec(6,i)="True" Then TopTag="<strong class=""notice_icon"">"&LangPack_Notice&"</strong>" : TopClass="notis"

			IF Allrec(5,i)="True" Then
				TitleView = LangPack_PostDeletedMsg
			Else
				IF Allrec(8,i)="True" AND Not(Allrec(9,i)="" Or IsNull(Allrec(9,i))) Then
					LinkTag="<a href='#jLink' onclick=""goPwdpage('view',"&Allrec(0,i)&")"" class=""title onlyLine1"">"
				Else
					LinkTag="<a href='?mode=view&page="&Page&"&"&PageStr&"&idx="&Allrec(0,i)&"' class=""title onlyLine1"">"
				End IF
			End IF

			IF always="1" Then
				termTag="상시채용"
			ElseIF startdate="" AND enddate="" Then
				termTag="채용시까지"
			ElseIF enddate="" Then
				termTag=""&startDate& " ~ 채용시까지"
			Else
				termTag=""&startdate&" ~ "&enddate&""
			End IF

			LangPack_Progress = "모집중"
	
			IF deadline="1" Then
				termStatus = "<span class=""icon end"">"&LangPack_Deadline&"</span>"
			ElseIF always="1" Then
				termStatus = "<span class=""icon ing"">"&LangPack_Progress&"</span>"
			Else
				IF CStr(Date()) > CStr(enddate) AND enddate<>"" Then							'마감
					termStatus = "<span class=""icon end"">"&LangPack_Deadline&"</span>"
				ElseIF CStr(Date()) < CStr(startdate) AND startdate<>"" Then						'예정
					termStatus = "<span class=""icon end"">"&LangPack_Expected&"</span>"
				Else																								'진행
					termStatus = "<span class=""icon ing"">"&LangPack_Progress&"</span>"
				End IF
			End IF

			Response.Write "<tr class="""&TopClass&""">"&Vbcrlf
			Response.Write "	<td class=""td_num2"">"&LinkTag & TopTag&"</a></td>"&Vbcrlf
			Response.Write "	<td class=""btm"">"&LinkTag & Allrec(2,i)&"</a></td>"&Vbcrlf
			Response.Write "	<td class=""td_subject"">"& LinkTag & ReplaceNoHtml(Note1) & "</a></td>"&Vbcrlf
			Response.Write "	<td class=""btm"">"&LinkTag & termTag&"</a></td>"&Vbcrlf
			Response.Write "	<td class=""btm"">"&LinkTag & ReplaceNoHtml(Note2)&"</a></td>"&Vbcrlf
			Response.Write "	<td class=""btm"">"&LinkTag & ReplaceNoHtml(Note3)&"</a></td>"&Vbcrlf
			Response.Write "	<td class=""btm"">"&LinkTag & ReplaceNoHtml(Note4)&"</a></td>"&Vbcrlf
			Response.Write "	<td class=""btm"">"&LinkTag & ReplaceNoHtml(Note5)&"</a></td>"&Vbcrlf
			Response.Write "	<td class=""btm state"">"&termStatus&"</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num=Num-1
		Next
	Else
		Response.Write "<tr class=""tr noPost""><td class=""td"" colspan=""9""><p>"&LangPack_PostNotFoundMsg&"</p></td></tr>"&Vbcrlf
	End IF
End Function
%>