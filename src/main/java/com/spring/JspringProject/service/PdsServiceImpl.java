package com.spring.JspringProject.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;

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
	PdsService pdsService;
	
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

	@Override
	public int setPdsDownNumPlus(int idx) {
		return pdsDao.setPdsDownNumPlus(idx);
	}

	@Override
	public PdsVo getPdsContent(int idx) {
		return pdsDao.getPdsContent(idx);
	}

//	@Override
//	public void pdsTotalDown(HttpServletRequest request, int idx) {
//		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/pds/");
//		
//		PdsVo vo = pdsService.getPdsContent(idx);
//		
//		String[] fNames = vo.getFName().split("/"); // 파일의 원래이름
//		String[] fSNames = vo.getFSName().split("/"); // db에 저장된 파일이름
//		
//		String zipPath = realPath + "temp"; // 집파일의 경로 설정
//		String zipName = vo.getTitle() + ".zip"; // 집파일의 이름을 설정
//		
//		//껍데기 만들기
//		FileInputStream fis = null;
//		FileOutputStream fos = null;
//		ZipOutputStream zout = null;
//		try {
//			zout = new ZipOutputStream(new FileOutputStream(zipPath + zipName));//만들어지는경로와 파일명이 들어가야함
//			
//		} catch (FileNotFoundException e1) {
//			e1.printStackTrace();
//		}
//		//껍데기 만들기 끝
//		
//		//껍데기에 내용채워넣기
//		byte[] bytes = new byte[2048];
//		
//		for(int i=0; i<fNames.length; i++) {
//			try {
//				fis = new FileInputStream(realPath + fSNames[i]);
//				fos = new FileOutputStream(zipPath + fNames[i]);//경로와 파일명 매개값넣기
//				File copyFile = new File(zipPath + fNames[i]);
//				int data = fis.read(bytes, 0, bytes.length);
//				
//				while(data != -1) {
//					fos.write(bytes, 0, data);
//				}
//				fos.flush();
//				fos.close();
//				fis.close();
//				
//				//이제 temp폴더 작업처리
//				fis = new FileInputStream(copyFile);
//				zout.putNextEntry(new ZipEntry(fNames[i]));
//				
//				while(data != -1) {
//					zout.write(bytes, 0, data);
//				}
//				zout.flush();
//				zout.closeEntry();
//				fis.close();
//				//zout.close(); 이렇게하면 작업하다 중간에 문닫는거라 하나넣고 끝나게됨
//				
//			} catch (FileNotFoundException e) {
//				e.printStackTrace();
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
//			
//			try {
//				zout.close();
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
//			//작업 완료후 클라이언트로 다운로드
//		}
//		
//		//pdsDao.pdsTotalDown(request, idx);
//	}
	
	@Override
	public String pdsTotalDown(HttpServletRequest request, int idx) {
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/pds/");
		
		PdsVo vo = pdsService.getPdsContent(idx);
		
		String[] fNames = vo.getFName().split("/");
		String[] fSNames = vo.getFSName().split("/");
		
		String zipPath = realPath + "temp/";
		String zipName = vo.getTitle() + ".zip";
		
		FileInputStream fis = null;
		FileOutputStream fos = null;
		ZipOutputStream zout = null;
		
		try {
			zout = new ZipOutputStream(new FileOutputStream(zipPath + zipName));
		} catch (FileNotFoundException e1) { e1.printStackTrace(); }
		
		byte[] bytes = new byte[2048];
		
		for(int i=0; i<fNames.length; i++) {
			try {
				fis = new FileInputStream(realPath + fSNames[i]);
				fos = new FileOutputStream(zipPath + fNames[i]);
				File copyFile = new File(zipPath + fNames[i]);
				
				int data = 0;
				while((data = fis.read(bytes, 0, bytes.length)) != -1) {
					fos.write(bytes, 0, data);
				}
				fos.flush();
				fos.close();
				fis.close();
				
				fis = new FileInputStream(copyFile);
				zout.putNextEntry(new ZipEntry(fNames[i]));
				while((data = fis.read(bytes, 0, bytes.length)) != -1) {
					zout.write(bytes, 0, data);
				}
				zout.flush();
				zout.closeEntry();
				fis.close();
				
			} catch (FileNotFoundException e) { e.printStackTrace(); } catch (IOException e) {e.printStackTrace();}
		}
		try {
			zout.close();
		} catch (IOException e) { e.printStackTrace(); }
		
		// 작업완료후... 
		
		// 서버의 기본파일 삭제처리(temp폴터의 파일 삭제처리, zip파일 제외)
		File folder = new File(zipPath);
		File[] files = folder.listFiles();
		if(files.length != 0) {
			for(File file : files) {
				//String fileStr = file.toString();
				//if(!fileStr.substring(fileStr.lastIndexOf(".")+1).equals("zip")) file.delete();
				//zip파일 안에 zip파일이 있을수있으니 위의 코드처럼 쓰면안됨
				String fName = file.toString();
				if(!zipName.equals(fName.substring(fName.lastIndexOf("\\")+1))) file.delete();
			}
		}
		
		//클라이언트로 다운로드....
		return zipName;
	}
	
}
