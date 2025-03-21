package com.spring.JspringProject.service;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.spring.JspringProject.dao.StudyDao;

@Service
public class StudyServiceImpl implements StudyService {

	@Autowired
	private StudyDao studyDao;

	@Override
	public String[] getCityStringArray(String dodo) {
		String[] strArray = new String[100];
		//시간이 없어 디비에 연결안하고 할예정
		//디비에 연결안하니 다오랑 연결할필요없고 여기서 바로 리턴값 넘겨줄거니 여기서 바로 결과값 넘김처리 
		if(dodo.equals("서울")) {
			strArray[0] = "강남구";
			strArray[1] = "강북구";
			strArray[2] = "강서구";
			strArray[3] = "강동구";
			strArray[4] = "서초구";
			strArray[5] = "영등포구";
			strArray[6] = "종로구";
			strArray[7] = "관악구";
			strArray[8] = "마포구";
			strArray[9] = "동대문구";
		}
		else if(dodo.equals("경기")) {
			strArray[0] = "안성시";
			strArray[1] = "평택시";
			strArray[2] = "오산시";
			strArray[3] = "수원시";
			strArray[4] = "용인시";
			strArray[5] = "고양시";
			strArray[6] = "일산시";
			strArray[7] = "의정부시";
			strArray[8] = "이천시";
			strArray[9] = "안양시";
		}
		else if(dodo.equals("충북")) {
			strArray[0] = "청주시";
			strArray[1] = "충주시";
			strArray[2] = "제천시";
			strArray[3] = "단양군";
			strArray[4] = "진천군";
			strArray[5] = "음성군";
			strArray[6] = "영동군";
			strArray[7] = "옥천군";
			strArray[8] = "괴산군";
			strArray[9] = "증평군";
		}
		else if(dodo.equals("충남")) {
			strArray[0] = "천안시";
			strArray[1] = "아산시";
			strArray[2] = "당진군";
			strArray[3] = "공주시";
			strArray[4] = "보령시";
			strArray[5] = "서산군";
			strArray[6] = "논산군";
			strArray[7] = "부여시";
			strArray[8] = "홍성군";
			strArray[9] = "계룡시";
		}
		
		return strArray;
	}

	@Override
	public List<String> getCityVosArray(String dodo) {
		List<String> vos = new ArrayList<String>();
		
		if(dodo.equals("서울")) {
			vos.add("강남구");
			vos.add("강북구");
			vos.add("강서구");
			vos.add("강동구");
			vos.add("서초구");
			vos.add("종로구");
			vos.add("관악구");
			vos.add("마포구");
			vos.add("영등포구");
			vos.add("동대문구");
		}
		else if(dodo.equals("경기")) {
			vos.add("안성시");
			vos.add("평택시");
			vos.add("오산시");
			vos.add("수원시");
			vos.add("용인시");
			vos.add("고양시");
			vos.add("일산시");
			vos.add("이천시");
			vos.add("안양시");
			vos.add("의정부시");
		}
		else if(dodo.equals("충북")) {
			vos.add("청주시");
			vos.add("충주시");
			vos.add("제천시");
			vos.add("단양군");
			vos.add("진천군");
			vos.add("음성군");
			vos.add("영동군");
			vos.add("옥천군");
			vos.add("괴산군");
			vos.add("증평군");
		}
		else if(dodo.equals("충남")) {
			vos.add("천안시");
			vos.add("아산시");
			vos.add("당진군");
			vos.add("공주시");
			vos.add("보령시");
			vos.add("서산군");
			vos.add("논산군");
			vos.add("부여시");
			vos.add("홍성군");
			vos.add("계룡시");
		}
		
		return vos;
	}
	
	//파일업로드
	//db처리안하기에 여기서 바로 처리시킴
	@Override
	public int fileUpload(MultipartFile fName, String mid) {
		int res = 0;
		
		//파일이름 중복처리(UUID)후 서버에 저장처리
		UUID uid = UUID.randomUUID();
		String Original_FileName = fName.getOriginalFilename(); // 업로드한 파일명
		String sFileName = mid + uid.toString().substring(0,8) + "_" + Original_FileName;// 업로드한 파일명이 중복되지않게처리
		
		try {
			writeFile(fName, sFileName);
			res = 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return res;
	}

	//io,스레드,서버,네트워크와 관계된건 다 무조건 예외처리 해줘야함
	private void writeFile(MultipartFile fName, String sFileName) throws IOException {
		//request.getSession().getServletContext().getRealPath("/resources/data/fileUpload")
		//리얼패스를 가져오기위해 위처럼 리퀘스트객체를 받아와야하는데 
		//그러려면 컨트롤러에서부터 매개값으로 리퀘스트객체를 받아와야함
		//그러는게 귀찮거나, 매개값으로 받아오기 싫을때 밑의 방법으로 리퀘스트객체를 받아오는 방법이있음 (복잡해서 잘 안쓰이지만 알아두면 좋음, 이렇게 쓸수도 있다라는정도로 알아두면됨)
		
		//리퀘스트홀더에서 리퀘스트 객체 받아오기
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/fileUpload/");
		
		FileOutputStream fos = new FileOutputStream(realPath + sFileName);
		
		//바이트단위로 저장,불러오기 해줘야함
		if (fName.getBytes().length != -1) {
			fos.write(fName.getBytes());
		}
		fos.flush();
		fos.close();
		
		
	}

	
	
	
	
}
