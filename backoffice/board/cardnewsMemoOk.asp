<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "news" : subMenuCode = "sub06" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
idx = uf_getRequest(Request("idx"), "int", "", "")
adMemo = uf_getRequestProc(Request("adMemo"), "char", "4000", "")

IF idx = "" Then
    Response.Write ExecJavaAlert("잘못된 접근입니다.", 0)
    Response.End
End IF

Sql = "UPDATE cardnews_request SET adMemo=? WHERE idx="&idx
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
    .ActiveConnection = DBcon
    .CommandType = adCmdText
    .CommandText = Sql
    .Parameters.Append .CreateParameter("@p1", adVarWChar, adParamInput, 4000, adMemo)
    .Execute ,, adExecuteNoRecords
End With
Set objCmd = Nothing

DBcon.Close
Set DBcon = Nothing
%>
<script>
parent.alert("관리자 메모가 저장되었습니다.");
parent.fnLayerPopupClose();
parent.location.reload();
</script>
