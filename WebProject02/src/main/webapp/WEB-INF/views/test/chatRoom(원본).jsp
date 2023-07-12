<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ChatRoom</title>

<!-- sockjs 라이브러리 -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.5/sockjs.min.js"></script>

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.4.min.js" 
integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" 
crossorigin="anonymous"></script>

<style type="text/css">
*{ margin: 0; padding: 0; }

.header { 
font-size: 15px; 
background: lightblue; 
color: black; 
text-align: center;  
width: 100%;
border-radius: 20px;
}

.chat { 
padding-bottom: 50px;
padding-top: 50px;
}

.left { text-align: left; left: 10px;}
.right { text-align: right; right: 10px; }
.center { text-align: center; }
 
.chat_wrap .chat div { font-size: 13px;  }

.sender { 
margin: 10px 20px 0 20px; 
font-weight: bold; 
}

.message { 
display: inline-block; 
word-break:break-all; 
margin: 5px 20px; 
max-width: 75%; 
border: 1px solid #888; 
padding: 10px; 
border-radius: 5px; 
background-color: #FCFCFC; 
color: #555; 
text-align: left; 
}

.input-div { 
position: fixed; 
bottom: 0; 
width: 100%;
background-color: #FFF; 
text-align: center;
border: none;
margin: auto;
}

.chat_wrap .input-div > input {
width: 300px;
height: 20px;
border: 2px solid lightblue; 
border-radius: 15px;
padding: 10px;
margin: auto;
resize: none;
}

.chat_wrap::-webkit-scrollbar {
  display: none;
}
.btn{
	font-size: 1.4rem;
}
</style>

</head>
<body>
<input type="hidden" id="member_id" value="${member_id }">	
<div class="chat_wrap container">
	<h4>Chat</h4>
	<div class="header">
		<ul id="chat-member">
		</ul>
	</div>
	<div class="chat">
	</div>
	<div class="input-div">
		<input type="text" id="textarea" style="overflow:hidden" placeholder="Press Enter for send message."/>
	</div>
</div>
</body>

<script type="text/javascript">
	const chatDiv = document.querySelector(".chat");
	
	const chatMemberList = function(){
		$.ajax({
			url: "/chatMember",
			type: "post",
			dataType: "json",
			success: function(response){
				let data = "";
				for(row of response){
					//웹 소켓에 접속한 회원이 chat 테이블에 추가되는 것보다 ajax 요청이 먼저 발생
					// ":"가 포함되지 않은 메세지가 올 때 ajax로 요청해야 함!!
// 					console.log("member_id = " + row["member_id"]);
				
					//ajax 응답 받을 때 기존의 태그를 삭제하고 새로운 태그에 값을 넣고 싶다.
					data += "<li>" + row["member_id"] + "</li>";
				}
				$("#chat-member").html(data);
			}
		})
	}
	
	function onOpen(sessionId){
		//alert("웹 소켓 서버 open");
		var str = "<div class='center'>";
		str += "<span>" + sessionId + "님이 채팅방에 입장했습니다</span></div>";
		$(".chat").append(str);
	}

	let sock = new SockJS("http://localhost:8080/chat?userId=" + $("#member_id").val());
	
	sock.onmessage = onMessage;
	sock.onclose = onClose;

	$(document).on("mousedown", ".input-div input", function(e){
		$(".input-div input").css("outline-color", "#FE6B8B")
	})

	//enter 눌렀을 때 메세지 전송되도록
	$(document).on("keydown", ".input-div input", function(e){
		//enter의 코드가 13이라고 함
		if(e.keyCode == 13){
			if(!e.shiftKey) {
				if(confirm("send?")){
					sendMessage();
					$("#textarea").val("");
				}
			}
		}
	})
	
	function sendMessage() {
		sock.send($(".input-div input").val());
	}
	
	// 서버로부터 메시지를 받았을 때
	function onMessage(msg) {
		var data = msg.data;
		var sessionId = null;
		var message = null;
		
		console.log(data)
		console.log(data.includes(":"))
		
		//handler에서 session 아이디와 메세지를 :로 구분해서 보냄
		if(!data.includes(":")){
			
// 			onOpen($("#member_id").val())
			var str = "";
			str += "<div class='center'>";
			str += "<span>" + data + "님이 채팅방에 입장했습니다</span></div>";
			$(".chat").append(str);
			
			chatMemberList();
		}
		else{
			var arr = data.split(":")
			
			for(let i = 0; i < arr.length; i++){
				console.log("arr['" + i + "']:" + arr[i])
			}
			
			var current_session = $("#member_id").val()
			console.log("current_session = " + current_session)
			
			sessionId = arr[0];
			message = arr[1];
			
			if(sessionId === current_session){
				//right
				console.log("same")
				
				var str = "<div class='right'>";
				str += "<div class=" + "'sender'><span>" + sessionId + "</span></div>"
				str += "<div class=" + "'message'><span>" + message + "</span></div>"
				str += "</div>";
				
				$(".chat").append(str);
				
				//스크롤 자동으로 내려가기
				window.scroll({
				  top: document.querySelector(".chat").scrollHeight,
				  left: 0,
				  behavior: "smooth",
				});
			}
			else if(sessionId !== current_session){
				//left
				console.log("different")
				
				var str = "<div class='left'>";
				str += "<div class=" + "'sender'><span>" + sessionId + "</span></div>"
				str += "<div class=" + "'message'><span>" + message + "</span></div>"
				str += "</div>";
				
				$(".chat").append(str);
				
				window.scroll({
				  top: document.querySelector(".chat").scrollHeight,
				  left: 0,
				  behavior: "smooth",
				});
			}
		}
	}
	
	// 서버와 연결을 끊었을 때
	function onClose(evt) {
		$(".chat").append("연결 끊김");
		console.log(evt);
	}
</script>
</html>