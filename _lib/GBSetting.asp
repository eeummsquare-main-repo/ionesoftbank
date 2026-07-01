<%
Dim objIconInfo 
Set objIconInfo = Server.CreateObject("Scripting.Dictionary")
With objIconInfo
	.Add "ASA",  "<img src='/_lib/fileimg/asp.gif' alt='Active Server Page 파일' border='0' align=""absmiddle"">"
	.Add "ASP",  "<img src='/_lib/fileimg/asp.gif' alt='Active Server Page 파일' border='0' align=""absmiddle"">"
	.Add "BMP",  "<img src='/_lib/fileimg/bmp.gif' alt='Bitmap 이미지 파일' border='0' align=""absmiddle"">"
	.Add "GIF",  "<img src='/_lib/fileimg/gif.gif' alt='GIF 이미지 파일' border='0' align=""absmiddle"">"
	.Add "JPG",  "<img src='/_lib/fileimg/jpg.gif' alt='JPG 이미지 파일' border='0' align=""absmiddle"">"
	.Add "JPEG", "<img src='/_lib/fileimg/jpg.gif' alt='JPEG 이미지 파일' border='0' align=""absmiddle"">"
	.Add "DOC",  "<img src='/_lib/fileimg/doc.gif' alt='MS Word 파일' border='0' align=""absmiddle"">"
	.Add "HWP",  "<img src='/_lib/fileimg/hwp.gif' alt='아래아 한글 파일' border='0' align=""absmiddle"">"
	.Add "TXT",  "<img src='/_lib/fileimg/txt.gif' alt='Text 파일' border='0' align=""absmiddle"">"
	.Add "MDB",  "<img src='/_lib/fileimg/mdb.gif' alt='MS Access 파일' border='0' align=""absmiddle"">"
	.Add "MDE",  "<img src='/_lib/fileimg/mdb.gif' alt='MS Access 파일' border='0' align=""absmiddle"">"
	.Add "MDW",  "<img src='/_lib/fileimg/mdb.gif' alt='MS Access 파일' border='0' align=""absmiddle"">"
	.Add "PPT",  "<img src='/_lib/fileimg/ppt.gif' alt='MS PowerPoint 파일' border='0' align=""absmiddle"">"
	.Add "PPS",  "<img src='/_lib/fileimg/ppt.gif' alt='MS PowerPoint 파일' border='0' align=""absmiddle"">"
	.Add "PPA",  "<img src='/_lib/fileimg/ppt.gif' alt='MS PowerPoint 파일' border='0' align=""absmiddle"">"
	.Add "POT",  "<img src='/_lib/fileimg/ppt.gif' alt='MS PowerPoint 파일' border='0' align=""absmiddle"">"
	.Add "XLA",  "<img src='/_lib/fileimg/xls.gif' alt='MS Excel 파일' border='0' align=""absmiddle"">"
	.Add "XLM",  "<img src='/_lib/fileimg/xls.gif' alt='MS Excel 파일' border='0' align=""absmiddle"">"
	.Add "XLS",  "<img src='/_lib/fileimg/xls.gif' alt='MS Excel 파일' border='0' align=""absmiddle"">"
	.Add "XLT",  "<img src='/_lib/fileimg/xls.gif' alt='MS Excel 파일' border='0' align=""absmiddle"">"
	.Add "PDF",  "<img src='/_lib/fileimg/pdf.gif' alt='Adobe Acrobat 파일' border='0' align=""absmiddle"">"
	.Add "HLP",  "<img src='/_lib/fileimg/hlp.gif' alt='도움말 파일' border='0' align=""absmiddle"">"
	.Add "HTML", "<img src='/_lib/fileimg/htm.gif' alt='HyperText MarkUp Language' border='0' align=""absmiddle"">"
	.Add "HTM",  "<img src='/_lib/fileimg/htm.gif' alt='HyperText MarkUp Language' border='0' align=""absmiddle"">"
	.Add "RAR",  "<img src='/_lib/fileimg/asp.gif' alt='WinRar 압축 파일' border='0' align=""absmiddle"">"
	.Add "ZIP",  "<img src='/_lib/fileimg/zip.gif' alt='WinZip 압축 파일' border='0' align=""absmiddle"">"
	.Add "MID",  "<img src='/_lib/fileimg/mid.gif' alt='MIDI 파일' border='0' align=""absmiddle"">"
	.Add "AVI",  "<img src='/_lib/fileimg/avi.gif' alt='동영상 파일' border='0' align=""absmiddle"">"
	.Add "MP3",  "<img src='/_lib/fileimg/mp3.gif' alt='MP3 음악 파일' border='0' align=""absmiddle"">"
	.Add "WMV",  "<img src='/_lib/fileimg/avi.gif' alt='WMV 동영상 파일' border='0' align=""absmiddle"">"
	.Add "M3U",  "<img src='/_lib/fileimg/mp3.gif' alt='MP3 리스트 파일' border='0' align=""absmiddle"">"
	.Add "RA",   "<img src='/_lib/fileimg/r1.gif' alt='Real Audio 파일' border='0' align=""absmiddle"">"
	.Add "WAV",  "<img src='/_lib/fileimg/wav.gif' alt='Wave 파일' border='0' align=""absmiddle"">"
	.Add "DLL",  "<img src='/_lib/fileimg/dll.gif' alt='응용 프로그램 확장' border='0' align=""absmiddle"">"
	.Add "UNKNOWN",  "<img src='/_lib/fileimg/unknown.gif' alt='알수없는파일' border='0' align=""absmiddle"">"
End With

Function GetFileStsImage(FileName)
	Dim fileext,FileImage
	IF FileName<>"" Then
		fileext=mid(FileName,instrrev(FileName,".")+1)
		FileImage = objIconInfo(UCASE(fileext))
		IF FileImage = "" Then FileImage = objIconInfo("UNKNOWN")
		GetFileStsImage = FileImage
	End IF
End Function
%>