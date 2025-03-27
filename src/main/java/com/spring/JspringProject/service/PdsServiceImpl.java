package com.spring.JspringProject.service;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.JspringProject.common.ProjectProvide;
import com.spring.JspringProject.dao.PdsDao;
import com.spring.JspringProject.vo.PdsVo;

@Service
public class PdsServiceImpl implements PdsService {
	
	@Autowired
	PdsDao pdsDao;
	
	@Autowired
	ProjectProvide projectProvide;

	@Override
	public List<PdsVo> getPdsList(int startIndexNo, int pageSize, String part, String search, String searchString) {
		return pdsDao.getPdsList(startIndexNo, pageSize, part, search, searchString);
	}

	@Override
	public int setPdsInput(MultipartHttpServletRequest mFile, PdsVo vo) {
		//파일 업로드 처리
		 try {
		        List<MultipartFile> fileList = mFile.getFiles("file"); // 업로드된 파일 리스트를 가져옴
		        //mFile.getFiles("file")을 호출하면, "file"이라는 name 속성을 가진 파일들을 List<MultipartFile> 형태로 가져옴, 
		        //List<MultipartFile> fileList  <= 이게 없어도 mFile.getFiles("file") 이것만으로 List<MultipartFile> 형태로 가져온다는뜻
		        //file"은 클라이언트(HTML 폼)에서 업로드된 파일 input의 name 속성 값을 의미합니다
		        //jsp에서 <input type="file" name="file">로 사용자가 파일을 업로드하면, 파일 데이터가 "file"이라는 키 값으로 서버로 전송됩니다
		        //"file"은 HTML의 <input type="file" name="file">과 연결되는 값이며, 이를 통해 서버에서 해당 파일 데이터를 가져올 수 있습니다.
		        //스터디서비스임플 참고
		        String oFileNames = ""; // 원본 파일명을 저장할 문자열 변수
		        String sFileNames = ""; // 서버에 저장될 파일명을 저장할 문자열 변수
		        int fileSizes = 0; // 총 파일 크기를 저장할 변수
		        
		        for (MultipartFile file : fileList) { // 업로드된 파일 리스트를 반복하면서 각각 처리
		            String oFileName = file.getOriginalFilename(); // 클라이언트가 업로드한 원본 파일명 가져오기
		            String sFileName = projectProvide.saveFileName(oFileName); // 서버에 저장될 파일명 생성 (중복 방지 목적)
		            projectProvide.writeFile(file, sFileName, "pds"); // (업로드된 파일, 저장될 파일명, 저장 경로) → 파일을 서버에 저장

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
		        
		        vo.setFName(oFileNames);
		        vo.setFSName(sFileNames);
		        vo.setFSize(fileSizes);
		        
		    } catch (IOException e) { // 파일 저장 과정에서 입출력 예외 발생 가능성 처리
		        e.printStackTrace(); // 예외 발생 시 콘솔에 오류 메시지 출력
		    }
		return pdsDao.setPdsInput(vo); //업로드된 파일들을 데이터베이스에 저장하기
	}

	@Override
	public int setpdsDelete(String idx) {
		return pdsDao.setpdsDelete(idx);
	}
	
	
}
