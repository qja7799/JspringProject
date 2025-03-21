package com.spring.JspringProject.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.JspringProject.vo.MemberVo;

public interface MemberDao {

	MemberVo getMemberIdCheck(String mid);

	MemberVo memberNickChcek(String nickName);

	int setMemberJoinOk(@Param("vo") MemberVo vo);

	void setMemberInforUpdate(@Param("mid") String mid, @Param("point") int point);

	List<MemberVo> getMemberList(int level);

	void setMemberDeleteCheck(String mid);

	int getGesigulcount(String name);

	int getTodayCount(String mid);

	MemberVo getMemberIdxSearch(int idx);

	int setMemberPwdChange(@Param("mid") String mid, @Param("pwd") String pwd);

	List<MemberVo> getEmailList(String email);

	void setMemberTodayCntClear(String mid);

	int setMemberUpdateOk(@Param("vo") MemberVo vo);


}
