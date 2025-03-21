package com.spring.JspringProject.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.spring.JspringProject.dao.BoardDao;
import com.spring.JspringProject.vo.BoardVo;

@Service
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	BoardDao boardDao;

	@Override
	public int getBoardTotRecCnt() {
		return boardDao.getBoardTotRecCnt();
	}

	@Override
	public List<BoardVo> getBoardList(int startIndexNo, int pageSize) {
		return boardDao.getBoardList(startIndexNo, pageSize);
	}

	@Override
	public BoardVo getBoardContent(int idx) {
		return boardDao.getBoardContent(idx);
	}

	@Override
	public void setBoardReadNumPlus(int idx) {
		boardDao.setBoardReadNumPlus(idx);
	}

	@Override
	public int setBoardInputOk(BoardVo vo) {
		return boardDao.setBoardInputOk(vo);
	}

	@Override
	public int setBoardDelete(int idx) {
		return boardDao.setBoardDelete(idx);
	}

	@Override
	public void imgCheck(String content) {
		//위치    0         1         2         3         4         4
		//      01234567890123456789012345678901234567890123456789012345678
		// <img src="/JspringProject/data/ckeditor/250321140356_2503.jpg" style="height:854px; width:1280px" />
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/");
		
		int position = 35;
		String nextImg = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		
		while(sw) {
			String imgFile = nextImg.substring(0, nextImg.indexOf("\""));
			
			String origFilePath = realPath + "ckeditor/" + imgFile;
			String copyFilePath = realPath + "board/" + imgFile;
			
			fileCopyCheck(origFilePath, copyFilePath);
			
			if(nextImg.indexOf("src=\"/") == -1) sw = false;
			else nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
		}
	}

	// 파일 복사처리
	private void fileCopyCheck(String origFilePath, String copyFilePath) {
		//서버안에꺼를 복사해서 다른서버에 집어넣어야하는 상황임
		//imgCheck메서드가 오버라이드메서드기 떄문에 io익센션으로 에러 못던져서 트라이캐치로 에러처리해줘야함
		try {
			FileInputStream fis = new FileInputStream(new File(origFilePath));
			FileOutputStream fos = new FileOutputStream(new File(copyFilePath));
			
			byte[] b = new byte[2048];
			int cnt = 0;
			while((cnt = fis.read(b)) != -1) {
				fos.write(b, 0, cnt);
			}
			fos.flush();
			fos.close();
			fis.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void imgDelete(String content) {
		//위치    0         1         2         3         4         4
		//      01234567890123456789012345678901234567890123456789012345678
		// <img src="/JspringProject/data/board/250321140356_2503.jpg" style="height:854px; width:1280px" />
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/");
		
		int position = 32;
		String nextImg = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		
		while(sw) {
			String imgFile = nextImg.substring(0, nextImg.indexOf("\""));
			
			String origFilePath = realPath + "board/" + imgFile;
			
			fileDelete(origFilePath);
			
			if(nextImg.indexOf("src=\"/") == -1) sw = false;
			else nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
		}
		
	}

	//파일 삭제 처리
	private void fileDelete(String origFilePath) {
		File delFile = new File(origFilePath); //항상 껍데기가 필요하기에 일단 먼저 객체를 만들어줘야함
		if(delFile.exists()) delFile.delete();
	}

	//게시글 수정시 그림이 있다면 보드폴더에서 그림 찾아서 ck에디터 폴더에 그림복사
	@Override
	public void imgBackup(String content) {
		//위치    0         1         2         3         4         4
		//      01234567890123456789012345678901234567890123456789012345678
		// <img src="/JspringProject/data/board/250321140356_2503.jpg" style="height:854px; width:1280px" />
		// <img src="/JspringProject/data/ckeditor/250321140356_2503.jpg" style="height:854px; width:1280px" />
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/");
		
		int position = 32;
		String nextImg = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		
		while(sw) {
			String imgFile = nextImg.substring(0, nextImg.indexOf("\""));
			
			String origFilePath = realPath + "board/" + imgFile;
			String copyFilePath = realPath + "ckeditor/" + imgFile;
			
			fileCopyCheck(origFilePath, copyFilePath);
			
			if(nextImg.indexOf("src=\"/") == -1) sw = false;
			else nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
		}
	}

	@Override
	public int setBoardUpdate(BoardVo vo) {
		return boardDao.setBoardUpdate(vo);
	}
	
	
}
