<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
langmode = uf_getRequest(Request("langmode"),"int","","1")
chkidx = uf_getRequest(Request("chkidx"),"char","","")

'=====form 전송을 위한 변수 셋팅============================
Page = uf_getRequest(Request("Page"),"int","","")
serSelCate = uf_getRequest(Request("serSelCate"),"int","1","")
sercatecode = uf_getRequest(Request("sercatecode"),"char","50","")
searchOB = uf_getRequest(Request("searchOB"),"int","3","")
seritemstat = uf_getRequest(Request("seritemstat"),"int","1","")
serSellYn = uf_getRequest(Request("serSellYn"),"int","1","")
searchStr = uf_getRequest(Request("searchStr"),"char","","")
sercatecode1 = uf_getRequest(Request("sercatecode1"),"char","","")
sercatecode2 = uf_getRequest(Request("sercatecode2"),"char","","")
sercatecode3 = uf_getRequest(Request("sercatecode3"),"char","","")

PageStr="langmode="&langmode&"&serSelCate="&serSelCate&"&sercatecode1="&sercatecode1&"&sercatecode2="&sercatecode2&"&sercatecode3="&sercatecode3&"&sercatecode="&sercatecode&"&searchOB="&searchOB&"&seritemstat="&seritemstat&"&serSellYn="&serSellYn&"&searchStr="&searchStr
'=====form 전송을 위한 변수 셋팅============================

Server.ScriptTimeOut=7200
Set UploadForm=Server.CreateObject("DEXT.FileUpload")
UploadForm.DefaultPath=Server.MapPath("/upload/product/")

Dim delFile(11)

Sql = "SELECT imgname1, imgname2, imgname3, imgname4, imgname5, imgname6, imgname7, listimg, edNonce FROM product WHERE idx IN ("&chkidx&")"
Set Rs=DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	Do Until Rs.Eof

		delFile(0)=RS(0) : delFile(1)=RS(1): delFile(2)=RS(2) : delFile(3)=RS(3) : delFile(4)=RS(4)
		delFile(5)=RS(5) : delFile(6)=Rs(6) : delFile(7)=Rs(7)
		edNonce=changeBlank(Rs(8))

		For i=0 To Ubound(DelFile)
			IF delFile(i)<>"" Then
				ImgDelete delFile(i),UploadForm.DefaultPath
			End IF
		Next
		Rs.MoveNext()
	Loop
End IF

Sql="DELETE product WHERE idx IN ("&chkidx&")"
DBcon.Execute Sql

'###### 에디터 등록이미지 삭제처리 ##########
Call edNonceRemove(edNonce)
'###### 에디터 등록이미지 삭제처리 ##########

DBcon.close
Set DBcon=Nothing
Set UploadForm=Nothing

strLocation="product.asp?page="&page&"&"&PageStr
Response.Write ExecJavaAlert("제품이 삭제 되었습니다.",2)
%>