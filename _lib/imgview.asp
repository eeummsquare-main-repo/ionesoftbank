<%@codepage="65001" language="VBScript"%>
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"

Dim imgname,myImg,Width,height,Path,ImgUrl
Path=Request("Path")
Imgname=Request("imgname")
ImgUrl=Server.MapPath("/upload/"&Path)&"/"&ImgName
%>
<html>
<head>
<meta http-equiv=content-type content=text/html;charset=utf-8>
<title>이미지보기</title>
<script type="text/javascript" src="/common/js/jquery.lastest.js"></script>
<script language="JavaScript">
function resize(){
	var imgWidth = document.getElementById("conimg").naturalWidth;
	var imgHeight = document.getElementById("conimg").naturalHeight;

	if(screen.availHeight-100 > imgHeight){
		winHeight = imgHeight + 100;
	}else{
		winHeight = screen.availHeight - 100;
	}

	if(screen.availWidth-40 > imgWidth){
		winWidth = imgWidth + 40;
	}else{
		winWidth = screen.availWidth-40;
	}

	var winPosLeft = (screen.width - winWidth) / 2; // 새창 Y 좌표
	var winPosTop = (screen.height - winHeight) / 2; // 새창 X 좌표

	window.moveTo(winPosLeft,winPosTop);
	window.resizeTo(winWidth,winHeight);
}
</script>

</head>
<body topmargin=10 leftmargin=0 marginheight = 0 marginwidth = 0 onload="resize()">
<table border=0 cellpadding=0 cellspacing=0 align=center width='100%' height='100%'>
<tr><td align='center' valign='middle'><a href="JavaScript:window.close();"><img src="<%="/upload/"&Path&"/"&Imgname%>" border=0 id="conimg"></a></td></tr>
</table>
</body>
</html>