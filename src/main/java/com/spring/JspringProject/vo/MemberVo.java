package com.spring.JspringProject.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberVo {
	private int idx;
	private String mid;
	private String pwd;
	private String nickName;
	private String name;
	private String gender;
	private String birthday;
	private String tel;
	private String address;
	private String email;
	private String job;
	private String hobby;
	private String photo;
	private String content;
	private String userInfor;
	private String userDel;
	private int point;
	private int level;
	private int visitCnt;
	private int todayCnt;
	private String startDate;
	private String lastDate;
	
	private int deleteDiff;
	
}
