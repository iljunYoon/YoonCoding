<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>push alarm</title>

<!-- sockjs 라이브러리 -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.5/sockjs.min.js"></script>

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.4.min.js" 
integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" 
crossorigin="anonymous"></script>

</head>
<body>
<h5>web socket test</h5>
<input type="hidden" id="login_id" value="${member_id }">
<form>
	<select id="sel">
		<option>선택</option>
		<option value="가입환영">가입환영</option>
		<option value="전체공지">전체공지</option>
	</select>
	<textarea rows="3" cols="30" id="textarea"></textarea>
	<button type="button" id="btn">send</button>
</form>
</body>

<script type="text/javascript">
	$("#btn").on("click", function(){
		alert("click")
		const content = $("#textarea").val();
		const sel = document.querySelector("#sel");
		const optVal = sel[sel.selectedIndex].value;
		
		console.log(content)
		console.log(optVal)
		
		sendMessage(content, optVal);
	})
	
	const msg = $("#textarea").val();
	console.log(msg);
	//웹소켓 서버 접속 시도
	//url에 ? 같은 쿼리스트링 붙일 수도 있음
	let sock = new SockJS("http://localhost:8080/alarm?login_id=" + $("#login_id").val());
	
	sock.onopen = onOpen;
	sock.onmessage = onMessage;
		
	function onOpen(){
		console.log($("#login_id").val() + " 웹 소켓 서버 접속")
	}
	
	function sendMessage(content, optVal) {
		//웹소켓 서버에 접속한 모든 세션에 대해 메세지 전송
		sock.send(content + "," + optVal);
	}
	
	// 서버로부터 메시지를 받았을 때
	function onMessage(msg) {
		const data = msg.data;
		console.log("data = " + data)
	}
	
	// 서버와 연결을 끊었을 때
	function onClose() {
	}
</script>
</html>