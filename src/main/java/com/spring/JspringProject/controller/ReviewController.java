package com.spring.JspringProject.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.JspringProject.service.ReviewService;
import com.spring.JspringProject.vo.ReviewReplyVo;
import com.spring.JspringProject.vo.ReviewVo;

@Controller
@RequestMapping("/review")
public class ReviewController {

	@Autowired
	ReviewService reviewService;
	
	// 리뷰 등록하기
	@ResponseBody
	@PostMapping(value="/reviewInputOk", produces="application/text; charset=utf-8")
	public String reviewInputOkPost(ReviewVo vo) {
		System.out.println("reviewInputOk vo=>"+vo);
		int res = reviewService.setReviewInputOk(vo);
		if(res != 0) return "리뷰가 등록되었습니다";
		else return "리뷰 등록실패";
		
	}
	
	//리뷰 삭제하기(정확히는 삭제처리)
	@ResponseBody
	@RequestMapping(value = "/reviewDelete", produces="application/text; charset=utf-8", method = RequestMethod.POST)
	public String reviewDeletePost(int idx) {
		int res = reviewService.setReviewDelete(idx);
		
		if(res != 0) return "리뷰가 삭제되었습니다";
		else return "리뷰 삭제 실패~";
	}
	
	
	//댓글 등록하기
	@ResponseBody
	@RequestMapping(value = "/commentInputOk", produces="application/text; charset=utf-8", method = RequestMethod.POST)
	public String commentInputOkPost(ReviewReplyVo vo) {
		System.out.println("commentInputOkPost=>"+vo);
		int res = reviewService.setCommentInputOK(vo);
		
		if(res != 0) return "댓글이 등록되었습니다";
		else return "댓글 등록실패";
	}
	
	//댓글 삭제하기
	@ResponseBody
	@RequestMapping(value = "/commentDelete", produces="application/text; charset=utf-8", method = RequestMethod.POST)
	public String commentDeletePost(int replyIdx) {
		int res = reviewService.setCommentDelete(replyIdx);
		
		if(res != 0) return "댓글이 삭제되었습니다";
		else return "댓글 삭제 실패~";
	}
}
