<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim Writer,Page,UserIdx,Search,searchStr,BoardSort
Dim Idx,Sort,Title,Content,Pass,publicYN,AlertTag,imgName(0),imgDel_Chk(0)
Dim ObjCmd,UploadForm,Result
Dim BBsCode,strLocation,i,ReLevel

Session.Contents.Remove("boardPass")

Server.ScriptTimeOut=7200
set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/board/")

prePage=UploadForm("prePage")
BBsCode=CLng(UploadForm("bbscode"))
Call HK_BBSSetup(BBsCode)
BBsViewModeChk("write")
BbsAdminChk()

serboardsort=UploadForm("serboardsort")
Search=UploadForm("Search")
searchStr=UploadForm("searchStr")
pageSize=UploadForm("pageSize")
Page=UploadForm("page")

Idx = uf_getRequestProc(UploadForm("idx"),"int","","")
itemidx = uf_getRequestProc(UploadForm("itemidx"),"int","","0")
Sort = uf_getRequestProc(UploadForm("sort"),"char","","")
UserIdx = uf_getRequestProc(UploadForm("useridx"),"int","",null)
editorYN = uf_getRequestProc(UploadForm("editorYN"),"int","","0")
BoardSort = uf_getRequestProc(UploadForm("BoardSort"),"int","",null)
ReLevel = uf_getRequestProc(UploadForm("ReLevel"),"char","","")
Writer = Replace(uf_getRequestProc(UploadForm("Writer"),"char","",""),", ","|")
Title = uf_getRequestProc(UploadForm("title"),"char","200","")
Email = Replace(UploadForm("Email"),", ","@")
homepage = uf_getRequestProc(UploadForm("homepage"),"char","","")
Pass = uf_getRequestProc(UploadForm("Pass"),"char","10",null)
imgDel_Chk(0) = uf_getRequestProc(UploadForm("imgDel_Chk"),"char","","")
imgName(0) = uf_getRequestProc(UploadForm("imgname"),"char","","")
publicYN = uf_getRequestProc(UploadForm("publicYN"),"int","","0")
company = uf_getRequestProc(UploadForm("company"),"char","","")
tel = Replace(UploadForm("tel"),", ","-")
phone = Replace(UploadForm("phone"),", ","-")

stars = uf_getRequestProc(UploadForm("stars"),"int","","0")
Note1 = uf_getRequestProc(UploadForm("Note1"),"char","100","")
Note2 = uf_getRequestProc(UploadForm("Note2"),"char","100","")
Note3 = uf_getRequestProc(UploadForm("Note3"),"char","100","")
Note4 = uf_getRequestProc(UploadForm("Note4"),"char","50","")
Note5 = uf_getRequestProc(UploadForm("Note5"),"char","50","")
Note6 = uf_getRequestProc(UploadForm("Note6"),"char","50","")
Note7 = uf_getRequestProc(UploadForm("Note7"),"char","50","")
Note8 = uf_getRequestProc(UploadForm("Note8"),"char","50","")
arrNote1 = FormArrayRequest(UploadForm("arrNote1"))
arrNote2 = FormArrayRequest(UploadForm("arrNote2"))
linkurl = uf_getRequestProc(UploadForm("linkurl"),"char","200","")

startdate = uf_getRequestProc(UploadForm("startdate"),"date","","")
enddate = uf_getRequestProc(UploadForm("enddate"),"date","","")

isActFrame = uf_getRequestProc(UploadForm("isActFrame"),"int","","0")

cate1 = uf_getRequestProc(UploadForm("cate1"),"char","","")
cate2 = uf_getRequestProc(UploadForm("cate2"),"char","","")
cate3 = uf_getRequestProc(UploadForm("cate3"),"char","","")

IF BBscode<>2 AND BBscode<>9 Then
	company = GB_Member_Company
	bizcode = GB_Member_Bizcode
End IF

IF BBscode="50" Then
	Writer = Session("UserName")
End IF

Content = UploadForm("content")

'IF UserIdx="" Then UserIdx=null
'IF Pass="" Then Pass=Null

IF BBscode=2 OR BBscode=9 Then
	Note1 = Replace(Note1,", ","-")

	publicYN=1
	IF Title="" Then
		IF BBscode="2" Then
			Title =  Replace(Writer, "|", " ")&"님의 구매상담 문의내역입니다."
		Else
			Title =  Replace(Writer, "|", " ")&"님의 제휴문의 내역입니다."
		End IF
	End IF
End IF

'=============섬네일 이미지 첨부=================
Dim ThumbFileName,tmpFileName
For i=1 To UploadForm("imgfiles").count
	IF imgDel_Chk(i-1)<>"" And imgName(i-1)<>"" Then
		ImgDelete imgName(i-1),UploadForm.DefaultPath
		ImgDelete getImageThumbFilename(imgName(i-1)),UploadForm.DefaultPath
	End IF

	IF imgDel_Chk(i-1)<>"" Or Sort="" Then 
		IF UploadForm("imgfiles")(i)<>"" Then 
			imgName(i-1)=ImgSaves(UploadForm("imgfiles")(i),uploadform.defaultpath,30720000)
			IF imgName(i-1)=False Then Result=1

			IF Result=1 Then
				Set UploadForm=Nothing
				DBcon.Close
				Set DBcon=Nothing
				Response.Write ExecJavaAlert(LangPack_FileAllowLimit30mMsg,0)
				Response.End
			Else
				ThumbSaves 500 , 500 , UploadForm("imgfiles")(i) , uploadform.DefaultPath, imgName(i-1), "thumbs"
			End IF
		Else
			imgName(i-1)=""
		End IF
	End IF
Next
'=============섬네일 이미지 첨부=================

IF Sort="edit" Then
	IF ReLevel="A" Then
		Sql="Update BBslist Set BoardSort="&ChangeStrNull(BoardSort)&", publicYN="&publicYN&" Where ref="&Idx
		DBcon.Execute Sql
	End IF

	Sql="Update BBslist Set linkurl=?, itemidx=?, stars=?, homepage=?,tel=?,note1=?,note2=?,note3=?,note4=?,note5=?,note6=?,note7=?,note8=?,editorYN=?,company=?,phone=?,email=?,BoardSort=?,writer=?,Title=?,Content=?,wip=?,imgnames=? Where idx="&idx
Else
	Sql="INSERT INTO BBslist(bizcode, cate1, cate2, cate3, linkurl,itemidx,stars,homepage,tel,note1,note2,note3,note4,note5,note6,note7,note8,editorYN,company,phone,email,BoardSort,writer,Title,Content,wip,imgnames,regdate,boardidx,useridx,pwd,publicYN, startdate, enddate, arrNote1, arrNote2) "
	Sql = Sql & "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, Getdate(), ?, ?, ?, ?, ?, ?, ?, ?)"
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	IF Sort<>"edit" Then
	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 100, bizcode)
	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 100, cate1)
	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 100, cate2)
	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 100, cate3)
	End IF

	.Parameters.Append .CreateParameter("@linkurl", adVarWChar, adParamInput, 200, linkurl)
	.Parameters.Append .CreateParameter("@itemidx", adBigint, adParamInput, 8, itemidx)
	.Parameters.Append .CreateParameter("@stars", adTinyint, adParamInput, 1, stars)
	.Parameters.Append .CreateParameter("@homepage", adVarWChar, adParamInput, 200, homepage)
	.Parameters.Append .CreateParameter("@tel", adVarWChar, adParamInput, 50, tel)
	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 100, note1)
	.Parameters.Append .CreateParameter("@note2", adVarWChar, adParamInput, 100, note2)
	.Parameters.Append .CreateParameter("@note3", adVarWChar, adParamInput, 100, note3)
	.Parameters.Append .CreateParameter("@note4", adVarWChar, adParamInput, 50, note4)
	.Parameters.Append .CreateParameter("@note4", adVarWChar, adParamInput, 50, note5)
	.Parameters.Append .CreateParameter("@note4", adVarWChar, adParamInput, 50, note6)
	.Parameters.Append .CreateParameter("@note4", adVarWChar, adParamInput, 50, note7)
	.Parameters.Append .CreateParameter("@note4", adVarWChar, adParamInput, 50, note8)

	.Parameters.Append .CreateParameter("@editorYN", adTinyint, adParamInput, 1, editorYN)
	.Parameters.Append .CreateParameter("@company", adVarWChar, adParamInput, 100, company)
	.Parameters.Append .CreateParameter("@phone", adVarWChar, adParamInput, 100, phone)
	.Parameters.Append .CreateParameter("@email", adVarWChar, adParamInput, 100, email)
	.Parameters.Append .CreateParameter("@BoardSort", adInteger, adParamInput, 4, BoardSort)
	.Parameters.Append .CreateParameter("@Writer", adVarWChar, adParamInput, 100, Writer)
	.Parameters.Append .CreateParameter("@title", adVarWChar, adParamInput, 200, title)
	.Parameters.Append .CreateParameter("@content", adVarWChar, adParamInput, 2147483647, content)
	.Parameters.Append .CreateParameter("@Wip", adVarChar, adParamInput, 50, WIP)
	.Parameters.Append .CreateParameter("@imgNames", adVarWChar, adParamInput, 100, imgName(0))
	IF Sort<>"edit" Then
	.Parameters.Append .CreateParameter("@BoardIdx", adInteger, adParamInput, 4, BBsCode)
	.Parameters.Append .CreateParameter("@UserIdx", adInteger, adParamInput, 4, UserIdx)
	.Parameters.Append .CreateParameter("@Pwd", adVarWChar, adParamInput, 15, Pass)
	.Parameters.Append .CreateParameter("@PublicYN", adBoolean, adParamInput, 1, PublicYN)
	.Parameters.Append .CreateParameter("@startdate", adVarWChar, adParamInput, 10, startdate)
	.Parameters.Append .CreateParameter("@enddate", adVarWChar, adParamInput, 10, enddate)

	.Parameters.Append .CreateParameter("@arrNote1", adVarWChar, adParamInput, 2147483647, arrNote1)
	.Parameters.Append .CreateParameter("@arrNote2", adVarWChar, adParamInput, 2147483647, arrNote2)
	End IF
	.Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

Dim bIdx,MaxIdx
IF Sort="edit" Then
	bIdx=Idx
Else
	Sql="Select Max(Idx) From bbslist"
	MaxIdx=DBcon.Execute(Sql)
	bIdx=MaxIdx(0)
	
	Sql="UPDATE BBslist Set Ref="&MaxIdx(0)&",ReLevel='A' Where idx="&MaxIdx(0)
	DBcon.Execute Sql
End IF

'====================첨부파일 업로드 작업==========================================================
For i=1 To UploadForm("files").count
	IF Sort<>"edit" Then 
		IF UploadForm("files")(i)<>"" Then 
			Filenames=ImgSaves(UploadForm("files")(i),uploadform.defaultpath,30720000)
			IF Filenames=False Then Result=1

			IF Result=1 Then
				Set UploadForm=Nothing
				DBcon.Close
				Set DBcon=Nothing
				Response.Write ExecJavaAlert(LangPack_FileAllowLimit30mMsg,0)
				Response.End
			Else
				Sql="INSERT INTO BBSData(bidx,filenames,regdate) values("&bIdx&",'"&Filenames&"',getdate())"
				DBcon.Execute Sql

				mailAttachFile = Filenames
			End IF
		End IF
	Else
		IF UploadForm("filedel_idx")(i)<>"" Then
			IF UploadForm("filedel_idx")(i)<>"0" Then
				Sql="Select filenames From BBSData WHERE idx="&UploadForm("filedel_idx")(i)
				Set Rs=DBcon.Execute(Sql)
				IF Not(Rs.Bof Or Rs.Eof) Then
					ImgDelete Rs("filenames"),UploadForm.DefaultPath
				End IF
				Set Rs=NOthing

				IF UploadForm("files")(i)="" Then
					Sql="DELETE BBSData WHERE idx="&UploadForm("filedel_idx")(i)
					DBcon.Execute Sql
				Else
					filenames=ImgSaves(UploadForm("files")(i),uploadform.defaultpath,30720000)
					IF filenames=False Then Result=1

					IF Result=1 Then
						Set UploadForm=Nothing
						DBcon.Close
						Set DBcon=Nothing
						Response.Write ExecJavaAlert(LangPack_FileAllowLimit30mMsg,0)
						Response.End
					Else
						Sql="Update BBSData Set filenames='"&filenames&"',regdate=getdate() Where idx="&UploadForm("filedel_idx")(i)
						DBcon.Execute Sql
					End IF
				End IF
			Else
				IF UploadForm("files")(i)<>"" Then 
					filenames=ImgSaves(UploadForm("files")(i),uploadform.defaultpath,30720000)
					IF filenames=False Then Result=1

					IF Result=1 Then
						Set UploadForm=Nothing
						DBcon.Close
						Set DBcon=Nothing
						Response.Write ExecJavaAlert(LangPack_FileAllowLimit30mMsg,0)
						Response.End
					Else
						Sql="INSERT INTO BBSData(bidx,filenames,regdate) values("&idx&",'"&filenames&"',getdate())"
						DBcon.Execute Sql
					End IF
				End IF
			End IF
		End IF
	End IF
Next
'===============================================================================================

IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" Then
	IF BBscode="40" Then
		IF Sort="edit" Then
			mailTitle = "[아이원소프트뱅크] 기타문의 접수내역이 수정 되었습니다."
		Else
			mailTitle = "[아이원소프트뱅크] 새로운 기타문의가 접수 되었습니다."
		End IF
	Else
		IF Sort="edit" Then
			mailTitle = "[아이원소프트뱅크] 1:1 문의 접수내역이 수정 되었습니다."
		Else
			mailTitle = "[아이원소프트뱅크] 새로운 1:1 문의가 접수 되었습니다."
		End IF
	End IF

	IF BBscode=8 Then
		customerNm = "log_amara.png"
		recvMail = GB_amaCsEmail
	ElseIF BBscode=18 Then
		customerNm = "log_icube.png"
		recvMail = GB_icubeCsEmail
	ElseIF BBscode=40 Then
		customerNm = "log_etc.png"
		recvMail = GB_etcCsEmail
	Else
		customerNm = "log_bizbox.png"
		recvMail = GB_bizboxCsEmail
	End IF

	Sql = "SELECT cate1 AS cateNm1, DBO.FN_CODENAME(cate1, cate2) AS cateNm2, DBO.FN_CODENAME(cate2, cate3) AS cateNm3 FROM bbslist WHERE idx="&bIdx
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		cateNm1 = Rs("cateNm1")
		cateNm2 = Rs("cateNm2")
		cateNm3 = Rs("cateNm3")

		cateNames = getBBSCateNm1(cateNm1)
		IF cateNames <> "" Then
			IF cateNm2<>"" Then
				cateNames = cateNames & " > "& cateNm2

				IF cateNm3<>"" Then
					cateNames = cateNames & " > "& cateNm3
				End IF
			End IF
		End IF
	End IF

	mailHtmlFileName = "consult.html"
	ReplaceWriter = Writer
	ReplacePhone = Phone
	ReplaceTel = tel
	ReplaceEmail = Email
	ReplaceTitle = ReplaceNoHtml(Title)
	ReplaceContent = ReplaceBr(ReplaceNoHtml(content))
	EmailAttachFileName = mailAttachFile
	ReplaceCOMPANY = ReplaceNoHtml(COMPANY)

	IF recvMail<>"" AND mailTitle<>"" AND mailHtmlFileName<>"" Then
		toEmail = "아이원소프트뱅크<ione@duzon119.co.kr>" '보내는사람
		ReEmail = recvMail '받는사람

		Set fso = Server.CreateObject("Scripting.FileSystemObject")
		Set f = fso.OpenTextFile(Server.MapPath("/mail/")&"/"&mailHtmlFileName,1,false,-1)
		MailBody = f.ReadAll

		MailBody=Replace(MailBody, "__%Domain%__", Request.Servervariables("Server_name"))
		MailBody=Replace(MailBody, "__%CUSTOMERNM%__", customerNm)
		MailBody=Replace(MailBody, "__%NAME%__", ReplaceWriter)
		MailBody=Replace(MailBody, "__%CATENMS%__", cateNames)
		MailBody=Replace(MailBody, "__%TEL%__", ReplaceTel)
		MailBody=Replace(MailBody, "__%EMAIL%__", ReplaceEmail)
		MailBody=Replace(MailBody, "__%TITLE%__", ReplaceTitle)
		MailBody=Replace(MailBody, "__%CONTENT%__", ReplaceContent)
		MailBody=Replace(MailBody, "__%COMPANY%__", ReplaceCOMPANY)
		MailBody=Replace(MailBody, "__%BIZCODE%__", bizcode)
		Title = mailTitle

		Call subSendMailSMTP(toEmail, ReEmail, Title, MailBody, 0, EmailAttachFileName)
	End IF

End IF

DBcon.Close
Set DBcon=Nothing

IF BBscode="2" Then
	mailHtmlFileName = "inquiry1.html"
	recvMail = GB_buyCsEmail

	mailTitle = "[아이원소프트뱅크] 새로운 구매상담 문의가 접수되었습니다."
	ReplaceWriter = Writer
	ReplacePhone = Phone
	ReplaceTel = tel
	ReplaceEmail = Email
	ReplaceTitle = ReplaceNoHtml(Title)
	ReplaceContent = ReplaceBr(ReplaceNoHtml(content))
	EmailAttachFileName = mailAttachFile
	ReplaceNote1 = ReplaceNoHtml(Note1)
	ReplaceNote2 = ReplaceNoHtml(Note2)
	ReplaceNote3 = ReplaceNoHtml(Note3)
	ReplaceNote4 = ReplaceNoHtml(Note4)
	ReplaceNote5 = ReplaceNoHtml(Note5)
	ReplaceNote6 = ReplaceNoHtml(Note6)
	ReplaceCOMPANY = ReplaceNoHtml(COMPANY)

	IF recvMail<>"" AND mailTitle<>"" AND mailHtmlFileName<>"" Then
		toEmail = "아이원소프트뱅크<ione@duzon119.co.kr>" '보내는사람
		ReEmail = recvMail '받는사람

		Set fso = Server.CreateObject("Scripting.FileSystemObject")
		Set f = fso.OpenTextFile(Server.MapPath("/mail/")&"/"&mailHtmlFileName,1,false,-1)
		MailBody = f.ReadAll

		MailBody=Replace(MailBody, "__%Domain%__", Request.Servervariables("Server_name"))
		MailBody=Replace(MailBody, "__%NAME%__", ReplaceWriter)
		MailBody=Replace(MailBody, "__%TEL%__", ReplaceTel)
		MailBody=Replace(MailBody, "__%PHONE%__", ReplacePhone)
		MailBody=Replace(MailBody, "__%EMAIL%__", ReplaceEmail)
		MailBody=Replace(MailBody, "__%TITLE%__", ReplaceTitle)
		MailBody=Replace(MailBody, "__%CONTENT%__", ReplaceContent)
		MailBody=Replace(MailBody, "__%NOTE1%__", ReplaceNote1)
		MailBody=Replace(MailBody, "__%NOTE2%__", ReplaceNote2)
		MailBody=Replace(MailBody, "__%NOTE3%__", ReplaceNote3)
		MailBody=Replace(MailBody, "__%NOTE4%__", ReplaceNote4)
		MailBody=Replace(MailBody, "__%COMPANY%__", ReplaceCOMPANY)

		Title = mailTitle

		Call subSendMailSMTP(toEmail, ReEmail, Title, MailBody, 0, EmailAttachFileName)
	End IF

	strLocation = "top.location.reload();"
	Response.Write ExecJavaAlert("구매상담 내역이 접수되었습니다.", 3)
ElseIF BBscode="9" Then
	mailHtmlFileName = "inquiry_bus.html"
	recvMail = GB_busCsEmail

	mailTitle = "[아이원소프트뱅크] 새로운 비즈니스 제휴문의가 접수되었습니다."
	ReplaceWriter = Writer
	ReplacePhone = Phone
	ReplaceEmail = Email
	EmailAttachFileName = mailAttachFile
	ReplaceNote1 = ReplaceNoHtml(Note1)
	ReplaceNote5 = ReplaceNoHtml(Note5)
	ReplaceNote6 = ReplaceNoHtml(Note6)
	ReplaceCOMPANY = ReplaceNoHtml(COMPANY)

	ReplaceAddr = ""
	IF Note2<>"" Then ReplaceAddr = "["&ReplaceNoHtml(Note2)&"] "
	ReplaceAddr = ReplaceAddr & ReplaceNoHtml(Note3) & " "& ReplaceNoHtml(Note4)

	IF recvMail<>"" AND mailTitle<>"" AND mailHtmlFileName<>"" Then
		toEmail = "아이원소프트뱅크<ione@duzon119.co.kr>" '보내는사람
		ReEmail = recvMail '받는사람

		Set fso = Server.CreateObject("Scripting.FileSystemObject")
		Set f = fso.OpenTextFile(Server.MapPath("/mail/")&"/"&mailHtmlFileName,1,false,-1)
		MailBody = f.ReadAll

		MailBody=Replace(MailBody, "__%Domain%__", Request.Servervariables("Server_name"))
		MailBody=Replace(MailBody, "__%NAME%__", ReplaceWriter)
		MailBody=Replace(MailBody, "__%PHONE%__", ReplacePhone)
		MailBody=Replace(MailBody, "__%EMAIL%__", ReplaceEmail)
		MailBody=Replace(MailBody, "__%NOTE1%__", ReplaceNote1)
		MailBody=Replace(MailBody, "__%ADDRESS%__", ReplaceAddr)
		MailBody=Replace(MailBody, "__%NOTE5%__", ReplaceNote5)
		MailBody=Replace(MailBody, "__%NOTE6%__", ReplaceNote6)
		MailBody=Replace(MailBody, "__%COMPANY%__", ReplaceCOMPANY)

		Title = mailTitle

		Call subSendMailSMTP(toEmail, ReEmail, Title, MailBody, 0, EmailAttachFileName)
	End IF

	strLocation = "top.location.reload();"
	Response.Write ExecJavaAlert("제휴문의가 접수되었습니다.", 3)
Else
	strLocation=prePage&""

	IF BBscode=12 Then
		Response.Write ExecJavaAlert(Langpack_inquiryOkMsg, 2)
	Else
		IF Sort="edit" Then
			Response.Write ExecJavaAlert(Langpack_ModifyOkMsg, 2)
		Else
			Response.Write ExecJavaAlert(Langpack_WriteOkMsg, 2)
		End IF
	End IF
End IF
%>