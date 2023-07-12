package com.exciting.amuse.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.exciting.dao.ChatDAO;
import com.exciting.dto.ChatDTO;

@Service
public class ChatServiceImpl implements ChatService{
	
	@Autowired
	ChatDAO dao;
	
	@Override
	public List<ChatDTO> chatMemberList() {
		return dao.chatMemberList();
	}
}
