<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
idx=Request("idx")
pwd=Request("pwd")
Session("boardPass")=pwd

Sql="Select writer,title,content,pwd,IsNull(UserIdx,0) As Useridx,relevel,adwrite,boardsort,imgNames,email,editorYN,tel,note1,note2,note3,note4 FROM BBslist Where Idx="&Idx
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Response.Write "게시물 정보를 찾을수 없습니다"
	Response.End
Else
	AdWrite=Rs("adwrite")
	UserIdx=Rs("useridx")
	dbPwd=Rs("pwd")

	souchk=0

	IF pwd="" Then
		IF CStr(UserIdx)=CStr(Session("useridx")) THen souchk=souchk+1
		AlertMsg="작성자 정보와 일치하지 않습니다."
	Else
		IF pwd=dbPwd THen souchk=souchk+1
		AlertMsg="비밀번호가 일치하지 않습니다."
	End IF

	IF souchk=false Then
		Response.Write AlertMsg
		Response.End
	End IF
End IF
%>