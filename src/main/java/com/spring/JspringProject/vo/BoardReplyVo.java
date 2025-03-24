package com.spring.JspringProject.vo;

import lombok.Data;

@Data
public class BoardReplyVo {
	private int idx;
	private int boardIdx;
	private String mid;
	private String nickName;
	private String content;
	private String hostIp;
	private String wDate;
}
