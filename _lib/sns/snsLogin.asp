<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<!--#include virtual = _lib/enc/base64.asp-->
<%
sns = uf_getRequestProc(Request("sns"), "char", "", "")
snsID = uf_getRequestProc(Request("snsID"), "char", "", "")

IF sns="" Or snsID="" Then
	Response.Wriet "Fail"
	Response.END
End IF

'Session("UserIdx") = "0"
'Session("UserID") = "guest"
'Session("UserName") = "게스트"
'Session("MemberShip") = "0"
'Response.Write "success"

Set Cmd=CreateCommand(dbcon,"UP_snsUserLogin",adCmdStoredProc)
With Cmd
	.Parameters.Append CreateInputParameter("@sns",adVarWChar,15,sns)
	.Parameters.Append CreateInputParameter("@snsID",adVarWChar,100,snsID)
	.Parameters.Append CreateInputParameter("@WIP",adVarchar,50,WIP)
	.Parameters.Append CreateOutPutParameter("@result",AdInteger,4)
	.Parameters.Append CreateOutPutParameter("@Username",adVarWChar,20)
	.Parameters.Append CreateOutPutParameter("@Memsort",adTinyint,1)
	.execute
End With
Result=Cmd.Parameters("@result").value
UserName=Cmd.Parameters("@Username").value
MemSort=Cmd.Parameters("@Memsort").value

IF Result=0 Then
	sns = strAnsi2Unicode(Base64encode(strUnicode2Ansi(sns)))
	snsID = strAnsi2Unicode(Base64encode(strUnicode2Ansi(snsID)))
	Session("sEncINFO") = sns&"|"&snsID

	Response.Write "noMember"
	Response.End
Else
	Session("UserIdx") = Result
	Session("UserID") = ID
	Session("UserName") = UserName
	Session("MemberShip") = MemSort

	Response.Write "success"
	Response.End
End IF
%>