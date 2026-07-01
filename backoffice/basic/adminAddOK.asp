<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim Sort
Sort = uf_getRequest(Request("sort"),"int","","1")

IF Sort<>99 Then
	topMenuCode = "admin" : subMenuCode = "admin"
End IF
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Cmd
Dim idx
Dim id, pwd, name, username, tel, email, m_pwd
Dim Result, strLocation

id = uf_getRequestProc(Request("id"),"char","15","")
pwd = uf_getRequestProc(Request("pwd"),"char","15","")
m_pwd = uf_getRequestProc(Request("m_pwd"),"char","15","")
name = uf_getRequestProc(Request("name"),"char","10","")
username = uf_getRequestProc(Request("username"),"char","50","")
tel = uf_getRequestProc(Request("tel"),"char","15","")
email = uf_getRequestProc(Request("email"),"char","100","")
pubMenu = uf_getRequestProc(Replace(Request("pubMenu"),", ",","),"char","4000","")
memsort = uf_getRequestProc(Request("memsort"),"int","2","0")

IF Sort=99 Then		'내정보수정
	idx=Session("acountidx")
Else
	idx = uf_getRequestProc(Request("idx"),"int","","0")

'	IF CSTR(idx)="0" Then
'		Response.write Execjavaalert("접근할수 없는 사용자코드입니다.\n다시시도해주세요.",0)
'		Response.end
'	End IF
End IF

set cmd=CreateCommand(dbcon,"AP_adminSet",adCmdStoredProc)
With cmd
	.Parameters.Append CreateInputParameter("@Sort",adInteger,4,Sort)
	.Parameters.Append CreateInputParameter("@Idx",adInteger,4,IDX)
	.Parameters.Append CreateInputParameter("@id",adVarWChar,15,ID)
	.Parameters.Append CreateInputParameter("@Name",adVarWChar,10,Name)
	.Parameters.Append CreateInputParameter("@username",adVarWChar,50,username)
	.Parameters.Append CreateInputParameter("@m_pwd",adVarWChar,15,m_pwd)
	.Parameters.Append CreateInputParameter("@pwd",adVarWChar,15,Pwd)
	.Parameters.Append CreateInputParameter("@email",adVarWChar,100,Email)
	.Parameters.Append CreateInputParameter("@tel",adVarWChar,15,tel)
	.Parameters.Append CreateInputParameter("@pubMenu",adVarWChar,4000,pubMenu)
	.Parameters.Append CreateInputParameter("@memsort",adInteger,1,memsort)
	.Parameters.Append CreateOutputParameter("@result",adInteger,4)
	.execute
End With
Result=Cmd.Parameters("@result").Value

Set Cmd=Nothing
DBcon.Close
Set DBcon=Nothing

IF Sort=99 Then
	IF Result=98 Then
		Response.Write "dupID"
	ElseIF Result=2 then
		Response.Write "success"
		Session("acountcode")=ID
		Session("acountname")=name
	ElseIF Result=99 then
		Response.Write "passError"
	End IF
Else
	IF Result=0 Then
		strLocation="top.location.href='adminlist.asp'"
		Response.Write ExecJavaAlert("관리자가 등록되었습니다.",3)
	ElseIF Result=1 then
		Response.Write ExecJavaAlert("중복된 아이디입니다..\n\n확인후 다시 시도해주세요","")
	ElseIF Result=2 then
		strLocation="top.location.reload();"
		Response.Write ExecJavaAlert("관리자정보가 정상적으로 수정되었습니다.","3")

		IF CStr(Session("acountidx")) = CStr(idx) Then
			Session("acountcode")=ID
			Session("acountname")=name
		End IF
	End IF
END IF
%>