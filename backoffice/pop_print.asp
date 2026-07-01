<%@ Language="VBScript" CodePage="65001" %>
<!--METADATA TYPE="TypeLib" NAME="Microsoft ActiveX Data Objects 2.7 Library" UUID="{EF53050B-882E-4776-B643-EDA472E8E3F2}" VERSION="2.7"-->
<% 'Option Explicit %>
<%
REM	인코딩 설정 : Page  - Encoding  [0 : ANSI], [949 : EUC-KR], [65001 : 유니코드(UTF-8)], [65535 : 유니코드(UTF-16)]
Response.CharSet = "utf-8"
Response.Expires = "-1"
Response.CodePage = "65001"
Session.CodePage = "65001"
Response.AddHeader "Expires","-1"
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "Cache-Control","no-cache,must-revalidate"
Response.AddHeader "Set-Cookie", "cookie_name=cookie_value;SameSite=None;"

popTitle = Request("popTitle")
%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

	<link rel="stylesheet" href="/backoffice/css/default.css" type="text/css" />
	<link rel="stylesheet" href="/backoffice/css/jquery-ui.css" type="text/css" />
	<link href="/_lib/css/editorContent.css" rel="stylesheet" type="text/css">

	<script src="/_lib/js/jquery-1.11.1.min.js" type="text/javascript"></script>
	<!--[if lt IE 9]>
		<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->

<script type="text/javascript">
	//<![CDATA[
	$(window).load(function(){
		$("body").on("click", "input[type=radio]", function(){
			return false;
		});
	});
	function startPrint() {
		var openerURL = opener.location.pathname;
		var openerIndex = openerURL.lastIndexOf("/") + 1;
		var openerPath = openerURL.substr(0, openerIndex);
		openerPath = escape(openerPath);

		var newContent = opener.document.getElementById("printArea").innerHTML;
		newContent = escape(newContent)

		newContent = AbsolutePath(newContent,"%22../",openerPath);
		newContent = AbsolutePath(newContent,"%27../",openerPath);
		newContent = AbsolutePath(newContent,"%3D../",openerPath);

		document.getElementById("forPrint").innerHTML = unescape(newContent);

		$(".attachedFile").remove();
		$(".conViewArea").remove();
		$(".conPrintArea").show();

		window.print();
	}

	function AbsolutePath(contentstr,findstr,restr){
		var temp="";
		var r;
		do{
			r=contentstr.indexOf(findstr,0);
			if(r>0){
				temp=temp+contentstr.substring(0,r+3);
				temp=temp+restr;
				contentstr=contentstr.substring(r+3,contentstr.length);
			}
		}while(r>0)
		temp=temp+contentstr;
		return temp;
	}
	window.onload = function(){startPrint();}
	//]]>
</script>
</head>
<body>
<table border="0" cellspacing="20" cellpadding="20" width="100%">
	<tr valign="top">
		<td>
			<div style="font-weight: 500; font-size:24px; line-height:1.3; color: #333; letter-spacing: -0.03em; margin-bottom:10px;"><%=popTitle%></div>
			<div id="forPrint"></div>
		</td>
	</tr>
</table>
</body>
</html>