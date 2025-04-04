package com.spring.JspringProject.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.JspringProject.dao.WebMessageDao;
import com.spring.JspringProject.vo.WebMessageVo;

@Service
public class WebMessageServiceImpl implements WebMessageService {
	
	@Autowired
	WebMessageDao webMessageDao;

	@Override
	public int setWmInputOk(WebMessageVo vo) {
		return webMessageDao.setWmInputOk(vo);
	}

	@Override
	public List<WebMessageVo> getWebmessageList(String mid, int mSw, int startIndexNo, int pageSize) {
		return webMessageDao.getWebmessageList(mid, mSw, startIndexNo, pageSize);
	}

	@Override
	public WebMessageVo getWebmessageContent(int idx, String mid) {
		return webMessageDao.getWebmessageContent(idx, mid);
	}

	@Override
	public int setWebDeleteCheck(int idx, int mFlag) {
		return webMessageDao.setWebDeleteCheck(idx, mFlag);
	}

	@Override
	public void setWebMessageSwUpdate(int idx) {
		webMessageDao.setWebMessageSwUpdate(idx);
	}

	@Override
	public int setWebDeleteAll(String mid, String sendId, String receiveId) {
		return webMessageDao.setWebDeleteAll(mid, sendId, receiveId);
	}

	@Override
	public void setWebDeleteAllProcess() {
		webMessageDao.setWebDeleteAllProcess();
	}

	@Override
	public int setWebMessageRecover(int idx, String mid, String sendId) {
		return webMessageDao.setWebMessageRecover(idx, mid, sendId);
	}
}
