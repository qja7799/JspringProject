package com.spring.JspringProject.vo;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
//@Data
public class BoardVo {
	private int idx;
	private String mid;
	private String nickName;
	private String title;
	private String content;
	private String hostIp;
	private String openSw;
	private String readNum;
	private String wDate;
	private String good;
	private String complaint;
}
