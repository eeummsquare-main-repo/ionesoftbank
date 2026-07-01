<%
Function getCommunityMemLevelNm(mLevel)
	IF mLevel = "1" Then
		getCommunityMemLevelNm = "신입사원"
	ElseIF mLevel = "2" Then
		getCommunityMemLevelNm = "사원"
	ElseIF mLevel = "3" Then
		getCommunityMemLevelNm = "과장"
	ElseIF mLevel = "4" Then
		getCommunityMemLevelNm = "부장"
	ElseIF mLevel = "5" Then
		getCommunityMemLevelNm = "이사"
	ElseIF mLevel = "6" Then
		getCommunityMemLevelNm = "상무"
	ElseIF mLevel = "7" Then
		getCommunityMemLevelNm = "대표"
	End IF
End Function

Function getBBSCateNm1(ByVal strValue)
	IF CStr(strValue)="uc" Then
		getBBSCateNm1 = "UC"
	ElseIF CStr(strValue)="erp" Then
		getBBSCateNm1 = "ERP"
	ElseIF CStr(strValue)="bizboxalpha" Then
		getBBSCateNm1 = "Bizbox Alpha"
	ElseIF CStr(strValue)="icube" Then
		getBBSCateNm1 = "iCUBE"
	ElseIF CStr(strValue)="icubeg20" Then
		getBBSCateNm1 = "iCUBE G20"
	ElseIF CStr(strValue)="cusetc" Then
		getBBSCateNm1 = "기타"
	End IF
End Function

Function getApplyStatus(strVal)
	IF CStr(strVal) = "0" Then
		getApplyStatus = "접수문의"
	ElseIF CStr(strVal) = "1" Then
		getApplyStatus = "처리중"
	ElseIF CStr(strVal) = "9" Then
		getApplyStatus = "완료"
	End IF
End Function

Sub sessionReSet_Identity()
	Session("IdentityDI") = ""
	Session("IdentityNM") = ""
	Session("IdentityPHONE") = ""
End Sub

Function getDateTermStatusFront(ByVal sDate, ByVal eDate, ByVal always, ByVal deadline)
	IF always="1" Then
		getDateTermStatusFront = "채용중"
	ElseIF deadline="1" Then
		getDateTermStatusFront = "마감"
	ElseIF sDate="" AND eDate="" Then
		getDateTermStatusFront = "채용중"
	ElseIF sDate > CStr(Date()) Then
		getDateTermStatusFront = "대기"
	ElseIF sDate <= CStr(Date()) And eDate >= CStr(Date()) Then
		getDateTermStatusFront = "채용중"
	Else
		getDateTermStatusFront = "마감"
	End IF
End Function

Function GetEdNonce()
	Sql = "SELECT NEWID()"
	Set Rs = DBcon.Execute(Sql)
	GetEdNonce = Replace(Replace(Rs(0),"{",""),"}","")
	Set Rs = Nothing
End Function

Sub edNonceReg(edNonce)
	Dim Sql, objCmd

	IF edNonce<>"" Then
		Sql = "UPDATE editorFileINFO SET isReg=1 WHERE edNonce=?"
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection = DBcon
			.CommandType = adCmdText
			.CommandText = Sql

			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, edNonce)
			.Execute,,adExecuteNoRecords
		End With
		Set objCmd = Nothing
	End IF
End Sub

Function fileRemoveUrl(ByVal fileUrl)
	Dim FilePath
	FilePath = Server.MapPath(fileUrl)

	Set FSO = CreateObject("Scripting.FileSystemObject")
	IF FSO.FileExists(filePath) Then FSO.DeleteFile(filePath)
	Set FSO = Nothing
End Function

Sub edNonceRemove(ByVal edNonce)
	Dim Sql, Rs, fileUrl

	IF edNonce<>"" Then
		Sql = "SELECT fileINFO FROM editorFileINFO WHERE edNonce='"&ReplaceEnsine(edNonce)&"'"
		Set Rs = DBcon.Execute(Sql)
		IF Not(Rs.Bof Or Rs.Eof) Then
			Do Until Rs.Eof
				fileUrl = changeBlank(Rs("fileINFO"))

				IF fileUrl<>"" Then
					fileRemoveUrl fileUrl
				End IF

				Rs.MoveNext()
			Loop
		End IF

		Sql = "DELETE editorFileINFO WHERE edNonce='"&ReplaceEnsine(edNonce)&"'"
		DBcon.Execute(Sql)
	End IF
End Sub

Function SE_FileSave(FormName,Path)
	Dim FileName,FilePath,Filenameonly,Fileext,i

	FileExt = FormName.FileExtension
	FilenameOnly = Session.sessionID&"_"&getTimestamp(Now())

	FileName = FilenameOnly &"."& Fileext
	FilePath=Path & "\" & FileName

	IF uploadform.fileexists(FilePath) then
		i=0
		Do while(1)
			FilePath=Path & "\" & FilenameOnly & "_" & i &"."& Fileext
			FileName = FilenameOnly & "_" & i &"."& Fileext
			IF Not UploadForm.FileExists(FilePath) Then Exit Do
			i=i+1
		Loop
	End IF
	FormName.saveas FilePath
	SE_FileSave = FileName
End Function

Function getCampaignSponStatusNm(ByVal cVal)
	IF CStr(cVal)="0" Then
		getCampaignSponStatusNm = "<span style='color:#a20000;'>종료</span>"
	ElseIF CStr(cVal)="1" Then
		getCampaignSponStatusNm = "<span style='color:#446fff;'>진행</span>"
	End IF
End Function

Function getCertCompanyStatusNm(ByVal cVal)
	IF CStr(cVal)="0" Then
		getCertCompanyStatusNm = "<span style='color:#8d8d8d;'>심사</span>"
	ElseIF CStr(cVal)="1" Then
		getCertCompanyStatusNm = "<span style='color:#446fff;'>취소</span>"
'	ElseIF CStr(cVal)="7" Then
'		getCertCompanyStatusNm = "<span style='color:#000000;'>합격</span>"
'	ElseIF CStr(cVal)="8" Then
'		getCertCompanyStatusNm = "<span style='color:#9b0000;'>불합격</span>"
	ElseIF CStr(cVal)="9" Then
		getCertCompanyStatusNm = "<span style='color:#0da600;'>유효</span>"
	End IF
End Function

Function getJApplyStatusNm(ByVal cVal)
	IF CStr(cVal)="0" Then
		getJApplyStatusNm = "<span style='color:#8d8d8d;'>접수중</span>"
	ElseIF CStr(cVal)="1" Then
		getJApplyStatusNm = "<span style='color:#446fff;'>결제완료</span>"
	ElseIF CStr(cVal)="7" Then
		getJApplyStatusNm = "<span style='color:#000000;'>합격</span>"
	ElseIF CStr(cVal)="8" Then
		getJApplyStatusNm = "<span style='color:#9b0000;'>불합격</span>"
	ElseIF CStr(cVal)="9" Then
		getJApplyStatusNm = "<span style='color:#0da600;'>2급1차합격</span>"
	End IF
End Function

Function getGApplyStatusNm(ByVal cVal)
	IF CStr(cVal)="0" Then
		getGApplyStatusNm = "<span style='color:#8d8d8d;'>입금 전</span>"
	ElseIF CStr(cVal)="1" Then
		getGApplyStatusNm = "<span style='color:#446fff;'>입금 완료</span>"
	ElseIF CStr(cVal)="7" Then
		getGApplyStatusNm = "<span style='color:#000000;'>작품 수령</span>"
	ElseIF CStr(cVal)="8" Then
		getGApplyStatusNm = "<span style='color:#9b0000;'>작품 반출</span>"
	End IF
End Function

Function getBookOrderStatusNm(ByVal cVal)
	IF CStr(cVal)="0" Then
		getBookOrderStatusNm = "<span style='color:#8d8d8d;'>결제대기</span>"
	ElseIF CStr(cVal)="1" Then
		getBookOrderStatusNm = "<span style='color:#446fff;'>결제완료</span>"
	ElseIF CStr(cVal)="7" Then
		getBookOrderStatusNm = "<span style='color:#000000;'>배송중</span>"
	ElseIF CStr(cVal)="8" Then
		getBookOrderStatusNm = "<span style='color:#9b0000;'>배송완료</span>"
	End IF
End Function

Sub getLicenseDate(passDate, historyDateTerm, expYear)
	Dim tmpArrData
	IF expYear="" Then expYear = 5

	IF historyDateTerm<>"" Then
		tmpArrData = Split(historyDateTerm, "|")

		licenseSdate = tmpArrData(0)
		licenseEdate = tmpArrData(1)
	Else
		licenseSdate = passDate
		licenseEdate = DateAdd("d",-1,DateAdd("yyyy",expYear,passDate))
	End IF
End Sub

Sub clearOKName()
	Session("cp_Di") = ""
	Session("cp_birthDate") = ""
	Session("cp_gender") = ""
	Session("cp_Mobile") = ""
	Session("cp_uName") = ""
End Sub

Function getTimeStringFromSeconds(seconds)
	Dim returnText

	seconds = CLng(seconds)
	IF seconds > 0 Then
		IF fix(seconds / 3600) > 0 Then
			returnText = fix(seconds / 3600) & "시 "
		End IF
	End IF
	IF fix((seconds MOD 3600) / 60) > 0 Then
		returnText = returnText & fix(((seconds) MOD 3600) / 60) & "분 "
	End IF
	IF fix(seconds MOD 60) > 0 Then
		returnText = returnText & (seconds MOD 60) & "초"
	End IF

	IF returnText="" Then returnText = "0초"
	getTimeStringFromSeconds = returnText
End Function

Function getMinuteFromSeconds(seconds)
	Dim returnText

	seconds = CLng(seconds)
	IF fix(seconds / 60) > 0 Then
		returnText = fix(seconds / 60)
	Else
		returnText = 0
	End IF

	getMinuteFromSeconds = returnText
End Function

Function getTimeString(seconds)
	Dim returnText

	seconds = CLng(seconds)
	IF seconds > 0 Then
		IF fix(seconds / 3600) > 0 Then
			returnText = fix(seconds / 3600) & "시 "
		End IF
	End IF
	IF fix((seconds MOD 3600) / 60) > 0 Then
		returnText = returnText & fix(((seconds) MOD 3600) / 60) & "분 "
	End IF
	getTimeString = returnText
End Function


Function getPassStatusNm(strVal)
	IF CStr(strVal) = "0" Then
		getPassStatusNm = "대기"
	ElseIF CStr(strVal) = "1" Then
		getPassStatusNm = "합격"
	ElseIF CStr(strVal) = "8" Then
		getPassStatusNm = "불합격"
	ElseIF CStr(strVal) = "9" Then
		getPassStatusNm = "결시"
	End IF
End Function

Function getFurchNm(strVal)
	IF CStr(strVal) = "0" Then
		getFurchNm = "협회계좌(무통장입금)"
	ElseIF CStr(strVal) = "1" Then
		getFurchNm = "신용카드"
	ElseIF CStr(strVal) = "2" Then
		getFurchNm = "계좌이체"
	ElseIF CStr(strVal) = "3" Then
		getFurchNm = "가상계좌"
	End IF
End Function

Function getApplyStatusNm(strVal)
	IF CStr(strVal) = "0" Then
		getApplyStatusNm = "접수완료"
	ElseIF CStr(strVal) = "8" Then
		getApplyStatusNm = "납부완료"
	ElseIF CStr(strVal) = "9" Then
		getApplyStatusNm = "승인완료"
	End IF
End Function

Function getLicAppStatusNm(strVal)
	IF CStr(strVal) = "0" Then
		getLicAppStatusNm = "대기"
	ElseIF CStr(strVal) = "9" Then
		getLicAppStatusNm = "발급완료"
	End IF
End Function

Function getisDepositNm(strVal)
	IF CStr(strVal) = "0" Then
		getisDepositNm = "결제대기"
	ElseIF CStr(strVal) = "1" Then
		getisDepositNm = "결제완료"
	End IF
End Function

Function getisDepositAdNm(strVal)
	IF CStr(strVal) = "0" Then
		getisDepositAdNm = "입금미확인"
	ElseIF CStr(strVal) = "1" Then
		getisDepositAdNm = "입금확인"
	End IF
End Function

Function getisFaxNm(strVal)
	IF CStr(strVal) = "0" Then
		getisFaxNm = "팩스미확인"
	ElseIF CStr(strVal) = "1" Then
		getisFaxNm = "팩스수령확인"
	End IF
End Function

Function getDateTermOrQuery(ByVal setDate1, ByVal setDate2, ByVal columnName)
	Dim i
	Dim tmpQuery : tmpQuery = ""
	Dim setDate : setDate = ""

	For i=0 To DateDiff("d", setDate1, setDate2)
		setDate = DateAdd("d", i, setDate1)

		IF setDate<>"" Then
			IF tmpQuery <> "" Then tmpQuery = tmpQuery & " OR "
			tmpQuery = tmpQuery & columnName & " LIKE '%"&setDate&"%'"
		End IF
	Next

	getDateTermOrQuery = tmpQuery
End Function

Function Get_LastDate(nYear, nMonth)
    Get_LastDate = nYear&"-"&nMonth&"-"&Day(DateSerial(nYear, nMonth + 1, 1 - 1))
End Function

Function Get_ArrFileFIrstName(ByVal cVal, ByVal delmiter)
	Dim i, retFileName
	retFileName = ""

	IF cVal<>"" Then
		IF delmiter = "" Then delmiter = "|"

		tmpArr = Split(cVal, delmiter)
		For i=0 To Ubound(tmpArr)
			IF tmpArr(i)<>"" Then
				retFileName = 	tmpArr(i)
				Exit For
			End IF
		Next
	End IF

	Get_ArrFileFIrstName = retFileName
End Function

Function Get_ArrFileList(ByVal cVal, ByVal path, ByVal delmiter)
	Dim i, tmpFIleTag
	tmpFIleTag = ""

	IF cVal<>"" Then
		IF delmiter = "" Then delmiter = "|"

		tmpArr = Split(cVal, delmiter)
		For i=0 To Ubound(tmpArr)
			IF tmpArr(i)<>"" Then tmpFIleTag = tmpFIleTag & "<a href=""/_lib/download.asp?path="&path&"&downfile="&Server.UrlEncode(tmpArr(i))&""" class=""files"">"&tmpArr(i)&"</a>"
		Next
	End IF

	Get_ArrFileList = tmpFIleTag
End Function

Function PT_FileThumbTag(fileNm, uploadFld)
	returnTag = "<a class=""thumb""></a>"
	IF ChangeBlank(fileNm)<>"" Then
		Exitsts=UCase(mid(fileNm,instrrev(fileNm,".")+1))

		IF Exitsts="JPG" Or Exitsts="JPEG" Or Exitsts="GIF" Or Exitsts="PNG" Then
			returnTag = "<a class=""thumb"" style=""background-image:url('/upload/"&uploadFld&"/"&fileNm&"');""><span class=""over"" style=""background-image:url('/upload/"&uploadFld&"/"&fileNm&"');""></span></a>"
		End IF
	End IF

	PT_FileThumbTag = returnTag
End Function

Function PT_FileThumbImgTag(fileNm, uploadFld)
	returnTag = ""
	IF ChangeBlank(fileNm)<>"" Then
		Exitsts=UCase(mid(fileNm,instrrev(fileNm,".")+1))

		IF Exitsts="JPG" Or Exitsts="JPEG" Or Exitsts="GIF" Or Exitsts="PNG" Then
			returnTag = "<a class=""imgThumb"" style=""background-image:url('/upload/"&uploadFld&"/"&fileNm&"');"" href=""javascript:openWindow(100,100,'/_lib/imgview.asp?path="&uploadFld&"&imgname="&fileNm&"','imgView','yes')""></a>"
		End IF
	End IF

	PT_FileThumbImgTag = returnTag
End Function

Function getYoutubeID(ByVal vodUrl)
	IF InStr(vodUrl, "?v=")>0 Then
		getYoutubeID = Mid(vodUrl, InStr(vodUrl, "?v=")+3)
	ElseIF InStrRev(vodUrl, "/")>0 Then
		getYoutubeID = Mid(vodUrl, InStrRev(vodUrl, "/")+1)
	Else
		getYoutubeID = vodUrl
	End IF
End Function

Function getYoutubeUrl(ByVal vodUrl)
	IF InStr(vodUrl, "youtu.be")>0 Then
		IF InStr(vodUrl, "?v=")>0 Then
			getYoutubeUrl = "https://www.youtube.com/embed/"&Mid(vodUrl, InStr(vodUrl, "?v=")+3)
		ElseIF InStrRev(vodUrl, "/")>0 Then
			getYoutubeUrl = "https://www.youtube.com/embed/"&Mid(vodUrl, InStrRev(vodUrl, "/")+1)
		Else
			getYoutubeUrl = vodUrl
		End IF
	Else
		getYoutubeUrl = vodUrl
	End IF
End Function

Function getYoutubeIMGUrl(ByVal vodUrl)
	IF InStr(vodUrl, "?v=")>0 Then
		getYoutubeIMGUrl = "<img src=""http://img.youtube.com/vi/"&Mid(vodUrl, InStr(vodUrl, "?v=")+3)&"/0.jpg"" class=""ofi"" alt="""">"
	ElseIF InStrRev(vodUrl, "/")>0 Then
		getYoutubeIMGUrl = "<img src=""http://img.youtube.com/vi/"&Mid(vodUrl, InStrRev(vodUrl, "/")+1)&"/0.jpg"" class=""ofi"" alt="""">"
	End IF
End Function

Function getYoutubeIMGUrlOnly(ByVal vodUrl)
	IF InStr(vodUrl, "youtu.be")>0 OR InStr(vodUrl, "youtube.com")>0 Then
		IF InStr(vodUrl, "?v=")>0 Then
			getYoutubeIMGUrlOnly = "http://img.youtube.com/vi/"&Mid(vodUrl, InStr(vodUrl, "?v=")+3)&"/0.jpg"
		ElseIF InStrRev(vodUrl, "/")>0 Then
			getYoutubeIMGUrlOnly = "http://img.youtube.com/vi/"&Mid(vodUrl, InStrRev(vodUrl, "/")+1)&"/0.jpg"
		End IF
	End IF
End Function

Function getBBsLinkUrl(strBBscode)
	IF CStr(strBBscode)="1" Then
		getBBsLinkUrl = "../community/sw_notice.asp"
	ElseIF CStr(strBBscode)="2" Then
		getBBsLinkUrl = "../community/ch_notice.asp"
	ElseIF CStr(strBBscode)="3" Then
		getBBsLinkUrl = "../community/sw_faq.asp"
	ElseIF CStr(strBBscode)="4" Then
		getBBsLinkUrl = "../community/ch_faq.asp"
	End IF
End Function

Function ConvertLineFeed(cVal, tag)
	Dim i
	Dim tmpContent : tmpContent = ""
	IF cVal<>"" Then
		cVal = ReplaceBr(cVal)
		tmpStr = Split(cVal,"<BR />")

		For i=0 To Ubound(tmpStr)
			IF tmpStr(i)<>"" Then
				tmpContent = tmpContent &"<"&tag&">"&tmpStr(i)&"</"&tag&">"
			End IF
		Next
	End IF
	ConvertLineFeed = tmpContent
End Function

Function ProductStatusIMG(strVal)
	tmpStr = tmpStr
	IF InStr(","&strVal&",", ",0,")>0 Then
		tmpStr = tmpStr & "<span class=""hot"">HOT</span>"&Vbcrlf
	End IF
	IF InStr(","&strVal&",", ",1,")>0 Then
		tmpStr = tmpStr & "<span class=""new"">NEW</span>"&Vbcrlf
	End IF
	ProductStatusIMG = tmpStr
End Function

Function PT_imgBanner(Rec)
	Dim i
	IF IsArray(Rec) Then
		aLinkTag = ""
		For i=0 To Ubound(Rec,2)
			locHref=""

			IF Rec(1,i)<>"" Then
				Response.Write "<li><a href="""&Rec(1,i)&""" target=""_blank""><img src=""/upload/mainbanner/"&Rec(0,i)&"""></a></li>"&Vbcrlf
			Else
				Response.Write "<li><a><img src=""/upload/mainbanner/"&Rec(0,i)&"""></a></li>"&Vbcrlf
			End IF
		Next
	End IF
End Function

Function PT_comBanner(Rec, tag)
	Dim i
	IF IsArray(Rec) Then
		aLinkTag = ""
		For i=0 To Ubound(Rec,2)
			locHref=""

			IF Rec(1,i)<>"" Then locHref="onclick=""location.href='"&Rec(1,i)&"'"""
			Response.Write "<"&tag&" class=""slider"" style=""background-image: url('/upload/mainbanner/"&Rec(0,i)&"');"" "&locHref&"></"&tag&">"&Vbcrlf
		Next
	End IF
End Function

Function Create_CheckBox(Rec, checkBoxName, chkVal)
	Dim i
	IF IsArray(Rec) Then
		For i=0 To UBound(Rec,2)
			IF InStr(","&chkVal&",", ","&Rec(1,i)&",")>0 Then
				Response.Write "<label><input type=""checkbox"" name="""&checkBoxName&""" value="""&Rec(1,i)&""" checked> "&Rec(0,i)&"</label>"&vbcrlf
			Else
				Response.Write "<label><input type=""checkbox"" name="""&checkBoxName&""" value="""&Rec(1,i)&"""> "&Rec(0,i)&"</label>"&vbcrlf
			End IF
		Next
	End IF
End Function

Function getDateTermTxt(Date1, Date2, isAlways)
	IF Date1="" AND Date2="" Then
		IF isAlways=True Then
			getDateTermTxt = "상시모집"
		Else
			getDateTermTxt = ""
		End IF
	Else
		getDateTermTxt = Date1 & "~" & Date2
	End IF
End Function

Function getAttachFileDownIcon(arrFileStr, downPath)
	Dim i
	tmpStr = ""
	IF arrFileStr<>"" Then
		arrFileStr = Split(arrFileStr, "^|^")

		For i=0 To Ubound(arrFileStr)
			IF arrFileStr(i)<>"" Then
				IF instrrev(arrFileStr(i),".") <> 0 then
					oFileExt = mid(arrFileStr(i),instrrev(arrFileStr(i),".")+1)
				Else
					oFileExt=""
				End IF

				IF UCase(oFileExt) = "PDF" Then
					tmpStr = tmpStr & "<a href=""/_lib/download.asp?path="&downPath&"&downfile="&arrFileStr(i)&"""><img src=""/images/icon_down_pdf.gif"" alt=""pdf"" /></a>"
				ElseIF UCase(oFileExt) = "JPG" OR UCase(oFileExt) = "JPEG" OR UCase(oFileExt) = "GIF" OR UCase(oFileExt) = "PNG" OR UCase(oFileExt) = "BMP" Then
					tmpStr = tmpStr & "<a href=""/_lib/download.asp?path="&downPath&"&downfile="&arrFileStr(i)&"""><img src=""/images/icon_down_jpg.gif"" alt=""이미지"" /></a>"
				Else
					tmpStr = tmpStr & "<a href=""/_lib/download.asp?path="&downPath&"&downfile="&arrFileStr(i)&"""><img src=""/images/icon_down_file.gif"" alt=""FILE"" /></a>"
				End IF
			End IF
		Next
	End IF
	getAttachFileDownIcon = tmpStr
End Function

Function ChangeConsultStatus(Str)
	IF CStr(Str)="0" Then
		ChangeConsultStatus="예약대기"
	ElseIF CStr(Str)="9" Then
		ChangeConsultStatus="예약완료"
	ElseIF CStr(Str)="-1" Then
		ChangeConsultStatus="예약취소"
	End IF
End Function

Function ChangeEstimateStatus(Str)
	IF CStr(Str)="0" Then
		ChangeEstimateStatus="<span style=""color: #003994;"">견적대기</span>"
	ElseIF CStr(Str)="9" Then
		ChangeEstimateStatus="견적완료"
	ElseIF CStr(Str)="8" Then
		ChangeEstimateStatus="<span style=""color: #ed6d00;"">견적취소</span>"
	End IF
End Function

Function ChageisDisplay(Str)
	IF isNull(Str) Then str=0
	IF CStr(Str)="0" Then
		ChageisDisplay="<span style='color:#cccccc'>비노출</span>"
	ElseIF CStr(Str)="1" Then
		ChageisDisplay="<span style=''>노출</span>"
	End IF
End Function

Function ChageBBsStatus(Str)
	IF CStr(Str)="0" Then
		ChageBBsStatus="숨김"
	ElseIF CStr(Str)="1" Then
		ChageBBsStatus="진행중"
	ElseIF CStr(Str)="2" Then
		ChageBBsStatus="접수마감"
	End IF
End Function

Function ChageInquriyStatus(Str)
	IF CStr(Str)="0" Then
		ChageInquriyStatus="<span style='color:#c5c5c5'>문의접수</span>"
	ElseIF CStr(Str)="1" Then
		ChageInquriyStatus="<span style='color:#ff811a'>접수처리</span>"
	ElseIF CStr(Str)="9" Then
		ChageInquriyStatus="상담완료"
	End IF
End Function

Function ChageReplyStatus(isSubmit, ReplyCnt)
	IF CStr(isSubmit)="0" Then
		ChageReplyStatus="<span style='color:#c5c5c5'>미확인</span>"
	ElseIF CStr(ReplyCnt)="1" Then
		ChageReplyStatus="<span style='color:#ff811a'>답변대기</span>"
	Else
		ChageReplyStatus="답변완료"
	End IF
End Function

Function comSelOption(Rec, cVal)
	Dim i
	IF isArray(Rec) Then
		For i=0 To Ubound(Rec,2)
			Response.Write "<option value="""&Rec(0,i)&""" "&iif_compare(Rec(0,i), cVal, "selected")&">"&Rec(1,i)&"</option>"&Vbcrlf
		Next
	End IF
End Function

Function getTextareaValMain(str,tag)
	Dim i,tmpContent

	Str = ReplaceBr(str)
	tmpStr = Split(str,"<BR />")
	tmpContent = ""

	j = 1
	For i=0 To Ubound(tmpStr)
		IF tmpStr(i)<>"" Then
			IF j<3 Then
				className = "tit"
			Else
				className = "txt"
			End IF
			tmpContent = tmpContent &"<"&tag&" class=""ii "&className&" i"&addZero(j)&""">"&tmpStr(i)&"</"&tag&">"
			j = j+1
		End IF
	Next
	getTextareaValMain = tmpContent
End Function

Function getTextareaValMain_MOBILE(str,tag)
	Dim i,tmpContent

	Str = ReplaceBr(str)
	tmpStr = Split(str,"<BR />")
	tmpContent = ""

	j = 1
	For i=0 To Ubound(tmpStr)
		IF tmpStr(i)<>"" Then
			IF j<4 Then
				className = "tit"
			Else
				className = "txt"
			End IF
			tmpContent = tmpContent &"<"&tag&" class=""ii "&className&" i"&addZero(j)&""">"&tmpStr(i)&"</"&tag&">"
			j = j+1
		End IF
	Next
	getTextareaValMain_MOBILE = tmpContent
End Function

Function isDisplayYN(str)
	IF CStr(str)="0" Then
		isDisplayYN = "<span style='color: #a60000'>N</span>"
	Else
		isDisplayYN = "<span style='color: #2270ff'>Y</span>"
	End IF
End Function

Function ChangeAuthStr(Str)
	IF CStr(Str)="0" Then
		ChangeAuthStr="<span style='color:blue;'>가입대기중</span>"
	ElseIF CStr(Str)="1" Then
		ChangeAuthStr="<span style='color:red;'>보류</span>"
	ElseIF CStr(Str)="99" Then
		ChangeAuthStr="<span>가입승인</span>"
	End IF
End Function

Function PT_ComCodeSelect(cate, oVal)
	Dim i

	IF isArray(GB_ComcodeRec) Then
		For i=0 To Ubound(GB_ComcodeRec,2)
			IF cate = GB_ComcodeRec(1,i) Then
				Response.Write "<option value="""&GB_ComcodeRec(0,i)&""" "&iif_compare(GB_ComcodeRec(0,i), oVal, "selected")&">"&GB_ComcodeRec(0,i)&"</option>"&Vbcrlf
			End IF
		Next
	End IF
End Function

Function getTextareaVal(str,tag)
	Dim i,tmpContent

	Str = ReplaceBr(str)
	tmpStr = Split(str,"<BR />")
	tmpContent = ""

	For i=0 To Ubound(tmpStr)
		IF tmpStr(i)<>"" Then
			tmpContent = tmpContent &"<"&tag&">"&tmpStr(i)&"</"&tag&">"
		End IF
	Next

	getTextareaVal = tmpContent
End Function

Function PT_Msg(Str)
	IF CStr(Str)="" Then
		PT_Msg = "<span style='color: #9d9d9d'>미입력</span>"
	Else
		PT_Msg = Str
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : 프로시져를 사용하지 않는 쿼리의 파라미터 검증
' ***************************************************************************************
Function uf_getRequest(par, stype, allowSize, basicVal)
	par = Trim(Replace(par,"	",""))

	IF stype="int" Then	'숫자형
		IF par = "" Then
			uf_getRequest = basicVal
		ElseIF Not(IsNumeric(par)) Then
			uf_getRequest = basicVal
		Else
			IF allowSize<>"" Then
				IF CInt(par) > CInt(allowSize) Then
					uf_getRequest = basicVal
				Else
					uf_getRequest=par
				End IF
			Else
				uf_getRequest=par
			End IF
		End IF
	ElseIF stype="date" Then	'날짜형
		IF par="" Then
			uf_getRequest=basicVal
		Else
			IF allowSize<>"" Then
				IF CInt(Len(par)) <> CInt(allowSize) Then
					uf_getRequest = basicVal
				ElseIF Not(isDate(par)) Then
					uf_getRequest = basicVal
				Else
					uf_getRequest=par
				End IF
			Else
				IF Not(isDate(par)) Then
					uf_getRequest = basicVal
				Else
					uf_getRequest=par
				End IF
			End IF
		End IF
	Else
		IF par="" Then
			uf_getRequest=basicVal
		Else
			IF allowSize<>"" Then
				IF Len(par) > CInt(allowSize) Then
					uf_getRequest=ReplaceEnsine(Left(par,CInt(allowSize)))
				Else
					uf_getRequest=ReplaceEnsine(par)
				End IF
			Else
				uf_getRequest=ReplaceEnsine(par)
			End IF
		End IF
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : 프로시져를 사용하는 쿼리의 파라미터 검증
' ***************************************************************************************
Function uf_getRequestProc(par, stype, allowSize, basicVal)
	par = Trim(Replace(par,"	",""))

	par = ChangeBlank(par)

	IF stype="int" Then	'숫자형
		IF par = "" Then
			uf_getRequestProc = basicVal
		ElseIF Not(IsNumeric(par)) Then
			uf_getRequestProc = basicVal
		Else
			IF allowSize<>"" Then
				IF CInt(par) > CInt(allowSize) Then
					uf_getRequestProc = basicVal
				Else
					uf_getRequestProc=par
				End IF
			Else
				uf_getRequestProc=par
			End IF
		End IF
	ElseIF stype="date" Then	'날짜형
		IF par="" Then
			uf_getRequestProc=basicVal
		Else
			IF allowSize<>"" Then
				IF CInt(Len(par)) <> CInt(allowSize) Then
					uf_getRequestProc = basicVal
				ElseIF Not(isDate(par)) Then
					uf_getRequestProc = basicVal
				Else
					uf_getRequestProc=par
				End IF
			Else
				IF Not(isDate(par)) Then
					uf_getRequestProc = basicVal
				Else
					uf_getRequestProc=par
				End IF
			End IF
		End IF
	Else
		IF par="" Then
			uf_getRequestProc=basicVal
		Else
			IF allowSize<>"" Then
				IF Len(par) > CInt(allowSize) Then
					uf_getRequestProc=Left(par,CInt(allowSize))
				Else
					uf_getRequestProc=par
				End IF
			Else
				uf_getRequestProc=par
			End IF
		End IF
	End IF
End Function

Function ChangeBlank(str)
	IF IsNull(Str) Then
		ChangeBlank = ""
	Else
		ChangeBlank = Trim(Str)
	End IF
End Function

SUB getLangModeTitle(Str)
	IF CStr(Str)="1" Then
		langTitle = "영문"
	Else
		langTitle = "국문"
		langmode = "0"
	End IF
End Sub

Function getLangModeCode(Str)
	IF CStr(Str)="1" Then
		getLangModeCode = "EN"
	Else
		getLangModeCode = "KO"
	End IF
End Function

Function getBBSLangMode(Str)
	IF CStr(Str)="1" Then
		getBBSLangMode = "EN"
	Else
		getBBSLangMode = "KR"
	End IF
End Function

Function getLangFolder(Str)
	IF CStr(Str)="1" Then
		getLangFolder = "eng"
	Else
		getLangFolder = "kor"
	End IF
End Function

Function getNum(StrCnt, strLength)
	Dim tmpStr

	IF Len(StrCnt)<strLength Then
		tmpStr = Right("000000000000000000"+CStr(StrCnt),strLength)
	Else
		tmpStr = StrCnt
	End IF

	getNum = tmpStr
End Function

Function ChangeConsultNum(byVal sNum, byVal sDate)
	sDate = Mid(Replace(sDate,"-",""),3,6)
	IF Len(sNum)<4 Then
		sNum = Right("000000"+CStr(sNum),4)
	End IF

	ChangeConsultNum = sDate + sNum
End Function

Function arignSortChecked(str1,str2)
	IF InStr(str1,str2)=0 Then
		arignSortChecked=""
	Else
		arignSortChecked="checked"
	End IF
End Function

Function ChangeIsDisplay(Str)
	IF CStr(Str)="1" Then
		ChangeIsDisplay="<span style='color:blue;'>공개</span>"
	Else
		ChangeIsDisplay="<span style='color:red;'>비공개</span>"
	End IF
End Function

Function ChangeWeekDay(Str)
	IF CStr(Str)="1" Then
		ChangeWeekDay="일"
	ElseIF CStr(Str)="2" Then
		ChangeWeekDay="월"
	ElseIF CStr(Str)="3" Then
		ChangeWeekDay="화"
	ElseIF CStr(Str)="4" Then
		ChangeWeekDay="수"
	ElseIF CStr(Str)="5" Then
		ChangeWeekDay="목"
	ElseIF CStr(Str)="6" Then
		ChangeWeekDay="금"
	ElseIF CStr(Str)="7" Then
		ChangeWeekDay="토"
	End IF
End Function

Function ChangeValueBasicStr(Str)
	IF IsNull(Str) Then
		ChangeValueBasicStr="<span style='color: #B3B3B3;'>미입력</span>"
	ElseIF CStr(Str)="" Then
		ChangeValueBasicStr="<span style='color: #B3B3B3;'>미입력</span>"
	Else
		ChangeValueBasicStr="<span style='color: red;'>"&Str&"</span>"
	End IF
End Function

Function ChangeAdminCalendarStr(Str)
	Str=Replace(Str,"|d","<div style='padding-top:4px; font-size:11px;'>")
	Str=Replace(Str,"d|","</div>")
	ChangeAdminCalendarStr=Str
End Function

Function ChangeCalendarStr(Str)
	Str=Replace(Str,"_a","<li><a href=""/sub/sub03_02View.asp?idx=")
	Str=Replace(Str,""">",""">")

	Str=Replace(Str,"a_","</a>")
	Str=Replace(Str,"|","</li>")
	ChangeCalendarStr=Str
End Function

Function Changebbs_status(Str)
	IF CStr(Str)="0" Then
		Changebbs_status="<span style='color: red;'>상담접수</span>"
	ElseIF CStr(Str)="1" Then
		Changebbs_status="<span style='color: blue;'>상담진행중</span>"
	ElseIF CStr(Str)="2" Then
		Changebbs_status="<span style='color: black;'>상담완료</span>"
	End IF
End Function

Function Changebbs_statusIMG(Str)
	IF CStr(Str)="0" Then
		Changebbs_statusIMG="<img src='/images/ing_btn.gif'>"
	ElseIF CStr(Str)="1" Then
		Changebbs_statusIMG="<img src='/images/ok_btn.gif'>"
	ElseIF CStr(Str)="2" Then
		Changebbs_statusIMG="<img src='/images/ico_end.gif'>"
	End IF
End Function

Function Changebbs_statusIMGMain(Str)
	IF CStr(Str)="0" Then
		Changebbs_statusIMGMain="<img src='/images/est_yet.gif'>"
	ElseIF CStr(Str)="1" Then
		Changebbs_statusIMGMain="<img src='/images/est_ing.gif'>"
	ElseIF CStr(Str)="2" Then
		Changebbs_statusIMGMain="<img src='/images/est_end.gif'>"
	End IF
End Function

Function Get_ConsultName(Str)
	tmpStr="OOOOOOOOOOOOOOOOOOOOOOOO"
	IF Str<>"" Then
		IF Len(Str)>2 Then
			Get_ConsultName = Left(Str,1)& MID(tmpStr,1,Len(Str)-2) & Right(Str,1)
		ElseIF Len(Str)=2 Then
			Get_ConsultName = Left(Str,1)& MID(tmpStr,1,Len(Str)-1)
		Else
			Get_ConsultName = LEFT(tmpStr,Len(Str))
		End IF
	End IF
End Function

Function Get_marking(Str, size)
	tmpStr="******************************************"
	IF Len(Str)>0 Then
		Get_marking=Left(Str,size)& MID(tmpStr,1,Len(Str)-size)
	End IF
End Function

Function ChangeMemSort(Str)
	IF CStr(Str)="0" Then
		ChangeMemSort="일반회원"
	ElseIF CStr(Str)="1" Then
		ChangeMemSort="특별회원"
	ElseIF CStr(Str)="9" Then
		ChangeMemSort="특별회원"
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : 원화로 변환
' ***************************************************************************************
Function ChangeWon(Str)
	IF IsNumerIc(Str) Then
		ChangeWon="\ "&FormatNumber(Str,0)
	Else
		ChangeWon=Str
	End IF
End Function

Function formatPrice(Str)
	IF IsNull(Str) Then	Exit Function

	IF IsNumerIc(CStr(Str)) Then
		formatPrice=FormatNumber(Str,0)
	Else
		formatPrice=Str
	End IF
End Function

Function getNumber(Str)
	IF IsNull(Str) Then
		getNumber = 0
	Else
		IF IsNumerIc(CStr(Str)) Then
			getNumber=Str
		Else
			getNumber=0
		End IF
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : 게시물 확인여부 변환
' ***************************************************************************************
Function ChangeCheckedInStr(val1,val2)
	val1 = Replace(Trim(val1),", ",",")

	IF INSTR(val1,val2)=0 Then
		ChangeCheckedInStr=""
	Else
		ChangeCheckedInStr="checked"
	End IF
End Function

Function ChangeCheckedYN(Str)
	IF Str=0 Or lcase(Str)=false Then
		ChangeCheckedYN=""
	Else
		ChangeCheckedYN="checked"
	End IF
End Function
Function ChangeChecked(val1,val2)
	IF CStr(val1)=CStr(val2) Then
		ChangeChecked="checked"
	Else
		ChangeChecked=""
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : 선택폼 체크
' ***************************************************************************************
Function SelCheck(val1,val2)
	IF isNull(val1) Then val1=""
	IF isNull(val2) Then val2=""

	IF CStr(val1)=CStr(val2) Then
		SelCheck="selected"
	Else
		SelCheck=""
	End IF
End Function

Function SelCheckInStr(val1,val2)
	val1 = Replace(Trim(val1),", ",",")

	IF INSTR(val1,val2)=0 Then
		SelCheckInStr=""
	Else
		SelCheckInStr="selected"
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : 게시물 확인여부 변환
' ***************************************************************************************
Function ChangeSubmitYN(Str)
	IF Str=0 Or Str=false Then
		ChangeSubmitYN="X"
	Else
		ChangeSubmitYN="O"
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : Text 문자열 변환함수
' * 변수설명 : str : 변환할 변수 값
' * 사용범위 : 프로시져 사용안할시(DB저장전)
' ***************************************************************************************
Function Replaceensine(ByVal Str)
	IF IsNull(Str) = False Then
		Str=Replace(Str,"'","''")
		Replaceensine = Str
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : Text 문자열 변환함수
' * 변수설명 : str : 변환할 변수 값
' * 사용범위 : 태그허용안하는 변수에 사용(DB저장전)
' ***************************************************************************************
Function ReplaceNoHtml(ByVal Str)
	IF IsNull(Str) = False Then
		Str=Replace(Str,"&","&amp;")
		Str=Replace(Str,"<","&lt;")
		Str=Replace(Str,">","&gt;")
		ReplaceNoHtml = Str
	End IF
End Function

Function deReplaceNoHtml(Str)
	IF IsNull(Str) = False Then
		Str=Replace(Str,"&gt;",">")
		Str=Replace(Str,"&lt;","<")
		Str=Replace(Str,"&amp;","&")
		deReplaceNoHtml = Str
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : Text 문자열 변환함수
' * 변수설명 : str : 변환할 변수 값
' * 사용범위 : 문자를 자바스크립트 변수로 사용될 경우
' ***************************************************************************************
Function ReplaceJScript(Str)
	IF IsNull(Str) = False Then
		Str=Replace(Str,"'","\'")
		Str=Replace(Str,CHR(34),"\""")
		str = REPLACE(str,CHR(13) & CHR(10),"\r")
		ReplaceJScript = Str
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : Text 문자열 변환함수
' * 변수설명 : str : 변환할 변수 값
' * 사용범위 : 문자를 value값으로 받는 모는 TextField
' ***************************************************************************************
Function ReplaceTextField(Str)
	IF IsNull(Str) = False Then
		Str=Replace(Str,"'","&#39;")
		Str=Replace(Str,CHR(34),"&quot;")
		ReplaceTextField = Str
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : HTML BR 태그 변환 함수
' * 변수설명 : str : 변환할 변수 값
' ***************************************************************************************
FUNCTION ReplaceBr(str)
	IF ISNULL(str) = False THEN
		str = REPLACE(str,CHR(13) & CHR(10),"<BR />")
		str = REPLACE(str,CHR(10),"<BR />")
		ReplaceBr = str
	END IF
End Function

FUNCTION UNReplaceBr(str)
	IF ISNULL(str) = False THEN
		str = UL_Replace(str,"<br />","")
		str = UL_Replace(str,"<br>","")
		str = UL_Replace(str,"<br/>","")
		UNReplaceBr = str
	END IF
End Function

' ***************************************************************************************
' * 함수설명 : 대소문자 구분없이 Replace
' ***************************************************************************************
Function UL_Replace(allText, findText, replaceText)
	Dim regObj
	Set regObj = New RegExp
	regObj.Pattern = findText
	regObj.IgnoreCase = True
	regObj.Global = True

	UL_Replace=regObj.Replace(allText,replaceText)
End Function

' ***************************************************************************************
' * 함수설명 : 배열형태의 폼 전송시 Request
' * 변수설명 : frm -> 전송폼네임
' ***************************************************************************************
Function FormArrayRequest(frm)
	Dim RequestStr,i
	For i=1 To frm.Count
		RequestStr=RequestStr&Replace(Replace(Trim(frm(i)),"|","_"),"	","")&"|"
	Next
	FormArrayRequest=RequestStr
End Function

' ***************************************************************************************
' * 함수설명 : 글번호 출력
' ***************************************************************************************
Function GetTextNum(Page,Pagesize)
	IF Page=1 Then
		GetTextNum=1
	Else
		GetTextNum=Page*Pagesize-(Pagesize-1)
	End IF
End Function

Function GetTextNumDesc(Page,Pagesize,Record_Cnt)
	If page=1 then
		GetTextNumDesc=Record_Cnt
	Else
		GetTextNumDesc=Record_Cnt-(Page-1)*PageSize
	End if
End Function

' ***************************************************************************************
' * 함수설명 : 페이지 변환
' ***************************************************************************************
Function GetPage()
	IF Request("Page")="" then
		GetPage=1
	ELSE
		GetPage=Request("Page")
	END IF
End Function

' ***************************************************************************************
' * 함수설명 : 문자열변환
' ***************************************************************************************
Function AddZero(Str)
	IF len(Str)=1 Then
		AddZero="0"&CStr(Str)
	Else
		AddZero=Str
	End IF
End Function

Function ChangeNull(Str)
	IF Str="" OR isNull(Str) Then
		ChangeNull=null
	Else
		ChangeNull=Str
	End IF
End Function

Function ChangeStrNull(Str)
	IF Str="" Or IsNull(Str) Then
		ChangeStrNull="null"
	Else
		ChangeStrNull=Str
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : 공백 -> 0
' ***************************************************************************************
Function spaceToZero(Str)
	IF Str="" OR isNull(Str) Then
		spaceToZero=0
	Else
		spaceToZero=str
	End IF
End Function

Function ZeroToSpace(Str)
	IF Str="0" OR isNull(Str) Then
		ZeroToSpace=""
	Else
		ZeroToSpace=str
	End IF
End Function

Function BitToNumber(Str)
	IF Str=False Then
		BitToNumber=0
	Else
		BitToNumber=1
	End IF
End Function

Function convertSpace(strVal, convertChar)
	IF strVal="" Then
		convertSpace = convertChar
	Else
		convertSpace = strVal
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : 문자열 길이 만큼 자르기
' * 변수설명 : Str = 변형할문자열 , strLen = 문자열수
' ***************************************************************************************
Function getString(str, strlen)
	Dim rValue,nLength,f,tmpStr,tmpLen
	nLength = 0.00
	rValue = ""

	For f = 1 To Len(Str)
		tmpStr = MID(str,f,1)
		tmpLen = ASC(tmpStr)
		IF  (tmpLen < 0) Then
			' 한글
			nLength = nLength + 1.4        '한글일때 길이값 설정
			rValue = rValue & tmpStr
		Elseif (tmpLen >= 97 And tmpLen <= 122) Then
			' 영문 소문자
			nLength = nLength + 0.75       '영문소문자 길이값 설정
			rValue = rValue & tmpStr
		Elseif (tmpLen >= 65 And tmpLen <= 90) Then
			' 영문 대문자
			nLength = nLength + 1           ' 영문대문자 길이값 설정
			rValue = rValue & tmpStr
		Else
			' 그외 키값
			nLength = nLength + 1.7         '특수문자 기호값...
			rValue = rValue & tmpStr
		End IF

		IF (nLength > strlen) Then
			rValue = rValue & ".."
			Exit For
		End if
	Next
	getString = rValue
End Function

' ***************************************************************************************
' * 함수설명 : 로그인처리에 따른 액션출력
' * 변수설명 : Url  =  로그인시 이동할 Page
' ***************************************************************************************
Function LoginCheck(Url,ReturnUrl)
	IF Session("useridx")="" Then
		LoginCheck="javascript:login('"&ReturnUrl&"');"
	Else
		LoginCheck=Url
	End IF
End Function

Function LoginMemsortCheck(Url,ReturnUrl,MemYN)
	IF Session("useridx")="" Then
		LoginMemsortCheck="javascript:login('"&ReturnUrl&"');"
	ElseIF CStr(Session("Membership"))<MemYN Then
		LoginMemsortCheck="javascript:alert('"&ChangeMemSort(MemYN)&" 이상 작성 가능합니다.');"
	Else
		LoginMemsortCheck=Url
	End IF
End Function

Function LoginCheckonclick(Url,returnUrl)
	IF Session("useridx")="" Then
		LoginCheckonclick="login('"&returnUrl&"');"
	Else
		LoginCheckonclick=Url
	End IF
End Function

Function LoginCk()
	IF Sign_Idx="" Then
		Response.Write "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
		Response.Write "alert('로그인이 필요한 서비스페이지 입니다.\n로그인후 다시 시도해주세요.')"&Vbcrlf
		Response.Write "history.back();"&Vbcrlf
		Response.Write "</SCRIPT>"&Vbcrlf
		Response.end
	End IF
End Function

Function ADLoginCk()
	IF Session("acountcode") = "" OR WIP<>Session("user_ip") Then
		Response.Redirect "/backoffice/login.asp"
		Call AD_Logout("","")
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : 자바스크립트 메시지 출력
' * 변수설명 : strMsg  = 출력메시지
' *            strExec = 스크립트 처리 (0:이전화면 / 1:창닫기 / 2:지정한URL / 3:스크립트)
' ***************************************************************************************
FUNCTION ExecJavaAlertgoHref(strMsg,goPage)
	DIM str
	str = "<script language=javascript>" & vbcrlf
	IF strMsg<>"" THEN str = str & "alert('" & strMsg & "');" & vbcrlf
	str = str & "location.href='"&goPage&"';" &vbcrlf
	ExecJavaAlertgoHref = str & "</script>" & vbcrlf
END Function

FUNCTION ExecJavaAlert(strMsg,strExec)
	DIM str
	str = "<script language=javascript>" & vbcrlf
	IF strMsg<>"" THEN str = str & "alert('" & strMsg & "');" & vbcrlf
	IF strExec = "0" THEN
		str = str & "history.back();" & vbcrlf
	ELSEIF strExec = "1" THEN
		str = str & "self.close();" & vbcrlf
	ELSEIF strExec = "2" THEN
		str = str & "location.href='"&strLocation&"';" &vbcrlf
	ELSEIF strExec = "3" THEN
		str = str & strLocation  &vbcrlf
	End IF
	ExecJavaAlert = str & "</script>" & vbcrlf
END FUNCTION

' ***************************************************************************************
' * 함수설명 : IMAGE Width Size 출력
' ***************************************************************************************
Function ImgSize(Path,MaxWidthSize,FileName)
	Dim ImgUrl,MyImg,Width
	Dim iType, Height

	ImgUrl=Server.MapPath("\upload\"&Path&"\")&"\"&FileName

	On Error Resume Next

	Set MyImg = new ImageClass
	With MyImg
		   .LoadFilePath(ImgUrl)
		   .ImageRead
		   iType = .ImageType
		   Width = .Width
		   Height = .Height
	End With
	Set MyImg = Nothing

	On Error goto 0

	IF Width>MaxWidthSize Then
		ImgSize=MaxWidthSize
	Else
		ImgSize=Width
	End IF
End Function

Function ImgPerSize(Path,MaxWidthSize,MaxHeightSize,FileName)
	Dim ImgUrl,MyImg,Width,Height,xo,yo,Rate

	Rate = 1
	ImgUrl=Server.MapPath("\upload\"&Path&"\")&"\"&FileName

	On Error Resume Next

	Set MyImg = new ImageClass
	With MyImg
		   .LoadFilePath(ImgUrl)
		   .ImageRead
		   iType = .ImageType
		   xo = .Width
		   yo = .Height
	End With
	Set MyImg = Nothing

	On Error goto 0

	if xo > MaxWidthSize Then Rate = (MaxWidthSize / xo)
	if yo * Rate > MaxHeightSize Then Rate = (MaxHeightSize / yo)

	ImgPerSize = " width='" & Cint(xo * rate) & "' height='" & Cint(yo * rate) & "'"
End Function

Function ImgPerSize1(Path,MaxWidthSize,MaxHeightSize,FileName)
	Dim ImgUrl,MyImg,Width,Height,xo,yo,Rate

	Rate = 1
	ImgUrl=Server.MapPath("\upload\"&Path&"\")&"\"&FileName

	On Error Resume Next

	Set MyImg = LoadPicture(Imgurl)
	xo = clng(cdbl(MyImg.width)*24/635)
	yo = clng(cdbl(MyImg.height)*24/635)

	if xo > MaxWidthSize Then Rate = (MaxWidthSize / xo)
	if yo * Rate > MaxHeightSize Then Rate = (MaxHeightSize / yo)
	Set MyImg = Nothing

	On Error goto 0

	imgWidth=Cint(xo * rate)
	imgHeight=Cint(yo * rate)
End Function

Function ImgPerSizeType1(Path,MaxWidthSize,MaxHeightSize,FileName)
	Dim ImgUrl,MyImg,Width,Height,xo,yo,Rate

	Rate = 1
	ImgUrl=Server.MapPath("\upload\"&Path&"\")&"\"&FileName

	On Error Resume Next

	Set MyImg = LoadPicture(Imgurl)
	xo = clng(cdbl(MyImg.width)*24/635)
	yo = clng(cdbl(MyImg.height)*24/635)

	if xo > MaxWidthSize Then Rate = (MaxWidthSize / xo)
	if yo * Rate > MaxHeightSize Then Rate = (MaxHeightSize / yo)
	Set MyImg = Nothing

	On Error goto 0

	ImgPerSizeType1 = Cint(xo * rate) & "," & Cint(yo * rate)
End Function

Function getImageThumbFilename(str)
	Dim ThumbFileName,ThumbFileExt
	ThumbFileName=left(str,instrrev(str,".")-1)
	ThumbFileExt=mid(str,instrrev(str,"."))

	IF LCase(ThumbFileExt)=".png" Then
		getImageThumbFilename=str
	Else
		getImageThumbFilename=ThumbFileName & "_thumbs"&ThumbFileExt
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : DextUpload ThumbNail 이미지 Save
' ***************************************************************************************
Function ThumbSaves(BasicWidthSize,BasicHeightSize,FormName,Path,SourceFile,changeName)
	Dim ObjImage,imgWidth,imgHeight,WidthPer,HeightPer,SizePer,SourceFileName,ThumbPath
	Dim ThumbWidth,ThumbHeight
	Dim SourceFileExt

	set objImage =server.CreateObject("DEXT.ImageProc")

	objImage.Quality=100

	SourceFileName=left(SourceFile,instrrev(SourceFile,".")-1)
	SourceFileExt=mid(SourceFile,instrrev(SourceFile,"."))

	'IF LCase(SourceFileExt)=".png" Then
	'	CopyPngThumbFile Path, SourceFile, SourceFileName & "_"&changeName&SourceFileExt
	'	ThumbSaves=SourceFileName & "_"&changeName&SourceFileExt
	'Else
		IF True = objImage.SetSourceFile(Path&"\"&SourceFile) then
			imgWidth = FormName.ImageWidth		'실제이미지 가로사이즈
			imgHeight = FormName.ImageHeight	'실제이미지 세로사이즈

			IF imgWidth<BasicWidthSize AND imgHeight<BasicHeightSize Then
				ThumbWidth=int(imgWidth)
				ThumbHeight=int(imgHeight)
			Else
				WidthPer=imgWidth/BasicWidthSize
				HeightPer=imgHeight/BasicHeightSize

				IF WidthPer>HeightPer Then
					SizePer=WidthPer
				Else
					SizePer=HeightPer
				End IF

				ThumbWidth=int(imgWidth/SizePer)
				ThumbHeight=int(imgHeight/SizePer)
			End IF

			ThumbPath = Path&"\"& SourceFileName & "_"&changeName&SourceFileExt

			objImage.SaveasThumbnail ThumbPath, ThumbWidth, ThumbHeight, false
			ThumbSaves=SourceFileName & "_"&changeName&SourceFileExt
		End IF
	'End IF
	set objImage = nothing
End Function

Function CopyPngThumbFile(path,oriFilename,desFilename)
	Dim fso, f, source, destination

	source = path&"\"&oriFilename
	destination = path&"\"&desFilename

	Set fso = CreateObject("Scripting.FileSystemObject")
	Set f = fso.GetFile(source)

	f.Copy destination
End Function

' ***************************************************************************************
' * 함수설명 : 파일 업로드
' ***************************************************************************************
Function FileSave(FormName,Path,reFileName,PermissionSize)
	Dim FileName,FilePath,Filenameonly,Fileext,i

	IF PermissionSize<>"" Then
		IF Int(PermissionSize) < Int(FormName.FileLen) Then
			FileSave=False
			Exit Function
		End IF
	End IF

	FileName = FormName.filename

	IF instrrev(filename,".") <> 0 then
		filenameonly=left(filename,instrrev(filename,".")-1)
		fileext=mid(filename,instrrev(filename,"."))
	Else
		filenameonly=filename
		fileext=""
	End IF

	IF reFileName<>"" Then filenameonly = reFileName

	filenameonly = Replace(Replace(Replace(Replace(filenameonly,"*","")," ","_"),"'",""),"""","")
	FileName=filenameonly & Fileext
	filepath=Path & "\" & FileName
	FolderMake(Path)

	if uploadform.fileexists(filepath) then
		i=0
		Do while(1)
			filepath=Path & "\" & filenameonly & "(" & i & ")" & fileext
			filename=filenameonly & "(" & i & ")" & fileext
			if not uploadform.fileexists(filepath) then exit do
			i=i+1
		Loop
	end if
	FormName.saveas filepath
	FileSave=Filename
End Function

' ***************************************************************************************
' * 함수설명 : DextUpload Image Save
' * 변수설명 : FormName -> 업로드폼네임 , Path -> 업로드경로 , PermissionSize ->허용용량
' ***************************************************************************************
Function ImgSaves(FormName,Path,PermissionSize)
	Dim FileName,FilePath,Filenameonly,Fileext,i

	IF PermissionSize<>"" Then
		IF Int(PermissionSize) < Int(FormName.FileLen) Then
			ImgSaves=False
			Exit Function
		End IF
	End If

	filename=Replace(Replace(FormName.filename," ","_"),"'","`")

	if instrrev(filename,".") <> 0 then
		filenameonly=left(filename,instrrev(filename,".")-1)
		fileext=mid(filename,instrrev(filename,"."))
	else
		filenameonly=filename
		fileext=""
	end if

	'filenameonly = Mid(Fileext,2)&Right(Replace(Date(),"-",""),6)&Right(Session.sessionID,2)

	FileName=Replace(filenameonly,"|","") & Fileext
	filepath=Path & "\" & FileName
	FolderMake(Path)

	if uploadform.fileexists(filepath) then
		i=0
		Do while(1)
			filepath=Path & "\" & filenameonly & i & fileext
			filename=filenameonly & i & fileext
			if not uploadform.fileexists(filepath) then exit do
			i=i+1
		Loop
	end if
	FormName.saveas filepath
	ImgSaves=Filename
End Function

' ***************************************************************************************
' * 함수설명 : 파일 COPY
' ***************************************************************************************
Function CopyFile(oripath,despath,oriFilename,ByVal desFilename)
	Dim fso, f, source, destination

	IF oriFilename<>"" Then
		IF desFilename="" Then
			desFilename = oriFilename
		Else
			IF instrrev(oriFilename,".") <> 0 then
				oriFileExt=mid(oriFilename,instrrev(oriFilename,"."))
			Else
				oriFileExt=""
			End IF

			desFilename = desFilename & oriFileExt
		End IF

		source = Server.MapPath(oripath)&"\"&oriFilename

		Set fso = CreateObject("Scripting.FileSystemObject")
		Set f = fso.GetFile(source)

		IF fso.FileExists(source) Then
			IF instrrev(desFilename,".") <> 0 then
				filenameonly=left(desFilename,instrrev(desFilename,".")-1)
				fileext=mid(desFilename,instrrev(desFilename,"."))
			Else
				filenameonly=desFilename
				fileext=""
			End IF

			filenameonly = Replace(Replace(Replace(Replace(filenameonly,"*","")," ","_"),"'",""),"""","")
			FileName = filenameonly & Fileext
			destination = Server.MapPath(despath)&"\"&FileName

			IF fso.FileExists(destination) Then
				i=0
				Do while(1)
					destination=Server.MapPath(despath) & "\" & filenameonly & "(" & i & ")" & fileext
					Filename=filenameonly & "(" & i & ")" & fileext
					IF Not fso.FileExists(destination) Then Exit Do
					i=i+1
				Loop
			End IF

			f.Copy destination
		End IF

		Set f = Nothing
		Set fso = Nothing
	End IF

	CopyFile = Filename
End Function

' ***************************************************************************************
' * 함수설명 : DextUpload waterMark 이미지 Save
' ***************************************************************************************
Function WaterMarkSaves(path,SourceFile)
	Dim objImage,SourceFileName,FilePath
	set objImage =server.CreateObject("DEXT.ImageProc")

	if true = objImage.SetSourceFile(Path&"\"&SourceFile) then
		SourceFileName=left(SourceFile,instrrev(SourceFile,".")-1)

		FilePath = Path&"\"&SourceFileName&"_WM.jpg"
		objImage.SaveAsWatermarkImage "/Images/marker/logo.gif",FilePath,-10,-10,false
	end if

	ImgDelete SourceFile,path

	WaterMarkSaves=SourceFileName&"_WM.jpg"
	Set ObjImage=Nothing
End Function

' ***************************************************************************************
' * 함수설명 : DextUpload Image Save
' * 변수설명 : FormName -> 업로드폼네임 , Path -> 업로드경로 , PermissionSize ->허용용량
' * 파일업로드시 파일명 SessionID로 변경 및 같은 이름의 파일일경우 덮어쓰기
' ***************************************************************************************
Function uploadRewrite(FormName,Path,PermissionSize)
	Dim FileName,FilePath,Filenameonly,Fileext,i

	IF PermissionSize<>"" Then
		IF Int(PermissionSize) < Int(FormName.FileLen) Then
			uploadRewrite=False
			Exit Function
		End IF
	End IF

	filename=FormName.filename
	filenameonly=Session.SessionId

	if instrrev(filename,".") <> 0 then
		fileext=mid(filename,instrrev(filename,"."))
	else
		fileext=""
	end if

	FileName = filenameonly & Fileext
	filepath=Path & "\" & FileName

	FormName.saveas filepath
	uploadRewrite=Filename
End Function

' ***************************************************************************************
' * 함수설명 : DextUpload Image Delete
' * 변수설명 : FormName -> 업로드폼네임 , Path -> 업로드경로
' ***************************************************************************************
Function ImgDelete(FileName,Path)
	Dim FilePath
	FilePath=Path & "/" & FileName

	Set FSO = CreateObject("Scripting.FileSystemObject")
	IF FSO.FileExists(filePath) Then FSO.DeleteFile(filePath)
	Set FSO = Nothing
End Function

' ***************************************************************************************
' * 함수설명 : 폴더 생성
' * 변수설명 : strPath = 생성할 폴더 경로 및 폴더명
' ***************************************************************************************
FUNCTION FolderMake(strPath)
	DIM FSO
	SET FSO = CreateObject("Scripting.FileSystemObject")
	IF NOT(fso.FolderExists(strPath)) THEN
		Fso.CreateFolder(strPath)
	END IF
	SET FSO = NOTHING
End Function

' ***************************************************************************************
' * 함수설명 : 다운로드태그변환
' ***************************************************************************************
Function DownloadTag(str,path)
	IF Not(Str="" Or IsNull(Str) Or IsEmpty(Str)) Then
		DownLoadTag="<a href='/_lib/download.asp?downfile="&Server.URLEncode(str)&"&path="&Path&"'>"&Str&"</a>"
	End IF
End Function

Function DownloadTagEN(str,path)
	IF Str="" Or IsNull(Str) Or IsEmpty(Str) Then
		DownloadTagEN="No AddFile!!!."
	Else
		DownloadTagEN="<a href='/_lib/download.asp?downfile="&Server.URLEncode(str)&"&path="&Path&"'>"&Str&"</a>"
	End IF
End Function

Function pubDownloadTag(str,path,downmode,memberShip)
	IF Not(Str="" Or IsNull(Str) Or IsEmpty(Str)) Then
		IF downmode<>"" Then
			IF CStr(memberShip)="" Or IsNull(memberShip) Or IsEmpty(memberShip) Then
				pubDownloadTag="<a href='#jLink' onclick=""alert('다운로드 권한이 없습니다.\n로그인 해주세요.')"">"&Str&"</a>"
			ElseIF CStr(downMode)>CStr(MemberShip) Then
				pubDownloadTag="<a href='#jLink' onclick=""alert('다운로드 권한이 없습니다.\n고객센터에 문의 바랍니다.')"">"&Str&"</a>"
			Else
				pubDownloadTag="<a href='/_lib/download.asp?downfile="&Server.URLEncode(str)&"&path="&Path&"'>"&Str&"</a>"
			End IF
		Else
			pubDownloadTag="<a href='/_lib/download.asp?downfile="&Server.URLEncode(str)&"&path="&Path&"'>"&Str&"</a>"
		End IF
	End IF
End Function

Function pubDownloadTag_onclick(str,path,downmode,memberShip)
	IF Not(Str="" Or IsNull(Str) Or IsEmpty(Str)) Then
		IF downmode<>"" Then
			IF CStr(memberShip)="" Or IsNull(memberShip) Or IsEmpty(memberShip) Then
				pubDownloadTag_onclick="alert('다운로드 권한이 없습니다.\n로그인 해주세요.')"
			ElseIF CStr(downMode)>CStr(MemberShip) Then
				pubDownloadTag_onclick="alert('다운로드 권한이 없습니다.\n고객센터에 문의 바랍니다.')"
			Else
				pubDownloadTag_onclick="location.href='/_lib/download.asp?downfile="&Server.URLEncode(str)&"&path="&Path&"'"
			End IF
		Else
			pubDownloadTag_onclick="location.href='/_lib/download.asp?downfile="&Server.URLEncode(str)&"&path="&Path&"'"
		End IF
	End IF
End Function

Function pubDownloadImgTag(str,path,downmode,memberShip)
	IF Not(Str="" Or IsNull(Str) Or IsEmpty(Str)) Then
		IF downMode>SpaceToZero(MemberShip) Then
			pubDownloadImgTag="<a href='#jLink' onclick=""alert('수강생 등급 이상 회원만 다운로드 가능합니다.')""><img src='/images/ico_down.png' border='0' align='absmiddle'></a>"
		Else
			pubDownloadImgTag="<a href='/_lib/download.asp?downfile="&Server.URLEncode(str)&"&path="&Path&"'><img src='/images/ico_down.png' border='0' align='absmiddle'></a>"
		End IF
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : Shop 페이징 네비게이션 출력
' * 변수설명 : linkpage  = 이동페이지
' *           str = 겟방식 전송값
' ***************************************************************************************
Function PT_SpPageLink(linkpage,str,ajaxYN)
	Dim BlockPage,i

'	IF MOBILEYN Then
		maxPageSize = 5
'	Else
'		maxPageSize = 10
'	End IF
	blockpage=int((page-1)/maxPageSize)*maxPageSize+1
	i=1

	Response.Write "<nav class=""paging_all"">"&Vbcrlf
	Response.Write "	<span class=""num"">"&Vbcrlf
	IF Int(page)>1 Then
		IF ajaxYN="" Then
			Response.Write "		<a href='"&linkpage&"?page="&page-1&"&"&str&"' class=""btns pg_page prev"">처음</a>"&Vbcrlf
		Else
			Response.Write "		<a href=""javascript:"&linkpage&"("&str&",'"&page-1&"')"" class=""btns pg_page prev"">처음</a>"&Vbcrlf
		End IF
	Else
		Response.Write "		<a class=""btns pg_page prev"">처음</a>"&Vbcrlf
	End IF

	do until i>maxPageSize or blockpage > totalpage
		If blockpage=int(page) Then
			Response.Write "		<span class=""sound_only"">열린</span><strong class=""pg_current"">"&blockpage&"</strong><span class=""sound_only"">페이지</span>"&Vbcrlf
		Else
			IF ajaxYN="" Then
				Response.Write "		<a href='"&linkpage&"?page="&blockpage&"&"&str&"' class=""pg_page"">"&blockpage&"</a>"&Vbcrlf
			Else
				Response.Write "		<a href=""javascript:"&linkpage&"("&str&",'"&blockpage&"')"" class=""pg_page"">"&blockpage&"</a>"&Vbcrlf
			End IF
		End If
		blockpage = blockpage+1
		i=i+1
	Loop

	IF Int(page)<Int(totalpage) Then
		IF ajaxYN="" Then
			Response.Write "		<a href='"&linkpage&"?page="&page+1 &"&"&str&"' class=""btns pg_page next"">다음</a>"&Vbcrlf
		Else
			Response.Write "		<a href=""javascript:"&linkpage&"("&str&",'"&page+1&"')"" class=""btns pg_page next"">다음</a>"&Vbcrlf
		End IF
	Else
		Response.Write "		<a class=""btns pg_page next"">다음</a>"&Vbcrlf
	End IF
	Response.Write "	</span>"&Vbcrlf
	Response.Write "</nav>"&Vbcrlf

End Function

Function PT_SpPageLinkType2(linkpage,str,ajaxYN)
	Dim BlockPage,i

	IF MOBILEYN Then
		maxPageSize = 5
	Else
		maxPageSize = 10
	End IF
	Response.Write "<div class=""paging"">"&Vbcrlf
	blockpage=int((page-1)/maxPageSize)*maxPageSize+1

	IF Page<>1 Then
		IF ajaxYN="" Then
			Response.Write "<a href='"&linkpage&"?page=1&"&str&"'><img src=""../images/front/btn2_prev2.gif"" alt=""Start"" /></a>"&Vbcrlf
		Else
			Response.Write "<a href=""javascript:"&linkpage&"("&str&",1)""><img src=""../images/front/btn2_prev2.gif"" alt=""Start"" /></a>"&Vbcrlf
		End IF
	Else
		Response.Write "<a><img src=""../images/front/btn2_prev2.gif"" alt=""Start"" /></a>"&Vbcrlf
	End IF

	IF Int(page)>1 Then
		IF ajaxYN="" Then
			Response.Write "<a href='"&linkpage&"?page="&page-1&"&"&str&"'><img src=""../images/front/btn2_prev.gif"" alt=""Prev"" /></a>"&Vbcrlf
		Else
			Response.Write "<a href=""javascript:"&linkpage&"("&str&",'"&page-1&"')""><img src=""../images/front/btn2_prev.gif"" alt=""Prev"" /></a>"&Vbcrlf
		End IF
	Else
		Response.Write "<a><img src=""../images/front/btn2_prev.gif"" alt=""Prev"" /></a>"&Vbcrlf
	End IF

	i=1

	Response.Write "<span class=""num"">"&Vbcrlf
	do until i>maxPageSize or blockpage > totalpage
		If blockpage=int(page) then
			Response.Write "<strong>"&blockpage&"</strong>"&vbcrlf
		Else
			IF ajaxYN="" Then
				Response.Write "<a href='"&linkpage&"?page="&blockpage&"&"&str&"'>"&blockpage&"</a>"&vbcrlf
			Else
				Response.Write "<a href=""javascript:"&linkpage&"("&str&",'"&blockpage&"')"">"&blockpage&"</a>"&vbcrlf
			End IF
		End If
		blockpage = blockpage+1
		i=i+1
	loop
	Response.Write "</span>"&Vbcrlf

	IF Int(page)<Int(totalpage) Then
		IF ajaxYN="" Then
			Response.Write "<a href='"&linkpage&"?page="&page+1 &"&"&str&"'><img src=""../images/front/btn2_next.gif"" alt=""Next"" /></a>"&Vbcrlf
		Else
			Response.Write "<a href=""javascript:"&linkpage&"("&str&",'"&page+1&"')""><img src=""../images/front/btn2_next.gif"" alt=""Next"" /></a>"&Vbcrlf
		End IF
	Else
		Response.Write "<a><img src=""../images/front/btn2_next.gif"" alt=""Next"" /></a>"&Vbcrlf
	End IF

	IF Cint(page)<totalpage Then
		IF ajaxYN="" Then
			Response.Write "<a href='"&linkpage&"?page="&TotalPage &"&"&str&"'><img src=""../images/front/btn2_next2.gif"" alt=""End"" /></a>"&Vbcrlf
		Else
			Response.Write "<a href=""javascript:"&linkpage&"("&str&",'"&TotalPage&"')""><img src=""../images/front/btn2_next2.gif"" alt=""End"" /></a>"&Vbcrlf
		End IF
	Else
		Response.Write "<a><img src=""../images/front/btn2_next2.gif"" alt=""End"" /></a>"&Vbcrlf
	End IF

	Response.Write "</div>"&Vbcrlf
End Function

Function PT_SpPageLink_mobile(linkpage,str,ajaxYN)
	Dim BlockPage,i
	Response.Write "<div class=""paging_all full"">"&Vbcrlf
	blockpage=int((page-1)/5)*5+1

'	IF Page<>1 Then
'		IF ajaxYN="" Then
'			Response.Write "<a href='"&linkpage&"?page=1&"&str&"'><img src=""../images/board/btn_prev2.gif"" alt=""Start"" /></a>"&Vbcrlf
'		Else
'			Response.Write "<a href=""javascript:"&linkpage&"("&str&",1)""><img src=""../images/board/btn_prev2.gif"" alt=""Start"" /></a>"&Vbcrlf
'		End IF
'	Else
'		Response.Write "<a href=""#noLink""><img src=""../images/board/btn_prev2.gif"" alt=""Start"" /></a>"&Vbcrlf
'	End IF

	IF Int(page)>1 Then
		IF ajaxYN="" Then
			Response.Write "<a href='"&linkpage&"?page="&page-1&"&"&str&"' class=""btn prev"">이전</a>"&Vbcrlf
		Else
			Response.Write "<a href=""javascript:"&linkpage&"("&str&",'"&page-1&"')"" class=""btn prev"">이전</a>"&Vbcrlf
		End IF
	Else
		Response.Write "<a href=""#noLink"" class=""btn prev"">이전</a>"&Vbcrlf
	End IF

	i=1

	Response.Write "<span class=""num"">"&Vbcrlf
	do until i>5 or blockpage > totalpage
		If blockpage=int(page) then
			Response.Write "<strong>"&blockpage&"</strong>"&vbcrlf
		Else
			IF ajaxYN="" Then
				Response.Write "<a href='"&linkpage&"?page="&blockpage&"&"&str&"'>"&blockpage&"</a>"&vbcrlf
			Else
				Response.Write "<a href=""javascript:"&linkpage&"("&str&",'"&blockpage&"')"">"&blockpage&"</a>"&vbcrlf
			End IF
		End If
		blockpage = blockpage+1
		i=i+1
	loop
	Response.Write "</span>"&Vbcrlf

	IF Int(page)<Int(totalpage) Then
		IF ajaxYN="" Then
			Response.Write "<a href='"&linkpage&"?page="&page+1 &"&"&str&"' class=""btn next"">다음</a>"&Vbcrlf
		Else
			Response.Write "<a href=""javascript:"&linkpage&"("&str&",'"&page+1&"')"" class=""btn next"">다음</a>"&Vbcrlf
		End IF
	Else
		Response.Write "<a href=""#noLink"" class=""btn next"">다음</a>"&Vbcrlf
	End IF

'	IF Cint(page)<totalpage Then
'		IF ajaxYN="" Then
'			Response.Write "<a href='"&linkpage&"?page="&TotalPage &"&"&str&"' class=""ml3""><img src=""../images/board/btn_next2.gif"" alt=""End"" /></a>"&Vbcrlf
'		Else
'			Response.Write "<a href=""javascript:"&linkpage&"("&str&",'"&TotalPage&"')"" class=""ml3""><img src=""../images/board/btn_next2.gif"" alt=""End"" /></a>"&Vbcrlf
'		End IF
'	Else
'		Response.Write "<a href=""#noLink"" class=""ml3""><img src=""../images/board/btn_next2.gif"" alt=""End"" /></a>"&Vbcrlf
'	End IF
	Response.Write "</div>"&Vbcrlf
End Function

' ***************************************************************************************
' * 함수설명 : 페이징 네비게이션 출력
' * 변수설명 : linkpage  = 이동페이지
' *           str = 겟방식 전송값
' ***************************************************************************************
Function PT_PageLink(linkpage,str,ajaxYN)
	Dim BlockPage,i
	Response.Write "<div class=""paging"">" &vbcrlf
	blockpage=int((page-1)/10)*10+1

	IF Int(page)>1 Then
		IF ajaxYN="" Then
			Response.Write "<a href='"&linkpage&"?page="&page-1&"&"&str&"' class=""paging_btn_prev""><span>이전</span></a>"&Vbcrlf
		Else
			Response.Write "<a href=""javascript:"&linkpage&"("&str&",'"&page-1&"')"" class=""paging_btn_prev""><span>이전</span></a>"&Vbcrlf
		End IF
	Else
		Response.Write "<a href=""#noLink"" class=""paging_btn_prev""><span>이전</span></a>"&Vbcrlf
	End IF

	i=1
	do until i>10 or blockpage > totalpage
		If blockpage=int(page) then
			Response.Write "<a class=""on"">"&blockpage&"</a>"&vbcrlf
		Else
			IF ajaxYN="" Then
				Response.Write "<a href='"&linkpage&"?page="&blockpage&"&"&str&"'>"&blockpage&"</a>"&vbcrlf
			Else
				Response.Write "<a href=""javascript:"&linkpage&"("&str&",'"&blockpage&"')"">"&blockpage&"</a>"&vbcrlf
			End IF
		End If
		blockpage = blockpage+1
		i=i+1
	loop

	IF Int(page)<Int(totalpage) Then
		IF ajaxYN="" Then
			Response.Write "<a href='"&linkpage&"?page="&page+1 &"&"&str&"' class=""paging_btn_next""><span>다음</span></a>"&Vbcrlf
		Else
			Response.Write "<a href=""javascript:"&linkpage&"("&str&",'"&page+1&"')"" class=""paging_btn_next""><span>다음</span></a>"&Vbcrlf
		End IF
	Else
		Response.Write "<a href=""#noLink"" class=""paging_btn_next""><span>다음</span></a>"&Vbcrlf
	End IF

	Response.Write "</div>"&vbcrlf
End Function

' ***************************************************************************************
' * 함수설명 : 카테고리 selectbox 셋팅
' ***************************************************************************************
Function PT_CateScript()
	Dim i,depth1,Depth2,Depth3,PreCaCode
	Response.Write "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
	Response.Write "depth1 = new Array();"&Vbcrlf
	Response.Write "depth1_value = new Array();"&Vbcrlf
	Response.Write "depth1_display = new Array();"&Vbcrlf
	Response.Write "depth2 = new Array();"&Vbcrlf
	Response.Write "depth2_value =  new Array();"&Vbcrlf
	Response.Write "depth2_display = new Array();"&Vbcrlf
	Response.Write "depth3 = new Array();"&Vbcrlf
	Response.Write "depth3_value =  new Array();"&Vbcrlf
	Response.Write "depth3_display = new Array();"&Vbcrlf

	IF IsArray(Allrec) Then
		Depth1=-1 : Depth2=0 : Depth3=0 : PreCaCode=""
		For i=0 To Ubound(Allrec,2)
			IF Allrec(2,i)=Allrec(3,i) Then
				Depth1=Depth1+1
				Response.Write "depth1["&Depth1&"]='"&ReplaceJScript(Allrec(0,i))&"';"&Vbcrlf
				Response.Write "depth1_value["&Depth1&"]="&Allrec(1,i)&";"&Vbcrlf
				Response.Write "depth1_display["&Depth1&"]="&Allrec(4,i)&";"&Vbcrlf
				Response.Write "depth2["&Depth1&"] = new Array();"&Vbcrlf
				Response.Write "depth2_value["&Depth1&"] = new Array();"&Vbcrlf
				Response.Write "depth2_display["&Depth1&"] = new Array();"&Vbcrlf
				Response.Write "depth3["&Depth1&"] = new Array();"&Vbcrlf
				Response.Write "depth3_value["&Depth1&"] = new Array();"&Vbcrlf
				Response.Write "depth3_display["&Depth1&"] = new Array();"&Vbcrlf
				Depth2=0
			Elseif Allrec(1,i)=Allrec(2,i) Then
				Response.Write "depth2["&Depth1&"]["&Depth2&"]='"&ReplaceJScript(Allrec(0,i))&"';"&Vbcrlf
				Response.Write "depth2_value["&Depth1&"]["&Depth2&"]="&Allrec(1,i)&";"&Vbcrlf
				Response.Write "depth2_display["&Depth1&"]["&Depth2&"]="&Allrec(4,i)&";"&Vbcrlf
				Response.Write "depth3["&Depth1&"]["&Depth2&"] = new Array();"&Vbcrlf
				Response.Write "depth3_value["&Depth1&"]["&Depth2&"] = new Array();"&Vbcrlf
				Response.Write "depth3_display["&Depth1&"]["&Depth2&"] = new Array();"&Vbcrlf
				Depth2=Depth2+1
				Depth3=0
			Else
				Response.Write "depth3["&Depth1&"]["&Depth2-1&"]["&Depth3&"]='"&ReplaceJScript(Allrec(0,i))&"';"&Vbcrlf
				Response.Write "depth3_value["&Depth1&"]["&Depth2-1&"]["&Depth3&"]="&Allrec(1,i)&";"&Vbcrlf
				Response.Write "depth3_display["&Depth1&"]["&Depth2-1&"]["&Depth3&"]="&Allrec(4,i)&";"&Vbcrlf
				Depth3=Depth3+1
			End IF
		Next
	End IF
	Response.Write "</SCRIPT>"&Vbcrlf
End Function

' ***************************************************************************************
' * 함수설명 : 카운터 Date체크함수
' ***************************************************************************************
Function DateRight(sDate)
	Dim Yy,Mm
	Yy = Mid(sDate,1,4)
	Mm = Mid(sDate,6,2)

	if (Mm = "01") or (Mm = "03") or (Mm = "05") or (Mm = "07") or (Mm = "08") or (Mm = "10") or (Mm = "12") then
		DateRight = Yy & "-" & Mm & "-" & "31"
		Exit Function
	End if

	if (Mm = "04") or (Mm = "06") or (Mm = "09") or (Mm = "11") then
		DateRight = Yy & "-" & Mm & "-" & "30"
		Exit Function
	End if

	if Mm = "02" then
		if DateCheck(Yy & "-" & Mm & "-" & "29") then
			DateRight = Yy & "-" & Mm & "-" & "29"
		ELSE
			DateRight = Yy & "-" & Mm & "-" & "28"
		End if

		Exit Function

	End if
End Function
Function DateCheck(sDate)
	'길이검사
	if Len(sDate) <> 10 then
		DateCheck = False
		Exit Function
	End if

	'월검사
	if ((Mid(sDate,6,2) < "01") or (Mid(sDate,6,2) > "12")) then
		DateCheck = False
		Exit Function
	End if

	'일검사
	if ((Mid(sDate,9,2) < "01") or (Mid(sDate,9,2) > "31")) then
		DateCheck = False
		Exit Function
	End if

	if (Mid(sDate,6,2) = "04") or (Mid(sDate,6,2) = "06") or (Mid(sDate,6,2) = "09") or (Mid(sDate,6,2) = "11") then
		if Mid(sDate,9,2) > "30" then
			DateCheck = False
			Exit Function
		End if
	End if

	'2월윤년검사
	if Mid(sDate,6,2) = "02" then

		if Mid(sDate,9,2) > "29" then
			DateCheck = False
			Exit Function
		ELSEif (CINT(Mid(sDate,1,4)) MOD 4) <> 0 then  '4로 나누어서 0가 아닌 것--> 28일이다
			if Mid(sDate,9,2) = "29" then
				DateCheck = False
				Exit Function
			End if
		ELSE '4로 나누어서 0인것 --> 29일 인것
			if (CINT(Mid(sDate,1,4)) MOD 100) =  0 then  '29 이면 error
				if (((CINT(Mid(sDate,1,4)) MOD 400) <> 0) and (Mid(sDate,9,2) > "28")) then
					DateCheck = False
					Exit Function
				End if
			End if
		End if
	End if

	DateCheck = True
End Function


'---------------------------------------------------------------------------------------------------
'** SMTP 메일 보내기
'---------------------------------------------------------------------------------------------------
Sub subSendMailSMTP(toMail, reMail, Subject, Body, iFormat , File)
	Dim iMsg
	Dim iConf
	Dim j
	Dim ARRMEMOFILENM

	Set iMsg = CreateObject("CDO.Message")
	'SendUsing 속성을 지정하기 위한 개체 생성
	Set iConf = iMsg.Configuration

	iConf.Load 1
	With iConf.Fields
		.item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2   '1일 경우 로컬(SMTP), 2일 경우 외부(SMTP)로 메일전송
		.item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "mail-002.iceserver.co.kr"
		.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 ' 메일 서버의 포트 번호
		'.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = true
		.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "master@medicube.iceserver.co.kr"
		.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "web13579"
		.item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 30
		.Update
	End With

	iMsg.To = reMail  '받는 사람 이메일 주소
	iMsg.From = toMail  '보내는 사람 이메일 주소
	iMsg.Subject  = Subject '제목
	iMsg.HTMLBody = Body    '본문

	IF File <> "" Then
		ARRMEMOFILENM = Split(File,"|")
		For j=0 To Ubound(ARRMEMOFILENM)
			IF ARRMEMOFILENM(j)<>"" Then iMsg.AddAttachment Server.MapPath("/upload/board/") &"/"& ARRMEMOFILENM(j)
		Next
	End If

	iMsg.BodyPart.Charset = "utf-8"
	iMsg.HTMLBodyPart.Charset = "utf-8"
	iMsg.Send

	Set iConf = Nothing
	Set iMsg = Nothing
End Sub
'---------------------------------------------------------------------------------------------------

Function Getrows_RecordSet(ProcName)
	Dim Rs
	SET Rs=DBCON.EXECUTE("{call "&procname&"}")
	IF NOT(Rs.BOF or Rs.EOF) then
		Getrows_RecordSet=Rs.Getrows
	END IF
	Rs.Close
	SET Rs=NOTHING
End Function

function CreateCommand(ByRef connection,ByVal cmdText,ByVal cmdType)
	dim objcmd
	set objcmd=Server.CreateObject("ADODB.Command")
		objcmd.ActiveConnection=connection
		objcmd.CommandText=cmdText
		objcmd.CommandType=cmdType
	set CreateCommand=objCmd
end function

function CreateInputParameter(ByVal paramName,ByVal paramType,ByVal paramSize,ByVal paramValue)
	Dim objParam
	set objParam=Server.CreateObject("ADODB.Parameter")
		objParam.Name=paramName
		objParam.Type=paramType
		objParam.direction=&H0001
		objParam.Size=paramSize
		objParam.Value=paramValue
	set CreateInputParameter=objParam
end function

function CreateOutputParameter(ByVal paramName,ByVal paramType,ByVal paramSize)
	Dim objParam
	set objParam=Server.CreateObject("ADODB.Parameter")
		objParam.Name=paramName
		objParam.Type=paramType
		objParam.direction=&H0002
		objParam.Size=paramSize
	set CreateOutputParameter=objParam
end function


' ***************************************************************************************
' * 함수설명 : 태그제거 함수
' * 변수설명 : ActText  = 변경할 스트링 변수
' *            AllowTags = 허용태그설정 변수
' ***************************************************************************************
Function RemoveUnallowTags(ActText, AllowTags)
	Dim content, tags
	content = ActText:
	tags = replace(AllowTags,",","|"):
	if Len(tags) = 0 Then tags = " "

	content	= EregiReplace("<(\/?)(?!\/|" & tags & ")([^<>]*)?>", "", content):
	content = EregiReplace("(javascript\:|vbscript\:)+","$1//",content):
	content = EregiReplace("(\.location|location\.|onload=|\.cookie|alert\(|window\.open\(|onmouse|onkey|onclick|view\-source\:)+","//",content): '//자바스크립트 실행방지

	content = replace(content,"&nbsp;"," "):
	RemoveUnallowTags = content:
End Function

Function EregiReplace(pattern, replace, text)
	Dim eregobj
	set eregobj= new regexp
	eregobj.pattern= pattern
	eregobj.ignorecase	= True
	eregobj.global = True
	EregiReplace = eregobj.replace(text, replace)

	set eregobj=nothing
End Function


FUNCTION REMOVETAGS(BYVAL STR)
 IF NOT ISNULL(STR) THEN
   DIM REGEX
   ' 정규표현식 객체
   SET REGEX = NEW REGEXP
   ' 자바스크립트 제거
   REGEX.PATTERN = "<script[^>]*>[\W|\w]*?</script>"
   REGEX.IGNORECASE = TRUE 'false(대소문자구분), true(구분안함, 기본)
   REGEX.GLOBAL = TRUE 'true(전체문자열), false(처음것만, 기본)
   STR = REGEX.REPLACE(STR, "")
   SET REGEX = NOTHING
   SET REGEX = NEW REGEXP
   ' 주석제거
   REGEX.PATTERN = "<!--[\W|\w]*?-->"
   REGEX.IGNORECASE = TRUE 'false(대소문자구분), true(구분안함, 기본)
   REGEX.GLOBAL = TRUE 'true(전체문자열), false(처음것만, 기본)
   STR = REGEX.REPLACE(STR, "")
   SET REGEX = NOTHING
   ' HTML태그 제거
   SET REGEX = NEW REGEXP
   REGEX.PATTERN = "<[\/\!]*?[^<>]*?>"
   REGEX.IGNORECASE = TRUE 'false(대소문자구분), true(구분안함, 기본)
   REGEX.GLOBAL = TRUE 'true(전체문자열), false(처음것만, 기본)
   REMOVETAGS = REPLACE(REGEX.REPLACE(STR, ""),"'","")
   REMOVETAGS = REPLACE(REMOVETAGS,"%","")
   SET REGEX = NOTHING
 ELSE
   REMOVETAGS = STR
 END IF
END FUNCTION

' ***************************************************************************************
' * 함수설명 : Date 형변환.(문자열 -추가)
' * 변수설명 : str : 변환할 변수 값
' ***************************************************************************************
Function DateStr(Str)
	DateStr=Left(Str,4)&"-"&Mid(Str,5,2)&"-"&Right(Str,2)
End Function

' ***************************************************************************************
' * 함수설명 : 게시판 중복방지용 코드생성.
' ***************************************************************************************
Function RdmCodeM(strLength)
	Dim str, strlen, tmpCode, Code
	Dim r, i, ds
	Dim RanSu(4)

	Randomize   ' 난수 발생기를 초기화합니다.
	For i=0 To 4
		RanSu(i)=Int((10 * Rnd) + 1)
	Next

	str = "abcdefghijklm0123456789nopqrstuvwxyz"
	strlen = strLength '자릿수
	Randomize '랜덤 초기화

	For i = 0 to strlen
		r = Int((Len(str) - 1 + 1) * Rnd + 1) ' 36은 str의 갯수

		tmpCode=Mid(Str,r,1)

		serialCode = serialCode + tmpCode
	Next
	RdmCodeM= serialCode
End Function

' ***************************************************************************************
' * 함수설명 : Layer팝업리스트 Get.
' ***************************************************************************************
SUB Get_PopInfo(Langsort, mobileYN)
	Dim NowDate,Allrec,i
	Dim Sort,TItle,Content,HtmlYN,LinkUrl,OutputImg
	NowDate=Year(date())&AddZero(Month(Date()))&AddZero(Day(Date()))
	Allrec=GetRows_RecordSet("FM_UP_PopupList(1,'"&NowDate&"','"&Langsort&"','"&mobileYN&"')")

	IF IsArray(Allrec) Then
		PopStr=""

		For i=0 To Ubound(Allrec,2)
			IF Allrec(11,i)=0 Then
				PopStr = PopStr & "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
				PopStr = PopStr & "popOpen("&Allrec(1,i)&","&Allrec(2,i)&","&Allrec(0,i)&","&Allrec(3,i)&","&Allrec(4,i)&","&Langsort&");"&Vbcrlf
				PopStr = PopStr & "</SCRIPT>"&Vbcrlf
			ElseIF Allrec(11,i)=1 Then
				Sort=Allrec(5,i) : Title=Allrec(6,i) : Content=Allrec(7,i) : HtmlYn=Allrec(8,i) : LinkUrl=Allrec(9,i) : OutputImg=Allrec(10,i)

				IF Request.Cookies("divpop_"&Allrec(0,i)) <> "done" Then
					PopStr = PopStr & "<div id='divpop_"&Allrec(0,i)&"' style='position:absolute; top:"&Allrec(3,i)&"px; left:"&Allrec(4,i)&"px; z-index:9999; border:3px solid #313031;'>"&Vbcrlf
					PopStr = PopStr & "<table cellpadding=0 cellspacing=0 style='word-break:break-all;'>"&Vbcrlf
					PopStr = PopStr & "	<tr>"&Vbcrlf
					PopStr = PopStr & "		<td bgcolor='#FFFFFF' colspan='2' valign='top' style='padding:3px;'>"&Vbcrlf
					IF Sort=0 Then
						PopStr = PopStr & "<div id='HKeditorContent' name='HKeditorContent' style='width:"&Allrec(1,i)&"px; height:"&Allrec(2,i)&"px; overflow-y:auto; color: #5D5D5D'>"&Content&"</div>"
					Else
						IF LinkUrl<>"" Then PopStr = PopStr & "<a href=""javascript:location.href='"&LinkUrl&"'"">"&Vbcrlf
						PopStr = PopStr & "<img src='/upload/popup/"&OutPutImg&"' border='0' align='absmiddle'></a>"&Vbcrlf
					End IF
					PopStr = PopStr & "		</td>"&Vbcrlf
					PopStr = PopStr & "	</tr>"&Vbcrlf
					PopStr = PopStr & "	<tr bgcolor='#313031' height='35' style='cursor:move; font-size:0; line-height:0;' onmouseover='Drag.init(this,divpop_"&Allrec(0,i)&")'>"&Vbcrlf
					PopStr = PopStr & "		<td style='padding:4px 0 0 10px; font-size:0; line-height:0; vertical-align: middle;'><img src='/_lib/memberimg/btn_pop_todayclose_layer.png' border='0' style='vertical-align:top;cursor:pointer;' onclick=""closetoLayer('divpop_"&Allrec(0,i)&"')"" /></td>"&Vbcrlf
					PopStr = PopStr & "		<td style='padding:4px 10px 0 0 ; font-size:0; line-height:0; vertical-align: middle;' align='right'><img src='/_lib/memberimg/btn_pop_close_layer.png' border='0' onclick='closeLayer(divpop_"&Allrec(0,i)&")' style='cursor:pointer; vertical-align:top;' /></td>"&Vbcrlf
					PopStr = PopStr & "	</tr>"&Vbcrlf
					PopStr = PopStr & "</table>"&Vbcrlf
					PopStr = PopStr & "</div>"&Vbcrlf
				End IF
			ElseIF Allrec(11,i)=2 Then
				idx=Allrec(0,i) : Sort=Allrec(5,i) : Title=Allrec(6,i) : HtmlYn=Allrec(8,i) : LinkUrl=Allrec(9,i) : temCode=Allrec(12,i)

				IF Request.Cookies("divpop_"&Allrec(0,i)) <> "done" Then
					PopStr = PopStr & "<div id='divpop_"&Allrec(0,i)&"' style='width:"&Allrec(1,i)&"px;position:absolute; top:"&Allrec(3,i)&"px; left:"&Allrec(4,i)&"px; z-index:9999; border:3px solid #313031;'>"&Vbcrlf
					PopStr = PopStr & "<div id='divtemppop_"&Allrec(0,i)&"' name='divtemppop_"&Allrec(0,i)&"' style='width:"&Allrec(1,i)&"px; height:"&Allrec(2,i)&"px;'></div>"&Vbcrlf
					PopStr = PopStr & "<table cellpadding=0 cellspacing=0 style='word-break:break-all;cursor:move;' width='100%' onmouseover='Drag.init(this,divpop_"&Allrec(0,i)&")'>"&Vbcrlf
					PopStr = PopStr & "	<tr bgcolor='#313031' height='30'>"&Vbcrlf
					PopStr = PopStr & "		<td style='font-size:0; line-height:0; vertical-align: middle;'><img src='/_lib/memberimg/btn_pop_todayclose_layer.png' border='0' style='cursor:pointer;' onclick=""closetoLayer('divpop_"&Allrec(0,i)&"')"" /></td>"&Vbcrlf
					PopStr = PopStr & "		<td style='font-size:0; line-height:0; vertical-align: middle;' align='right'><img src='/_lib/memberimg/btn_pop_close_layer.png' border='0' onclick='closeLayer(divpop_"&Allrec(0,i)&")' style='cursor:pointer;' /></td>"&Vbcrlf
					PopStr = PopStr & "	</tr>"&Vbcrlf
					PopStr = PopStr & "</table>"&Vbcrlf
					PopStr = PopStr & "</div>"&Vbcrlf
					PopStr = PopStr & "<SCRIPT LANGUAGE='JavaScript'>viewTempPopup('divtemppop_"&Allrec(0,i)&"',"&temCode&",'"&idx&"')</SCRIPT>"&Vbcrlf
				End IF
			END IF
		Next
	End IF
END Sub

SUB GET_PopInfo_Mobile(Langsort, mobileYN)
	Dim NowDate,Allrec,i
	Dim Sort,TItle,Content,HtmlYN,LinkUrl,OutputImg
	NowDate=Year(date())&AddZero(Month(Date()))&AddZero(Day(Date()))
	Allrec = GetRows_RecordSet("FM_UP_PopupList(1,'"&NowDate&"','"&Langsort&"','"&mobileYN&"')")

	IF IsArray(Allrec) Then
		PopStr=""

		For i=0 To Ubound(Allrec,2)
			popidx = Allrec(0,i) : sort = Allrec(5,i) : Title = Allrec(6,i) : Content = Allrec(7,i) : HtmlYn = Allrec(8,i) : LinkUrl = Allrec(9,i) : OutputImg = Allrec(10,i)

			IF Sort=0 Then
				PopStr = PopStr & "<div class=""slider"" id='HKeditorContent' name='HKeditorContent'>"&Content&"</div>"
			Else
				IF LinkUrl<>"" Then LinkTag = "<a href=""javascript:location.href='"&LinkUrl&"'"">"
				PopStr = PopStr & "<div class=""slider"">"&LinkTag&"<img src='/upload/popup/"&OutPutImg&"' border='0' align='absmiddle'></a></div>"
			End IF
		Next
	End IF
END Sub

Class ImageClass
	   Private m_Width
	   Private m_Height
	   Private m_ImageType
	   Private BinFile
	   Private BUFFERSIZE
	   Private objStream
	   Private m_Depth

	   Private Sub class_initialize()
	   	   BUFFERSIZE = 65535
	   	   m_Width	   = 0
	   	   m_Height	   = 0
	   	   m_Depth	   = 0
	   	   m_ImageType = Null
	   	   Set objStream = Server.CreateObject("ADODB.Stream")
	   End Sub

	   Private Sub class_terminate()
	   	   Set objStream = Nothing
	   End Sub

	   Public Property Get Width()
	   	   Width = m_Width
	   End Property

	   Public Property Get Height()
	   	   Height = m_Height
	   End Property

	   Public Property Get ImageType()
	   	   ImageType = m_ImageType
	   End Property

	   Private Function Mult(lsb, msb)
	   	   Mult = lsb + (msb * CLng(256))
	   End Function

	   Private Function BinToAsc(ipos)
	   	   BinToAsc = AscB(MidB(BinFile, (ipos+1), 1))
	   End Function

	   Public Sub LoadFilePath(strPath)
	   	   If InStr(strPath, ":") = 0 Then
	   	   	   strPath = Server.MapPath(strPath)
	   	   End If

	   	   objStream.Open
	   	   objStream.LoadFromFile(strPath)
	   	   BinFile = objStream.ReadText(-1)
	   End Sub

	   Public Sub LoadBinary(BinaryFile)
	   	   BinFile = BinaryFile
	   End Sub

	   Public Sub ImageRead
	   	   IF  BinToAsc(0) = 137 And BinToAsc(1) = 80 And BinToAsc(2) = 78 Then
	   	   	   m_ImageType = "png"

	   	   	   Select Case BinToAsc(25)
	   	   	   	   Case 0
	   	   	   	   	   Depth = BinToAsc(24)
	   	   	   	   Case 2
	   	   	   	   	   Depth = BinToAsc(24) * 3
	   	   	   	   Case 3
	   	   	   	   	   Depth = 8
	   	   	   	   Case 4
	   	   	   	   	   Depth = BinToAsc(24) * 2
	   	   	   	   Case 6
	   	   	   	   	   Depth = BinToAsc(24) * 4
	   	   	   	   Case Else
	   	   	   	   	   m_ImageType = Null
	   	   	   End Select

	   	   	   If not IsNull(m_ImageType) Then
	   	   	   	   m_Width = Mult(BinToAsc(19), BinToAsc(18))
	   	   	   	   m_Height = Mult(BinToAsc(23), BinToAsc(22))
	   	   	   End If
	   	   End If

	   	   If BinToAsc(0) = 71 And BinToAsc(1) = 73 And BinToAsc(2) = 70 Then
	   	   	   m_ImageType = "gif"
	   	   	   m_Width = Mult(BinToAsc(6), BinToAsc(7))
	   	   	   m_Height = Mult(BinToAsc(8), BinToAsc(9))
	   	   	   m_Depth = (BinToAsc(10) And 7) + 1
	   	   End If

	   	   If BinToAsc(0) = 66 And BinToAsc(1) = 77 Then
	   	   	   m_ImageType = "bmp"
	   	   	   m_Width = Mult(BinToAsc(18), BinToAsc(19))
	   	   	   m_Height = Mult(BinToAsc(22), BinToAsc(23))
	   	   	   m_Depth = BinToAsc(28)
	   	   End If


	   	   If IsNull(m_ImageType) Then
	   	   	   Dim lPos : lPos = 0
	   	   	   Do
	   	   	   	   If (BinToAsc(lPos) = &HFF And BinToAsc(lPos + 1) = &HD8 _
	   	   	   	   	    And BinToAsc(lPos + 2) = &HFF) _
	   	   	   	   	    Or (lPos >= BUFFERSIZE - 10) Then Exit Do
	   	   	   	   	   lPos = lPos + 1
	   	   	   Loop

	   	   	   lPos = lPos + 2
	   	   	   If lPos >= BUFFERSIZE - 10 Then Exit Sub

	   	   	   Do
	   	   	   	   Do
	   	   	   	   	   If BinToAsc(lPos) = &HFF And BinToAsc(lPos + 1) _
	   	   	   	   	   	   <> &HFF Then Exit Do
	   	   	   	   	   	   lPos = lPos + 1
	   	   	   	   	   	   If lPos >= BUFFERSIZE - 10 Then Exit Sub
	   	   	   	   Loop

	   	   	   	   lPos = lPos + 1

	   	   	   	   If  (BinToAsc(lPos) >= &HC0 And BinToAsc(lPos) <= &HC3) Or _
	   	   	   	   (BinToAsc(lPos) >= &HC5 And BinToAsc(lPos) <= &HC7) Or _
	   	   	   	   (BinToAsc(lPos) >= &HC9 And BinToAsc(lPos) <= &HCB) Or _
	   	   	   	   (BinToAsc(lPos) >= &HCD And BinToAsc(lPos) <= &HCF) Then
	   	   	   	   	   Exit Do
	   	   	   	   End If

	   	   	   	   lPos = lPos + Mult(BinToAsc(lPos + 2), BinToAsc(lPos + 1))

	   	   	   	   If lPos >= BUFFERSIZE - 10 Then Exit Sub
	   	   	   Loop

	   	   	   m_ImageType = "jpg"
	   	   	   m_Height = Mult(BinToAsc(lPos + 5), BinToAsc(lPos + 4))
	   	   	   m_Width = Mult(BinToAsc(lPos + 7), BinToAsc(lPos + 6))
	   	   	   m_Depth = BinToAsc(lPos + 8) * 8
	   	   End IF
	   End Sub

End Class

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Set Default Value
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub SetDefault(Var, Value)
	if (Var = "") or isNull(Var) then
		Var = Value
	End if
End Sub


Function isMobile()
	Dim user_agent, mobile_browser, Regex, match, mobile_agents, mobile_ua, i, size
	user_agent = Request.ServerVariables("HTTP_USER_AGENT")
	mobile_browser = 0
	Set Regex = New RegExp
	With Regex
		.Pattern = "(up.browser|up.link|mmp|symbian|smartphone|midp|wap|phone|windows ce|pda|mobile|mini|palm)"
		.IgnoreCase = True
		.Global = True
	End With
	match = Regex.Test(user_agent)
	If match Then mobile_browser = mobile_browser+1
	If InStr(Request.ServerVariables("HTTP_ACCEPT"), "application/vnd.wap.xhtml+xml") Or Not IsEmpty(Request.ServerVariables("HTTP_X_PROFILE")) Or Not IsEmpty(Request.ServerVariables("HTTP_PROFILE")) Then
		mobile_browser = mobile_browser+1
	End  If
	' // Now you're going through the list of devices,
	' // this is an array so as time moves on, just add
	' // more that come to the marketplace into here
	mobile_agents = Array("alcatel", "amoi", "android", "avantgo", "blackberry", "benq", "cell", "cricket", "docomo", "elaine", "htc", "iemobile", "iphone", "ipad", "ipaq", "ipod", "j2me", "java", "midp", "mini", "mmp", "mobi", "motorola", "nec-", "nokia", "palm", "panasonic", "philips", "phone", "sagem", "sharp", "sie-", "smartphone", "sony", "symbian", "t-mobile", "telus", "up\.browser", "up\.link", "vodafone", "wap", "webos", "wireless", "xda", "xoom", "zte")
	size = Ubound(mobile_agents)
	mobile_ua = LCase(Left(user_agent, 4))
	' // You've previously set mobile_browser as 0,
	' // now loop through the array set above and
	' // if one or more is matched, add 1 to this variable
	For i = 0 To size
		If mobile_agents(i) = mobile_ua Then
			mobile_browser = mobile_browser+1
		Exit For
		End If
	Next
	' // Check that full website has not been requested
	' // (you can have a link in the page for this like:
	' // View Full Site
'	If request.querystring("v")="full" then session("fullsite")=true
	' // Check to see if the var mobile_browser is greater
	' // than 0, if so it's a mobile device, act accordingly.
'	If mobile_browser>0 and session("fullsite")=false and flag2Bool(cfgIsMobile) then
	If mobile_browser>0 then
	' // redirect the user to a mobile appropriate page you've written
		isMobile = True
	Else
		isMobile = False
	End If
	' END MOBILE PHONE SCRIPT
End Function

FUNCTION SendMesg(url)
    Dim RStr
    Dim xmlHttp

    SET xmlHttp = Server.CreateObject("Microsoft.XMLHTTP")
    xmlHttp.open "GET", url, False
    xmlHttp.setRequestHeader "Content-Type","text/xml"
    xmlHttp.setRequestHeader "Accept-Language","ko"
    xmlHttp.send

    if xmlHttp.status = 200 then
        RStr = xmlHttp.responseText
    Else
        RStr = "get_fail"
    End if

    SET xmlHttp = Nothing

    SendMesg = RStr
END FUNCTION

Function ResultMsg(Str)
	IF Str=1 Then
		ResultMsg="필수전달값이 빠짐\nSms발송이 중지되었습니다\n다시시도해주십시오."
	ElseIF Str=2 Then
		ResultMsg="존재하지 않는 아이디\nSms발송이 중지되었습니다\n다시시도해주십시오."
	ElseIF Str=3 Then
		ResultMsg="비밀번호 인증실패\nSms발송이 중지되었습니다\n다시시도해주십시오."
	ElseIF Str=4 Then
		ResultMsg="잔액이 충분하지 않음\nSms발송이 중지되었습니다\n다시시도해주십시오."
	ElseIF Str=5 Then
		ResultMsg="받는 번호가 잘못됨\nSms발송이 중지되었습니다\n다시시도해주십시오."
	ElseIF Str=6 Then
		ResultMsg="보내는 번호가 잘못됨\nSms발송이 중지되었습니다\n다시시도해주십시오."
	ElseIF Str=7 Then
		ResultMsg="서비스 이용이 중지된 아이디\nSms발송이 중지되었습니다\n다시시도해주십시오."
	ElseIF Str=9 Then
		ResultMsg="SMS전송이 완료되었습니다."
	End IF
End Function

Sub AD_Logout(altMsg, url)
	Session("acountcode") = ""
	Session("accuntmemsort") = ""
	Session("acountidx") = ""
	Session("acountname") = ""
	Session("user_ip") = ""

	IF url<>"" Then
		strLocation=url
		Response.Write ExecJavaAlert(altMsg,2)
	End IF
	Response.End
End Sub

Function CSRP_TokenCreate(strLength)
	set_KeyTable = "A0N1B2A3C4N5D6U7E8M9F0LGOHTITJOKLMNOPQRSTUVWXYZ"
	set_Token = ""
	randomize

	For cnt = 1 to strLength
		get_KeyPos = int((49 - 1 + 1) * Rnd + 1)
		set_Token = set_Token & mid(set_KeyTable, get_KeyPos, 1)
	Next
	session("CSRP_Token") = set_Token
	CSRP_TokenCreate = set_Token
End Function

Function CSRP_TokenConfirm( get_Token )
	IF session("CSRP_Token")="" OR session("CSRP_Token") <> get_Token Then
		CSRP_TokenConfirm = False
	Else
		CSRP_TokenConfirm = True
	End IF
End Function

Function GetFileStsCode(FileName)
	Dim fileext,FileImage
	IF FileName<>"" Then
		fileext=LCASE(mid(FileName,instrrev(FileName,".")+1))

		IF fileext<>"pdf" AND fileext<>"zip" Then
			fileext = "other"
		End IF

		GetFileStsCode = fileext
	End IF
End Function

Function iif_InstrCompareDiv(separator, val1, val2, setVal)
	IF isNull(val1) Then val1=""
	val1 = Trim(val1) : val2 = Trim(val2)
	IF setVal="" Then setVal = "active"

	IF INSTR(separator&val1&separator, separator&val2&separator)>0 Then
		iif_InstrCompareDiv = setVal
	Else
		iif_InstrCompareDiv = ""
	End IF
End Function

Function iif_InstrCompare(val1, val2, setVal)
	IF isNull(val1) Then val1=""
	val1 = Replace(Trim(val1),", ",",")
	IF setVal="" Then setVal = "active"

	IF INSTR(","&val1&",", ","&val2&",")>0 Then
		iif_InstrCompare = setVal
	Else
		iif_InstrCompare = ""
	End IF
End Function

Function iif_Compare(val1, val2, setVal)
	IF IsNull(val1) Then val1=""
	IF IsNull(val2) Then val2=""

	IF CStr(val1)=CStr(val2) Then
		iif_Compare = setVal
	Else
		iif_Compare=""
	End IF
End Function

Function iif_CompareNot(val1,val2,setVal)
	IF IsNull(val1) Then val1=""
	IF IsNull(val2) Then val2=""

	IF CStr(val1)<>CStr(val2) Then
		iif_CompareNot = setVal
	Else
		iif_CompareNot=""
	End IF
End Function

'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' Function Name	: uf_ConvertDateFormat
' Parameter		: strDate - 대상날자값 ,OutFormat - 변경하고 싶은 유형
' Return		:
' Description	: 날짜데이터를 받아 원하는 형식으로 변환
'
'			OutFormat = "1" ==> yyyy-mm-dd hh:mm:ss
'			OutFormat = "2" ==> yyyy-mm-dd
'			OutFormat = "3" ==> mm/dd hh:mm
'			OutFormat = "4" ==> yyyy.mm.dd
'	 		OutFormat = "5" ==> yyyy/mm.dd
'	 		OutFormat = "10"==> YYYYMMDDhhmmss (14자리)
'
'			예: uf_ConvertDateFormat(now,10)	 --> YYYYMMDDhhmmss 형태로나옴.
'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Function uf_ConvertDateFormat(byVal strDate,OutFormat)
	Dim sResult
	If IsNull(strDate) or strDate ="" Then
		sResult = ""
	Else
		IF Not(isDate(strDate)) Then
			strDate = uf_ConvertDateFormat1(strDate)
		End IF

		Dim sYear,sMonth,sDay,sHour,sMinute,sSecond
		sYear   = Year(strDate)
		sMonth  = Month(strDate)
		sDay    = Day(strDate)
		sHour   = Hour(strDate)
		sMinute = Minute(strDate)
		sSecond = Second(strDate)
		sWeekday = strWeekday(Weekday(strDate))

		shlafHour = sHour
		hourSort = "AM"
		IF sHour>13 AND sHour<24 Then
			shlafHour = sHour - 12
			hourSort = "PM"
		End IF

		If Len(sMonth) < 2 Then sMonth = "0" & sMonth
		If Len(sDay) < 2 Then sDay = "0" & sDay
		If Len(sHour) < 2 Then sHour = "0" & sHour
		If Len(sMinute) < 2 Then sMinute = "0" & sMinute
		If Len(sSecond) < 2 Then sSecond = "0" & sSecond
		If Len(shlafHour) < 2 Then shlafHour = "0" & shlafHour

		Select Case OutFormat
			Case 1
				sResult = sYear & "-" & sMonth & "-" & sDay & " " & sHour & ":" & sMinute
			Case 2
				sResult = sYear & "-" & sMonth & "-" & sDay
			Case 3
				sResult = sMonth & "/" & sDay & " " & sHour & ":" & sMinute
			Case 4
				sResult = sYear & "." & sMonth & "." & sDay
			Case 5
				sResult = sYear & "/" & sMonth & "/" & sDay
			Case 6
				sResult = sMonth & "-" & sDay
			Case 7
				sResult = sYear & "년 " & sMonth & "월 " & sDay & "일"
			Case 8
				sResult = sYear & "." & sMonth & "." & sDay & " " & sHour & ":" & sMinute & ":" & sSecond
			Case 9
				sResult = sYear & "." & sMonth & "." & sDay & "." & sHour & "." & sMinute & "." & sSecond
			Case 10
				sResult = sYear & sMonth & sDay & sHour & sMinute & sSecond
			Case 11
				sResult = Right(sYear,2) & sMonth & sDay & sHour & sMinute & sSecond
			Case 12
				sResult = sYear & sMonth & sDay
			Case 13
				sResult = sHour & sMinute & sSecond
			Case 90
				sResult = sYear&"."&sMonth&"<strong>"&sDay&"</strong>"
			Case 91
				sResult = Right(sYear,2) & "." & sMonth & "." & sDay
			Case 92
				sResult = sYear & "년 " & sMonth & "월 " & sDay & "일("&sWeekday&")"
			Case 93
				sResult = sHour & ":" & sMinute & ":" & sSecond
			Case 94
				sResult = sHour & ":" & sMinute
			Case 95
				sResult = "<dt>"&sDay&"</dt><dd>"&sYear&"."&sMonth&"</dd>"
			Case 96
				sResult = sYear & sMonth & sDay & sHour & sMinute
			Case 97
				sResult = getEngMonth(CLng(sMonth)) & " " & AddZero(CLng(sDay)) & ", " & sYear
			Case 98
				sResult = sYear & "년 " & sMonth & "월 " & sDay & "일 " & sHour & "시 " & sMinute &"분"
			Case 99
				sResult = sYear & "년 " & sMonth & "월 " & sDay & "일("&sWeekday&") " & shlafHour & ":" & sMinute &" "&hourSort
			Case 14
				sResult = sMonth & "." & sDay
		End Select
	End If
	uf_ConvertDateFormat = sResult
End Function

Function getEngMonth(cVal)
	cVal = CStr(cVal)
	IF cVal="1" Then
		getEngMonth = "January"
	ElseIF cVal="2" Then
		getEngMonth = "February"
	ElseIF cVal="3" Then
		getEngMonth = "March"
	ElseIF cVal="4" Then
		getEngMonth = "April"
	ElseIF cVal="5" Then
		getEngMonth = "May"
	ElseIF cVal="6" Then
		getEngMonth = "June"
	ElseIF cVal="7" Then
		getEngMonth = "July"
	ElseIF cVal="8" Then
		getEngMonth = "August"
	ElseIF cVal="9" Then
		getEngMonth = "September"
	ElseIF cVal="10" Then
		getEngMonth = "October"
	ElseIF cVal="11" Then
		getEngMonth = "November"
	ElseIF cVal="12" Then
		getEngMonth = "December"
	End IF
End Function

Function uf_ConvertDateFormat1(byVal strDate)
	Dim sResult
	If IsNull(strDate) or strDate ="" Then
		sResult = ""
	Else
		Dim sYear,sMonth,sDay,sHour,sMinute,sSecond
		sYear   = LEFT(strDate,4)
		sMonth  = MID(strDate,5,2)
		sDay    = MID(strDate,7,2)

		sResult = sYear & "-" & sMonth & "-" & sDay
	End If
	uf_ConvertDateFormat1 = sResult
End Function

Function getTimestamp(strDate)
	ON ERROR RESUME NEXT
	getTimestamp = DateDiff("s", "1970-01-01 00:00:00", strDate)
End Function

Function convertTimestampDatetime(ByVal p_timestamp)
	ON ERROR RESUME NEXT
	convertTimestampDatetime = DateAdd("s", p_timestamp, "1970-01-01 00:00:00")
End Function

function time_stamp()
	time_stamp = DateDiff("s", "1970-01-01 00:00:00", now)*1000+clng(timer)
end function

Function strWeekday(Str)
	IF CStr(Str)="1" Then
		strWeekday="일"
	ElseIF CStr(Str)="2" Then
		strWeekday="월"
	ElseIF CStr(Str)="3" Then
		strWeekday="화"
	ElseIF CStr(Str)="4" Then
		strWeekday="수"
	ElseIF CStr(Str)="5" Then
		strWeekday="목"
	ElseIF CStr(Str)="6" Then
		strWeekday="금"
	ElseIF CStr(Str)="7" Then
		strWeekday="토"
	End IF
End Function

Sub getHour(basicVal)
	Dim i
	For i=0 To 23
		Response.Write "<option value="""&addZero(i)&""" "&selCheck(basicVal, addZero(i))&">"&addZero(i)&"</option>"
	Next
End Sub

Sub getTime(basicVal)
	Dim i
	For i=0 To 55 Step 5
		Response.Write "<option value="""&addZero(i)&""" "&selCheck(basicVal, addZero(i))&">"&addZero(i)&"</option>"
	Next
End Sub

Sub getYear(firstyear, lastYear, basicVal)
	Dim i
	IF firstyear = "" Then firstyear="2010"
	IF lastYear = "" Then lastYear=Year(Date())

	For i=firstyear To lastYear
		Response.Write "<option value="""&addZero(i)&""" "&selCheck(basicVal, addZero(i))&">"&addZero(i)&"</option>"
	Next
End Sub

Sub getYearDesc(firstyear, lastYear, basicVal)
	Dim i
	IF firstyear = "" Then firstyear = Year(Date())
	IF lastYear = "" Then lastYear = "2010"

	For i=firstyear To lastYear Step -1
		Response.Write "<option value="""&addZero(i)&""" "&selCheck(basicVal, addZero(i))&">"&addZero(i)&"년</option>"
	Next
End Sub

Sub getMonth(basicVal)
	Dim i
	For i=1 To 12
		Response.Write "<option value="""&addZero(i)&""" "&selCheck(addZero(basicVal), addZero(i))&">"&addZero(i)&"</option>"
	Next
End Sub

Sub getDay(basicVal)
	Dim i
	For i=1 To 31
		Response.Write "<option value="""&addZero(i)&""" "&selCheck(addZero(basicVal), addZero(i))&">"&addZero(i)&"</option>"
	Next
End Sub

Function Fill_Space(byVal sNum, byVal sCnt)
	sNum = Right("                         "+CStr(sNum),sCnt)
	Fill_Space = sNum
End Function

Function addHyphen(strVal)
	IF isNull(strVal) Then strVal = ""

	tmpStrVal = Split(strVal,"-")
	IF Ubound(tmpStrVal)<>2 Then
		Select Case Len(strVal)
		Case 8    '1588-xxxx
			t1 = Mid(strVal,1,4)
			t2 = Mid(strVal,5,4)
			addHyphen = t1 & "-" &t2
		Case 9	'02-xxx-xxxx
			t1 = Mid(strVal,1,2)
			t2 = Mid(strVal,3,3)
			t3 = Mid(strVal,6,4)
			addHyphen = t1 & "-" &t2 & "-" &t3
		Case 10	'휴대전화 010-xxx-xxxx
			If Mid(strVal,1,2) = "01" Then	'휴대전화 010-xxx-xxxx
				t1 = Mid(strVal,1,3)
				t2 = Mid(strVal,4,3)
				t3 = Mid(strVal,7,4)
				addHyphen = t1 & "-" &t2 & "-" &t3
			Else	'일반전화
				If Mid(strVal,1,2) = "02" Then
					t1 = Mid(strVal,1,2)
					t2 = Mid(strVal,3,4)
					t3 = Mid(strVal,7,4)
					addHyphen = t1 & "-" &t2 & "-" &t3
				Else
					t1 = Mid(strVal,1,3)
					t2 = Mid(strVal,4,3)
					t3 = Mid(strVal,7,4)
					addHyphen = t1 & "-" &t2 & "-" &t3
				End If
			End If
		Case 11	'xxx-xxxx-xxxx(휴대전화,070)
			t1 = Mid(strVal,1,3)
			t2 = Mid(strVal,4,4)
			t3 = Mid(strVal,8,4)
			addHyphen = t1 & "-" &t2 & "-" &t3
		Case Else
			addHyphen = strVal
		End Select
	Else
		addHyphen = strVal
	End IF
End Function

Function returnToByte(ByVal str)
	Dim str_byte, t

	str_byte = 0

	For t = 1 To Len(str)
		If Len(escape(Mid(str, t, 1))) > 4 Then
			str_byte = str_byte + 2
		Else
			str_byte = str_byte + 1
		End If
	Next

	returnToByte = str_byte
End Function

Function getImageTags(Patrn, TestStr)
	IF Patrn = 0 Then
		rPatrn = "<img [^<>]*>"					 '이미지 태그만 추출 패턴
	ElseIF Patrn = 1 Then
		rPatrn = "[src]+=[\""']([^\""']*).(gif|jpg|jpeg|bmp|png)"     '이미지 경로 전체 추출 패턴
	ElseIF Patrn = 2 Then
		rPatrn = "[^='/]*\.(gif|jpg|jpeg|bmp|png)"   '이미지 파일명만 추출 패턴
	End IF

	Dim ObjRegExp
	'On Error Resume Next
	Set ObjRegExp = New RegExp
	ObjRegExp.Pattern = rPatrn               ' 정규 표현식 패턴
	ObjRegExp.Global = True                 ' 문자열 전체를 검색함
	ObjRegExp.IgnoreCase = True          ' 대.소문자 구분 안함

	Set Matches = ObjRegExp.Execute(TestStr)

	RetStr = ""
	For Each Match in Matches 'Matches 컬렉션을 반복
		'RetStr = RetStr & "<br>" & Replace(Match, Value, "<", "&lt;") & vbcrlf
		'RetStr = RetStr & "<br>" & Match
		RetStr = Match
		Exit For
	Next

	IF Patrn = 1 Then
		RetStr = Replace(RetStr, "src=""","")
		RetStr = Replace(RetStr, "src='","")
	End IF
	getImageTags = Trim(RetStr)

	Set ObjRegExp = Nothing
End Function

Function getWeekDay(strDate)
	weekDate = weekDay(strDate)

	select case weekDate
		case "1" getWeekDay = "일요일"
		case "2" getWeekDay = "월요일"
		case "3" getWeekDay = "화요일"
		case "4" getWeekDay = "수요일"
		case "5" getWeekDay = "목요일"
		case "6" getWeekDay = "금요일"
		case "7" getWeekDay = "토요일"
	end select
End Function

Function EmailMasking(stremail)
	emailpattern = "^[\w-\.]{1,}\@([\da-zA-Z-]{1,}\.){1,}[\da-zA-Z-]{2,3}$"
	IF stremail = "" then
		EmailMasking = ""
	Else
		Dim regEx, Matches
		Set regEx = New RegExp
		regEx.Pattern = emailpattern
		regEx.IgnoreCase = True
		regEx.Global = True
		Set Matches = regEx.Execute(stremail)

		tmpStr = "***********************************************************************************************"
		IF 0 < Matches.count Then
			arrEmailStr = Split(stremail,"@")

			LenEmailID = Len(arrEmailStr(0))
			IF LenEmailID>1 Then
				EmailMasking = Left(arrEmailStr(0), FIX(LenEmailID/2)) & MID(tmpStr,1,Len(arrEmailStr(0))-FIX(LenEmailID/2))&"@"&arrEmailStr(1)
			Else
				EmailMasking = "*@"&arrEmailStr(1)
			End IF
		Else
			EmailMasking = ""
		End IF
	End IF
End Function

Function PhoneMasking(strVal)
	tmpStr = "***********************************************************************************************"
	IF isNull(strVal) Then strVal = ""

	tmpStrVal = Split(strVal,"-")
	IF Ubound(tmpStrVal)<>2 Then
		Select Case Len(strVal)
		Case 8    '1588-xxxx
			t1 = Mid(strVal,1,4)
			t2 = Mid(strVal,5,4)
			PhoneMasking = t1 & "-" &MID(tmpStr,1,Len(t2))
		Case 9	'02-xxx-xxxx
			t1 = Mid(strVal,1,2)
			t2 = Mid(strVal,3,3)
			t3 = Mid(strVal,6,4)
			PhoneMasking = t1 & "-" & MID(tmpStr,1,Len(t2)) & "-" &t3
		Case 10	'휴대전화 010-xxx-xxxx
			If Mid(strVal,1,2) = "01" Then	'휴대전화 010-xxx-xxxx
				t1 = Mid(strVal,1,3)
				t2 = Mid(strVal,4,3)
				t3 = Mid(strVal,7,4)
				PhoneMasking = t1 & "-" & MID(tmpStr,1,Len(t2)) & "-" &t3
			Else	'일반전화
				If Mid(strVal,1,2) = "02" Then
					t1 = Mid(strVal,1,2)
					t2 = Mid(strVal,3,4)
					t3 = Mid(strVal,7,4)
					PhoneMasking = t1 & "-" & MID(tmpStr,1,Len(t2)) & "-" &t3
				Else
					t1 = Mid(strVal,1,3)
					t2 = Mid(strVal,4,3)
					t3 = Mid(strVal,7,4)
					PhoneMasking = t1 & "-" & MID(tmpStr,1,Len(t2)) & "-" &t3
				End If
			End If
		Case 11	'xxx-xxxx-xxxx(휴대전화,070)
			t1 = Mid(strVal,1,3)
			t2 = Mid(strVal,4,4)
			t3 = Mid(strVal,8,4)
			PhoneMasking = t1 & "-" & MID(tmpStr,1,Len(t2)) & "-" &t3
		Case Else
			PhoneMasking = strVal
		End Select
	Else
		PhoneMasking = tmpStrVal(0) & "-" & MID(tmpStr,1,Len( tmpStrVal(1) )) & "-" &tmpStrVal(2)
	End IF
End Function

Function Create_CCodeOption(gCode, cVal)
	Dim i

	IF IsArray(GB_CodeRec) Then
		For i=0 To UBound(GB_CodeRec,2)
			IF GB_CodeRec(0,i) = gCode Then
				Response.Write "<option value="""&GB_CodeRec(1,i)&""" "&selCheck(GB_CodeRec(1,i), cVal)&">"&GB_CodeRec(2,i)&"</option>"
			End IF
		Next
	End IF
End Function

Function Create_CCodeCheckBox(gCode, checkBoxName, chkVal)	
	Dim i
	IF IsArray(GB_CodeRec) Then
		For i=0 To UBound(GB_CodeRec,2)
			IF GB_CodeRec(0,i) = gCode Then
				IF InStr(","&chkVal&",", ","&GB_CodeRec(1,i)&",") > 0 Then
					Response.Write "<p class=""checkIn""><input type=""checkbox"" id="""&checkBoxName&"_"&i&""" name="""&checkBoxName&""" value="""&GB_CodeRec(1,i)&""" checked><label for="""&checkBoxName&"_"&i&""">"&ReplaceNoHtml(GB_CodeRec(2,i))&"</label></p>"
				Else
					Response.Write "<p class=""checkIn""><input type=""checkbox"" id="""&checkBoxName&"_"&i&""" name="""&checkBoxName&""" value="""&GB_CodeRec(1,i)&"""><label for="""&checkBoxName&"_"&i&""">"&ReplaceNoHtml(GB_CodeRec(2,i))&"</label></p>"
				End IF
			End IF
		Next
	End IF
End Function

Function Create_Option(Rec, cVal, vindex, nindex, nmStr)
	Dim i
	IF IsArray(Rec) Then
		For i=0 To UBound(Rec,2)
			IF nmStr="" Then
				Response.Write "<option value="""&Rec(vindex,i)&""" "&selCheck(Rec(vindex,i), cVal)&">"&Rec(nindex,i)&"</option>"&Vbcrlf
			Else
				Response.Write "<option value="""&Rec(vindex,i)&""" "&selCheck(Rec(vindex,i), cVal)&">"&Rec(nindex,i)&" "&nmStr&"</option>"&Vbcrlf
			End IF
		Next
	End IF
End Function

Function FileAllowCheckIMG(FormName)
	fName = FormName.filename
	fType = LCase(Mid(fName, InStrRev(fName, ".") + 1))

	IF InStr(allowIMGFileTypes,fType)>0 Then
		FileAllowCheckIMG = True
	Else
		FileAllowCheckIMG = False
	End IF
End Function

Function testThumbSaves(BasicWidthSize, BasicHeightSize, FormName, Path, tPath, SourceFile)
	Dim ObjImage, imgWidth, imgHeight, WidthPer, HeightPer, SizePer, SourceFileName, ThumbPath
	Dim ThumbWidth, ThumbHeight
	Dim SourceFileExt

	Set objImage =server.CreateObject("DEXT.ImageProc")
	objImage.Quality=100

	IF True = objImage.SetSourceFile(Path&"\"&SourceFile) then
		imgWidth = FormName.ImageWidth		'실제이미지 가로사이즈
		imgHeight = FormName.ImageHeight		'실제이미지 세로사이즈

		IF imgWidth<BasicWidthSize AND imgHeight<BasicHeightSize Then
			ThumbWidth=int(imgWidth)
			ThumbHeight=int(imgHeight)
		Else
			WidthPer=imgWidth/BasicWidthSize
			HeightPer=imgHeight/BasicHeightSize

			IF WidthPer>HeightPer Then
				SizePer=WidthPer
			Else
				SizePer=HeightPer
			End IF

			ThumbWidth=int(imgWidth/SizePer)
			ThumbHeight=int(imgHeight/SizePer)
		End IF

		ThumbPath = tPath&"\"& SourceFile

		objImage.SaveasThumbnail ThumbPath, ThumbWidth, ThumbHeight, false
		testThumbSaves = SourceFile
	End IF
	set objImage = nothing
End Function

Sub conTestFileSave(FormName, Path, PermissionSize)
	Dim FileNameOri, FileName, FilePath, Filenameonly, Fileext, i
	retFileUploadOk = True : retFileSaveName = "" : retFileOriName = ""

	IF PermissionSize<>"" Then
		IF CLng(PermissionSize) < CLng(FormName.FileLen) Then
			retFileUploadOk = False
			Exit Sub
		End IF
	End IF

	FileNameOri = Replace(Replace(Replace(FormName.filename," ","_"),"'","`"),"|","")

	IF instrrev(FileNameOri,".") <> 0 then
		Filenameonly = left(FileNameOri, instrrev(FileNameOri,".")-1)
		Fileext = MID(FileNameOri, instrrev(FileNameOri,"."))
	Else
		Filenameonly = FileNameOri
		Fileext=""
	End IF

	FileReName = RdmCodeM(50)

	FileName = FileReName & Fileext
	FilePath = Path & "\" & FileName

	IF UploadForm.FileExists(FilePath) then
		i=0
		Do While(1)
			FilePath = Path & "\" & FileReName & i & fileext
			FileName = FileReName & i & fileext
			IF Not uploadform.fileexists(FilePath) Then Exit Do
			i=i+1
		Loop
	End IF
	FormName.saveas FilePath

	retFileSaveName = FileName : retFileOriName = FileNameOri
End Sub

Sub extendLogin()
	IF Session("useridx")<>"" Then
		Sql = "UPDATE loginTable Set ssID='"&Session.SessionID&"' WHERE status=1 AND useridx="&Session("useridx")
		DBcon.Execute(Sql)
	End IF
End Sub
%>