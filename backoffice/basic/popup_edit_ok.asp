<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "popup" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim UploadForm,Cmd,Idx
Dim Sort,Pop_w,Pop_h,Pop_title,Content,Tag,Link_Url,Filse,StartDate,EndDate,Result,FileName,AlertStr,DelFileName
Dim pTop, pLeft, imgDel_Chk, imgName, popSort, temCode
Dim strLocation

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/Popup/")

Dim langTitle, langmode
langmode = uf_getRequestProc(UploadForm("langmode"), "int", "1", "0")
Call getLangModeTitle(langmode)

Idx = uf_getRequestProc(UploadForm("idx"), "int", "", "")

Sort = uf_getRequestProc(UploadForm("sort"), "int", "1", "0")
StartDate = uf_getRequestProc(Replace(UploadForm("SearchDate1"),"-",""), "char", "8", "")
EndDate = uf_getRequestProc(Replace(UploadForm("SearchDate2"),"-",""), "char", "8", "")
Pop_w = uf_getRequestProc(UploadForm("pop_w"), "int", "", "0")
Pop_h = uf_getRequestProc(UploadForm("pop_h"), "int", "", "0")
Pop_title = uf_getRequestProc(UploadForm("pop_title"), "char", "100", "")
pTop = uf_getRequestProc(UploadForm("pTop"), "int", "", "0")
pLeft = uf_getRequestProc(UploadForm("pLeft"), "int", "", "0")
popSort = uf_getRequestProc(UploadForm("popSort"), "int", "1", "0")
temCode = uf_getRequestProc(UploadForm("temCode"), "int", "", "0")
mobileYN = uf_getRequestProc(UploadForm("mobileYN"), "int", "1", "0")

imgDel_Chk = uf_getRequestProc(UploadForm("imgDel_Chk"), "int", "", "")
imgName = uf_getRequestProc(UploadForm("imgname"), "char", "", "")
edNonce = uf_getRequestProc(UploadForm("edNonce"),"char","","")

IF Sort=1 Then
	Link_Url = uf_getRequestProc(UploadForm("Link_Url"), "char", "200", "")

	IF imgDel_Chk<>"" And imgName<>"" Then ImgDelete imgName,UploadForm.DefaultPath

	IF imgDel_Chk<>"" OR imgName="" Then
		IF UploadForm("files")<>"" Then 
			imgName=ImgSaves(UploadForm("files"),uploadform.defaultpath,3072000)
			IF imgName=False Then Result=1

			IF Result=1 Then
				Set UploadForm=Nothing
				DBcon.Close
				Set DBcon=Nothing
				Response.Write ExecJavaAlert("업로드 허용용량(3M)을 초과하여 업로드를 실패하였습니다.",0)
				Response.End
			End IF
		Else
			imgName=""
		End IF
	End IF
Else
	Content = Replace(UploadForm("content"),"http://"&Request.Servervariables("Server_name")&"/","/")
End IF

Set Cmd=CreateCommand(DBcon,"FM_AP_PopupEdit",adCmdStoredProc)
With Cmd
	.Parameters.Append CreateInputParameter("@edNonce",adVarchar,50,edNonce)
	.Parameters.Append CreateInputParameter("@langmode",adTinyint,1,langmode)
	.Parameters.Append CreateInputParameter("@Idx",adBigint,8,Idx)
	.Parameters.Append CreateInputParameter("@popSort",adTinyint,1,popSort)
	.Parameters.Append CreateInputParameter("@temCode",adTinyint,1,temCode)
	.Parameters.Append CreateInputParameter("@Sort",adInteger,4,Sort)
	.Parameters.Append CreateInputParameter("@StartDate",adChar,8,StartDate)
	.Parameters.Append CreateInputParameter("@EndDate",adChar,8,EndDate)
	.Parameters.Append CreateInputParameter("@WSize",adInteger,4,Pop_w)
	.Parameters.Append CreateInputParameter("@HSize",adInteger,4,Pop_h)
	.Parameters.Append CreateInputParameter("@Title",adVarWchar,100,Pop_Title)
	.Parameters.Append CreateInputParameter("@Content",adVarWchar,2147483647,Content)
	.Parameters.Append CreateInputParameter("@HtmlYN",adInteger,4,0)
	.Parameters.Append CreateInputParameter("@LinkUrl",adVarchar,200,Link_Url)
	.Parameters.Append CreateInputParameter("@OutPutImg",adVarWchar,50,imgName)
	.Parameters.Append CreateInputParameter("@pTop",adInteger,4,pTop)
	.Parameters.Append CreateInputParameter("@pLeft",adInteger,4,pLeft)
	.Parameters.Append CreateInputParameter("@mobileYN",adTinyint,1,mobileYN)
	.Parameters.Append CreateOutputParameter("@Result",adInteger,4)
	.Execute
End With
Result=Cmd.Parameters("@Result").Value

IF Result=0 Then
	AlertStr="팝업이 수정되었습니다."
Else
	AlertStr="수정중 에러... 다시시도해주세요."
End IF

Set Cmd=Nothing
Set UploadForm=Nothing

'###### 에디터 ID 등록처리 ##########
Call edNonceReg(edNonce)
'###### 에디터 ID 등록처리 ##########

DBcon.Close
Set DBcon=Nothing

strLocation="popup.asp?langmode="&langmode
Response.Write ExecJavaAlert(AlertStr,2)
%>
