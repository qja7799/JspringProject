package com.spring.JspringProject.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.JspringProject.service.AdminService;
import com.spring.JspringProject.service.MemberService;
import com.spring.JspringProject.vo.ComplaintVo;
import com.spring.JspringProject.vo.MemberVo;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	AdminService adminService;
	
	@Autowired
	MemberService memberService;
	
	@GetMapping("/adminMain")
	public String adminMainGet() {
		return "admin/adminMain";
	}
	
	@GetMapping("/adminLeft")
	public String adminLeftGet() {
		return "admin/adminLeft";
	}
	
	@GetMapping("/adminContent")
	public String adminContentGet() {
		return "admin/adminContent";
	}
	
	@GetMapping("/member/memberList")
	public String memberListGet(Model model, HttpSession session,
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize,
			@RequestParam(name="level", defaultValue = "99", required = false) int level
		) {
		int totRecCnt = adminService.getMemberTotRecCnt(level);
		int totPage = (totRecCnt % pageSize) == 0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStartNo = totRecCnt - startIndexNo;
		
		int blockSize = 3;
		int curBlock = (pag - 1) / blockSize;
		int lastBlock = (totPage - 1) / blockSize;
		List<MemberVo> vos = memberService.getMemberList(startIndexNo, pageSize, level);
		
		model.addAttribute("vos", vos);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("totPage", totPage);
		model.addAttribute("curScrStartNo", curScrStartNo);
		model.addAttribute("blockSize", blockSize);
		model.addAttribute("curBlock", curBlock);
		model.addAttribute("lastBlock", lastBlock);
		model.addAttribute("level", level);
		
		return "admin/member/memberList";
	}
	
	// 선택된 회원 레벨 등급 변경처리
	@ResponseBody
	@RequestMapping(value = "/memberLevelChange", method = RequestMethod.POST)
	public String memberLevelChangePost(int level, int idx) {
		//int res = adminService.setMemberLevelChange(level, idx);
		//return res + "";
		
		//위처럼 쓸수있지만 밑처럼 쓰면 효율적임(하지만 가독성 별로)
		return adminService.setMemberLevelChange(level, idx) + "";//반환값이 인트이기에 빈문자열 더해서 문자타입으로 변경
	}
	
	// 선택한 회원 전체적으로 등급 변경하기
	@ResponseBody
	@RequestMapping(value = "/member/memberLevelSelectCheck", method = RequestMethod.POST)
	public String memberLevelSelectCheckPost(String idxSelectArray, int levelSelect) {
		String[] idxSelectArrays = idxSelectArray.split("/");
		
		String str = "0";
		for(String idx : idxSelectArrays) {
			//setMemberLevelChange써도 되지만 그건 반환값이 있기때문에 반환값없는 setMemberLevelCheck를 새로 만들어줌
			adminService.setMemberLevelCheck(Integer.parseInt(idx), levelSelect);
			str = "1";
		}
		return str;
	}
	
	// 개별회원정보 상세보기
	@RequestMapping(value = "/memberInfor/{idx}", method = RequestMethod.GET)
	public String memberInforGet(Model model, @PathVariable int idx) {
		MemberVo vo = memberService.getMemberIdxSearch(idx);
		model.addAttribute("vo", vo);
		
		return "admin/member/memberInfor";
	}
	
//	// 신고 리스트 출력
//	@RequestMapping(value = "/complaint/complaintList", method = RequestMethod.GET)
//	public String complaintListGet(Model model) {
//		List<ComplaintVo> vos = adminService.getComplaintList();
//		model.addAttribute("vos", vos);
//		
//		return "admin/complaint/complaintList";
//	}

	// 신고 리스트 출력
	@RequestMapping(value = "/complaint/complaintList", method = RequestMethod.GET)
	public String memberInforGet(Model model) {
		List<ComplaintVo> vos = adminService.getComplaintList();
		model.addAttribute("vos", vos);
		
		return "admin/complaint/complaintList";
	}
	
	// 신고글 감추기/보이기
	@ResponseBody
	@RequestMapping(value = "/complaint/contentChange", method = RequestMethod.POST)
	public String contentChangePost(int contentIdx, String contentSw) {
		return adminService.setContentChange(contentIdx, contentSw) + "";
	}
}
