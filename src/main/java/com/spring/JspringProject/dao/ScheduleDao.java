package com.spring.JspringProject.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.JspringProject.vo.ScheduleVo;

public interface ScheduleDao {

	List<ScheduleVo> getScheduleList(@Param("mid") String mid, @Param("ym") String ym, @Param("level") int level);

	List<ScheduleVo> getScheduleMenu(@Param("mid") String mid, @Param("ymd") String ymd);

	int setScheduleInputOk(@Param("vo") ScheduleVo vo);

	int setScheduleUpdateOk(@Param("vo") ScheduleVo vo);

	int setScheduleDeleteOk(int idx);

}
