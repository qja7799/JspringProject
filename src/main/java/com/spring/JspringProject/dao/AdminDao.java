package com.spring.JspringProject.dao;

import org.apache.ibatis.annotations.Param;

public interface AdminDao {

	int setMemberLevelChange(@Param("level") int level, @Param("idx") int idx);

}
