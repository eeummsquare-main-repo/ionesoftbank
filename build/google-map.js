/** Google Map 객체. **/
GoogleMap = {
	/* 초기화. */
	initialize : function(addr) {
		if(!addr)return;
		$("#GoogleMap_map").show();
		//this.input = document.getElementById("GoogleMap_input");
		this.address = addr;
		this.geocoder = new google.maps.Geocoder();
		this.infowindow = new google.maps.InfoWindow();
		this.setAgencyPosition();

	},

	setAgencyPosition : function(){
		this.geocoder.geocode( { 'address': this.address }, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				var p = results[0].geometry.location;

				//지도 생성.(기본 위치 서울.)
				var latlng = new google.maps.LatLng(p.lat(),p.lng());
				var myOptions = {
					zoom: 17,
					center: latlng,
					mapTypeControl : false,
					mapTypeId: google.maps.MapTypeId.ROADMAP
				};
				this.map = new google.maps.Map(
						document.getElementById("GoogleMap_map"),myOptions);

				//마커 생성.
				this.marker = new google.maps.Marker({
					map : this.map,
					//animation: google.maps.Animation.DROP,
					position: latlng
				});

			}
		});
	},


	//주소 클릭 이벤트.
	clickAddress : function(a, addr,content){
		a.onmousedown = function(){
			//지도와 마커이동.
			GoogleMap.map.setCenter(addr);
			GoogleMap.marker.setPosition(addr);
			//GoogleMap.marker.setAnimation(google.maps.Animation.DROP);
			GoogleMap.infowindow.setContent(content);
			GoogleMap.infowindow.open(GoogleMap.map,GoogleMap.marker);
		}
	}
}