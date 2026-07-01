<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
'==========================================================================
'  CARD-NEWS ONE-TIME SETUP SCRIPT
'  - URL: /_lib/setup_cardnews.asp?token=XXXXX
'  - Steps:
'      1) cardnews_request 테이블 생성 (IF NOT EXISTS)
'      2) menu 테이블에 카드뉴스 메뉴 등록
'      3) admin 권한(pubMenu)에 새 메뉴 idx 추가
'  - 보안: TOKEN 일치 시에만 동작
'  - 완료 후 반드시 이 파일을 FTP에서 삭제할 것
'==========================================================================

' === 토큰 (이 줄을 그대로 사용; 작업 후 파일 삭제하면 됨) ===
Const TOKEN = "cn_9zPq4Rk7Lm2Vt8Wx1Yh6Bf3Cd5Eg0"

' Token 검증
If Trim(Request("token")) <> TOKEN Then
    Response.Status = "404 Not Found"
    Response.Write "Not Found"
    Response.End
End If

Dim doExecute, adminsToUpdate
doExecute = (Request("execute") = "1")
adminsToUpdate = Request("mids")

Response.ContentType = "text/html"
Response.Charset = "utf-8"
%>
<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>Card-News Setup</title>
<style>
body{font-family:'Segoe UI','Apple SD Gothic Neo','맑은 고딕',sans-serif;max-width:920px;margin:30px auto;padding:20px;color:#222;line-height:1.5;}
h1{color:#0863de;border-bottom:2px solid #eee;padding-bottom:10px;}
h2{margin-top:30px;color:#222;font-size:17px;border-left:4px solid #0863de;padding-left:10px;}
.ok{color:#0a8a3a;background:#eaf7ee;padding:10px 14px;border-radius:6px;margin:8px 0;}
.warn{color:#a85a00;background:#fff5e6;padding:10px 14px;border-radius:6px;margin:8px 0;}
.err{color:#b00020;background:#fdeded;padding:10px 14px;border-radius:6px;margin:8px 0;}
.note{background:#f0f4fa;padding:10px 14px;border-radius:6px;margin:8px 0;font-size:13px;}
table{border-collapse:collapse;width:100%;margin:10px 0;font-size:13px;}
td,th{padding:6px 10px;border:1px solid #ddd;text-align:left;vertical-align:top;}
th{background:#f0f4fa;}
a.btn{display:inline-block;padding:10px 20px;background:#0863de;color:#fff;text-decoration:none;border-radius:6px;font-size:14px;margin:8px 6px 8px 0;}
a.btn:hover{background:#0750b0;}
a.btn.danger{background:#b00020;}
code{background:#eef;padding:2px 6px;border-radius:3px;font-size:12px;}
.mono{font-family:Consolas,Menlo,monospace;font-size:12px;background:#f5f5f5;padding:8px;border-radius:4px;white-space:pre-wrap;}
</style></head><body>

<h1>Card-News 설치 스크립트</h1>

<%
If Not doExecute Then
    Response.Write "<div class='warn'>현재는 <b>점검 모드</b>입니다 — DB에 아무 변경도 가하지 않습니다. 아래 상태를 확인 후 [실행] 버튼을 누르세요.</div>"
Else
    Response.Write "<div class='note'><b>실행 모드</b> — 변경을 시도합니다.</div>"
End If

'===================================================
' STEP 1: cardnews_request 테이블 확인/생성
'===================================================
Response.Write "<h2>1. cardnews_request 테이블</h2>"

Dim tableExists : tableExists = False
On Error Resume Next
Set Rs = DBcon.Execute("SELECT COUNT(*) FROM sys.tables WHERE name='cardnews_request'")
If Err.Number = 0 And Not Rs.Eof Then
    If Rs(0) > 0 Then tableExists = True
End If
Err.Clear
On Error GoTo 0

If tableExists Then
    Response.Write "<div class='ok'>✓ 테이블이 이미 존재합니다 (cardnews_request)</div>"
Else
    If doExecute Then
        Dim createSql
        createSql = "CREATE TABLE cardnews_request (" & _
            " idx INT IDENTITY(1,1) NOT NULL PRIMARY KEY," & _
            " company NVARCHAR(100) NOT NULL," & _
            " writer NVARCHAR(50) NOT NULL," & _
            " phone NVARCHAR(30) NOT NULL," & _
            " email NVARCHAR(100) NULL," & _
            " interest NVARCHAR(200) NULL," & _
            " note1 NVARCHAR(500) NULL," & _
            " agree1 TINYINT NOT NULL DEFAULT 0," & _
            " agree2 TINYINT NOT NULL DEFAULT 0," & _
            " Wip NVARCHAR(50) NULL," & _
            " regdate DATETIME NOT NULL DEFAULT GETDATE()," & _
            " status INT NOT NULL DEFAULT 0," & _
            " statusChangeDate DATETIME NULL," & _
            " adMemo NVARCHAR(MAX) NULL" & _
            ")"
        On Error Resume Next
        DBcon.Execute createSql
        If Err.Number = 0 Then
            Response.Write "<div class='ok'>✓ 테이블 생성 완료</div>"
            DBcon.Execute "CREATE INDEX IX_cardnews_request_regdate ON cardnews_request(regdate DESC)"
            If Err.Number = 0 Then
                Response.Write "<div class='ok'>✓ 인덱스 생성 완료 (regdate DESC)</div>"
            End If
            Err.Clear
            tableExists = True
        Else
            Response.Write "<div class='err'>✗ 테이블 생성 실패: " & Server.HtmlEncode(Err.Description) & "</div>"
            Response.Write "<div class='mono'>" & Server.HtmlEncode(createSql) & "</div>"
        End If
        Err.Clear
        On Error GoTo 0
    Else
        Response.Write "<div class='warn'>! 테이블이 없습니다 — [실행] 시 생성됩니다</div>"
    End If
End If

'===================================================
' STEP 2: menu 테이블 컬럼 구조 (참고용)
'===================================================
Response.Write "<h2>2. menu 테이블 컬럼 구조 (참고)</h2>"
Response.Write "<div class='note'>INSERT가 실패한다면 아래 컬럼 중 NOT NULL 인데 우리가 채우지 않은 게 있는지 확인하세요.</div>"
On Error Resume Next
Set Rs = DBcon.Execute("SELECT TOP 0 * FROM menu")
If Err.Number = 0 Then
    Response.Write "<table><tr><th>#</th><th>컬럼명</th><th>타입(ADO)</th></tr>"
    Dim i, fld
    For i = 0 To Rs.Fields.Count - 1
        Set fld = Rs.Fields(i)
        Response.Write "<tr><td>" & (i+1) & "</td><td>" & fld.Name & "</td><td>" & fld.Type & "</td></tr>"
    Next
    Response.Write "</table>"
Else
    Response.Write "<div class='err'>menu 테이블 조회 실패: " & Server.HtmlEncode(Err.Description) & "</div>"
End If
Err.Clear
On Error GoTo 0

'===================================================
' STEP 3: menu 등록
'===================================================
Response.Write "<h2>3. menu 등록 (topcode=news, subcode=sub06)</h2>"

Dim menuIdx : menuIdx = ""
On Error Resume Next
Set Rs = DBcon.Execute("SELECT idx FROM menu WHERE topcode='news' AND subcode='sub06'")
If Err.Number = 0 And Not Rs.Eof Then
    menuIdx = CStr(Rs(0))
End If
Err.Clear
On Error GoTo 0

If menuIdx <> "" Then
    Response.Write "<div class='ok'>✓ 이미 등록됨. menu idx = <code>" & menuIdx & "</code></div>"
Else
    If doExecute Then
        Dim menuSql, nextIdx : nextIdx = 0
        On Error Resume Next
        Set Rs = DBcon.Execute("SELECT ISNULL(MAX(idx), 0) + 1 AS nextIdx FROM menu")
        If Err.Number = 0 And Not Rs.Eof Then
            nextIdx = CLng(Rs(0))
        End If
        Err.Clear
        On Error GoTo 0

        If nextIdx <= 0 Then
            Response.Write "<div class='err'>✗ 다음 idx 계산 실패. menu 테이블 조회 권한 또는 데이터 확인 필요.</div>"
        Else
            menuSql = "INSERT INTO menu (idx, topcode, subcode, topName, subName, linkurl, isUse, listnum) " & _
                      "VALUES (" & nextIdx & ", 'news', 'sub06', '고객센터', '카드뉴스 신청관리', '/backoffice/board/cardnewsList.asp', 1, 60)"
            On Error Resume Next
            DBcon.Execute menuSql
            If Err.Number = 0 Then
                menuIdx = CStr(nextIdx)
                Response.Write "<div class='ok'>✓ 메뉴 등록 완료. 새 menu idx = <code>" & menuIdx & "</code></div>"
            Else
                Response.Write "<div class='err'>✗ INSERT 실패: " & Server.HtmlEncode(Err.Description) & "</div>"
                Response.Write "<div class='mono'>" & Server.HtmlEncode(menuSql) & "</div>"
                Response.Write "<div class='warn'>STEP 2의 컬럼 목록을 보고, INSERT 문에 필수 컬럼을 추가해서 직접 실행해야 할 수도 있습니다.</div>"
            End If
            Err.Clear
            On Error GoTo 0
        End If
    Else
        Response.Write "<div class='warn'>! 미등록 — [실행] 시 추가됩니다</div>"
    End If
End If

'===================================================
' STEP 4: admin 권한(pubMenu) 확인
'===================================================
Response.Write "<h2>4. admin 권한 (pubMenu) 현황</h2>"

On Error Resume Next
Set Rs = DBcon.Execute("SELECT idx, id, name, memsort, pubMenu FROM admin ORDER BY idx ASC")
If Err.Number = 0 And Not Rs.Eof Then
    Response.Write "<table><tr><th>idx</th><th>id</th><th>name</th><th>memsort</th><th>pubMenu</th><th>새 메뉴 포함?</th></tr>"
    Dim aIdx, aId, aName, aMemsort, aPubMenu, aHas, parts, p, idx2
    Do Until Rs.Eof
        aIdx = Rs("idx") : aId = Rs("id") : aName = Rs("name")
        aMemsort = Rs("memsort") : aPubMenu = Rs("pubMenu") & ""
        aHas = False
        If menuIdx <> "" And aPubMenu <> "" Then
            parts = Split(aPubMenu, ",")
            For idx2 = 0 To UBound(parts)
                If Trim(parts(idx2)) = menuIdx Then aHas = True
            Next
        End If
        Response.Write "<tr><td>" & aIdx & "</td><td>" & Server.HtmlEncode(aId) & "</td><td>" & Server.HtmlEncode(aName) & "</td><td>" & aMemsort & "</td>"
        Response.Write "<td><code>" & Server.HtmlEncode(aPubMenu) & "</code></td>"
        If aHas Then
            Response.Write "<td><b style='color:#0a8a3a'>YES</b></td>"
        Else
            Response.Write "<td><b style='color:#a85a00'>NO</b></td>"
        End If
        Response.Write "</tr>"
        Rs.MoveNext
    Loop
    Response.Write "</table>"
Else
    Response.Write "<div class='err'>admin 테이블 조회 실패: " & Server.HtmlEncode(Err.Description) & "</div>"
End If
Err.Clear
On Error GoTo 0

'===================================================
' STEP 5: 요청 시 admin pubMenu 업데이트
'===================================================
If doExecute And menuIdx <> "" And adminsToUpdate <> "" Then
    Response.Write "<h2>5. admin pubMenu 업데이트 결과</h2>"
    Dim updList, u, uTrim, curPub, newPub, alreadyHas, tparts, ti
    updList = Split(adminsToUpdate, ",")
    For idx2 = 0 To UBound(updList)
        u = Trim(updList(idx2))
        If IsNumeric(u) Then
            uTrim = CStr(CLng(u))
            On Error Resume Next
            Set Rs = DBcon.Execute("SELECT pubMenu FROM admin WHERE idx=" & uTrim)
            If Err.Number = 0 And Not Rs.Eof Then
                curPub = Rs("pubMenu") & ""
                alreadyHas = False
                If curPub <> "" Then
                    tparts = Split(curPub, ",")
                    For ti = 0 To UBound(tparts)
                        If Trim(tparts(ti)) = menuIdx Then alreadyHas = True
                    Next
                End If
                If alreadyHas Then
                    Response.Write "<div class='ok'>이미 포함됨: admin idx=" & uTrim & "</div>"
                Else
                    If curPub = "" Then
                        newPub = menuIdx
                    Else
                        newPub = curPub & "," & menuIdx
                    End If
                    DBcon.Execute "UPDATE admin SET pubMenu='" & newPub & "' WHERE idx=" & uTrim
                    If Err.Number = 0 Then
                        Response.Write "<div class='ok'>✓ admin idx=" & uTrim & " pubMenu 업데이트 (" & curPub & " → " & newPub & ")</div>"
                    Else
                        Response.Write "<div class='err'>✗ admin idx=" & uTrim & " 업데이트 실패: " & Server.HtmlEncode(Err.Description) & "</div>"
                    End If
                End If
            Else
                Response.Write "<div class='err'>admin idx=" & uTrim & " 조회 실패</div>"
            End If
            Err.Clear
            On Error GoTo 0
        End If
    Next
End If

'===================================================
' STEP 6: 고객센터 그룹 진단 / 합치기 (선택)
'   - 항상 진단 표시 (topName='고객센터' 메뉴 행 전체)
'   - URL에 &gfix=<새topcode> 붙이면 news/sub06 행의 topcode를 그 값으로 UPDATE
'===================================================
Response.Write "<h2>6. 고객센터 그룹 진단</h2>"
Response.Write "<p>현재 topName='고객센터'를 쓰는 메뉴 행입니다. <code>topcode</code>가 'news'와 다른 행이 있다면 그게 기존 그룹입니다.</p>"

On Error Resume Next
Set Rs = DBcon.Execute("SELECT idx, topcode, subcode, subName, linkurl, listnum, isUse FROM menu WHERE topName=N'고객센터' ORDER BY topcode, listnum")
If Err.Number = 0 And Not Rs.Eof Then
    Response.Write "<table>"
    Response.Write "<tr><th>idx</th><th>topcode</th><th>subcode</th><th>subName</th><th>linkurl</th><th>listnum</th><th>isUse</th></tr>"
    Do Until Rs.Eof
        Response.Write "<tr>"
        Response.Write "<td>" & Rs("idx") & "</td>"
        Response.Write "<td><code>" & Server.HtmlEncode(Rs("topcode") & "") & "</code></td>"
        Response.Write "<td><code>" & Server.HtmlEncode(Rs("subcode") & "") & "</code></td>"
        Response.Write "<td>" & Server.HtmlEncode(Rs("subName") & "") & "</td>"
        Response.Write "<td>" & Server.HtmlEncode(Rs("linkurl") & "") & "</td>"
        Response.Write "<td>" & Rs("listnum") & "</td>"
        Response.Write "<td>" & Rs("isUse") & "</td>"
        Response.Write "</tr>"
        Rs.MoveNext
    Loop
    Response.Write "</table>"
Else
    Response.Write "<div class='warn'>topName='고객센터' 행이 없습니다.</div>"
End If
Err.Clear
On Error GoTo 0

' 그룹 합치기 실행: ?gfix=<새topcode>
Dim newTopcode : newTopcode = Trim(Request("gfix"))
If doExecute And newTopcode <> "" Then
    ' 안전: 영숫자와 _ 만 허용
    Dim safeTopcode, ch, i2
    safeTopcode = ""
    For i2 = 1 To Len(newTopcode)
        ch = Mid(newTopcode, i2, 1)
        If (ch >= "a" And ch <= "z") Or (ch >= "A" And ch <= "Z") Or (ch >= "0" And ch <= "9") Or ch = "_" Then
            safeTopcode = safeTopcode & ch
        End If
    Next
    If safeTopcode = "" Or safeTopcode <> newTopcode Then
        Response.Write "<div class='err'>✗ 잘못된 topcode 형식 (영숫자/언더스코어만 허용)</div>"
    Else
        On Error Resume Next
        DBcon.Execute "UPDATE menu SET topcode='" & safeTopcode & "' WHERE topcode='news' AND subcode='sub06'"
        If Err.Number = 0 Then
            Response.Write "<div class='ok'>✓ news/sub06 → " & safeTopcode & "/sub06 로 topcode 변경 완료. 어드민에서 <b>로그아웃 → 재로그인</b> 후 확인하세요.</div>"
        Else
            Response.Write "<div class='err'>✗ UPDATE 실패: " & Server.HtmlEncode(Err.Description) & "</div>"
        End If
        Err.Clear
        On Error GoTo 0
    End If
End If

' 새 탭 이름으로 변경: ?rename=1  → topName을 '카드뉴스관리'로 UPDATE
If doExecute And Request("rename") = "1" Then
    Response.Write "<p>news/sub06 행의 <code>topName</code>을 <b>'카드뉴스관리'</b>로 변경 시도:</p>"
    On Error Resume Next
    DBcon.Execute "UPDATE menu SET topName=N'카드뉴스관리' WHERE topcode='news' AND subcode='sub06'"
    If Err.Number = 0 Then
        Response.Write "<div class='ok'>✓ topName 변경 완료. 어드민에서 <b>로그아웃 → 재로그인</b> 후 두 번째 '고객센터' 탭이 '카드뉴스관리'로 표시되는지 확인하세요.</div>"
    Else
        Response.Write "<div class='err'>✗ UPDATE 실패: " & Server.HtmlEncode(Err.Description) & "</div>"
    End If
    Err.Clear
    On Error GoTo 0
End If

'===================================================
' 다음 액션 안내
'===================================================
Response.Write "<h2>다음 액션</h2>"
If Not doExecute Then
    Response.Write "<p>위 상태를 확인했고 문제 없으면, 아래 버튼으로 <b>실제 실행</b> 하세요:</p>"
    Response.Write "<a class='btn' href='?token=" & TOKEN & "&execute=1'>▶ STEP 1 + STEP 3 실행 (테이블 + 메뉴 생성)</a>"
Else
    If tableExists And menuIdx <> "" Then
        Response.Write "<p>위 admin 목록에서 카드뉴스 메뉴(<code>idx=" & menuIdx & "</code>)를 추가할 admin의 idx를 콤마(,)로 나열하여 호출하세요. 예:</p>"
        Response.Write "<div class='mono'>/_lib/setup_cardnews.asp?token=" & TOKEN & "&execute=1&mids=1,2,3</div>"
        Response.Write "<p>또는 <b>모든 슈퍼관리자(memsort=9)</b> 한꺼번에 업데이트:</p>"
        Response.Write "<a class='btn' href='?token=" & TOKEN & "&execute=1&mids=all_super'>▶ memsort=9 전체 업데이트</a>"

        ' all_super 처리
        If adminsToUpdate = "all_super" Then
            On Error Resume Next
            Set Rs = DBcon.Execute("SELECT idx FROM admin WHERE memsort=9")
            Dim adminIdxList : adminIdxList = ""
            If Err.Number = 0 Then
                Do Until Rs.Eof
                    If adminIdxList = "" Then
                        adminIdxList = Rs("idx")
                    Else
                        adminIdxList = adminIdxList & "," & Rs("idx")
                    End If
                    Rs.MoveNext
                Loop
            End If
            Err.Clear
            On Error GoTo 0
            If adminIdxList <> "" Then
                Response.Write "<div class='note'>memsort=9 admin idx: " & adminIdxList & " 를 업데이트 진행하려면 다음 URL을 호출하세요:</div>"
                Response.Write "<div class='mono'>/_lib/setup_cardnews.asp?token=" & TOKEN & "&execute=1&mids=" & adminIdxList & "</div>"
            Else
                Response.Write "<div class='warn'>memsort=9 인 admin이 없습니다. 위 목록을 보고 적절한 idx를 직접 지정해 주세요.</div>"
            End If
        End If
    End If
End If

Response.Write "<h2 style='color:#b00020;border-left-color:#b00020'>⚠ 작업 완료 후 반드시 할 것</h2>"
Response.Write "<div class='err'><b>FTP로 이 파일을 즉시 삭제하세요:</b><br>" & _
               "<code>/_lib/setup_cardnews.asp</code><br><br>" & _
               "이 토큰을 아는 사람은 누구나 DB를 조작할 수 있습니다.</div>"

DBcon.Close
Set DBcon = Nothing
%>

</body></html>
