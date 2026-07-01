<%
Call HK_BBSSetup(BBsCode)
BBsViewModeChk("reply")
BbsAdminChk()

Ref=Request("Ref")
ReLevel=Request("ReLevel")
pageSize=uf_getRequest(Request("pageSize"),"int","","10")
page=uf_getRequest(Request("page"),"int","","1")

idx=uf_getRequest(Request("idx"),"int","","")
seritemidx=uf_getRequest(Request("seritemidx"),"int","","")
serstoreidx=uf_getRequest(Request("serstoreidx"),"int","","")
serboardsort=uf_getRequest(Request("serboardsort"),"int","","")
search=uf_getRequest(Request("search"),"int","4","1")
searchStr=uf_getRequest(Request("searchStr"),"char","50","")

Sql="Select publicYN FROM BBslist Where idx="&Idx
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Response.write ExecJavaAlert(Langpack_WrongMsg, 0)
	Response.End
Else
	IF Rs(0)="True" Then
		Response.write ExecJavaAlert(Langpack_WrongMsg, 0)
		Response.End
	End IF
End IF
%>