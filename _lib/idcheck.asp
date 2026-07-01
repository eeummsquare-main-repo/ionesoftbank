<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Function Word_check(str,patrn)
	Dim regEx, match, matches
	SET regEx = New RegExp

	regEx.Pattern = patrn            ' 패턴을 설정합니다.
	regEx.IgnoreCase = True      ' 대/소문자를 구분하지 않도록 합니다.
	regEx.Global = True             ' 전체 문자열을 검색하도록 설정합니다.

	SET Matches = regEx.Execute(str)

	IF 0 < Matches.count then
		Word_check = false
	Else
		Word_check = true
	End IF
End Function

pattern0 = "[^가-힣]"  '한글만
pattern1 = "[^0-9 ]"  '숫자만
pattern2 = "[^a-zA-Z]"  '영어만
pattern3 = "[^가-힣a-zA-Z0-9/ ]" '숫자와 영어 한글만 
pattern4 = "<[^>]*>"   '태그만
pattern5 = "[^a-zA-Z0-9_/ ]"    '영어 숫자 _만

id = uf_getRequest(Request("id"),"char","","")

IF Len(id)<6 OR Len(id)>15 Then
	ErrorMsg = "ID는 6~15자 이내로 입력해주세요."
ElseIF Word_check(id,pattern5)=False Then
	ErrorMsg = "ID는 영문 혹은 영문, 숫자 혼합(6~15자이내), 특수문자(_)만 사용가능 합니다."
End IF

IF 	ErrorMsg="" Then
	Sql="Select Top 1 * from Members WHERE id='"&id&"'"
	Set IdYN=DBcon.Execute(sql)

	IF IdYN.Bof or IdYN.Eof Then
		Response.Write "useY"
	Else
		Response.Write "useN"
	End IF
	Set IdYN=Nothing
Else
	Response.Write ErrorMsg
End IF

DBcon.Close
Set DBcon=Nothing
%>