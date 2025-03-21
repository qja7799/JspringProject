package com.spring.JspringProject.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.JspringProject.dao.Userdao;
import com.spring.JspringProject.dao.UserdaoImpl;
import com.spring.JspringProject.vo.UserVo;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	//private Userdao userdao;
	private UserdaoImpl userdao;

	@Override
	public UserVo getUserIdSearch(String mid) {
		return userdao.getUserIdSearch(mid);
	}

	@Override
	public int setUserInput(UserVo vo) {
		return userdao.setUserInput(vo);
	}

	@Override
	public UserVo getUserSearchPart(UserVo vo) {
		
		return userdao.getUserSearchPart(vo);
	}

	@Override
	public List<UserVo> getUserList() {
		return userdao.getUserList();
	}

	@Override
	public int setUserDeleteOk(int idx) {
		return userdao.setUserDeleteOk(idx);
	}

	@Override
	public UserVo getSearchIdx(int idx) {
		return userdao.getSearchIdx(idx);
	}

	@Override
	public int getUserUpdate(UserVo vo) {
		return userdao.getUserUpdate(vo);
	}
	
}
