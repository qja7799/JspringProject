package com.spring.JspringProject.vo;

import lombok.Data;

@Data
public class PdsVo {
	private int idx;
	private String mid;
	private String nickName;
	private String fName;
	private String fSName;
	private int fSize;
	private String title;
	private String content;
	private String part;
	private String hostIp;
	private String fDate;
	private int downNum;
	private String openSw;
	private String complaint;
	
	private int dateDiff;
	private int hourDiff;
}
