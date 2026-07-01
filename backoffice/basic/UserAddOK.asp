<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "intra" : subMenuCode = "intra" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Sort = uf_getRequestProc(Request("sort"),"int","2","1")
Idx = uf_getRequestProc(Request("idx"),"int","","0")

id = uf_getRequestProc(Request("id"),"char","15","")
pwd = uf_getRequestProc(Request("pwd"),"char","15","")
name = uf_getRequestProc(Request("name"),"char","40","")
Company = uf_getRequestProc(Request("Company"),"char","100","")
Tel = uf_getRequestProc(Request("Tel"),"char","30","")
email = uf_getRequestProc(Request("email"),"char","100","")

set cmd=CreateCommand(dbcon,"AP_intraUserSet",adCmdStoredProc)
With cmd
	.Parameters.Append CreateInputParameter("@Sort",adInteger,4,Sort)
	.Parameters.Append CreateInputParameter("@Idx",adInteger,4,IDX)
	.Parameters.Append CreateInputParameter("@id",adVarWChar,15,ID)
	.Parameters.Append CreateInputParameter("@Name",adVarWChar,40,Name)
	.Parameters.Append CreateInputParameter("@pwd",adVarWChar,15,Pwd)
	.Parameters.Append CreateInputParameter("@email",adVarWChar,100,Email)
	.Parameters.Append CreateInputParameter("@Company",adVarWChar,100,Company)
	.Parameters.Append CreateInputParameter("@Tel",adVarWChar,30,Tel)
	.Parameters.Append CreateOutputParameter("@result",adInteger,4)
	.execute
End With
Result=Cmd.Parameters("@result").Value

Set Cmd=Nothing
DBcon.Close
Set DBcon=Nothing

IF Result=0 Then
	strLocation="top.location.href='intraUser.asp'"
	Response.Write ExecJavaAlert("사용자가 등록되었습니다.",3)
ElseIF Result=1 then
	Response.Write ExecJavaAlert("중복된 아이디입니다..\n\n확인후 다시 시도해주세요","")
ElseIF Result=2 then
	strLocation="top.location.reload();"
	Response.Write ExecJavaAlert("사용자정보가 정상적으로 수정되었습니다.","3")
End IF
%>