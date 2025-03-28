package com.spring.JspringProject.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.JspringProject.dao.ReviewDao;
import com.spring.JspringProject.vo.ReviewReplyVo;
import com.spring.JspringProject.vo.ReviewVo;

@Service
public class ReviewServiceImple implements ReviewService {

	@Autowired
	ReviewDao reviewDao;

	@Override
	public int setReviewInputOk(ReviewVo vo) {
		return reviewDao.setReviewInputOk(vo);
	}

	@Override
	public List<ReviewVo> getPdsReview(String part, int idx) {
		return reviewDao.getPdsReview(part, idx);
	}

	@Override
	public double getPdsReviewAge(String part, int idx) {
		// TODO Auto-generated method stub
		return reviewDao.getPdsReviewAge(part, idx);
	}

	@Override
	public List<ReviewReplyVo> getPdsReviewReply(String part, int rIdx) {
		// TODO Auto-generated method stub
		return reviewDao.getPdsReviewReply(part, rIdx);
	}

	@Override
	public int setCommentInputOK(ReviewReplyVo vo) {
		return reviewDao.setCommentInputOK(vo);
	}

	@Override
	public int setReviewDelete(int idx) {
		return reviewDao.setReviewDelete(idx);
	}

	@Override
	public int setCommentDelete(int replyIdx) {
		return reviewDao.setCommentDelete(replyIdx) ;
	}


	
	
}
