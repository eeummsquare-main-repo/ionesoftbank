		<script type="text/javascript">
		<!--
		$(document).ready(function(){
			if (!$("body").hasClass("adMain")){
				$(".gnb .navi li[dataTCode=<%=topMenuCode%>]").addClass("current");
				$(".lnb .side_navi li[dataTCode=<%=topMenuCode%>]").show();
				$(".lnb .side_navi li[dataSCode=<%=subMenuCode%>]").addClass("current");
			}
		});

		function userinfoModify(){
			$.ajax({
				type:"post",
				url: "/backoffice/basic/pop_admininfoModify.asp",
				data:"",
				dataType:"html",
				async: true,
				beforeSend : function(){
					popupLoadingOpen();
				}
			}).done(function(data){
				fnLayerPopupOpen(data);
			})
		}
		//-->
		</script>

		<div class="top_wrap">
			<div class="top_navi">
				<h1 class="logo"><span>아이원 관리자 센터</span></h1>
				<p class="topinfo">
					<span class="nametag"><%=Session("acountname")%></span> 님 환영합니다.

					<span class="top_btn">
						<a href="/backoffice/code_login_ok.asp?logout=1" class="" style="background: #747474;vertical-align: middle; cursor: pointer;">로그아웃</a>
						<a href="javascript:userinfoModify()" class="btn_modify">내정보변경</a>
						<a href="/" class="btn_home" target="_blank">서비스 메인</a>
					</span>
				</p>
			</div>
			</div>

			<div class="gnb">
				<ul class="navi">
					<li <% IF topMenuCode = "" Then %>class="current"<% End IF %>><a href="/backoffice/">Home</a></li>
					<%=GB_TopMenu%>
				</ul>
			</div>

			<div class="lnb">
				<ul class="side_navi">
				<%=GB_SubMenu%>
				</ul>
			</div>
		</div>