package com.spring.JspringProject.controller;

import java.util.Arrays;
import java.util.List;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.spring.JspringProject.service.MemberService;
import com.spring.JspringProject.service.StudyService;
import com.spring.JspringProject.vo.GuestVo;
import com.spring.JspringProject.vo.MailVo;
import com.spring.JspringProject.vo.MemberVo;

@Controller
//@RestController
@RequestMapping("/study")
public class StudyController {
	
	@Autowired
	private StudyService studyService;
	
	@Autowired
	private JavaMailSender mailSender;
	
	@Autowired
	private MemberService memberService;
	
	
	@RequestMapping("/ajax/ajaxForm")
	public String ajaxFormGet() {	
		return "study/ajax/ajaxForm";
	}
	
//	//동기식 호출
//	@RequestMapping("/ajax/ajaxTest1")
//	public String ajaxTest1Get(Model model, int idx) {
//		model.addAttribute("idx", idx);
//		return "study/ajax/ajaxForm";
//	}
	
	//레스트api방식
	//@ResponseBody=> 부분적으로만 @RestController적용 / 레스트컨트롤러에선 문자가 넘어가기에 객체가 넘어가는 모델은 쓸모가없음
	@ResponseBody// produces = "application/json; charset=UTF-8"
	@RequestMapping(value="/ajax/ajaxTest1", method = RequestMethod.POST, produces="application/text; charset=utf-8")
	public String ajaxTest1Get(int idx) {
		String str = "전송값: " + idx;	//문자열로 가져오는 방식
		return str;
	}
	
	
	@RequestMapping(value="/ajax/ajaxTest2_1", method = RequestMethod.GET)
	public String ajaxTest2_1Get() {
		return "study/ajax/ajaxTest2_1";
	}
	
//	문자배열로 가져오는방식(리스트랑 문자배열은 다른거임)
//	문자배열로 가져오려면 pom.xml에 라이브러리 의존성주입 해줘야함/ 리스트는 안해줘도됨
//	@ResponseBody  
//	@RequestMapping(value="/ajax/ajaxTest2_1", method = RequestMethod.POST)
//	public String[] ajaxTest2_1Post(String dodo) {
//		String[] strArray = new String[100];
//		strArray = studyService.getCityStringArray(dodo);
//		return strArray;
//	}
	
	
//	위에걸(문자열) 간략하게 축약한 버전
	@ResponseBody
	@RequestMapping(value="/ajax/ajaxTest2_1", method = RequestMethod.POST)
	public String[] ajaxTest2_1Post(String dodo) {
		return studyService.getCityStringArray(dodo);
	}
	
	//
	//리스트로 가져오는 방식 뷰 이동
	@RequestMapping(value="/ajax/ajaxTest2_2", method = RequestMethod.GET)
	public String ajaxTest2_2Get(String dodo) {
		return "study/ajax/ajaxTest2_2";
	}
	
	//리스트로 가져오는 방식 처리
	@ResponseBody
	@RequestMapping(value="/ajax/ajaxTest2_2", method = RequestMethod.POST)
	public List<String> ajaxTest2_2Post(String dodo) {
		return studyService.getCityVosArray(dodo);
	}
	
	//파일업로드 폼보기
	@RequestMapping(value="/fileUpload/fileUpload", method = RequestMethod.GET)
	public String fileUploadGet(HttpServletRequest request) {
		//String realPath = request.getSession().getServletContext().getRealPath("/resources/data/fileUpload");
		
		return "study/fileUpload/fileUpload";
	}
	
	//파일업로드 처리
	@RequestMapping(value="/fileUpload/fileUpload", method = RequestMethod.POST)
	public String fileUploadPost(MultipartFile fName, String mid) {
		int res = studyService.fileUpload(fName, mid);
		
		if(res != 0) return "redirect:/message/fileUploadOk";
		return "redirect:/message/fileUploadNo";
	}
	
	// 메일 연습폼 보기
	@RequestMapping(value = "/mail/mailForm", method = RequestMethod.GET)
	public String mailFormGet(HttpServletRequest request) {
		return "study/mail/mailForm";
	}
	
	// MideMessageHelper는 메세지보관함
	// 메일 연습 보내기
	@RequestMapping(value = "/mail/mailForm", method = RequestMethod.POST)
	public String mailFormPost(HttpServletRequest request, MailVo vo) throws MessagingException {
		String toMail = vo.getToMail();
		String title = vo.getTitle();
		String content = vo.getContent();
		
		// MimeMessage(), MideMessageHelper()
		MimeMessage message = mailSender.createMimeMessage();
		MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
		
		// 메일보관함에 메세지 내용 저장...후... 처리
		messageHelper.setTo(toMail);
		messageHelper.setSubject(title);
		messageHelper.setText(content);//먼저 내용을 넣고 추가로 넣을걸 넣어주는식으로 해야한다
		
		//메세지에 추가로 필요한 사항을 messageHelper에 추가로 넣어준다
		content = content.replace("\n", "<br>");//중바꿈처리
		content += "<br><hr><h3>JspringProject에서 보냅니다</h3><br>";
		content += "<p><img src=\"cid:paris.jpg\" width='550px'></p>";
		content += "<p>방문하기 : <a href='http://49.142.157.251:9090/cjgreen'>Green Project</a></p>";
		content += "<hr>";
		messageHelper.setText(content, true);//덮어쓰기(위에서 먼저 넣어주고 그다음 고친다음 덮어쓰기를 해줘야함 /한번에 넣는건 불가능
		
		//본문에 기재된 그림파일의 경로 / addInline(보낼그림파일의 이름, 그 파일의 경로)
		//FileSystemResource file = new FileSystemResource("D:\\springProject\\springframework\\works\\JspringProject\\src\\main\\webapp\\resources\\images\\paris.jpg");
		FileSystemResource file = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images//paris.jpg"));
		messageHelper.addInline("paris.jpg",file);
		
		//첨부파일 보내기
		file = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images//chicago.jpg"));
		messageHelper.addAttachment("chicago.jpg", file);//그림파일 보내기
		
		file = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images//chicago.zip"));
		messageHelper.addAttachment("chicago.zip", file);//집파일 보내기
		
		
		//메일 전송하기
		mailSender.send(message);
		
		return "redirect:/message/mailSendOk";
	}
	
	
	// 모달 연습 겟
	@RequestMapping(value = "/modal/modalForm", method = RequestMethod.GET)
	public String modalFormGet(Model model) {
		List<MemberVo> vos = memberService.getMemberList(99);//전체자료 가져오기
		MemberVo vo = memberService.getMemberIdCheck("qwe123123");
		model.addAttribute("name", "홍길동");
		model.addAttribute("age", "22");
		model.addAttribute("address", "서울");
		
		model.addAttribute("vo", vo);
		
		model.addAttribute("vos", vos);
		
		return "study/modal/modalForm";
	}
	
	
	
}
