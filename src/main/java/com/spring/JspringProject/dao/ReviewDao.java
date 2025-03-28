package com.spring.JspringProject.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.JspringProject.vo.ReviewReplyVo;
import com.spring.JspringProject.vo.ReviewVo;

public interface ReviewDao {

	int setReviewInputOk(@Param("vo") ReviewVo vo);

	List<ReviewVo> getPdsReview(@Param("part") String part, @Param("idx") int idx);

	double getPdsReviewAge(@Param("part") String part, @Param("idx") int idx);

	List<ReviewReplyVo> getPdsReviewReply(@Param("part") String part, @Param("rIdx") int rIdx);

	int setCommentInputOK(@Param("vo") ReviewReplyVo vo);

	int setReviewDelete(int idx);

	int setCommentDelete(int replyIdx);



}
