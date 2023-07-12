package com.exciting.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.exciting.dto.ChatDTO;

@Repository
public class ChatDAO {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	public List<ChatDTO> chatMemberList(){
		return sqlSessionTemplate.selectList("exciting.chatMemberList");
	}
}
