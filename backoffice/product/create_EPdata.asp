<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
'	id			필수		제품고유값		50
'	title		필수		상품명			100
'	price_pc	필수		상품가격		10
'	link		필수		상품URL			255
'	image_link	필수	이미지URL		255
'	category_name1	필수	카테고리명(대분류)	50
'	category_name2	필수	카테고리명(중분류)	50
'	category_name3	필수	카테고리명(소분류)	50
'	category_name4	필수	카테고리명(세분류)	50
'	product_flag		필수	판매방식구분	'도매', '렌탈', '대여', '할부', '예약판매', '구매대행'
'	model_number		권장	모델명	60
'	brand					권장	브랜드	60
'	event_words		권장	이벤트	100
'	shipping				필수	배송료	100	무료배송


SET FSO = Server.CreateObject("Scripting.FileSystemObject")
Set objFile = FSO.OpenTextFile(server.Mappath("/")&"/all.txt",2, True)

objFile.WriteLine("id" & VbTab & "title" & VbTab & "price_pc" & VbTab & "link" & VbTab & "image_link" & VbTab & "category_name1" & VbTab & "category_name2" & VbTab & "category_name3" & VbTab & "category_name4" & VbTab & "product_flag" & VbTab & "model_number" & VbTab & "brand" & VbTab & "event_words" & VbTab & "shipping")

Sql = "SELECT p.idx, catecode, itemname, listimg, note2, price, imgname1, title, name, CASE WHEN isNull(note5,'')<>'' THEN ','+note5 ELSE '' END AS note5, pricesort FROM View_Product P LEFT OUTER JOIN brandadmin B ON P.brandidx = B.idx LEFT OUTER JOIN category C ON P.catecode = C.lowcode WHERE display=1 AND name<>''"
Set Rs=DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	Do Until Rs.Eof
		eventTAG = "등록/설치비 전액무료"&Replace(Replace(deReplaceNoHtml(Rs("note5")),"<","("),">",")")
		IF Len(eventTAG)>100 Then
			eventTAG="등록/설치비 전액무료"
		END IF
		eventTAG = Replace(Replace(eventTAG,"<","("),">",")")

		tmpStr = ""

		tmpStr = tmpStr & Rs("idx") & vbTab
		tmpStr = tmpStr & Left(deReplaceNoHtml(Rs("itemname")&","&eventTAG),100) & vbTab
		tmpStr = tmpStr & Rs("price") & vbTab
		tmpStr = tmpStr & "http://rental-nara.com/products/detail.asp?idx="&Rs("idx") & vbTab
		tmpStr = tmpStr & "http://rental-nara.com/upload/product/"&server.UrlEncode(Rs("imgname1")) & vbTab
		tmpStr = tmpStr & Left(Rs("name"),50) & vbTab
		tmpStr = tmpStr & "" & vbTab
		tmpStr = tmpStr & "" & vbTab
		tmpStr = tmpStr & "" & vbTab

		IF Rs("pricesort")=0 Then
			tmpStr = tmpStr & "렌탈" & vbTab
		Else
			tmpStr = tmpStr & "" & vbTab
		End IF

		tmpStr = tmpStr & Left(Rs("note2"),60) & vbTab
		tmpStr = tmpStr & Left(Rs("title"),60) & vbTab
		tmpStr = tmpStr & Replace(Replace(eventTAG,"<","("),">",")") & vbTab

		tmpStr = tmpStr & "0"

		objFile.WriteLine(tmpStr)
		Rs.MoveNext()
	Loop
End IF

Response.write "생성완료"
%>