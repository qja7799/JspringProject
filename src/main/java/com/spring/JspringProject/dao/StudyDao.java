package com.spring.JspringProject.dao;

import java.util.List;

import com.spring.JspringProject.vo.ChartVo;

public interface StudyDao {

	List<ChartVo> getRecentlyVisitCount(int visitCount);

}
