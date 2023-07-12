package com.exciting.websocket;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.stereotype.Repository;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import lombok.extern.log4j.Log4j2;

@Repository
public class AlarmHandler extends TextWebSocketHandler{
	
	@Autowired
	SqlSession sqlSession;
	
	//웹 소켓 서버에 접속할 경우 그 세션을 담을 리스트를 생성한다
	//푸쉬 알림이므로 접속한 모든 세션에 메세지를 전달해야 하기 때문에 리스트 사용
	//특정 세션에만 메세지 전달하려면 Map 이용
	List<WebSocketSession> connectSessions = new ArrayList<WebSocketSession>();
//	Map<String, WebSocketSession> users = new HashMap<String, WebSocketSession>();

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		connectSessions.add(session);
		
		int idx = session.getUri().toString().indexOf("=");
		String member_id = session.getUri().toString().substring(idx + 1);
		System.out.println("member_id = " + member_id);
		
	}
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		// 1) 웹소켓 클라이언트 쪽에서 sendMessage 메소드를 통해 서버 오픈 시 메세지 보내면 여기서 받을 수 있음
		System.out.println(message.getPayload());
		int idx = message.getPayload().toString().indexOf(",");
		System.out.println(idx);
		String alarmMsg = message.getPayload().substring(0,idx);
		System.out.println("alarmMsg = " + alarmMsg);
		String alarmType = message.getPayload().substring(idx + 1);
		System.out.println("alarmType = " + alarmType);
		
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
	}
}
