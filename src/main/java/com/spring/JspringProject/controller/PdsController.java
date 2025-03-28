package com.spring.JspringProject.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.JspringProject.common.Pagination;
import com.spring.JspringProject.common.ProjectProvide;
import com.spring.JspringProject.service.PdsService;
import com.spring.JspringProject.service.ReviewService;
import com.spring.JspringProject.vo.BoardReplyVo;
import com.spring.JspringProject.vo.BoardVo;
import com.spring.JspringProject.vo.PageVo;
import com.spring.JspringProject.vo.PdsVo;
import com.spring.JspringProject.vo.ReviewReplyVo;
import com.spring.JspringProject.vo.ReviewVo;

@Controller
@RequestMapping("/pds")
public class PdsController {
	
	@Autowired
	PdsService pdsService;
	
	@Autowired
	Pagination pagination;
	
	@Autowired
	ProjectProvide projectProvide;
	
	@Autowired
	ReviewService reviewService;
	
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
	
	
	//파일 다운로드 수 증가처리
	@ResponseBody
	@RequestMapping(value = "/pdsDownNumCheck", method = RequestMethod.POST)
	public String pdsDownNumCheckPost(int idx) {
		return pdsService.setPdsDownNumPlus(idx) + "";
	}
	
	//자료실 상세보기
	@RequestMapping(value = "/pdsContent", method = RequestMethod.GET)
	public String pdsContentGet(Model model, int idx, 
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "5", required = false) int pageSize,
			@RequestParam(name="part", defaultValue = "전체", required = false) String part
			) {
		
		PdsVo vo = pdsService.getPdsContent(idx);
		
		model.addAttribute("vo", vo);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("part", part);
		
		//리뷰 가져오기
		List<ReviewVo> rVos = reviewService.getPdsReview("pds", idx);
		model.addAttribute("rVos", rVos);
		
		// 리뷰 평점 구하기 / 게시글에 리뷰가 있다면 평점구한거 모델에 담아보내고 아니면 0을 보내게함
		if(rVos == null || rVos.isEmpty()) {
			model.addAttribute("reviewAvg", "0");
		}else {
			double reviewAvg = reviewService.getPdsReviewAge("pds", idx);
			model.addAttribute("reviewAvg", reviewAvg);
		}

		List<List<ReviewReplyVo>> allReplyVos = new ArrayList<>();//댓글 리스트를 저장할 리스트
		//List<ReviewReplyVo> replyVos = new ArrayList<>();//각 리뷰의 댓글들을 저장할 리스트
		ReviewReplyVo replyVo = new ReviewReplyVo();
		
		//각 리뷰에 달린 댓글들 가져오기
	    for (ReviewVo replyVofor : rVos) {
	    	List<ReviewReplyVo> replyVos = reviewService.getPdsReviewReply(replyVofor.getPart(), replyVofor.getIdx()); 
	    	
	        if (!replyVos.isEmpty()) {  // 댓글이 존재하는 경우만 추가
	        	allReplyVos.add(replyVos);
	        }
	    }
	    model.addAttribute("allReplyVos", allReplyVos);
	    System.out.println("allReplyVos=>"+allReplyVos);
	    
		
		return "pds/pdsContent";
	}
	
	
	

	
	
	
	
	
	
	
//	//자료실상세보기에서 자료전체 다운로드하기
	
//	@GetMapping("/pdsTotalDown")
//	public String pdsTotalDownGet(HttpServletRequest request, int idx) {
//		//다운로드 수 증가처리
//		pdsService.setPdsDownNumPlus(idx);
//		
//		//마이페이지에서 다운로드 기록게시판도 만들어야하나? 고민이네
//		//여러개의 파일을 하나의 통합파일(zip)으로 다운로드 처리, 파일명은 '제목.zip'
//		pdsService.pdsTotalDown(request, idx);
//		
//		
//		return "";
//	}
	
	
	@GetMapping("/pdsTotalDown")
	public String pdsTotalDownGet(HttpServletRequest request, int idx) {
		// 다운로드수 증가처리
		pdsService.setPdsDownNumPlus(idx);
		
		// 여러개의 파일을 하나의 통합파일(zip)로 다운로드 처리, 파일명은 '제목.zip'
		String zipName = pdsService.pdsTotalDown(request, idx);
		
		//가로줄 나오는거 옛날코드라 그런거고 문제없음
		return "redirect:/fileDownAction?path=pds&file="+java.net.URLEncoder.encode(zipName);
		
	}
	
	
	
	
	
	
	
	
	
	//컨트롤러버전
//	@GetMapping("/pdsTotalDown")
//	public String pdsTotalDownGet(HttpServletRequest request, int idx) throws IOException {
//		// 다운로드수 증가처리
//		pdsService.setPdsDownNumPlus(idx);
//		
//		// 여러개의 파일을 하나의 통합파일(zip)로 다운로드 처리, 파일명은 '제목.zip'
//		pdsService.pdsTotalDown(request, idx);
//		/*
//		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/pds/");
//		
//		PdsVo vo = pdsService.getPdsContent(idx);
//		
//		String[] fNames = vo.getFName().split("/");
//		String[] fSNames = vo.getFSName().split("/");
//		
//		String zipPath = realPath + "temp/";
//		String zipName = vo.getTitle() + ".zip";
//		
//		FileInputStream fis = null;
//		FileOutputStream fos = null;
//		ZipOutputStream zout = null;
//		
//		zout = new ZipOutputStream(new FileOutputStream(zipPath + zipName));
//		
//		byte[] bytes = new byte[2048];
//		
//		for(int i=0; i<fNames.length; i++) {
//			fis = new FileInputStream(realPath + fSNames[i]);
//			fos = new FileOutputStream(zipPath + fNames[i]);
//			File copyFile = new File(zipPath + fNames[i]);
//			
//			int data = 0;
//			while((data = fis.read(bytes, 0, bytes.length)) != -1) {
//				fos.write(bytes, 0, data);
//			}
//			fos.flush();
//			fos.close();
//			fis.close();
//			
//			fis = new FileInputStream(copyFile);
//			zout.putNextEntry(new ZipEntry(fNames[i]));
//			while((data = fis.read(bytes, 0, bytes.length)) != -1) {
//				zout.write(bytes, 0, data);
//			}
//			zout.flush();
//			zout.closeEntry();
//			fis.close();
//				
//		}
//		zout.close();
//		*/
//		return "";
//	}
//	
	


	

	
}
