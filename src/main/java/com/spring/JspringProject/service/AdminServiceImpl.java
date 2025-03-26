package com.spring.JspringProject.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.JspringProject.dao.AdminDao;
import com.spring.JspringProject.vo.ComplaintVo;

@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	AdminDao adminDao;//나중에 생성자로 바꿔야한다는데 무슨의미?

	@Override
	public int setMemberLevelChange(int level, int idx) {
		return adminDao.setMemberLevelChange(level, idx);
	}

	@Override
	public int setBoardComplaintInput(ComplaintVo vo) {
		return adminDao.setBoardComplaintInput(vo);
	}

	@Override
	public void setBoardTableComplaintOk(int partIdx) {
		adminDao.setBoardTableComplaintOk(partIdx);	
	}

	@Override
	public int getMemberTotRecCnt(int level) {
		return adminDao.getMemberTotRecCnt(level);
	}

	@Override
	public void setMemberLevelCheck(int parseInt, int levelSelect) {
		adminDao.setMemberLevelCheck(parseInt, levelSelect);
	}

	@Override
	public List<ComplaintVo> getComplaintList() {
		return adminDao.getComplaintList();
	}

	@Override
	public int setContentChange(int contentIdx, String contentSw) {
		return adminDao.setContentChange(contentIdx, contentSw);
	}
	
}
