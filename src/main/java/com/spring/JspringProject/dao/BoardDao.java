package com.spring.JspringProject.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.JspringProject.vo.BoardVo;

public interface BoardDao {

	int getBoardTotRecCnt();

	List<BoardVo> getBoardList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	BoardVo getBoardContent(int idx);

	void setBoardReadNumPlus(int idx);

	int setBoardInputOk(@Param("vo") BoardVo vo);

	int setBoardDelete(int idx);

	int setBoardUpdate(@Param("vo") BoardVo vo);

}
