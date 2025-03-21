package com.spring.JspringProject.service;

import java.util.List;

import com.spring.JspringProject.vo.BoardVo;

public interface BoardService {

	int getBoardTotRecCnt();

	List<BoardVo> getBoardList(int startIndexNo, int pageSize);

	BoardVo getBoardContent(int idx);

	void setBoardReadNumPlus(int idx);

	int setBoardInputOk(BoardVo vo);

	int setBoardDelete(int idx);

	void imgCheck(String content);

	void imgDelete(String content);

	void imgBackup(String content);

	int setBoardUpdate(BoardVo vo);

}
