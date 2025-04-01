package com.spring.JspringProject.service;

import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.spring.JspringProject.dao.ScheduleDao;
import com.spring.JspringProject.vo.ScheduleVo;

@Service
public class ScheduleServiceImpl implements ScheduleService {
	
	@Autowired
	ScheduleDao scheduleDao;

	@Override
	public void getSchedule() {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		
		//오늘날짜(년/월/일)를 위한 변수 설정
		//캘린더는 싱글톤에 열거형상수라 클래스명(객체명)으로 불러야함
		Calendar calToday = Calendar.getInstance();
		int toYear = calToday.get(Calendar.YEAR); //오늘의 년
		int toMonth = calToday.get(Calendar.MONTH); //오늘의 월
		int toDay = calToday.get(Calendar.DATE);//오늘의 일
		
		//화면에 보여주는 달력(년/월) 이전년월,다음년월
		Calendar calView = Calendar.getInstance();
		//앞에서 넘어온값(년도와 월)이 없을경우 시스템의 년과 월을 출력)
		int yy = request.getParameter("yy")==null ? calView.get(Calendar.YEAR) : Integer.parseInt(request.getParameter("yy")); //시스템의 년
		int mm = request.getParameter("mm")==null ? calView.get(Calendar.MONTH) : Integer.parseInt(request.getParameter("mm")); //시스템의 월
		
		if(mm < 0) {
			mm = 11;
			yy--;
		}
		
		if(mm > 11) {
			mm = 0;
			yy++;
		}
		calView.set(yy, mm, 1);
		
		int startWeek = calView.get(Calendar.DAY_OF_WEEK);//해당하는 요일의 그주에서의 위치(1~7)
		int lastDay = calView.getActualMaximum(Calendar.DAY_OF_MONTH); // 해당일에 해당하는 월의 마지막 일을 구함
		
		
		//화면에 보여줄 달력의 이전,다음달의 년월기준(달력의 앞뒤 구하기)
		int prevYear = yy;
		int prevMonth = mm -1;
		int nextYear = yy;
		int nextMonth = mm + 1;
		
		if(prevMonth == -1) {
			prevMonth = 11;
			prevYear--;
		}
		if(nextMonth == 12) {
			nextMonth = 0;
			nextYear++;
		}
		
		//달력에서 이전달날짜 찍기위한 변수
		Calendar calPrev = Calendar.getInstance();
		calPrev.set(prevYear, prevMonth, 1);
		int prevLastDay = calPrev.getActualMaximum(Calendar.DAY_OF_MONTH);//이전달의 마지막일 위치
		
		//달력에서 다음달날짜 찍기위한 변수
		Calendar calNext = Calendar.getInstance();
		calNext.set(nextYear, nextMonth, 1);
		int nextStartWeek = calNext.get(Calendar.DAY_OF_WEEK);//다음달의 시작일 위치
		
		
		// 화면에 보여줄 달력에 필요한 변수 리퀘스트에 담아서 보내기
		request.setAttribute("toYear", toYear);
		request.setAttribute("toMonth", toMonth);
		request.setAttribute("toDay", toDay);
		
		request.setAttribute("yy", yy);
		request.setAttribute("mm", mm);
		request.setAttribute("startWeek", startWeek);
		request.setAttribute("lastDay", lastDay);
		
		request.setAttribute("prevYear", prevYear);
		request.setAttribute("prevMonth", prevMonth);
		request.setAttribute("nextYear", nextYear);
		request.setAttribute("nextMonth", nextMonth);
		
		request.setAttribute("nextStartWeek", nextStartWeek);
		request.setAttribute("prevLastDay", prevLastDay);
		
		
		//일은 일요일부터 시작(일월화수목금토) 일:1, 토:7
		//월은 0이 1월이라 가시성 생각해서 mm+1로 찍어봄
		//System.out.println("yy: " + yy + ", mm: " + (mm+1) + ", startWeek : " + startWeek + ", lastDay : " + lastDay);
		
		//등록된 일정을 보여주기 처리하기
		HttpSession session = request.getSession();
		String mid = session.getAttribute("sMid")+"";
		int level = (int) session.getAttribute("sLevel");
		
		String ym = "";
		int intMM = mm + 1;
		//날짜비교를 위해 1~9월을 9가 아니라 09로 바꿔서 비교해야함
		if(intMM >= 1 && intMM <= 9) ym= yy + "-0" + intMM;
		else ym= yy + "-" + intMM;
		
		List<ScheduleVo> vos = scheduleDao.getScheduleList(mid, ym, level);
		request.setAttribute("vos", vos);
		//System.out.println("vos=>"+vos);
	}

	@Override
	public List<ScheduleVo> getScheduleMenu(String mid, String ymd) {
		return scheduleDao.getScheduleMenu(mid, ymd);
	}

	@Override
	public int setScheduleInputOk(ScheduleVo vo) {
		return scheduleDao.setScheduleInputOk(vo);
	}

	@Override
	public int setScheduleUpdateOk(ScheduleVo vo) {
		return scheduleDao.setScheduleUpdateOk(vo);
	}

	@Override
	public int setScheduleDeleteOk(int idx) {
		return scheduleDao.setScheduleDeleteOk(idx);
	}
	
}
