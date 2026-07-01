<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "emp" : subMenuCode = "empApply" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim ErrorRMsg : ErrorRMsg = ""

'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serdate1, serdate2

page = uf_getRequest(Request("page"),"int","","1")
pageSize = uf_getRequest(Request("pageSize"),"int","","20")
seritem = uf_getRequest(Request("seritem"),"int","3","0")
serStatus = uf_getRequest(Request("serStatus"),"int","","")
serEmpidx = uf_getRequest(Request("serEmpidx"),"int","","")
SearchStr = uf_getRequest(Request("searchStr"),"char","","")
oSearchStr = Request("searchstr")

PageLink = "index.asp"
PageStr = "serEmpidx="&serEmpidx&"&serStatus="&serStatus&"&seritem="&seritem&"&pagesize="&PageSize&"&searchStr="&Server.UrlEncode(oSearchStr)
'=============================================

uploadPath = Server.MapPath("/upload/apply/")
procMode = uf_getRequestProc(Request("procMode"), "char", "", "")

Dim FileUploadSuccess : FileUploadSuccess = True
Dim UploadComCnt : UploadComCnt = 0
Dim removeFileCnt : removeFileCnt = 0
Dim UploadComFile()	 : ReDim UploadComFile(UploadComCnt) 	'업로드 완료파일 배열
Dim removeFile() : ReDim removeFile(removeFileCnt)				'삭제될 파일 배열
Dim arrImgName : arrImgName=""
Dim arrDImgName : arrDImgName=""
Dim arrFilename : arrFilename=""
Dim retFileUploadOk, retFileSaveName, retFileOriName

IF ErrorRMsg = "" Then
	DBCon.BEGINTRANS

	IF procMode="status" Then
		idx = uf_getRequestProc(Request("idx"), "int", "", "")
		selVal = uf_getRequestProc(Request("selVal"), "int", "", "")

		IF idx="" OR selVal="" Then
			ErrorRMsg = "필수 파라미터 오류.\n다시 시도해주세요."
		Else
			Sql = "UPDATE empApply Set status="&selVal&" WHERE idx="&idx
			DBcon.Execute(Sql)
		End IF
	ElseIF procMode="groupStatus" Then
		idx = uf_getRequestProc(Request("idx"), "char", "", "")
		selVal = uf_getRequestProc(Request("selVal"), "int", "", "")

		Sql = "UPDATE empApply Set status="&selVal&" WHERE idx IN ("&idx&")"
		DBcon.Execute(Sql)
	ElseIF procMode="remove" Then
		IF Request("idx")<>"" Then
			arridx = Split(Request("idx"),",")

			For i=0 To Ubound(arridx)
				idx = uf_getRequest(arridx(i),"int","","")

				IF idx<>"" Then

					Sql = "SELECT arrFile FROM empApply WHERE isComplete=1 AND idx="&idx
					Set Rs = DBcon.Execute(Sql)
					IF Not(Rs.Bof Or Rs.Eof) Then
						DB_arrFile = ChangeBlank(Rs("arrFile"))

						IF DB_arrFile<>"" Then
							arrFile = Split(DB_arrFile, "|")

							For j=0 To Ubound(arrFile)
								IF arrFile(j)<>"" Then
									ImgDelete arrFile(j), uploadPath
								End IF
							Next
						End IF

						Sql = "DELETE empApply WHERE idx="&idx
						DBcon.Execute(Sql)
					End IF
				End IF
			Next
		End IF
	END IF

	DBcon.CommitTrans()
End IF

Set objCmd = Nothing

IF ErrorRMsg="" Then
	'### 업데이트 및 삭제파일 삭제처리 ###########
	For i=0 To Ubound(removeFile)
		IF removeFile(i)<>"" Then
			ImgDelete removeFile(i), uploadPath
		End IF
	Next
	'### 업데이트 및 삭제파일 삭제처리 ###########

	IF procMode="status" Then
		Response.Write "OK|"
	ElseIF procMode="groupStatus" Then
		strLocation = PageLink&"?page="&Page&"&"&pageStr
		Response.Write ExecJavaAlert("상태가 변경되었습니다.", 2)
	ElseIF procMode="remove" Then
		strLocation = PageLink&"?page="&Page&"&"&pageStr
		Response.Write ExecJavaAlert("삭제되었습니다.", 2)
	End IF
Else
	'### 오류시 업로드된 파일 삭제처리 ###########
	For i=0 To Ubound(UploadComFile)
		IF UploadComFile(i)<>"" Then
			ImgDelete UploadComFile(i), uploadPath
		End IF
	Next
	'### 오류시 업로드된 파일 삭제처리 ###########

	IF procMode="status" Then
		Response.Write "ERROR|"&ErrorRMsg
	ElseIF procMode="groupStatus" Then
		Response.Write ExecJavaAlert(ErrorRMsg, 0)
	ElseIF procMode="remove" Then
		Response.Write ExecJavaAlert(ErrorRMsg, 0)
	End IF
End IF
%>