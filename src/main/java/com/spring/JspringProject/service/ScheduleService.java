package com.spring.JspringProject.service;

import java.util.List;

import com.spring.JspringProject.vo.ScheduleVo;

public interface ScheduleService {

	void getSchedule();

	List<ScheduleVo> getScheduleMenu(String mid, String ymd);

	int setScheduleInputOk(ScheduleVo vo);

	int setScheduleUpdateOk(ScheduleVo vo);

	int setScheduleDeleteOk(int idx);

}
