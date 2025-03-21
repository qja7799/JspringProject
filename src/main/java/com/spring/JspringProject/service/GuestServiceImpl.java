package com.spring.JspringProject.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.JspringProject.dao.GuestDao;
import com.spring.JspringProject.vo.GuestVo;

@Service
public class GuestServiceImpl implements GuestService {
	
	@Autowired
	GuestDao guestDao;

	@Override
	public List<GuestVo> getGuestList(int startIndexNo, int pageSize) {
		return guestDao.getGuestList(startIndexNo, pageSize);
	}

	@Override
	public int setGuestInput(GuestVo vo) {
		return guestDao.setGuestInput(vo);
	}

	@Override
	public int setGuestDelete(int idx) {
		return guestDao.setGuestDelete(idx);
	}

	@Override
	public int getTotRecCnt() {
		return guestDao.getTotRecCnt();
	}

}
