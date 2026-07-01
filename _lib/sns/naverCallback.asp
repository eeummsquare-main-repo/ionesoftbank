<!--#include virtual = _lib/common.asp-->
<!doctype html>
<html lang="ko">
<head>
	<!--#include virtual="/common/include/head.asp"-->
	<script type="text/javascript" src="/_lib/js/snsLogin.js?ver=<%=nowTimeStamp%>"></script>
</head>
<body>
<% IF Request("error")="" Then %>
<script type="text/javascript">
	var naver_id_login = new naver_id_login(naverApiKey, naverLoginCallBackUrl);
	naver_id_login.get_naver_userprofile("naverSignInCallback()");

	function naverSignInCallback() {
		var snsid = naver_id_login.getProfileData('id')
		snsLogin("naver", snsid, "opener")
	}
</script>
<% Else %>
<script type="text/javascript">
	self.close()
</script>
<% End IF %>
</body>
</html>