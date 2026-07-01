<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "category" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Server.ScriptTimeOut=7200
set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/category/")

isdisplay=Trim(UploadForm("isdisplay"))
CateName=Trim(UploadForm("catename"))
CateNameSub=Trim(UploadForm("CateNameSub"))
CateCode=UploadForm("catecode")
Topcode=UploadForm("select1")
MiddleCode=UploadForm("select2")
Sort=UploadForm("regsort")
Mode=UploadForm("mode")
sIndex1=UploadForm("sIndex1")
sIndex2=UploadForm("sIndex2")
sIndex3=UploadForm("sIndex3")
Content = Replace(UploadForm("Content"),"http://"&Request.Servervariables("Server_name")&"/","/")
detailcontent = Replace(UploadForm("detailcontent"),"http://"&Request.Servervariables("Server_name")&"/","/")

mbTitle=UploadForm("mbTitle")
mbCaption=UploadForm("mbCaption")


Dim langTitle, langmode
langmode=UploadForm("langmode")
Call getlangmodeTitle(langmode)

IF catecode="1317707120" OR catecode="1317707140" OR catecode="1317707146" OR catecode="1317707152" OR catecode="1317707157" Then
	Response.Write ExecJavaAlert("프로그램 로직상 수정할수 없는 카테고리입니다.",0)
	Response.End
End IF

'==================이미지 AND 파일 처리==========================
Dim imgDel_Chk(1),imgName(1),fileDel_Chk(1),fileName(1)

imgDel_Chk(0)=UploadForm("imgDel_Chk")
imgName(0)=UploadForm("imgname")
imgDel_Chk(1)=UploadForm("imgDel_Chk1")
imgName(1)=UploadForm("imgname1")
fileDel_Chk(0)=UploadForm("fileDel_Chk")
fileName(0)=UploadForm("filename")

Dim ThumbFileName,tmpFileName
For i=1 To UploadForm("imgfiles").count
	IF imgDel_Chk(i-1)<>"" And imgName(i-1)<>"" Then
		ImgDelete imgName(i-1),UploadForm.DefaultPath
		ImgDelete getImageThumbFilename(imgName(i-1)),UploadForm.DefaultPath
	End IF

	IF imgDel_Chk(i-1)<>"" Or Mode="" Then 
		IF UploadForm("imgfiles")(i)<>"" Then 
			imgName(i-1)=ImgSaves(UploadForm("imgfiles")(i),uploadform.defaultpath,10240000)
			IF imgName(i-1)=False Then Result=1

			IF Result=1 Then
				Set UploadForm=Nothing
				DBcon.Close
				Set DBcon=Nothing
				Response.Write ExecJavaAlert("업로드 허용용량(10M)을 초과하여 업로드를 실패하였습니다.",0)
				Response.End
			Else
				ThumbSaves 500 , 500 , UploadForm("imgfiles")(i) , uploadform.DefaultPath, imgName(i-1), "thumbs"
			End IF
		Else
			imgName(i-1)=""
		End IF
	End IF
Next

For i=1 To UploadForm("files").count
	IF fileDel_Chk(i-1)<>"" And fileName(i-1)<>"" Then
		ImgDelete fileName(i-1),UploadForm.DefaultPath
	End IF

	IF fileDel_Chk(i-1)<>"" Or Mode="" Then 
		IF UploadForm("files")(i)<>"" Then 
			fileName(i-1)=ImgSaves(UploadForm("files")(i),uploadform.defaultpath,307200000)
			IF fileName(i-1)=False Then Result=1

			IF Result=1 Then
				Set UploadForm=Nothing
				DBcon.Close
				Set DBcon=Nothing
				Response.Write ExecJavaAlert("업로드 허용용량(300M)을 초과하여 업로드를 실패하였습니다.",0)
				Response.End
			End IF
		Else
			fileName(i-1)=""
		End IF
	End IF
Next
'================================================================

Set Cmd=CreateCommand(DBcon,"SAp_CateProc",adCmdStoredProc)
With Cmd
	.Parameters.Append CreateInputParameter("@Mode",adVarchar,10,Mode)
	.Parameters.Append CreateInputParameter("@langmode",adTinyint,1,langmode)
	.Parameters.Append CreateInputParameter("@isdisplay",adTinyint,1,isdisplay)
	.Parameters.Append CreateInputParameter("@CateName",adVarWchar,100,CateName)
	.Parameters.Append CreateInputParameter("@CateNameSub",adVarWchar,100,CateNameSub)
	.Parameters.Append CreateInputParameter("@CateCode",adVarchar,50,CateCode)
	.Parameters.Append CreateInputParameter("@CateCode",adVarchar,50,MiddleCode)
	.Parameters.Append CreateInputParameter("@TopCode",adVarchar,50,TopCode)
	.Parameters.Append CreateInputParameter("@images",adVarWchar,100,imgName(0))
	.Parameters.Append CreateInputParameter("@rollimages",adVarWchar,100,imgName(1))
	.Parameters.Append CreateInputParameter("@pdfFile",adVarWchar,100,"")
	.Parameters.Append CreateInputParameter("@content", adVarWchar, 2147483647, content)
	.Parameters.Append CreateInputParameter("@detailcontent", adVarWchar, 2147483647, detailcontent)
	.Parameters.Append CreateInputParameter("@mbTitle", adVarWchar, 200, mbTitle)
	.Parameters.Append CreateInputParameter("@mbCaption", adVarWchar, 200, mbCaption)
	.Parameters.Append CreateInputParameter("@Sort",adTinyint,1,Sort)
	.Execute
End With

Set Cmd=Nothing
DBcon.Close
Set DBcon=Nothing

IF mode="edit" Then
	strLocation="top.location.reload();"
	Response.Write ExecJavaAlert("카테고리 정보가 수정되었습니다.",3)
Else
	strLocation="category.asp?langmode="&langmode&"&sIndex1="&sIndex1&"&sIndex2="&sIndex2&"&sIndex3="&sIndex3
	Response.Write ExecJavaAlert("",2)
End IF
%>