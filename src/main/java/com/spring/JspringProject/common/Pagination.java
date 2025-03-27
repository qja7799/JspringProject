package com.spring.JspringProject.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.JspringProject.dao.BoardDao;
import com.spring.JspringProject.dao.PdsDao;
import com.spring.JspringProject.vo.PageVo;

@Service
public class Pagination {
	
	@Autowired
	BoardDao boardDao;
	
	@Autowired
	PdsDao pdsDao;

	public PageVo getTotRecCnt(int pag, int pageSize, String section, String search, String searchString) {
		PageVo vo = new PageVo();
		
		int totRecCnt = 0;
		String searchStr = "";
		
//		검색어가 넘어왔을경우 처리하는 부분
//		if(!searchString.equals("/")) {	// searchString : 'title/공지'
//			search = searchString.split("/")[0];
//			searchString = searchString.split("/")[1];
//		}
		
		//게시판종류가 보드게시판일경우
		if(section.equals("board")) {
			//검색필드가 빈값이라면 전체검색개수를 totRecCnt에 저장
			if(search.equals("")) totRecCnt = boardDao.getBoardTotRecCnt();
			else {
				//검색필드가 빈값이 아니라면 검색필드와 검색어를 받아 검색개수를 totRecCnt에 저장
				totRecCnt = boardDao.getBoardTotRecCntSearch(search, searchString);
			}
		}//게시판종류가 자료실일경우
		else if(section.equals("pds")) {
			totRecCnt = pdsDao.getPdsTotRecCnt(search);
		}
		
		//검색어가 존재한다면 검색어로 검색한 결과의 개수를 페이지사이즈(한페이지에 보여줄개수)에 넣고
		//searchStr에 검색주제 한글로 번역한걸 넣음
		//그냥 강사가 야매식으로 누더기골렘마냥 만들어서 어떻게든 꾸역꾸역 이 프로젝트에서 굴러만가는수준임 이 페이지네비게이션은 다른곳에서 쓰려면 뜯어고칠데가 한두군데가아님
		if(!searchString.equals("")) {
			//pageSize = totRecCnt;
			//totRecCnt(검색결과로 나온글개수)
			if(totRecCnt != 0) pageSize = totRecCnt; // 이걸로 검색결과가 있을때만 페이지사이즈 주도록 설정(이렇게 써줌으로써 검색결과 없을때 에러안남)
			if(search.equals("title")) searchStr = "글제목";
			else if(search.equals("nickName")) searchStr = "닉네임";
			else searchStr = "글내용";
		}
		
		int totPage = (totRecCnt % pageSize) == 0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStartNo = totRecCnt - startIndexNo;
		
		int blockSize = 3;
		int curBlock = (pag - 1) / blockSize;
		int lastBlock = (totPage - 1) / blockSize;
		
		vo.setPag(pag);
		vo.setPageSize(pageSize);
		vo.setTotPage(totPage);
		vo.setStartIndexNo(startIndexNo);
		vo.setCurScrStartNo(curScrStartNo);
		vo.setBlockSize(blockSize);
		vo.setCurBlock(curBlock);
		vo.setLastBlock(lastBlock);
		vo.setSearch(search);
		vo.setSearchStr(searchStr);
		vo.setSearchString(searchString);
		
		//확장성고려해서 만든 파트변수(게시판종류가 섹션변수,게시판안에서의 또다른 종류를 담는게 파트변수) / 지금은 안쓰임
		vo.setPart(search);
		
		return vo;
	}
	
	
	
}
