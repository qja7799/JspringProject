package com.spring.JspringProject.common;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ProjectProvide {

	//파일 저장하는 메소드 (업로드된파일명, 저장될파일명, 저장경로)
	public void writeFile(MultipartFile fName, String sFileName, String urlPath) throws IOException {
		//리퀘스트홀더에서 리퀘스트 객체 받아오기
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+urlPath+"/");
		
		FileOutputStream fos = new FileOutputStream(realPath + sFileName);
		
		//바이트단위로 저장,불러오는 방식을 사용함(4층강사의 방식) 5층강사는 다른방식을 썻음 맞나? 함 알아보자
		if (fName.getBytes().length != -1) {
			fos.write(fName.getBytes());
		}
		fos.flush();
		fos.close();
		
	}
	
	//파일삭제하는 메서드
	public void deleteFile(String photo, String urlPath) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+urlPath+"/");
		
		File file = new File(realPath + photo);
		//file => realPath + photo 를 담은 경로고
		//file.exists()는 경로에 파일이 존재하는지 검사
		//파일이 있다면 true반환되어서 file.delete()로 지운다
		if(file.exists()) file.delete();
	}

	
	
	
	
}
