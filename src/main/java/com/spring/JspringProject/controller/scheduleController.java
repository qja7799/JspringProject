package com.spring.JspringProject.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.JspringProject.service.ScheduleService;
import com.spring.JspringProject.vo.ScheduleVo;

@Controller
@RequestMapping("/schedule")
public class scheduleController {

	@Autowired
	ScheduleService scheduleService;
	
	//스케줄 입/출력을 위한 달력
	@GetMapping("/schedule")
	public String scheduleGet() {
		scheduleService.getSchedule();
		return "schedule/schedule";
	}
	
	//선택된 일자의 일정을 확인/등록 처리
	@GetMapping("/scheduleMenu")
	public String scheduleMenuGet(Model model, String ymd, HttpSession session) {
		String mid = session.getAttribute("sMid") + "";
		
		//날짜비교 위해 0추가 작업해주기
		//db에 저장될땐 5월 5일이 05월 05일로 자동변환되서 저장되지만
		//뷰에서 값을 가져올땐 그렇지 않기에 5월 5일과 05월 05일을 비교하면 같지않기에 0추가를 해줘야함
		String mm = "", dd = "";
		String[] ymdArr = ymd.split("-");
		if(ymd.length() != 10) {//2025-03-30(길이10) 이런형식이 아닐경우 길이를 비교해서 그에맞게 0추가해주는 코드 
			if(ymdArr[1].length() == 1) mm = "0" + ymdArr[1];
			else mm = ymdArr[1];
			
			if(ymdArr[2].length() == 1) dd = "0" + ymdArr[2];
			else dd = ymdArr[2];
			
			ymd = ymdArr[0] + "-" + mm + "-" + dd;
		}
		
		List<ScheduleVo> vos = scheduleService.getScheduleMenu(mid, ymd);	
		model.addAttribute("vos", vos);
		model.addAttribute("ymd", ymd);
		model.addAttribute("scheduleCnt", vos.size());
		
		return "schedule/scheduleMenu";
	}
	
	//스케줄 입력 처리하기(등록) 
	@ResponseBody
	@PostMapping("/scheduleInputOk")
	public String scheduleInputOkPost(ScheduleVo vo) {
		return scheduleService.setScheduleInputOk(vo)+"";
	}
	
	//스케줄 수정 처리하기(수정) 
	@ResponseBody
	@PostMapping("/scheduleUpdateOk")
	public String scheduleUpdateOkPost(ScheduleVo vo) {
		return scheduleService.setScheduleUpdateOk(vo)+"";
	}
	
	// 스케줄 삭제 처리하기
	@ResponseBody
	@PostMapping("/scheduleDeleteOk")
	public String scheduleDeleteOkPost(int idx) {
		return scheduleService.setScheduleDeleteOk(idx) + "";
	}
}
