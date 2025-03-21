package com.spring.JspringProject.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.spring.JspringProject.vo.MemberVo;

public interface MemberService {

	MemberVo getMemberIdCheck(String mid);

	MemberVo memberNickChcek(String nickName);

	String fileUpload(MultipartFile fName, String mid, String photo);

	int setMemberJoinOk(MemberVo vo);

	void setMemberInforUpdate(String mid, int point);

	List<MemberVo> getMemberList(int level);

	void setMemberDeleteCheck(String mid);

	int getGesigulcount(String name);

	int getTodayCount(String mid);

	MemberVo getMemberIdxSearch(int idx);

	int setMemberPwdChange(String mid, String pwd);

	List<MemberVo> getEmailList(String email);

	void setMemberTodayCntClear(String mid);

	int setMemberUpdateOk(MemberVo vo);


}
