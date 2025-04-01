package com.spring.JspringProject.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface StudyService {

	String[] getCityStringArray(String dodo);

	List<String> getCityVosArray(String dodo);

	int fileUpload(MultipartFile fName, String mid);

	int multiFileUpload(MultipartHttpServletRequest mFile);

	void getCalendar();

}
