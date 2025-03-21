package com.spring.JspringProject.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public interface StudyService {

	String[] getCityStringArray(String dodo);

	List<String> getCityVosArray(String dodo);

	int fileUpload(MultipartFile fName, String mid);

}
