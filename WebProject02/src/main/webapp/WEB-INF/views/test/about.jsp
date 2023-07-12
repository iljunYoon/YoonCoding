<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<title>amusement detail</title>
<!-- jquery cdn -->
  <script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
  <!-- 부트스트랩 cdn -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
  <!-- 폰트 설정 -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Hahmlet&display=swap" rel="stylesheet">
  <!-- 아이콘 cdn-->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">

<style>
.divRight{
	width: 100%;
	overflow: hidden;
	scroll-behavior: smooth;
}
.images{
	width: 500px;
	height: 500px;
}
.mid{
	padding: 10px;
}
.atag{
	margin: 5px;
	width: 50px;
	height: 50px;
}
#mainImg{
	width: 600px;
	height: 600px;
}
#fDiv{
	display: flex;
	flex-direction: column;
}
a{text-decoration: none;}

/* chrome */
.divRight::-webkit-scrollbar{
  	display: none; 
}
.item {
	padding-right: 1rem;
	list-style: none;
	user-select: none;
}
.item:first-child {
	padding-left: 1rem;
}
.link {
	display: block;
	-webkit-user-drag: none;
}
.rimage {
	display: block;
	width: 300px;
	height: 300px;
	-webkit-user-drag: none;
}
.wrapper2{
	overflow: hidden;
}
.imgs{
	margin-left: 25px;
	overflow: hidden;
}
.img-list{
	transform: translate(0, 0);
	overflow-x: auto;
	overflow: hidden;
}

.ride-image{
}

</style>


<script>
//==========about============
function aboutClick(){
	location.reload();
}

$(document).ready(function() {
	const input = document.querySelectorAll("#input");
	const image = document.querySelectorAll("#image");
	//console.log("input 개수 = " + input.length)
	const length = input.length
	
	for(let i=0; i < length ; i++){
		//console.log("i = " + i)
		//console.log("input[" + i + "] =" + input[i].value)
		//console.log(image[i].value)
		$('#'+input[i].value).mouseover(function(){
			$("#mainImg").attr("src", image[i].value)
		})
	}
	
	let pressed;

	$(document).on("mousedown", ".divRight", function(e){
		pressed = true;
		startX = e.clientX;
		console.log(startX);
	})
	$(document).on("mouseleave", ".divRight", function(e){
		pressed = false;
	})
	$(document).on("mouseup", ".divRight", function(e){
		pressed = false;
	})
	$(document).on("mousemove", ".divRight", function(e){
		if(!pressed) return;
		//Y축이 영향을 미치지 않게 X축에서만 이동하도록 설정
		e.preventDefault();
		this.scrollLeft += startX - e.clientX;
		console.log(startX - e.clientX)
	})
	
	//rides image 확대
	$(document).on("mouseover", ".ride-image", function(){
		$(this).css("transition", "transform, 2s, linear")
		$(this).css("transform", "scale(1.2)")
	})
	$(document).on("mouseleave", ".ride-image", function(){
		$(this).css("transition", "transform, 2s, linear")
		$(this).css("transform", "translate(0px, 0px)")
	})
})	

function ridesClick(){
	//alert("click");
	$.ajax({
		url:"/ridesList?amuse_id=" + ${dto.amuse_id},
		type: "get",
		dataType: "json",
		success: function(response){
			//console.log("aaaa")
			//console.log(response);
			let data = "";
			let data2 = "";
			
			data += "<h3 align=" + "'center'>Cate1</h3>"
			data += "<div class=" + "'container divRight'>";
			data += "<div class=" + "'d-flex row-cols-2 row-cols-md-3 row-cols-xl-4'>"
			
			data2 += "<div class=" + "'container divRight'>";
			data2 += "<div class=" + "'d-flex row-cols-2 row-cols-md-3 row-cols-xl-4'>"
			
			for(row of response){
				data += "<div class=" + "'col mb-5 img-list'>"
				data += "<div class=" + "'card h-100 imgs'>"
				data += "<img class=" + "'card-img-top ride-image' src='" + row["r_img"] + "'/>"
				data += "<div class=" + "'card-body p-4'>"
				data += "<div class=" + "'text-center'>"
				data += "<h5 class=" + "'fw-bolder'>" + row["r_name"] + "</h5></div></div>"
				data += "<div class=" + "'card-footer p-4 pt-0 border-top-0 bg-transparent'>"
				data += "<div class=" + "'text-center'>"
				data += "<a class=" + "'btn btn-outline-dark mt-auto' href=" + "'ridesDetail?rides_id=" + row["rides_id"] +"'>" + "Detail" + "</a>"
				data += "</div></div></div></div>"
				
				data2 += "<div class=" + "'col mb-5 img-list'>"
				data2 += "<div class=" + "'card h-100 imgs'>"
				data2 += "<img class=" + "'card-img-top ride-image' src='" + row["r_img"] + "'/>"
				data2 += "<div class=" + "'card-body p-4'>"
				data2 += "<div class=" + "'text-center'>"
				data2 += "<h5 class=" + "'fw-bolder'>" + row["r_name"] + "</h5></div></div>"
				data2 += "<div class=" + "'card-footer p-4 pt-0 border-top-0 bg-transparent'>"
				data2 += "<div class=" + "'text-center'>"
				data2 += "<a class=" + "'btn btn-outline-dark mt-auto' href=" + "'ridesDetail?rides_id=" + row["rides_id"] +"'>" + "Detail" + "</a>"
				data2 += "</div></div></div></div>"
			}
			$(".img-div").html(data)
			$("<h2>").text("Cate2").attr("align", "center").appendTo(".img-div")
			$("<div>").attr("class", "divMid d-flex").html(data2).appendTo(".img-div")
		},
		error:function(request,status,error){
			console.log("code: " + request.status)
			console.log("message: " + request.responseText)
			console.log("error: " + error);
		}
	});
}

function facilityClick(){
	$.ajax({
		url:"/facilityList?amuse_id=" + ${dto.amuse_id},
		type: "get",
		dataType:"json",
		success: function(response){
			//console.log("aaaa")
			//console.log(response);
			let data = "<div id=" + "'fDiv'" + ">";
			for(row of response){
				//console.log(row)
				data += "<div><h2><a class=" + "'list-group-item list-group-item-action list-group-item-light p-3'" 
				data += "href=" + "'#'" + ">" + row["f_name"] + "</a></h2></div>"
			}
			data += "</div>"
			$(".img-div").html(data)
		},
		error:function(request,status,error){
			console.log("code: " + request.status)
			console.log("message: " + request.responseText)
			console.log("error: " + error);
		}
	});
}

</script>

</head>
<body>
<!-- d-flex => display: flex -->
	<div class="d-flex container wrapper">
		<input type="hidden" id="amuse_id" value="${dto.amuse_id }"> 
		<div class="border-top bg-white col-2" id="sidebar-wrapper">
			<div class="list-group list-group-flush text-md-center">
				<a class="border-start border-end list-group-item list-group-item-action list-group-item-light p-3"
				href="javascript:void(0);" onclick="aboutClick();">About</a>
				
				<a class="border-start border-end list-group-item list-group-item-action list-group-item-light p-3"
				href="javascript:void(0);" onclick="ridesClick();">Rides</a> 
				
				<a class="border-start border-end list-group-item list-group-item-action list-group-item-light p-3" 
				href="javascript:void(0);" onclick="facilityClick();">Facility</a>
				
				<a class="border-start border-end list-group-item list-group-item-action list-group-item-light p-3" 
				href="javascript:void(0);" onclick="reservationClick();">Reservation</a>
				
				<a class="border-start border-end list-group-item list-group-item-action list-group-item-light border-bottom p-3" 
				href="javascript:void(0);" onclick="promotionClick();">Promotion</a> 
			</div>
		</div>
		<div class="container img-div">
			<div class="divMid d-flex">
				<div class="mid col-8" id="firstMid">
					<img class="card card-img-top custom-card-img mb-5 mb-md-0" id="mainImg" src="${dto.a_img }"/>
					<div>
					 <c:forEach items="${aImg }" var="img" varStatus="status">
						<img alt="1" name="imgs" class="atag card-img-top mb-5 mb-md-0" id="${status.index }" src="${img.url }">
					 	<input type="hidden" id="input" value="${status.index }">
					 	<input type="hidden" id="image" value="${img.url }">
					 </c:forEach>
					</div>
					<div id="divImage">
					</div>
				</div>
				<div class="mid col-4" id="secondMid">
					<h2>${dto.a_name }</h2>
					<p>${dto.a_time }</p>
					<c:if test="${dto.a_country != '대한민국' }">
						<p>${dto.a_country }</p>					
					</c:if>
					<div class="d-flex small text-warning mb-2">
						<div class="bi-star-fill"></div>
						<div class="bi-star-fill"></div>
						<div class="bi-star-fill"></div>
						<div class="bi-star-fill"></div>
						<div class="bi-star-fill"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>