<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<title>아이원 관리자 센터</title>
	<link rel="stylesheet" href="/backoffice/css/default.css?ver=1" type="text/css" />
	<link rel="stylesheet" href="/backoffice/css/jquery-ui.css?ver=1" type="text/css" />
	<script src="/_lib/js/jquery-1.11.1.min.js?ver=1" type="text/javascript"></script>
	<script src="/backoffice/js/jquery-ui.min.js?ver=1" type="text/javascript"></script>
	<script src="/backoffice/js/common.js?ver=1" type="text/javascript"></script>
	<link href="/_lib/css/editorContent.css?ver=1" rel="stylesheet" type="text/css">
	<script language='javascript' src='/_lib/functions.js?ver=1'></script>
	<script type="text/javascript" src="/_lib/js/plug-in/jquery.simplemodal/jquery.simplemodal.js?ver=1"></script>
	<link rel="stylesheet" href="/_lib/ckeditor5/content-styles.css?ver=1" type="text/css">
	<link rel="icon" type="image/png" href="/favicon.ico">

	<script type="text/javascript">
	$(document).ready(function(){
		//세션유지용 서버호출////////
		setInterval(function() {
			$.ajax({
				url : "/ajaxpage/sessionkeep.asp",
				type : 'POST',
				async: true,
				dataType:"html",
				beforeSend : function(){
				},
				success : function(data) {
				}
			});
		}, 1000 * 60 * 5 );
		//세션유지용 서버호출////////
	});	//End
	</script>