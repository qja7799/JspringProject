package com.spring.JspringProject.service;

import java.util.List;

import com.spring.JspringProject.vo.ReviewReplyVo;
import com.spring.JspringProject.vo.ReviewVo;

public interface ReviewService {

	int setReviewInputOk(ReviewVo vo);

	List<ReviewVo> getPdsReview(String part, int idx);

	double getPdsReviewAge(String part, int idx);

	List<ReviewReplyVo> getPdsReviewReply(String part, int rIdx);

	int setCommentInputOK(ReviewReplyVo vo);

	int setReviewDelete(int idx);

	int setCommentDelete(int replyIdx);

	

}
