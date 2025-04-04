package com.spring.JspringProject.service;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.JspringProject.common.ProjectProvide;
import com.spring.JspringProject.dao.StudyDao;
import com.spring.JspringProject.vo.ChartVo;

@Service
public class StudyServiceImpl implements StudyService {

	//db에 연결안할거라 dao에 연결안할거니 접근제한자 private로 설정
	//굳이 private로 설정안해줘도 되지만 어차피 dao안쓸거라 dao에서 StudyServiceImpl로
	//접근할일이 없으니 굳이 다른곳에서의 접근을 허용해줄 필요가없음, 캡슐화(보안)를 유지하기위해 private로 설정하는게남
	@Autowired
	private StudyDao studyDao;

	@Autowired
	private ProjectProvide projectProvide;
	
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
		String sFileName = mid + "_" + uid.toString().substring(0,8) + "_" + Original_FileName;// 업로드한 파일명이 중복되지않게처리
		
		try {
			writeFile(fName, sFileName);
			res = 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return res;
	}

	//전송된 파일을 서버로 저장처리
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
	
	@Override
	public int multiFileUpload(MultipartHttpServletRequest mFile) { // 다중 파일 업로드를 처리하는 메서드
	    int res = 0; // 기본적으로 업로드 실패(0)로 설정
	    
	    try {
	        List<MultipartFile> fileList = mFile.getFiles("fName"); // 업로드된 파일 리스트를 가져옴
	        //mFile.getFiles("fName")을 호출하면, "fName"이라는 name 속성을 가진 파일들을 List<MultipartFile> 형태로 가져옴, 
	        //List<MultipartFile> fileList  <= 이게 없어도 mFile.getFiles("fName") 이것만으로 List<MultipartFile> 형태로 가져온다는뜻
	        //fName"은 클라이언트(HTML 폼)에서 업로드된 파일 input의 name 속성 값을 의미합니다
	        //jsp에서 <input type="file" name="fName">로 사용자가 파일을 업로드하면, 파일 데이터가 "fName"이라는 키 값으로 서버로 전송됩니다
	        //"fName"은 HTML의 <input type="file" name="fName">과 연결되는 값이며, 이를 통해 서버에서 해당 파일 데이터를 가져올 수 있습니다.
	        //지금 강사는 sql테이블에서 파일이름을 담을 열이름을 똑같이 fName으로 줬는데 키값 fName과 겹칠경우 에러가 생길수있기때문에 둘이 겹치는 이름을 사용하면안됨!!
	        String oFileNames = ""; // 원본 파일명을 저장할 문자열 변수
	        String sFileNames = ""; // 서버에 저장될 파일명을 저장할 문자열 변수
	        int fileSizes = 0; // 총 파일 크기를 저장할 변수
	        
	        for (MultipartFile file : fileList) { // 업로드된 파일 리스트를 반복하면서 각각 처리
	            String oFileName = file.getOriginalFilename(); // 클라이언트가 업로드한 원본 파일명 가져오기
	            String sFileName = projectProvide.saveFileName(oFileName); // 서버에 저장될 파일명 생성 (중복 방지 목적)
	            projectProvide.writeFile(file, sFileName, "fileUpload"); // (업로드된 파일, 저장될 파일명, 저장 경로) → 파일을 서버에 저장

	            oFileNames += oFileName + "/"; // 원본 파일명을 '/'로 구분하여 저장
	            sFileNames += sFileName + "/"; // 저장된 파일명을 '/'로 구분하여 저장
	            fileSizes += file.getSize(); // 파일 크기를 누적하여 총 크기 계산
	        }
	        
	        //마지막 /를 제거하는 것은 문자열 데이터의 정합성을 유지하고, 이후의 처리(파싱, 저장 등)를 쉽게 하기 위해서임 / 안해줘도 당장에 문제는없지만 길게본다면 해주는게좋음
	        oFileNames = oFileNames.substring(0, oFileNames.length() - 1); // 마지막 '/' 제거
	        sFileNames = sFileNames.substring(0, sFileNames.length() - 1); // 마지막 '/' 제거
	        
	        System.out.println("원본파일 : " + oFileNames); // 업로드된 파일들의 원본 파일명 출력
	        System.out.println("서버에저장되는파일 : " + sFileNames); // 서버에 저장된 파일명 출력
	        System.out.println("총사이즈 : " + fileSizes); // 총 파일 크기 출력
	        
	        res = 1; // 파일 업로드가 성공적으로 완료되면 1로 설정
	    } catch (IOException e) { // 파일 저장 과정에서 입출력 예외 발생 가능성 처리
	        e.printStackTrace(); // 예외 발생 시 콘솔에 오류 메시지 출력
	    }
	    
	    return res; // 파일 업로드 성공 여부 반환 (1 = 성공, 0 = 실패)
	}

	//달력 만들기
	@Override
	public void getCalendar() {
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
	}

	@Override
	public List<ChartVo> getRecentlyVisitCount(int visitCount) {
		// TODO Auto-generated method stub
		return studyDao.getRecentlyVisitCount(visitCount);
	}
}
