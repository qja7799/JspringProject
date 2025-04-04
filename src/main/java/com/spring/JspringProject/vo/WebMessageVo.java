package com.spring.JspringProject.vo;

import lombok.Data;

@Data
public class WebMessageVo {
	private int idx;
	private String title;
	private String content;
	private String sendId;
	private String sendSw;
	private String sendDate;
	private String receiveId;
	private String receiveSw;
	private String receiveDate;
}
