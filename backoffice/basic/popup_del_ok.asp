<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "popup" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Idx,Cmd,DelFileName,Result,AlertStr,UploadForm
Dim strLocation

Dim langTitle, langmode
langmode = uf_getRequest(Request("langmode"),"int","1","0")
Idx = uf_getRequest(Request("idx"),"int","","")

Call getLangModeTitle(langmode)

Server.ScriptTimeOut=7200
Set UploadForm=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/Popup/")

Set Cmd=CreateCommand(DBcon,"FM_AP_PopupDel",adCmdStoredProc)
With Cmd
	.Parameters.Append CreateInputParameter("@Idx",adBigint,8,Idx)
	.Parameters.Append CreateOutputParameter("@DelFileName",adVarWchar,50)
	.Parameters.Append CreateOutputParameter("@edNonce",adVarchar,50)
	.Parameters.Append CreateOutputParameter("@Result",adInteger,4)
	.Execute
End With
DelFileName=Cmd.Parameters(1).Value
edNonce=Cmd.Parameters(2).Value
Result=Cmd.Parameters(3).Value

IF Result=0 Then
	IF DelFileName<>"" Then	ImgDelete DelFileName,UploadForm.DefaultPath

	'###### 에디터 등록이미지 삭제처리 ##########
	Call edNonceRemove(edNonce)
	'###### 에디터 등록이미지 삭제처리 ##########

	AlertStr="팝업이 삭제되었습니다."
Else
	AlertStr="팝업삭제중 에러... 다시시도해주세요."
End IF

Set Cmd=Nothing
Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

Application("idx_popmob_0_1_ts") = ""
Application("idx_popmob_0_1_data") = ""

strLocation="popup.asp?langmode="&langmode
Response.Write ExecJavaAlert(AlertStr,2)
%>