package com.spring.JspringProject.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.JspringProject.vo.UserVo;

public interface User2Dao {

	UserVo getUserIdSearch(String mid);

	int setUserInput(UserVo vo);

	UserVo getUserSearchPart(UserVo vo);

	List<UserVo> getUserList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	int setUserDeleteOk(int idx);

	UserVo getSearchIdx(int idx);

	//int getUserUpdate(@Param("vo") UserVo vo);
	int getUserUpdate(UserVo vo);

	List<UserVo> getUserOrderList(String order);

	int getUserCount();

	int getTotRecCnt();
}
