package com.spring.JspringProject.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.JspringProject.vo.GuestVo;

public interface GuestDao {

	//
	//List<GuestVo> getGuestList(int startIndexNo, int pageSize);
	//이렇게 매개값이 1개가 아니라 2개이상일땐 @Param을 붙여줘야함
	List<GuestVo> getGuestList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	//int setGuestInput(GuestVo vo);
	//이렇게 매개값이 객체타입이여도 @Param으로 값을 매퍼에 전달해줘야하는데
	//여기서 중요!
	//객체타입이여도 매개값이 1개라서 굳이 @Param안붙여줘도 되는데 
	//매퍼에서 해당sql에서 파라미터타입을 지정안해줘서 @Param으로 매개값을 전달해주는 작업이 필요하게된거임
	//매퍼에 있는 해당sql에서 파라미터 타입을 매개값객체(GuestVo)로 지정해주면 @Param안붙여줘도 됨!
	int setGuestInput(@Param("vo") GuestVo vo);

	int setGuestDelete(int idx);

	int getTotRecCnt();

}
