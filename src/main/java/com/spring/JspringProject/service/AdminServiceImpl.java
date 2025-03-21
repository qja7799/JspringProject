package com.spring.JspringProject.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.JspringProject.dao.AdminDao;

@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	AdminDao adminDao;//나중에 생성자로 바꿔야한다는데 무슨의미?

	@Override
	public int setMemberLevelChange(int level, int idx) {
		return adminDao.setMemberLevelChange(level, idx);
	}
	
}
