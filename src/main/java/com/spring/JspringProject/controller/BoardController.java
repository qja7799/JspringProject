package com.spring.JspringProject.controller;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.JspringProject.service.BoardService;
import com.spring.JspringProject.vo.BoardVo;
import com.spring.JspringProject.vo.GuestVo;

@Controller
@RequestMapping("/board")
public class BoardController {
	
	@Autowired
	BoardService boardService;
	
	// 게시판메인 
	@RequestMapping(value = "/boardList", method = RequestMethod.GET)
	public String boardListGet(Model model,
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize
		) {
		int totRecCnt = boardService.getBoardTotRecCnt();
		int totPage = (totRecCnt % pageSize) == 0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStartNo = totRecCnt - startIndexNo;
		
		int blockSize = 3;
		int curBlock = (pag - 1) / blockSize;
		int lastBlock = (totPage - 1) / blockSize;
		List<BoardVo> vos = boardService.getBoardList(startIndexNo, pageSize);
		
		model.addAttribute("vos", vos);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("totPage", totPage);
		model.addAttribute("curScrStartNo", curScrStartNo);
		model.addAttribute("blockSize", blockSize);
		model.addAttribute("curBlock", curBlock);
		model.addAttribute("lastBlock", lastBlock);
		
		return "board/boardList";
	}
	
	//게시글 뷰보기
	@RequestMapping(value = "/boardContent", method = RequestMethod.GET)
	public String boardContentGet(Model model, HttpSession session, int idx, int pag, int pageSize) {
		//글 조회수 증가처리
		//session.setAttribute("sViewCheck"+idx, ""); 이렇게 게시글 하나하나마다
		//다른값을 세션에 저장시켜서 이 세션값의 존재유무로 조회수중복처리를 해줄수도 있지만
		//그러면 세션에 게시글마다 조회수중복값을 다 저장해줘야하기에 너무 비효율적이고 세션에 공간도 많이 차지하여 메모리소모가 심함
		//그래서 Set<Integer>를 사용하여 묶음으로 관리해주는거임
		//Set은 중복을 허용하지 않는 자료구조이므로, 동일한 게시글을 여러 번 저장하지 않고
		//사용자가 조회한 게시글들을 하나의 Set에 모아서 관리하므로 메모리 사용을 절약할 수 있음
		
	    // 세션에서 "viewedPosts" 가져오기 (없으면 null이 저장될뿐 에러는 안남)
	    Set<Integer> viewedPosts = (Set<Integer>) session.getAttribute("viewedPosts");

	    // 처음 조회하는 경우 빈Set을 생성
	    if (viewedPosts == null) {
	        viewedPosts = new HashSet<>();
	    }

	    // 게시글을 처음 조회하는 경우에만 조회수 증가
	    //viewedPosts 셋에 게시글번호가 들어있지않다면 
	    //viewedPosts 셋에 게시글번호 추가한 후 세션에 viewedPosts셋 저장
	    //셋은 중복된값이 들어가지않기에 자동중복체크가됨
	    if (!viewedPosts.contains(idx)) {
	        boardService.setBoardReadNumPlus(idx); // 조회수 증가
	        viewedPosts.add(idx); // 세션에 게시글 ID 추가
	        session.setAttribute("viewedPosts", viewedPosts); // 세션에 저장
	    }
		
		BoardVo vo = boardService.getBoardContent(idx);
		
		model.addAttribute("vo", vo);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		
		return "board/boardContent";
	}
	
	//게시글 입력 폼보기
	@RequestMapping(value = "/boardInput", method = RequestMethod.GET)
	public String boardInputGet() {
		return "board/boardInput";
	}
	
	//게시글 입력 처리
	@RequestMapping(value = "/boardInput", method = RequestMethod.POST)
	public String boardInputPost(BoardVo vo) {
		if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgCheck(vo.getContent());
		
		vo.setContent(vo.getContent().replace("/data/ckeditor/", "/data/board/"));	
			
	    int res = boardService.setBoardInputOk(vo);
		if(res != 0) return "redirect:/message/boardInputOk";
		else return "redirect:/message/boardInputNo";
	}
	
	//게시글 더미생성
    @RequestMapping("/insertDummy")
    public String insertDummyData() {
    	
        for (int i = 1; i <= 30; i++) {
        	BoardVo vo = new BoardVo();
            vo.setMid("qqq111");
            vo.setNickName("김나그네");
            vo.setTitle("제목테스트"+i);
            vo.setContent("내용테스트"+i);
            vo.setHostIp("192.1234567123");
            vo.setOpenSw("OK");
            boardService.setBoardInputOk(vo);
        }
        return "redirect:/message/insertBoardDummyDataok";
    }
	
	// 게시글 삭제 처리
	@RequestMapping(value = "/boardDelete", method = RequestMethod.GET)
	public String boardDeleteGet(int idx) {
		//게시글에 사진이 존재한다면 실제 파일을 board폴더에서 삭제시킨다
		BoardVo vo = boardService.getBoardContent(idx);
		if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgDelete(vo.getContent());
		
		//사진작업완룧 db에 저장된 실제 정보레코드를 삭제처리한다
		int res = boardService.setBoardDelete(idx);
		
		//페이지랑 페이지 사이즈도 넘길려면 넘겨도됨
		if(res != 0) return "redirect:/message/boardDeleteOk";
		else return "redirect:/message/boardDeleteNo?idx="+idx;
	}
	
	//게시글 수정 폼보기
	@RequestMapping(value = "/boardUpdate", method = RequestMethod.GET)
	public String boardUpdateGet(Model model ,int idx) {
		//수정처리시, 수정폼을 호출할때 현재게시글에 그림이 존재한다면 그림파일 모두를 ck에디터폴더로 복사시켜둔다
		BoardVo vo = boardService.getBoardContent(idx);
		if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgBackup(vo.getContent());
		model.addAttribute("vo", vo);
		
		return "board/boardUpdate";
	}
	
	// 게시글 수정처리 
	@RequestMapping(value = "/boardUpdate", method = RequestMethod.POST)
	public String boardUpdatePost(Model model, BoardVo vo) {
		// 수정된 자료가 원본자료와 완전히 동일하다면 수정할 필요가 없다.
		BoardVo dbVo = boardService.getBoardContent(vo.getIdx());//db에서 가져온 vo데이터
		
		//기존에 업로드된파일 지우고 새걸로 재업로드하는거라고 생각하면됨
		//content의 내용이 조금이라도 변경이 되었다면 내용을 수정처리한것이기에, 그림파일 처리유무를 결정한다
		if(!dbVo.getContent().equals(vo.getContent())) {
			// 1.기존 board폴더의 그림이 존재했다면,원본그림을 모두 삭제처리한다.
			if(dbVo.getContent().indexOf("src=\"/") != -1) boardService.imgDelete(dbVo.getContent());
			
			// 2.삭제후 'board'폴더를 'ckeditor'폴더로 경로 변경
			vo.setContent(vo.getContent().replace("/data/board/", "/data/ckeditor/"));
			
			// 1,2번 작업을 마치면 처음 글을 올릴때와 똑 같은 상황으로 처리하면 된다.
			if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgCheck(vo.getContent());
			
			// 이미지 복사작업을 모두 마치면(ckeditor폴더에서 board폴더로) 'ckeditor -> board' 변경한다.
			// 즉, 다시 원상태로 만들어줘야함
			vo.setContent(vo.getContent().replace("/data/ckeditor/", "/data/board/"));
		}
		int res = boardService.setBoardUpdate(vo);
		
		if(res != 0) return "redirect:/message/boardUpdateOk";
		else return "redirect:/message/boardUpdateNo?idx="+vo.getIdx();
	}
	
	
}
