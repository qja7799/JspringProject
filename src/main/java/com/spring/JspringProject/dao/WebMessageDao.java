package com.spring.JspringProject.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.JspringProject.vo.WebMessageVo;

public interface WebMessageDao {

	int setWmInputOk(@Param("vo") WebMessageVo vo);

	List<WebMessageVo> getWebmessageList(
			@Param("mid") String mid, 
			@Param("mSw") int mSw, 
			@Param("startIndexNo") int startIndexNo, 
			@Param("pageSize") int pageSize
			);

	WebMessageVo getWebmessageContent(@Param("idx") int idx, @Param("mid") String mid);

	int setWebDeleteCheck(@Param("idx") int idx, @Param("mFlag") int mFlag);

	void setWebMessageSwUpdate(int idx);

	int setWebDeleteAll(@Param("mid") String mid, @Param("sendId") String sendId, @Param("receiveId") String receiveId);

	void setWebDeleteAllProcess();

	int setWebMessageRecover(@Param("idx") int idx, @Param("mid") String mid, @Param("sendId") String sendId);

}
