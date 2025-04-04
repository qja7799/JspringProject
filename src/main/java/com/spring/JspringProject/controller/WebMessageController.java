package com.spring.JspringProject.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.JspringProject.common.Pagination;
import com.spring.JspringProject.service.MemberService;
import com.spring.JspringProject.service.WebMessageService;
import com.spring.JspringProject.vo.MemberVo;
import com.spring.JspringProject.vo.PageVo;
import com.spring.JspringProject.vo.WebMessageVo;

@Controller
@RequestMapping("/webMessage")
public class WebMessageController {

	@Autowired
	WebMessageService webMessageService;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	Pagination pagination;
	
	//웹메세지 뷰
	@RequestMapping(value = "/webMessage", method = RequestMethod.GET)
	public String webMessageGet(Model model, HttpSession session,
			@RequestParam(name="mSw", defaultValue = "1", required = false) int mSw,
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize,
			@RequestParam(name="idx", defaultValue = "0", required = false) int idx
			) {
		String mid = session.getAttribute("sMid")+"";
		
		if(mSw == 0) {} // 메세지 작성
		else if(mSw == 6) {// 메세지 내용보기(메세지컨텐트)
			WebMessageVo vo = webMessageService.getWebmessageContent(idx, mid);
			if(vo.getReceiveSw().equals("n")) webMessageService.setWebMessageSwUpdate(idx);
			model.addAttribute("vo", vo);
		}
		else if(mSw == 9) {// 휴지통 비우기(sendSw와 receiveSw 둘다 'x'라면 완전삭제시킴)
			List<WebMessageVo> vos = webMessageService.getWebmessageList(mid, 5, 0, pageSize);//내 휴지통리스트가져오기
			int res = 0;
			if(vos.size() != 0) {
				for(WebMessageVo wVo : vos) {
					//스위치값이 g(휴지통)인것만 삭제처리(x로변경)
					res = webMessageService.setWebDeleteAll(mid, wVo.getSendId(), wVo.getReceiveId());
					webMessageService.setWebDeleteAllProcess();//(sendSw와 receiveSw 둘다 'x'라면 완전삭제시킴)/ 타입보이드에다 매퍼에 조건문잘줘서 실행실패해도 에러안날듯
				}
				if(res != 0) {
					return "redirect:/message/webMessageResetOk";
				}else {
					return "redirect:/message/webMessageResetNo";
				}
			}
			else return "redirect:/message/webMessageEmpty";
		}
		else {//mSw=1~5까지 처리 
			PageVo pageVo = pagination.getTotRecCnt(pag, pageSize, "webMessage", mid, mSw+"");
			//List<WebMessageVo> vos = webMessageService.getWebmessageList(mid, mSw, pageVo.getStartIndexNo(), pageSize);
			List<WebMessageVo> vos = webMessageService.getWebmessageList(mid, mSw, 0, pageSize);
			model.addAttribute("vos", vos);
			model.addAttribute("pageVo", pageVo);
			
			System.out.println("vos=>" + vos);
		}
		
		model.addAttribute("mSw", mSw);
		
		return "webMessage/webMessage";
	}
	
	//주소록보이게하기
	@ResponseBody
	@RequestMapping(value="/webMessageJusoList", method = RequestMethod.POST)
	public List<MemberVo> webMessageJusoListPost() {
		List<MemberVo> vos = memberService.getMemberList(0, 999, 99);
		System.out.println("webMessageJusoListvos=>"+vos);
		return vos;
		
	}
	//웹메세지 전송
	@RequestMapping(value = "/wmInputOk", method = RequestMethod.POST)
	public String wmInputOkPost(WebMessageVo vo) {
		MemberVo mVo = memberService.getMemberIdCheck(vo.getReceiveId());
		if(mVo == null) return "redirect:/message/wmMemberIdNo";
		if(webMessageService.setWmInputOk(vo) != 0) return "redirect:/message/wmInputOk";
		else return "redirect:/message/wmInputNo";
	}
	
	//웹메세지 삭제처리
	@RequestMapping(value = "/webDeleteCheck", method = RequestMethod.GET)
	public String webDeleteCheckGet(int idx, int mSw, int mFlag) {
		System.out.println("idx=>"+idx);
		System.out.println("mSw=>"+mSw);
		System.out.println("mFlag=>"+mFlag);
		//<!-- 1:받은메세지, 2:새메세지, 3:보낸메세지, 4:수신확인, 5:휴지통 -->
		if(webMessageService.setWebDeleteCheck(idx, mFlag) != 0) return "redirect:/message/webMessageDeleteOk";
		else return "redirect:/message/webMessageDeleteNo";
	}
	
	//휴지통에서 메세지 복구하기
	@RequestMapping(value = "/webMessageRecover", method = RequestMethod.GET)
	public String webMessageRecoverGet(int idx, String sendId, HttpSession session) {
		String mid = session.getAttribute("sMid")+"";
		System.out.println("idx=>"+idx);
		System.out.println("sendId=>"+sendId);
		//<!-- 1:받은메세지, 2:새메세지, 3:보낸메세지, 4:수신확인, 5:휴지통 6:내용보기-->
		if(webMessageService.setWebMessageRecover(idx, mid, sendId) != 0) return "redirect:/message/webMessageRecoverOk";
		else return "redirect:/message/webMessageRecoverNo";
	}
	
}
