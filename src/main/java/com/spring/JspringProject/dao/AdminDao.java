package com.spring.JspringProject.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.JspringProject.vo.ComplaintVo;

public interface AdminDao {

	int setMemberLevelChange(@Param("level") int level, @Param("idx") int idx);

	int setBoardComplaintInput(@Param("vo") ComplaintVo vo);

	void setBoardTableComplaintOk(int partIdx);

	int getMemberTotRecCnt(int level);
	
	void setMemberLevelCheck(@Param("idx") int idx, @Param("level") int levelSelect);

	List<ComplaintVo> getComplaintList();

	int setContentChange(@Param("contentIdx") int contentIdx, @Param("contentSw") String contentSw);

}
