package com.spring.JspringProject.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = {"/","/h"}, method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		String formattedDate = dateFormat.format(date);
		model.addAttribute("serverTime", formattedDate );
		return "main/home";
	}
	
	//ck에디터에서의 그림파일 업로드시 수행처리되는 메서드
	@RequestMapping(value = "/imageUpload")
	public void imageUploadGet(MultipartFile upload, HttpServletRequest request, HttpServletResponse response) throws IOException {
		//이미 필터에서 인코딩설정 해줘서 안해줘도되지만, ck에디터를 거치는거니 혹시몰라 그래도 한번더 해주는게좋다함
		response.setCharacterEncoding("utp-8"); 
		response.setContentType("text/html; charset=utf-8");
		
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/ckeditor/");
		String oFileName = upload.getOriginalFilename();
		
		//중복방지를 위한 파일명 만들기(오늘날짜 + 랜덤난수 + 기존파일명으로 하는게 베스트인데 지금은 간단하게 오늘날짜+기존파일명으로만함)
		//오늘날짜말고 id붙이는게 베스트인데 그림업로드를 비회원이 올릴경우도 대응하게 하려면 오늘날짜붙이는게 나음
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss");
		oFileName = sdf.format(date) + "_" + oFileName;
		
		byte[] bytes = upload.getBytes();
		
		//서버(db)에 저장하는게 아웃풋스트림 / (게시글작성에서)파일올려서 컨트롤러에 보내는게 인풋스트림
		//여기선 서버에 저장해야하니까 파일아웃풋스트림 사용
		FileOutputStream fos = new FileOutputStream(new File(realPath + oFileName));
		fos.write(bytes);
		
		//위에까지만하면 파일을 서버에 저장까지만 하게되고
		//ck에디터를 써서 파일을 올리려면 이제 저장시킨 파일을 읽어서 브라우저에 다시 보내주는단계가 필요함
		//그래야 ck에디터에 미리보기창에 사진을 넣어줄수있고 ck에디터에서 그 미리보기사진을 브라우저에 뿌려주는거임
		PrintWriter out = response.getWriter();
		//서버에 저장시키는 실제경로 => getRealPath("/resources/data/ckeditor/");
		//매핑경로 => 서블릿컨텍스트.xml에 매핑한 경로(축약경로)
		//여기선 실제경로가 아닌 매핑경로를 사용해야함
		//매핑경로의 맨앞 '/' 는 도메인경로로 적용되기에 (도메인경로=> localhost:8080) / 뭐지? 매핑경로의 맨앞의 /는 웹앱이 아니였나?
		//그걸 컨텍스트주소로 바꿔주기 위해 맨앞에 컨텍스트패스를 붙여줌
		String fileUrl = request.getContextPath() + "/data/ckeditor/" + oFileName;

		//제이슨이 맵과 같이 키와 밸류로 값을 주고받기에 제이슨방식으로 값을 넘겨줘야함
		//""안에 ''사용불가해서 ""를 써야하는데 그냥쓰면 에러나기에 \"로 써줘야함
		//originalFilename과 uploaded와 url는 예약어라 변경불가
		out.println("{\"originalFilename\":\""+oFileName+"\",\"uploaded\":1,\"url\":\""+fileUrl+"\"}");
		out.flush();
		
		fos.close();
		
	}
	
	@GetMapping("/fileDownAction")
	public void fileDownActionGet(HttpServletRequest request, HttpServletResponse response, 
			String path, String file) throws IOException {
		
		if(path.equals("pds")) path += "/temp/";
		
		String realPathFile = request.getSession().getServletContext().getRealPath("/resources/data/" + path) + file;
		
		//파일명이 한글일때 에러안나게 처리하기위해 인코딩처리
		File downFile = new File(realPathFile);
		
		String downFileName = new String(file.getBytes("UTF-8"), "8859_1");
		response.setHeader("Content-Disposition", "attachment;filename=" + downFileName); // Content-Disposition은 예약어 ,다른것도 예약어
		
		FileInputStream fis = new FileInputStream(downFile);
		ServletOutputStream sos = response.getOutputStream();
		//껍데기 만들기 끝
		
		
		byte[] bytes = new byte[2048];
		int data = 0;
		while((data = fis.read(bytes, 0, bytes.length)) != -1) {
			sos.write(bytes, 0, data);
		}
		
		sos.flush();
		sos.close();
		fis.close();
		
		//확장성을 생각해서 if문 걸어서 path(자료실에서 넘어온건지,게시판에서넘어온건지)에 따라 유동적으로 대응되게
		if(path.equals("pds/temp/")) {
			downFile.delete();
		}
	}
	
}
