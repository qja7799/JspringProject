package com.spring.JspringProject.vo;

import lombok.Data;

@Data
public class ScheduleVo {
	private int idx;
	private String mid;
	private String sDate;
	private String part;
	private String content;

	private String ymd;
	private int partCnt; //달력에서 일정 중복체크할때 사용
}
