package com.spring.JspringProject.vo;

import lombok.Data;

@Data
public class ReviewReplyVo {
	private int replyIdx;
	private String reviewPart;
	private int reviewIdx;
	private String replyMid;
	private String replyNickName;
	private String replyRDate;
	private String replyContent;
}
