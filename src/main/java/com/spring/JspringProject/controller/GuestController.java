package com.spring.JspringProject.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import com.spring.JspringProject.dao.GuestDao;
import com.spring.JspringProject.service.GuestService;
import com.spring.JspringProject.vo.GuestVo;


@Controller
@RequestMapping("/guest")
public class GuestController {
	
	@Autowired
	GuestService guestService;
	
	//방명록글 더미생성
    @RequestMapping("/insertDummy")
    public String insertDummyData() {
    	
        for (int i = 1; i <= 30; i++) {
            GuestVo vo = new GuestVo();
            vo.setName("작성자"+i);
            vo.setContent("글내용"+i);
            vo.setEmail("qwe123@aaa.com"+i);
            vo.setHomePage("homepage@aaa.com"+i);
            vo.setHostIp("호스트아이디"+i);
            guestService.setGuestInput(vo);
        }
        return "redirect:/message/insertDummyDataok";
    }
    
	@RequestMapping("/guestList")
	public String guestListGet(Model model,
		@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
		@RequestParam(name = "pageSize", defaultValue = "5", required = false) int pageSize
		) {
		int totRecCnt = guestService.getTotRecCnt();
		int totPage = (totRecCnt % pageSize) == 0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize) +1;
		int startIndexNo = pageSize * (pag - 1);
		int curScrStartNo = totRecCnt - startIndexNo;
		//0-1 * 3+1이 이전페이지
		int blockSize = 5; // 한블록의 페이지개수
		int curBlock = (pag - 1) / blockSize; //첫번쨰 블록/ 첫번쨰 블록은 0으로 설정
		int lastBlock = (totPage - 1) / blockSize; //마지막 블록
		
		List<GuestVo> vos = guestService.getGuestList(startIndexNo, pageSize);
		
		model.addAttribute("vos", vos);
		//페이징 처리방식
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("totPage", totPage);
		model.addAttribute("startIndexNo", startIndexNo);
		model.addAttribute("curScrStartNo", curScrStartNo);
		//페이징네비게이션 처리방식
		model.addAttribute("blockSize", blockSize);
		model.addAttribute("curBlock", curBlock);
		model.addAttribute("lastBlock", lastBlock);
		
		return "guest/guestList";
	}
	
	@RequestMapping("/guestInput")
	public String guestInputGet() {
		return "guest/guestInput";
	}
	
	@RequestMapping(value =  "/guestInput", method = RequestMethod.POST)
	public String guestListPost(GuestVo vo) {
		int res = guestService.setGuestInput(vo);
		
		if(res != 0) return "redirect:/message/guestInputOk";
		else return "redirect:/message/guestInputNo";
	}
	
	//관리자 로그인 폼보기
	@RequestMapping(value =  "/admin", method = RequestMethod.GET)
	public String adminGet() {
		return "guest/admin";
	}
	
	//관리자 로그인 처리
//	인터셉터안쓴 하드코딩기법의 관리자 인증
	@RequestMapping(value =  "/admin", method = RequestMethod.POST)
	public String adminPost(String mid, String pwd, HttpSession session) {
		if(mid.equals("admin") && pwd.equals("1234")) {
			session.setAttribute("sAdmin", "adminOk");
			return "redirect:/message/adminOk";
		}else {
			return "redirect:/message/adminNo";
		}
	}
	
	//관리자 로그아웃 처리
	@RequestMapping(value =  "/adminLogout", method = RequestMethod.GET)
	public String adminLogoutGet(HttpSession session) {
		//세션.인밸리디드를 쓰면안되는 이유=> 세션인밸리디드는 세션에 저장된걸 전부 삭제시키는것이기에 
		//관리자가 로그아웃하면 기존에 로그인되어있던 일반유저들의 세션에 저장된 정보들도 함께 날아가게됨
		//그렇기에 세션에 저장된 특정데이터(관리자아이디)만 지워야함
		session.removeAttribute("sAdmin");
		return "redirect:/message/adminLogout";
	}
	
	//게시글 삭제 처리
	@RequestMapping(value =  "/guestDelete", method = RequestMethod.GET)
	public String guestDeleteGet(int idx) {
		int res = guestService.setGuestDelete(idx);
		
		//res가 0이여도 에러는 안남 / 지울게 없었기에 안지운거기때문임 /
		if(res != 0) return "redirect:/message/guestDeleteOk";
		else return "redirect:/message/guestDeleteNo";
	}
	
	
}
