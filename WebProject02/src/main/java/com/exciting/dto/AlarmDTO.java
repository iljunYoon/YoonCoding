package com.exciting.dto;

import lombok.Data;

@Data
public class AlarmDTO {
	int alarm_id;
	String member_id;
	String alarm_type;
	String alarm_msg;
	String alarm_chk;
}
