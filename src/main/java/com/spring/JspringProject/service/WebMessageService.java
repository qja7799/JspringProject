package com.spring.JspringProject.service;

import java.util.List;

import com.spring.JspringProject.vo.WebMessageVo;

public interface WebMessageService {

	int setWmInputOk(WebMessageVo vo);

	List<WebMessageVo> getWebmessageList(String mid, int mSw, int startIndexNo, int pageSize);

	WebMessageVo getWebmessageContent(int idx, String mid);

	int setWebDeleteCheck(int idx, int mFlag);

	void setWebMessageSwUpdate(int idx);

	int setWebDeleteAll(String mid, String sendId, String receiveId);

	void setWebDeleteAllProcess();

	int setWebMessageRecover(int idx, String mid, String sendId);

}
