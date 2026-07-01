<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Set Default Value
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub SetDefault(Var, Value)
	if (Var = "") or isNull(Var) then
		Var = Value
	End if
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Check Null
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Function ChkNull(Object)
'	ChkNull = false
	
'	if (isNull(Object) or (Object = "") or (Object = " ")) then
'		ChkNull = true
'	end if
'End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Strings Replace Word Size
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Function ReSize(String, ReLen)
'	t = ReLen - Len(String)
'	Do While not t <= 0
'		String = "0" & String
'		t = t - 1
'	Loop
	
'	ReSize = String
'End Function
%>