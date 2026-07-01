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

Sql="SELECT Top "&PageSize&" bbsList.idx, title, viewdate, writer, relevel, DelYN, TopYn, readnum, publicYN, pwd, sortName, (select Count(*) From CommentAdmin Where boardidx=bbsList.idx) AS CommentCnt, imgnames, filenames, startdate, enddate, thumbcontent, note1, note2, replyCnt, linkurl, newWin1, isimp, likeCnt FROM View_BBslistWithFileData AS bbsList Left Outer Join BoardSort ON boardsort=boardsort.idx WHERE isDisplay=1 AND relevel='A' AND bbsList.boardidx="&BBsCode & StrWhere&" And bbsList.idx NOT IN (select top "&(Page-1)*PageSize&" idx from bbsList where isDisplay=1 AND relevel='A' AND boardidx="&BBsCode & StrWhere&" order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, Idx DESC) order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, bbsList.Idx DESC"

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
IF isListLike = True Then basicColumnCnt = basicColumnCnt + 1
IF BBscode="5" OR BBscode="7" OR BBscode="15" OR BBscode="17" OR BBscode="25" OR BBscode="26" OR BBscode="27" Then basicColumnCnt = basicColumnCnt + 1

'<img src="../images/front/icon_hot.png" class="icon" alt="hot" /><img src="../images/front/icon_file.png" class="icon" alt="file" />
Function PT_BoardList
	Dim i,Num,Depth,j,TitleView,TopTag,NewIcon
	Num=GetTextNumDesc(Page,Pagesize,Count)
	IF IsArray(Allrec) Then
		For i=0 To UBound(Allrec,2)
			TopTag=Num : PublicIcon="" : NewIcon="" : LevelICon="" : LevelView="" : DownTag = "" : CommentCnt="" : TopClass="" : consultBtn="" : LinkTag=""

			note1 = Allrec(17,i)
			note2 = Allrec(18,i)
			ReplyCnt = Allrec(19,i)

			linkurl = changeBlank(Allrec(20,i))
			newWin1 = changeBlank(Allrec(21,i))
			isimp = changeBlank(Allrec(22,i))
			likeCnt = changeBlank(Allrec(23,i))

			impTag = "" : IF isimp="1" Then impTag = "<span class=""bbsimp"">중요</span>"
			IF linkurl<>"" Then LinkTag = "<a href="""&linkurl&""" target="""&iif_compare(newWin1, 1, "_blank")&"""><img src=""/images/sub/online__link.png"" alt=""""></a>"

			IF Len(Allrec(4,i))<>1 Then
				LevelICon="<img src=""../../images/front/re.gif"" alt="""" /><span class=""ans"">"&LangPack_Reply&"</span>"
				LevelView="reply"
			End IF

			IF Allrec(6,i)="True" Then TopTag="<strong class=""notice_icon"">"&LangPack_Notice&"</strong>" : TopClass="notis"
			IF CDate(Allrec(2,i))>DateAdd("d",-2,Date()) Then NewIcon="<img src=""../images/sub/new_icon.png"" class=""icon"" alt=""new"" />"
			IF Allrec(8,i)="True" AND Len(Allrec(4,i))=1 Then PublicIcon="<img src=""../images/sub/lock_icon.png"" class=""icon"" alt=""secret"" /> "

			IF Allrec(11,i)<>0 Then CommentCnt="<span class=""comment"">["&Allrec(11,i)&"]</span>"

			IF Allrec(5,i)="True" Then
				TitleView = LangPack_PostDeletedMsg
			Else
				IF Allrec(8,i)="True" AND Not(Allrec(9,i)="" Or IsNull(Allrec(9,i))) Then
					LingTag="<a href='#jLink' onclick=""goPwdpage('view',"&Allrec(0,i)&")"" class=""title onlyLine1"">"
				Else
					LingTag="<a href='?mode=view&page="&Page&"&"&PageStr&"&idx="&Allrec(0,i)&"' class=""title onlyLine1"">"
				End IF
			End IF

			'IF Allrec(13,i)<>"" Then DownTag = "<i class=""fa fa-floppy-o"" aria-hidden=""true"" onclick=""location.href='/_lib/download.asp?downfile="&Allrec(13,i)&"&path=board'""></i>"
			IF Allrec(13,i)<>"" Then DownTag = "<a href=""/_lib/download.asp?downfile="&Allrec(13,i)&"&path=board""><img src=""/images/sub/online__dw.png"" alt=""""></a>"

			IF Allrec(14,i) > CStr(Date()) Then
				statusIMG = "<span class=""icon end"">"&LangPack_Expected&"</span>"&Vbcrlf
			ElseIF Allrec(14,i) <= CStr(Date()) And Allrec(15,i) >= CStr(Date()) Then
				statusIMG = "<span class=""icon ing"">"&LangPack_Progress&"</span>"&Vbcrlf
				consultBtn = "<a href=""javascript:openEventPop("&Allrec(0,i)&")""><img src=""../../images/event/request.gif"" alt="""&LangPack_wBtnApply&"""/></a>"
			Else
				statusIMG = "<span class=""icon end"">"&LangPack_Deadline&"</span>"&Vbcrlf
			End IF

			Response.Write "<tr class="""&TopClass&""">"&Vbcrlf
			Response.Write "	<td class=""td_num2"">"&TopTag&"</td>"&Vbcrlf
			IF isListSortHidden = False Then
				Response.Write "	<td class=""btm"">"&ReplaceNoHtml(Allrec(10,i))&"</td>"&Vbcrlf
			End IF
			Response.Write "	<td class=""td_subject"">"&Vbcrlf
			Response.Write "		"&LevelICon & LingTag & impTag & PublicIcon & ReplaceNoHtml(Allrec(1,i)) & CommentCnt & "</a>"&Vbcrlf
			Response.Write "	</td>"&Vbcrlf

			IF isListWriterHidden = False Then
				IF BBscode="50" Then
					Response.Write "	<td class=""btm""><span class=""mb_lv lv01"">"&ReplaceNoHtml(Allrec(3,i))&"</span></td>"&Vbcrlf
				Else
					Response.Write "	<td class=""btm""><span class=""sv_member"">"&ReplaceNoHtml(Allrec(3,i))&"</span></td>"&Vbcrlf
				End IF
			End IF

			IF isListDateHidden = False Then
				Response.Write "	<td class=""btm"">"&Left(Allrec(2,i),10)&"</td>"&Vbcrlf
			End IF
			IF isListHitHidden = False Then
				Response.Write "	<td class=""btm"">"&Allrec(7,i)&"</td>"&Vbcrlf
			End IF

			IF isListDown = True Then
				Response.Write "<td class=""btm file"">"&DownTag&"</td>"&Vbcrlf
			End If
			
			IF BBscode="5" OR BBscode="7" OR BBscode="15" OR BBscode="17" OR BBscode="25" OR BBscode="26" OR BBscode="27" OR BBscode="30" Then
				Response.Write "<td class=""btm file"">"&LinkTag&"</td>"&Vbcrlf
			End IF

			IF isListTermStats = True Then
				Response.Write "	<td class=""btm"">"&Allrec(14,i)&" ~ "&Allrec(15,i)&"</td>"&Vbcrlf
				Response.Write "	<td class=""btm"">"&statusIMG&"</td>"&Vbcrlf
			End IF
			IF isListReplyStats = True Then
				IF ReplyCnt > 1 Then
					Response.Write "<td class=""btm state""><span class=""icon end"">"&LangPack_wReplyCom&"</span></td>"&Vbcrlf
				Else
					Response.Write "<td class=""btm state""><span class=""icon ing"">"&LangPack_wReplyWaiting&"</span></td>"&Vbcrlf
				End IF
			End IF

			IF isListLike Then
				Response.Write "	<td class=""btm"">"&likeCnt&"</td>"&Vbcrlf
			End IF
			Response.Write "</tr>"&Vbcrlf

			Num=Num-1
		Next
	Else
		Response.Write "<tr class=""tr noPost""><td class=""td"" colspan="""&basicColumnCnt&"""><p>"&LangPack_PostNotFoundMsg&"</p></td></tr>"&Vbcrlf
	End IF
End Function
%>