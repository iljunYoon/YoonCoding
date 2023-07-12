package com.exciting.websocket;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import lombok.extern.log4j.Log4j2;

@Repository
@Log4j2
public class WebSocketHandler extends TextWebSocketHandler{
	
	@Autowired
	SqlSession sqlsession;
	
	List<WebSocketSession> connectSessions = new ArrayList<WebSocketSession>();
	Map<String, WebSocketSession> users = new HashMap<String, WebSocketSession>();
	Map<String, Object> map = new HashMap<String, Object>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		int idx = session.getUri().toString().indexOf("=");
		
		String member_id = session.getUri().toString().substring(idx + 1);
		System.out.println("member_id = " + member_id);
		
		log.info(session.getUri().toString().substring(idx + 1) + "님이 채팅방에 입장했습니다");
		map.put("member_id", member_id);
		
		users.put(member_id, session);
		//채팅방에 접속한 회원을 alarm 테이블에 넣고 chatRoom 페이지에서 ajax로 alarm 테이블 정보를 가져와서 현재 채팅방에 접속해 있는 회원을 나타내줌
		sqlsession.insert("exciting.insertChatMember", map);		
		
		for(WebSocketSession ws : users.values()) {
			System.out.println("map value = " + ws);
			System.out.println("웹 소켓 서버 접속 아이디: " + ws.getUri().toString().substring(idx + 1));
			
			//전체 session에 보내느냐 아님 map에 넣은 특정 session을 기준으로 보내느냐에 따라 달라짐
			//채팅방에 들어갈 때 어떤 회원이 들어왔는지 알려줌! 기존에 채팅방에 있는 사람들에게 나중에 들어온 회원 아이디가 나타나야 함
			ws.sendMessage(new TextMessage(session.getUri().toString().substring(idx + 1)));
		}
	}
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		//================ "/echo" ================
//		for(WebSocketSession s : connectSessions) {
//			int idx = s.getUri().toString().indexOf("=");
//			s.sendMessage(new TextMessage(session.getUri().toString().substring(idx + 1) + ":" + message.getPayload()));
//		}
		
		for(WebSocketSession ws : users.values()) {
//			System.out.println("웹 소켓 서버 접속 아이디: " + ws.getUri().toString().substring(idx + 1));
			int idx = ws.getUri().toString().indexOf("=");
			ws.sendMessage(new TextMessage(session.getUri().toString().substring(idx + 1) + ":" + message.getPayload()));
			System.out.println("member_id = " + ws.getUri().toString().substring(idx + 1));
		}
	}	
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		int idx = session.getUri().toString().indexOf("=");
		String member_id = session.getUri().toString().substring(idx + 1);
		map.put("member_id", member_id);
		
		System.out.println("웹소켓 종료하고 session = " + session);
		System.out.println("웹소켓 종료하고 member_id = " + member_id);
		
		users.remove(member_id);
		
		sqlsession.delete("exciting.deleteChatMember", map);
		
		log.info(member_id + "님이 퇴장했습니다");
		
	}
}
