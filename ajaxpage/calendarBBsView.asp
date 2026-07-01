<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
serDate = uf_getRequest(Request("serDate"),"char","10","")
bbscode = uf_getRequest(Request("bbscode"),"int","","")
idx = uf_getRequest(Request("idx"),"int","","")

Sql="Select title, writer, viewdate, content, Ref, ReLevel, pwd, TopYn, readNum, publicYN, IsNull(UserIdx,0) As Useridx, SortName, imgnames, WIP, vodUrl, editorYN, tel, note1, note2, note3, note4, note5, note6, note7, note4, startdate, enddate, testFile1, testFile2, sortdate, stars, itemidx FROM BBslist AS B Left Outer Join BoardSort AS S ON BoardSort=S.idx Where isDisplay=1 AND b.idx="&Idx
Set Rs=DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	title=Rs("title") : writer=Rs("writer") : regdate=Rs("viewdate")
	Ref=Rs("Ref") : ReLevel=Rs("ReLevel") : Pwd=Rs("pwd") : TopYn=Rs("TopYn")
	ReadNum=Rs("readNum") : PublicYN=Rs("publicYN") : UserIdx=Rs("UserIdx") : SortName=Rs("sortName") : imgnames=Rs("imgnames")
	WIP=Rs("WIP") : vodUrl=Rs("vodUrl")
	startdate=Rs("startdate")
	enddate=Rs("enddate")
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

	'=========에디터사용 여부에 따른 내용변경==========
	editorYN=Rs("editorYN") : content=Rs("content")
	IF editorYN = 0 Then Content = ReplaceBr(ReplaceNoHtml(Content))
	'==================================================

	IF PublicYN="True" Then
		IF inputPwd="" Then
			IF CStr(UserIdx)=CStr(Session("useridx")) THen souchk=souchk+1
			AlertMsg="작성자 정보와 일치하지 않습니다."
		Else
			IF inputPwd=Pwd THen souchk=souchk+1
			AlertMsg="비밀번호가 일치하지 않습니다."
		End IF
		IF souchk=false Then
			Response.Write AlertMsg&"<br>다시시도해주세요."
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

	Set Rs=Nothing
Else
	Response.END
End IF

IF TopYn="True" Then TopTag="[공지]"

Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="SELECT filenames FROM bbsData WHERE bidx="&idx
Rs.Open Sql,DBcon,1
If Not(Rs.Bof Or Rs.Eof) Then FileRec=Rs.GetRows()
Rs.CLose()

DBcon.Close
Set DBcon=Nothing

Function PT_FileArea()
	IF IsArray(FileRec) Then
		Response.Write "<tr>"&Vbcrlf
		Response.Write "	<td class=""file"" colspan=""2"">"&Vbcrlf
		For i=0 To UBound(FileRec,2)
			Response.Write "	<a href=""/_lib/download.asp?downfile="&Server.UrlEncode(FileRec(0,i))&"&path=board"">"&FileRec(0,i)&"</a>"&Vbcrlf
		Next
		Response.Write "	</td>"&Vbcrlf
		Response.Write "</tr>"&Vbcrlf
	End IF
End Function
%>

<div class="board_view mt50">
	<table>
		<thead>
		<tr>
			<th><%=ReplaceNoHtml(Title)%></th>
		</tr>
		<tr>
			<td class="etc">
				<p><strong>등록일</strong><%=Left(Regdate,10)%></p>
				<p><strong>조회수</strong><%=readnum%></p>
			</td>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td class="cont">
				<% IF VodUrl<>"" Then %>
				<div style='text-align:center; padding-bottom:10px;'>
				<iframe width="640" height="360" src="<%=VodUrl%>?autoplay=1" frameborder="0" allowfullscreen></iframe>
				</div>
				<% End IF %>

				<% IF ImgNames<>"" AND HK_ImgViewYN<>"False" Then Response.write "<div style='text-align:center; padding-bottom:20px'><img src='/upload/board/"&ImgNames&"'></div>" %>
				<%
					IF HK_ImgViewYN = True AND IsArray(FileRec) Then
						For i=0 To UBound(FileRec,2)
							Exitsts=UCase(mid(FileRec(0,i),instrrev(FileRec(0,i),".")+1))

							IF Exitsts="JPG" Or Exitsts="JPEG" Or Exitsts="GIF" Or Exitsts="PNG" Then
								Response.write "<div style='text-align:center; padding-bottom:20px'><img src='/upload/board/"&FileRec(0,i)&"'></div>"
							ElseIF Exitsts="MP4" Then
								Response.Write "	<div class=""cVideo"">"&Vbcrlf
								Response.Write "		<video id=""player"" class=""video-js vjs-default-skin"" controls=""controls"" ><source src=""/upload/board/"&FileRec(0,i)&""" type=""video/mp4"" /></video>"&Vbcrlf
								Response.Write "	</div>"&Vbcrlf
							End If
						Next
					End IF
				%>

				<%=Content%>
			</td>
		</tr>
		<%=PT_FileArea()%>
		</tbody>
	</table>
</div>

<div class="btnArea tac">
	<a href="javascript:viewCalendarBBsList();">목록</a>
</div>