package com.spring.JspringProject.vo;

import lombok.Data;

@Data
public class ComplaintVo {
	private int idx;
	private String part;
	private int boardIdx;
	private int pdsIdx;
	private String cpMid;
	private String cpContent;
	private String cpDate;
	
	private String title;
	private String nickName;
	private String complaint;
}
