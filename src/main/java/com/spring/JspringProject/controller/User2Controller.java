package com.spring.JspringProject.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.JspringProject.service.User2Service;
import com.spring.JspringProject.vo.GuestVo;
import com.spring.JspringProject.vo.UserVo;

@Controller
@RequestMapping("/user2")
public class User2Controller {
	//User2(컨트롤러,다오,서비스)는 sql세션방식으로 작성
	@Autowired
	User2Service user2Service;
	
	// user 메인화면
	@RequestMapping("/userMain")
	public String userMainGet(Model model) {
		int userCnt = user2Service.getUserCount();
		model.addAttribute("userCnt", userCnt);
		return "user2/userMain";
	}
	
	// user 등록화면 폼보기
	@RequestMapping(value = "/userInput", method = RequestMethod.GET)
	public String userInputGet() {
		return "user2/userInput";
	}
	
	// user 등록 처리
	@RequestMapping(value = "/userInput", method = RequestMethod.POST)
	public String userInputPost(UserVo vo) {
		// 아이디 중복체크
		UserVo vo2 = user2Service.getUserIdSearch(vo.getMid());
		if(vo2 != null) return "redirect:/message/user2IdDuplication";
		
		// 회원 가입처리
		int res = user2Service.setUserInput(vo);
		if(res != 0) return "redirect:/message/user2InputOk";
		else return "redirect:/message/user2InputNo";
	}
	
	// user 개별검색 폼보기 
	@RequestMapping(value = "/userSearch", method = RequestMethod.GET)
	public String userSearchGet() {
		return "user2/userSearch";
	}
	
	// user 개별검색 처리하기
	@RequestMapping(value = "/userSearchPart", method = RequestMethod.GET)
	public String userSearchPartGet(Model model , UserVo vo) {
		UserVo vo2 = user2Service.getUserSearchPart(vo);
		if(vo2 == null) return "redirect:/message/user2SearchNo";
		model.addAttribute("vo", vo2);
		return "user2/userSearch";
	}
	
//	// user 전체 자료 보기 
//	@RequestMapping(value = "/userList", method = RequestMethod.GET)
//	public String userListGet(Model model) {
//		List<UserVo> vos = user2Service.getUserList();
//		
//		model.addAttribute("vos", vos);
//		return "user2/userList";
//	}
	
	
	//유저2 더미생성
    @RequestMapping("/insertDummy")
    public String insertDummyData() { 	
        for (int i = 1; i <= 30; i++) {
            UserVo vo = new UserVo();
            vo.setMid("아이디"+i);
            vo.setPwd("비밀번호"+i);
            vo.setName("이름"+i);
            vo.setAge(i);
            vo.setGender("성별");
            vo.setAddress("주소"+i);
            user2Service.setUserInput(vo);
        }
        return "redirect:/message/insertDummyDataok";
    }	
//	// user 전체 자료 보기 
	@RequestMapping("/userList")
	public String guestListGet(Model model,
		@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
		@RequestParam(name = "pageSize", defaultValue = "5", required = false) int pageSize
		) {
		int totRecCnt = user2Service.getTotRecCnt();
		int totPage = (totRecCnt % pageSize) == 0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize) +1;
		int startIndexNo = pageSize * (pag - 1);
		int curScrStartNo = totRecCnt - startIndexNo;
		//0-1 * 3+1이 이전페이지
		int blockSize = 5; // 한블록의 페이지개수
		int curBlock = (pag - 1) / blockSize; //첫번쨰 블록/ 첫번쨰 블록은 0으로 설정
		int lastBlock = (totPage - 1) / blockSize; //마지막 블록
		
		List<UserVo> vos = user2Service.getUserList(startIndexNo, pageSize);
		
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
		
		return "user2/userList";
	}
	
	
	// user 삭제 
	@RequestMapping(value = "/userDeleteOk", method = RequestMethod.GET)
	public String userDeleteOkGet(int idx) {
		int res = user2Service.setUserDeleteOk(idx);//딜리트,업데이트같이 기존에 있던 값을 바꾸는거니까 겟이 아닌 셋으로 설정
		
		if(res != 0) return "redirect:/message/user2DeleteOk";
		else return "redirect:/message/user2DeleteNo";
	}
	
	// user 수정 폼보기
	@RequestMapping(value = "/userUpdate", method = RequestMethod.GET)
	public String userUpdateGet(Model model, int idx) {
		UserVo vo = user2Service.getSearchIdx(idx);
		model.addAttribute("vo", vo);
		
		return "user2/userUpdate";
	}
	
	// user 수정 처리하기
	@RequestMapping(value = "/userUpdate", method = RequestMethod.POST)
	public String userUpdatePost(UserVo vo) {
		int res = user2Service.getUserUpdate(vo);
		
		if(res != 0) return "redirect:/message/user2UpdateOk";
		else return "redirect:/message/user2UpdateNo";
	}
	
	// 순서별 조회하기
	@RequestMapping(value = "/userOrderList/{order}", method = RequestMethod.GET)
	public String userOrderListGet(Model model, @PathVariable String order) {
		List<UserVo> vos = user2Service.getUserOrderList(order);
		model.addAttribute("vos", vos);
		model.addAttribute("order", order);
		return "user2/userList";
	}
}
