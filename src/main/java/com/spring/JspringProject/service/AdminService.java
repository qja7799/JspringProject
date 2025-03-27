package com.spring.JspringProject.service;

import java.util.List;

import com.spring.JspringProject.vo.ComplaintVo;

public interface AdminService {

	int setMemberLevelChange(int level, int idx);

	int setBoardComplaintInput(ComplaintVo vo);

	void setBoardTableComplaintOk(int partIdx);

	int getMemberTotRecCnt(int level);

	void setMemberLevelCheck(int parseInt, int levelSelect);

	List<ComplaintVo> getComplaintList();

	int setContentChange(int contentIdx, String contentSw);

	int setComplaintDelete(int contentIdx, String contentName);

	int setContentDelete(int contentIdx, String contentPart);

}
