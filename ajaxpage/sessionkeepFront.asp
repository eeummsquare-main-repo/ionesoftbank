<!-- #include virtual = _lib/common.asp -->
<!-- #include virtual = _lib/dbCon.asp -->
<%
IF Session("useridx")<>"" Then
	Sql = "SELECT TOP 1 * FROM LoginTable WITH(NoLock) WHERE useridx="&Session("useridx")&" AND ssid='"&Session.SessionID&"' AND status=1"
	Set Rs = DBcon.Execute(Sql)
	IF Rs.Bof Or Rs.Eof Then
		Response.Write "DUPLOGIN"

		Session("UserIdx") = ""
		Session("UserID") = ""
		Session("UserName") = ""
		Session("MemberShip") = ""
	End IF
End IF

DBcon.Close
Set DBcon = Nothing
%>