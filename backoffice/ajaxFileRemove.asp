<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "" : subMenuCode = "" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim ErrorMsg : ErrorMsg = ""

uploadPath=Server.MapPath("/upload/")

tbNm = uf_getRequestProc(Request("tbNm"),"char","","")
fieldNm = uf_getRequestProc(Request("fieldNm"),"char","","")

IF tbNm="" OR fieldNm="" Then
	ErrorMsg = "필수파라미터가 없습니다."
Else
	Sql = "SELECT "&fieldNm&" FROM "&tbNm
	Set Rs = DBcon.Execute(Sql)
	IF Rs.Bof Or Rs.Eof Then
		ErrorMsg = "파일 정보를 찾을수 없습니다."
	Else
		DB_FileNm = ChangeBlank(Rs(0))
	End IF
End IF

Dim FileUploadSuccess : FileUploadSuccess = True
Dim UploadComCnt : UploadComCnt = 0
Dim removeFileCnt : removeFileCnt = 0
Dim UploadComFile()	 : ReDim UploadComFile(UploadComCnt) 	'업로드 완료파일 배열
Dim removeFile() : ReDim removeFile(removeFileCnt)				'삭제될 파일 배열
Dim dbFileName() : ReDim dbFileName(0)								'파일명

IF ErrorMsg = "" Then
	IF DB_FileNm<>"" Then
		ReDim Preserve removeFile(removeFileCnt)
		removeFile(removeFileCnt) = DB_FileNm
		removeFileCnt = removeFileCnt + 1
	End IF
End IF

IF ErrorMsg = "" Then
	ON ERROR RESUME Next

	DBCon.BEGINTRANS
	
	Sql = "UPDATE "&tbNm&" SET "&fieldNm&"=''"
	DBcon.Execute(Sql)

	IF CStr(Err.Number)<>"0"  Then
		DBcon.RollBackTrans()
		ErrorMsg = "DB처리중 오류가 발생했습니다."
	Else
		DBcon.CommitTrans()
	End IF

	ON ERROR GOTO 0
End IF

IF ErrorMsg = "" Then
	'### 오류시 업로드된 파일 삭제처리 ###########
	For i=0 To Ubound(removeFile)
		IF removeFile(i)<>"" Then
			ImgDelete removeFile(i), uploadPath
		End IF
	Next
	'### 오류시 업로드된 파일 삭제처리 ###########
	Response.Write "OK|"
Else
	Response.Write "ERROR|"&ErrorMsg
End IF

DBcon.close
Set DBcon=Nothing
%>