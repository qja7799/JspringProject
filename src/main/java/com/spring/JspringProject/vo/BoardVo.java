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
	
	private int dateDiff;//게시글의 일자 경과유무 체크
	private int hourDiff;//게시글의 24시간 경과유무 체크
	
	private int replyCnt;// 댓글의 개수를 저장하는 변수
}
