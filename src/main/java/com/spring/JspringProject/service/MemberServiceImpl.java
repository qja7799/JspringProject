package com.spring.JspringProject.service;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring.JspringProject.common.ProjectProvide;
import com.spring.JspringProject.dao.MemberDao;
import com.spring.JspringProject.vo.MemberVo;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	MemberDao memberDao;
	
	@Autowired
	ProjectProvide projectProvide;

	@Override
	public MemberVo getMemberIdCheck(String mid) {
		return memberDao.getMemberIdCheck(mid);
	}

	@Override
	public MemberVo memberNickChcek(String nickName) {
		return memberDao.memberNickChcek(nickName);
	}

	//db를 거치지않는 메서드니까 임플에서 처리하고 반환시킴(다오안씀)
	@Override							//업로드할사진, 아이디, 사진이름
	public String fileUpload(MultipartFile fName, String mid, String photo) {
		//파일 이름 중복방지를 위한 처리
		String original_FileName = fName.getOriginalFilename();
		String sFileName = mid + "_" + UUID.randomUUID().toString().substring(0,8) + "_" + original_FileName;
		
		try {
			//projectProvide에 있는 파일저장하는 메소드 (업로드된파일명, 저장될파일명, 저장경로)
			projectProvide.writeFile(fName, sFileName, "member");//서버에 파일 올리기
			
			//기존 사진파일을 삭제처리한다 (단, 기존사진이 기본이미지(noimage.jpg)일경우엔 삭제처리 안함)
			//그런데 기존 사진파일과 같은이름의 파일이 없으면 deleteFile은 어떻게 되는거지 에러 안나나? 안남
			//projectProvide클래스에 만들어둔 deleteFile메서드에서 file.exists()로 파일 있는지 없는지 검사해서
			//있으면 지우고 없으면 안지우기에 괜찮음
			if(!photo.equals("noimage.jpg")) projectProvide.deleteFile(photo, "member");//매개값=> 사진이름, 사진의 저장된경로
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return sFileName;
	}

	@Override
	public int setMemberJoinOk(MemberVo vo) {
		return memberDao.setMemberJoinOk(vo);
	}

	@Override
	public void setMemberInforUpdate(String mid, int point) {
		memberDao.setMemberInforUpdate(mid, point);
	}

	@Override
	public List<MemberVo> getMemberList(int level) {
		return memberDao.getMemberList(level);
	}

	@Override
	public void setMemberDeleteCheck(String mid) {
		memberDao.setMemberDeleteCheck(mid);
	}

	@Override
	public int getGesigulcount(String name) {
		return memberDao.getGesigulcount(name);
	}

	@Override
	public int getTodayCount(String mid) {
		return memberDao.getTodayCount(mid);
	}

	@Override
	public MemberVo getMemberIdxSearch(int idx) {
		return memberDao.getMemberIdxSearch(idx);
	}

	@Override
	public int setMemberPwdChange(String mid, String pwd) {
		return memberDao.setMemberPwdChange(mid, pwd);
	}

	@Override
	public List<MemberVo> getEmailList(String email) {
		return memberDao.getEmailList(email);
	}

	@Override
	public void setMemberTodayCntClear(String mid) {
		memberDao.setMemberTodayCntClear(mid);
	}

	@Override
	public int setMemberUpdateOk(MemberVo vo) {
		return memberDao.setMemberUpdateOk(vo);
	}

}
