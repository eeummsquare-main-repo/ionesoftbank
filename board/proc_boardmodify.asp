<%
pageSize=uf_getRequest(Request("pageSize"),"int","","10")
page=uf_getRequest(Request("page"),"int","","1")
seritemidx=uf_getRequest(Request("seritemidx"),"int","","")
serstoreidx=uf_getRequest(Request("serstoreidx"),"int","","")
serboardsort=uf_getRequest(Request("serboardsort"),"int","","")
search=uf_getRequest(Request("search"),"int","4","1")
searchStr=uf_getRequest(Request("searchStr"),"char","50","")
idx=uf_getRequest(Request("idx"),"int","","")
inputPwd=Session("boardPass")

IF BBsCode=false Or Idx="" Then 
	Response.write ExecJavaAlert(Langpack_WrongMsg, 0)
	Response.End
End IF
Call HK_BBSSetup(BBsCode)

Sql="Select writer,title,content,pwd,IsNull(UserIdx,0) As Useridx,relevel,adwrite,boardsort,imgNames,email,editorYN,tel,note1,note2,note3,note4,publicYN,stars,itemidx, linkurl, company FROM BBslist Where Idx="&Idx

Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Response.Write ExecJavaAlert(Langpack_WrongMsg, 0)
	Response.End
Else
	writer=ReplaceTextField(Rs("writer")) : title=ReplaceTextField(Rs("title")) : pwd=Rs("pwd")
	UserIdx=Rs("useridx") : relevel=Rs("relevel") : AdWrite=Rs("adwrite") : boardsort=Rs("boardsort")
	imgNames=Rs("imgNames") : publicYN=Rs("publicYN")
	itemidx=Rs("itemidx")
	linkurl=Rs("linkurl")

	'=========에디터사용 여부에 따른 내용변경==========
	editorYN=Rs("editorYN") : content=Rs("content")

	IF editorYN=1 AND isWriteEditorUse=True Then
		Content = ReplaceNoHtml(Content)
	ElseIF editorYN=1 AND isWriteEditorUse=False Then
		Content = RemoveUnallowTags(((Content)),"")
	ElseIF editorYN=0 AND isWriteEditorUse=True Then
		Content = ReplaceBr(ReplaceNoHtml(ReplaceNoHtml(Content)))
	Else
		Content = ReplaceNoHtml(Content)
	End IF
	'==================================================

	tel=Split(ReplaceTextField(Rs("tel")),"-")
	email=Split(ReplaceTextField(Rs("email")),"@")
	note1=ReplaceTextField(Rs("note1"))
	note2=ReplaceTextField(Rs("note2"))
	note3=ReplaceTextField(Rs("note3"))
	note4=ReplaceTextField(Rs("note4"))
	company=ReplaceTextField(Rs("company"))

	stars = Rs("stars")

	IF UBound(Tel)<>2 Then ReDim Tel(2)
	IF UBound(Email)<>1 Then ReDim Email(1)

	IF isSetBSort<>True Then
		BBsSort=GetBoardSort(BBsCode,BoardSort,ReLevel)
	End IF

	souchk=0

	IF AdWrite="False" Then
		IF inputPwd="" Then
			IF CStr(UserIdx)=CStr(Session("useridx")) THen souchk=souchk+1
			AlertMsg = Langpack_AuthErrorMsg_Modify
		Else
			IF inputPwd=Pwd THen souchk=souchk+1
			AlertMsg = Langpack_PassErrorMsg
		End IF
	Else
		AlertMsg = Langpack_AuthErrorMsg_Modify
	End IF

	IF souchk=false Then
		Response.Write ExecJavaalert(AlertMsg,0)
		Response.End
	End IF

	'=============파일정보Get======================================
	Set Rs=Server.CreateObject("ADODB.RecordSet")
	Sql="Select idx,filenames From BBSData Where bidx="&Idx
	Rs.Open Sql,DBcon,1

	IF Not(Rs.Bof Or Rs.Eof) Then FileRec=Rs.Getrows()
	Rs.Close
	'==============================================================

End IF
%>