package com.spring.JspringProject.controller;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.JspringProject.common.Pagination;
import com.spring.JspringProject.common.ProjectProvide;
import com.spring.JspringProject.service.PdsService;
import com.spring.JspringProject.vo.PageVo;
import com.spring.JspringProject.vo.PdsVo;

@Controller
@RequestMapping("/pds")
public class PdsController {
	
	@Autowired
	PdsService pdsService;
	
	@Autowired
	Pagination pagination;
	
	@Autowired
	ProjectProvide projectProvide;
	
	//자료실 리스트 보기
	@RequestMapping(value = "/pdsList", method = RequestMethod.GET)
	public String pdsListGet(Model model,
			@RequestParam(name="part", defaultValue = "전체", required = false) String part,
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "5", required = false) int pageSize
			) {
		PageVo pageVo = pagination.getTotRecCnt(pag, pageSize, "pds", part, ""); // 자료실 검색필드에 따라 글개수 구하기
		System.out.println("pageVo.getPageSize()=>"+pageVo.getPageSize());
		List<PdsVo> vos = pdsService.getPdsList(pageVo.getStartIndexNo(), pageVo.getPageSize(), part, "", "");//글정보 가져오기
		
		model.addAttribute("pageVo", pageVo);
		model.addAttribute("vos", vos);
		
		return "pds/pdsList";
	}
	
	//자료실 입력폼보기
	@RequestMapping(value = "/pdsInput", method = RequestMethod.GET)
	public String pdsInputGet(Model model,
			@RequestParam(name="part", defaultValue = "전체", required = false) String part
			) {
		model.addAttribute("part", part);
		return "pds/pdsInput";
	}
	
	//자료실 입력처리
	@RequestMapping(value = "/pdsInput", method = RequestMethod.POST)
	public String pdsInputPost(MultipartHttpServletRequest mFile, PdsVo vo) {
		int res = pdsService.setPdsInput(mFile, vo);
				
		if(res != 0) return "redirect:/message/pdsInputOk";
		else return "redirect:/message/pdsInputNo";

	}
	
	//자료실 삭제처리
	@ResponseBody
	@RequestMapping(value = "/pdsDelete", method = RequestMethod.POST)
	public String pdsDeletePost(String files, String idx) {
		String res = "0";
		
		if (files != null && !files.isEmpty()) { // 파일들이 제대로 넘어왔는지 체크
		    String[] fileArray = files.split("/"); // 파일명을 "/" 기준으로 분리

		    for (String file : fileArray) {
		    	//원래는 이프문걸어서 중간에 삭제실패한게 있다면 브레이크로 포문중지시키려고 생각했습니다만 
		    	//선생님이랑 만든 deleteFile가 타입이 보이드라 그냥 이렇게만했습니다
		        projectProvide.deleteFile(file, "pds"); // 각 파일 삭제 //매개값 : 사진이름과 url경로
		        //System.out.println("삭제된 파일: " + file);
		    }
		    
		    res = pdsService.setpdsDelete(idx)+"";
		}
		
		return res;
	}
}
