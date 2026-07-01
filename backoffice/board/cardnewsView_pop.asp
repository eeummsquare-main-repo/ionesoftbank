<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "news" : subMenuCode = "sub06" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
idx = uf_getRequest(Request("idx"),"int","","")

IF idx="" Then
    Response.Write ExecJavaAlert("잘못된 접근입니다.", 0)
    Response.End
End IF

Sql = "SELECT idx, company, writer, phone, email, interest, note1, agree1, agree2, Wip, regdate, status, statusChangeDate, adMemo FROM cardnews_request Where idx="&idx
Set Rs = DBcon.Execute(Sql)
IF Rs.Bof Or Rs.Eof Then
    Response.Write ExecJavaAlert("신청정보를 찾을 수 없습니다.", 0)
    Response.End
Else
    company  = Rs("company")
    writer   = Rs("writer")
    phone    = Rs("phone")
    email    = Rs("email")
    interest = Rs("interest")
    note1    = Rs("note1")
    agree1   = Rs("agree1")
    agree2   = Rs("agree2")
    Wip      = Rs("Wip")
    regdate  = Rs("regdate")
    status   = Rs("status")
    statusChangeDate = Rs("statusChangeDate")
    adMemo   = Rs("adMemo")
End IF
Set Rs = Nothing
DBcon.Close
Set DBcon = Nothing

Function statusLabel(s)
    Select Case CStr(s)
        Case "0"  : statusLabel = "대기중"
        Case "1"  : statusLabel = "접수완료"
        Case "9"  : statusLabel = "보관"
        Case "99" : statusLabel = "취소"
        Case Else : statusLabel = "-"
    End Select
End Function
%>

<script type="text/javascript">
function adMemoOk(){
    if (confirm("관리자 메모를 저장하시겠습니까?")){
        document.revFrm.target = "actFrame";
        document.revFrm.action = "cardnewsMemoOk.asp";
        document.revFrm.submit();
    }
}
</script>

<div class="popWrap">
    <div class="popCon">
        <h1>카드뉴스 신청 상세 <a href="#" class="btnClose" onclick="fnLayerPopupClose();return false;"><img src="/backoffice/images/close_popup.gif" alt="" /></a></h1>

        <div id="container">
            <div id="contents">

                <table class="tbl_row" style="width:800px;">
                    <colgroup>
                        <col style="width:18%" />
                        <col style="width:32%" />
                        <col style="width:18%" />
                        <col style="width:32%" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">신청일시</th>
                            <td><%=regdate%></td>
                            <th scope="row">상태</th>
                            <td>
                                <b><%=statusLabel(status)%></b>
                                <% IF statusChangeDate<>"" AND Not IsNull(statusChangeDate) Then %>
                                    <span style="color:#888; font-size:12px;">(변경 <%=statusChangeDate%>)</span>
                                <% End IF %>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">회사명</th>
                            <td colspan="3"><%=ReplaceNoHtml(company)%></td>
                        </tr>
                        <tr>
                            <th scope="row">담당자명</th>
                            <td><%=ReplaceNoHtml(writer)%></td>
                            <th scope="row">연락처</th>
                            <td><%=ReplaceNoHtml(phone)%></td>
                        </tr>
                        <tr>
                            <th scope="row">이메일</th>
                            <td><%=ReplaceNoHtml(email)%></td>
                            <th scope="row">접속 IP</th>
                            <td><%=ReplaceNoHtml(Wip)%></td>
                        </tr>
                        <tr>
                            <th scope="row">관심주제</th>
                            <td colspan="3"><%=ReplaceNoHtml(interest)%></td>
                        </tr>
                        <tr>
                            <th scope="row">문의사항</th>
                            <td colspan="3" style="white-space:pre-wrap; line-height:1.5;"><%=ReplaceNoHtml(note1)%></td>
                        </tr>
                        <tr>
                            <th scope="row">동의항목</th>
                            <td colspan="3">
                                <%IF CStr(agree1)="1" Then%>✓<%Else%>✗<%End IF%> 개인정보 수집 및 이용 &nbsp;|&nbsp;
                                <%IF CStr(agree2)="1" Then%>✓<%Else%>✗<%End IF%> 정보 수신
                            </td>
                        </tr>
                    </tbody>
                </table>

                <form name="revFrm" id="revFrm" method="post" action="">
                <input type="hidden" name="idx" value="<%=idx%>">
                <table class="tbl_row" style="width:800px; margin-top:15px;">
                    <colgroup>
                        <col style="width:18%" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">관리자 메모</th>
                            <td>
                                <textarea name="adMemo" rows="5" style="width:99%;"><%=adMemo%></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>
                </form>

                <div class="btn_center pt30">
                    <a href="javascript:adMemoOk()" class="btn_largeG">메모 저장</a>
                    <a href="javascript:fnLayerPopupClose()" class="btn_largeW">닫기</a>
                </div>

            </div>
        </div>
    </div>
</div>
<iframe name="actFrame" id="actFrame" style="display:none;"></iframe>
