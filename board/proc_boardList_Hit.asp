<%
IF BBsCode="" Or BBsCode=false Then BBsCode=1

Call HK_BBSSetup(BBsCode)
'BBsViewModeChk("list")

'TopSortListTag = GetBoardSortList(BBsCode,serBoardSort)
BBsSelectField = GetBoardSortSh(BBsCode,serboardsort)

IF BBsSelectField<>"" Then isListSortHidden = False

StrWhere = StrWhere & " AND sortDate >= '"&DateAdd("y",-7,Date())&"'"

Sql="SELECT Top 10 bbsList.idx, title, viewdate, writer, relevel, DelYN, TopYn, readnum, publicYN, pwd, sortName, (select Count(*) From CommentAdmin Where boardidx=bbsList.idx) AS CommentCnt, imgnames, filenames, startdate, enddate, thumbcontent, note1, note2, replyCnt, linkurl, newWin1, isimp, likeCnt, dbo.fn_cLevelCd(useridx) AS cMemLevel FROM View_BBslistWithFileData AS bbsList Left Outer Join BoardSort ON boardsort=boardsort.idx WHERE isDisplay=1 AND relevel='A' AND bbsList.boardidx="&BBsCode & StrWhere&" ORDER BY readnum DESC, likeCnt DESC, sortDate DESC, bbsList.Idx DESC"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows

Dim basicColumnCnt : basicColumnCnt = 7

Function PT_BoardList
	Dim i,Num,Depth,j,TitleView,TopTag,NewIcon

	IF IsArray(Allrec) Then
		Num = CLng(UBound(Allrec,2)) + 1

		For i=0 To UBound(Allrec,2)
			TopTag=Num : PublicIcon="" : NewIcon="" : LevelICon="" : LevelView="" : DownTag = "" : CommentCnt="" : TopClass="" : consultBtn="" : LinkTag="" : cMemLevel=""

			note1 = Allrec(17,i)
			note2 = Allrec(18,i)
			ReplyCnt = Allrec(19,i)

			linkurl = changeBlank(Allrec(20,i))
			newWin1 = changeBlank(Allrec(21,i))
			isimp = changeBlank(Allrec(22,i))
			likeCnt = changeBlank(Allrec(23,i))
			cMemLevel = changeBlank(Allrec(24,i))

			cLevelClass = ""
			IF CStr(cMemLevel) > "0" Then cLevelClass = "mb_lv lv0"&cMemLevel

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
					LinkTag="<a href='#jLink' onclick=""goPwdpage('view',"&Allrec(0,i)&")"" class=""title onlyLine1"">"
				Else
					LinkTag="<a href='?mode=view&idx="&Allrec(0,i)&"' class=""title onlyLine1"">"
				End IF
			End IF

			Response.Write "<tr class="""&TopClass&""">"&Vbcrlf
			Response.Write "	<td class=""td_num2"">"&TopTag&"</td>"&Vbcrlf
			Response.Write "	<td class=""btm"">"&ReplaceNoHtml(Allrec(10,i))&"</td>"&Vbcrlf
			Response.Write "	<td class=""td_subject"">"&Vbcrlf
			Response.Write "		"&LevelICon & LinkTag & impTag & PublicIcon & ReplaceNoHtml(Allrec(1,i)) & CommentCnt & "</a>"&Vbcrlf
			Response.Write "	</td>"&Vbcrlf
			Response.Write "	<td class=""btm""><span class="""&cLevelClass&""">"&ReplaceNoHtml(Allrec(3,i))&"</span></td>"&Vbcrlf
			Response.Write "	<td class=""btm"">"&Left(Allrec(2,i),10)&"</td>"&Vbcrlf
			Response.Write "	<td class=""btm"">"&Allrec(7,i)&"</td>"&Vbcrlf
			Response.Write "	<td class=""btm"">"&likeCnt&"</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf

			Num=Num-1
		Next
	Else
		Response.Write "<tr class=""tr noPost""><td class=""td"" colspan="""&basicColumnCnt&"""><p>최근 7일간 등록된 게시글이 없습니다.</p></td></tr>"&Vbcrlf
	End IF
End Function
%>