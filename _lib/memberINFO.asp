<%
GB_myLikeBBsRecord = ""

IF Session("useridx")<>"" AND Session("useridx")<>"0" Then
	Sql="SELECT name, id, memsort, phone, tel, zipcode, addr1, addr2, Email, Company, birthday, sex, bizcode, lastLogin, loginCnt, dbo.fn_cLevelCd(idx) AS cMemLevel FROM Members Where isAuth=99 AND outmember=0 AND idx="&Session("useridx")
	Set Rs=DBcon.Execute(Sql)

	IF Rs.Bof Or Rs.Eof Then
		Session("UserIdx") = ""
		Session("UserID") = ""
		Session("UserName") = ""
		Session("MemberShip") = ""
	Else
		Session("UserID") = Rs("id")
		Session("UserName") = Rs("name")
		Session("MemberShip") = Rs("memsort")

		GB_Member_Zip = Rs("zipcode")
		GB_Member_Addr1 = Rs("addr1")
		GB_Member_Addr2 = Rs("addr2")
		GB_Member_Company = Rs("Company")
		GB_Member_Bizcode = Rs("bizcode")
		
		GB_Member_Birthday = Rs("birthday")
		GB_Member_Sex = Rs("sex")
		
		GB_Member_Tel = Rs("tel")
		GB_Member_Phone = Rs("phone")
		GB_Member_Email = Rs("Email")

		GB_Member_ArrTel = Split(Rs("tel"), "-")
		GB_Member_ArrPhone = Split(Rs("phone"), "-")
		GB_Member_ArrEmail = Split(Rs("Email"), "@")
		GB_Member_lastLogin = Rs("lastLogin")
		GB_Member_loginCnt = Rs("loginCnt")
		GB_Member_CommunityLevel = Rs("cMemLevel")

		Sql = "SELECT COUNT(1) FROM BBSLIST WHERE boardidx=50 And useridx="&Session("useridx")
		Set Rs = DBcon.Execute(Sql)
		GB_Member_BoardRegCnt = Rs(0)

		Sql = "SELECT COUNT(1) FROM CommentAdmin WHERE useridx="&Session("useridx")
		Set Rs = DBcon.Execute(Sql)
		GB_Member_CommentRegCnt = Rs(0)

		Sql = "SELECT Distinct STUFF(( SELECT ',' + Convert(VARCHAR, bidx) FROM _LikeLog WHERE uidx="&Session("useridx")&" FOR XML PATH('') ),1,1,'') AS strPidx FROM _LikeLog AS TB"
		Set Rs = DBcon.Execute(Sql)
		IF Not(Rs.Bof Or Rs.Eof) Then
			GB_myLikeBBsRecord = Rs(0)
		End IF
	End IF
ElseIF Session("useridx")="0" Then
	Session("UserIdx") = "0"
	Session("UserID") = "guest"
	Session("UserName") = "게스트"
	Session("MemberShip") = "0"
End IF

IF Not(isArray(GB_Member_ArrTel)) Then Dim GB_Member_ArrTel(2)
IF Not(isArray(GB_Member_ArrPhone)) Then Dim GB_Member_ArrPhone(2)
IF Not(isArray(GB_Member_ArrEmail)) Then Dim GB_Member_ArrEmail(1)

IF Ubound(GB_Member_ArrTel)<2 Then ReDim GB_Member_ArrTel(2)
IF Ubound(GB_Member_ArrPhone)<2 Then ReDim GB_Member_ArrPhone(2)
IF Ubound(GB_Member_ArrEmail)<1 Then ReDim GB_Member_ArrEmail(1)
%>