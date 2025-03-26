package com.spring.JspringProject.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.spring.JspringProject.service.AdminService;
import com.spring.JspringProject.service.MemberService;
import com.spring.JspringProject.vo.MailVo;
import com.spring.JspringProject.vo.MemberVo;

@Controller
@RequestMapping("/member")
public class MemberController {

	@Autowired
	MemberService memberService;
	
	@Autowired
	JavaMailSender mailSender;
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder; 
	
	
	// 로그인 폼 보기
	@RequestMapping(value = "/memberLogin", method = RequestMethod.GET)
	public String memberLoginGet(HttpServletRequest request) {
		// 쿠키처리로 저장된 아이디를 가져와서 view에 보내주기(숙제)
		Cookie[] cookies = request.getCookies();
		
		if(cookies != null) {
			for(int i=0; i<cookies.length; i++){
				if(cookies[i].getName().equals("cMid")){
					request.setAttribute("mid", cookies[i].getValue());
					break;
				}
			}
		}
		
		return "member/memberLogin";
	}
	
	// 로그인 처리
	@RequestMapping(value = "/memberLogin", method = RequestMethod.POST)
	public String memberLoginPost(HttpSession session, HttpServletRequest req, HttpServletResponse reps , String mid, String pwd, String idSave) {
		// 로그인인증처리(스프링 시큐리티의 BCryptPasswordEncoder객체를 이용한 암호화 되어 있는 비밀번호 비교하기)
		MemberVo vo = memberService.getMemberIdCheck(mid);
		
		
	    LocalDateTime imsitime = (LocalDateTime) session.getAttribute("imsitime");

	    // 현재 시간이 만료 시간을 넘었는지 확인
	    if (imsitime != null && LocalDateTime.now().isAfter(imsitime)) {
	    	return "redirect:/message/memberLoginNo2";
	    }
		
		
		//DB에 저장된 암호화된 비번이랑 입력받은 비번이 같은지 비교하는 함수
		//=> passwordEncoder.matches(입력받은비번 , DB에 저장된 암호화된 비번)
		//탈퇴중인회원(UserDel=ok)은 로그인 못하게 처리
		if(vo != null && vo.getUserDel().equals("NO") && passwordEncoder.matches(pwd, vo.getPwd())) {
			//로그인 완료시 처리할 로직(1.세션, 2.쿠키, 3.기타설정값(방문포인트등) 세팅)
			
			//1. 세션
			String strLevel = "";
			if(vo.getLevel() == 0) strLevel = "관리자";
			else if(vo.getLevel() == 1) strLevel = "우수회원";
			else if(vo.getLevel() == 2) strLevel = "정회원";
			else if(vo.getLevel() == 3) strLevel = "준회원";
			
			session.setAttribute("sMid", mid);
			session.setAttribute("sNickName", vo.getNickName());
			session.setAttribute("sLevel", vo.getLevel());
			session.setAttribute("strLevel", strLevel);
			
			//2. 쿠키
			if(idSave != null && idSave.equals("on")) {//쿠키 저장 처리
				Cookie cookie_id = new Cookie("cMid", vo.getMid());
				//cookie_id.setPath("/");
				cookie_id.setPath(req.getContextPath());
				cookie_id.setMaxAge(60*60*24*7); // 단위:초  / 쿠키 만료시간을 7일로 설정
				reps.addCookie(cookie_id);
				
			}else {	//쿠키 삭제 처리
				Cookie[] cookies = req.getCookies();
				if(cookies != null) {
					for(int i=0; i<cookies.length; i++){
						if(cookies[i].getName().equals("cMid")){
							cookies[i].setPath(req.getContextPath());
							cookies[i].setMaxAge(0); 
							reps.addCookie(cookies[i]);
							break;
						}
					}
				}
			}
			
			System.out.println("req.getContextPath()=> " + req.getContextPath());
			System.out.println("req.getCookies()=> " + req.getCookies());
			System.out.println("idSave => " + idSave);
			
			// 3-1. 기타처리 : 오늘 첫방문이면 todayCnt = 0
			if(!LocalDateTime.now().toString().substring(0,10).equals(vo.getLastDate().substring(0,10))) {
				memberService.setMemberTodayCntClear(mid);
				vo.setTodayCnt(0);
			}
			
			// 3-2. 기타처리 : 방문카운트로 10포인트 증정(단, 1일 50포인트까지만 제한처리)
			//방문횟수가 5이상이면 포인트추가 0으로 설정
			int point = vo.getTodayCnt() < 5 ? 10 : 0;
			memberService.setMemberInforUpdate(mid, point);
			
			//내가했던거
			//3. 기타처리 : 방문카운트로 10포인트증정 (단, 1일 50포인트까지만 제한처리) +10
//			int todayCount = memberService.getTodayCount(mid);
//			int point = 0;
//			
//			if(todayCount < 5) {	
//				memberService.setMemberInforUpdate(mid, point);
//			}else {
//				point = 10;
//				memberService.setMemberInforUpdate(mid, point);
//			}
			
			
			//로그인 성공했으니 임시비밀번호찾기에서 세션에 저장한 2분후시간값 삭제
			session.removeAttribute("imsitime");
			
			return "redirect:/message/memberLoginOk?mid="+mid;
		}else {
			return "redirect:/message/memberLoginNo";
		}
	}
	
	// 회원가입 폼 보기
	@RequestMapping(value = "/memberJoin", method = RequestMethod.GET)
	public String memberJoinGet() {
		return "member/memberJoin";
	}
	
	// 회원가입 처리하기(DB에 회원 정보 저장)
	@RequestMapping(value = "/memberJoin", method = RequestMethod.POST)
	public String memberJoinPost(MemberVo vo, MultipartFile fName) {
		System.out.println("memberJoinPost 이메일1 => "+vo.getEmail());
		//프런트단에서 이미 체크해줬지만 혹시모르니 컨트롤러단에서 또 중복체크 해줌(난 프런트단에서 확실하게 해주는편이라 여기서 굳이 다시한번 체크안해줘도됨)
		//아이디 중복체크
		if(memberService.getMemberIdCheck(vo.getMid()) != null) {
			return "redirect:message/idCheckNo";
		}
		//닉네임 중복체크
		if(memberService.memberNickChcek(vo.getNickName()) != null) {
			return "redirect:message/NickCheckNo";
		}
		
		//비밀번호 암호화
		vo.setPwd(passwordEncoder.encode(vo.getPwd()));
		
		//회원 사진 처리
		if(!fName.getOriginalFilename().equals("")) {
			vo.setPhoto(memberService.fileUpload(fName, vo.getMid(), ""));//확장성을 고려해서 매개값 하나 비운채로 넣어놓음
		}else {
			vo.setPhoto("noimage.jpg");
		}
		System.out.println("memberJoinPost 이메일2 => "+vo.getEmail());
		//위의 처리가 완료되면 DB에 회원정보 저장
		int res = memberService.setMemberJoinOk(vo);
		
		if(res != 0) return "redirect:/message/memberJoinOk";
		else return "redirect:/message/memberJoinNo";
	}
	
	// 아이디 중복체크
	@ResponseBody
	@RequestMapping(value = "/memberIdChcek", method = RequestMethod.GET)
	public String memberIdChcekGet(String mid) {
		MemberVo vo = memberService.getMemberIdCheck(mid);
		if(vo != null) return "1";
		else return "0";
	}
	
	// 닉네임 중복체크
	@ResponseBody
	@RequestMapping(value = "/memberNickChcek", method = RequestMethod.GET)
	public String memberNickChcekGet(String nickName) {
		MemberVo vo = memberService.memberNickChcek(nickName);
		if(vo != null) return "1";
		else return "0";
	}
	
	// 이메일 인증처리
	@ResponseBody
	@RequestMapping(value = "/memberEmailCheck", method = RequestMethod.POST)
	public String memberEmailCheckPost(String email, HttpSession session) throws MessagingException {
		UUID uid = UUID.randomUUID();
		String emailKey = uid.toString().substring(0,8);
		
		mailSend(email, "이메일 인증키입니다", "인증키 : " + emailKey);
		//메일 받아서 세션에 저장
		session.setAttribute("sEmailKey", emailKey);
		
		return "1";
	}
	
	// 메일 전송하기(인증번호, 아이디찾기, 비번찾기에 쓸예정)
	public void mailSend(String toMail, String title, String mailFlag) throws MessagingException {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String content = "";
		
		MimeMessage message = mailSender.createMimeMessage();
		MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
		
		// 메일보관함에 메세지 내용 저장...후... 처리
		messageHelper.setTo(toMail);
		messageHelper.setSubject(title);
		messageHelper.setText(content);
		
		// 메세지에 추가로 필요한 사항을 messageHelper에 추가로 넣어준다.
		content = content.replace("\n", "<br>");
		content += "<br><hr><h3>"+ mailFlag +"</h3><br>";
		content += "<p><img src=\"cid:paris.jpg\" width='550px'></p>";
		content += "<p>방문하기 : <a href='http://49.142.157.251:9090/cjgreen'>Green Project</a></p>";
		content += "<hr>";
		messageHelper.setText(content, true);
		
		//본문에 기재된 그림파일의 경로 / addInline(보낼그림파일의 이름, 그 파일의 경로)
		//FileSystemResource file = new FileSystemResource("D:\\springProject\\springframework\\works\\JspringProject\\src\\main\\webapp\\resources\\images\\paris.jpg");
		FileSystemResource file = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images//paris.jpg"));
		messageHelper.addInline("paris.jpg",file);
		
		// 메일 전송하기
		mailSender.send(message);

	}

	
	// 이메일 인증번호 검사
	@ResponseBody
	@RequestMapping(value = "/memberEmailCheckOk", method = RequestMethod.GET)
	public String memberEmailCheckOkGet(String checkKey, HttpSession session) {
//		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
//		HttpSession session = request.getSession();
		String emailKey = session.getAttribute("sEmailKey")+"";
		session.removeAttribute(emailKey);
		
		if(checkKey.equals(emailKey) ) return "1";
		else return "0";
	}
	
	
	// 멤버 메인페이지이동
	@RequestMapping(value = "/memberMain", method = RequestMethod.GET)
	public String memberMainGet(Model model, HttpSession session) {
		String mid = session.getAttribute("sMid")+"";
		MemberVo vo = memberService.getMemberIdCheck(mid);
		int count = memberService.getGesigulcount(vo.getName());
		
		model.addAttribute("vo", vo);
		model.addAttribute("count", count);
		
		return "member/memberMain";
	}
	
	// 멤버 로그아웃
	@RequestMapping(value = "/memberLogout", method = RequestMethod.GET)
	public String memberLogoutGet(HttpSession session) {
		//session.invalidate();
		//세션.인밸리디드를 쓰면안되는 이유=> 세션인밸리디드는 세션에 저장된걸 전부 삭제시키는것이기에 
		//관리자가 로그아웃하면 기존에 로그인되어있던 일반유저들의 세션에 저장된 정보들도 함께 날아가게됨
		//그렇기에 세션에 저장된 특정데이터(관리자아이디)만 지워야함
		session.removeAttribute("sMid");
		session.removeAttribute("sNickName");
		session.removeAttribute("sLevel"); 
		session.removeAttribute("strLevel"); 
		//흠 그런데 저장할때 구분자를 줘야할거같은데..
		//저장할때 sLevel 이런식으로 저장하니 삭제할때 다른 유저의 정보까지 지워질거같은데
		
		return "redirect:/message/memberLogoutOk";
	}
	
	// 회원 탈퇴(정보수정)신청을 위한 비밀번호 확인
	//패스밸류어블식으로 받은값을 @PathVariable String pwdFlag로 변수에 저장안해줘도되는게 pwdCheckPost에서 바로 사용할거라 그런거
	//사정이 바뀌어서 다른곳에서도 패스밸리어블값 사용해야해서 변수에 담아줘야함
	//쿼리스트링으로 보내면 jsp에서 파람.el문으로 바로쓸수있는데
	//패스밸리어블로 보내면 컨트롤러에서 값넘겨줘야 el로 쓸수있음 그냥은못씀
	@RequestMapping(value = "/pwdCheck/{pwdFlag}", method = RequestMethod.GET)
	public String pwdCheckGet(Model model, @PathVariable String pwdFlag) {
		model.addAttribute("pwdFlag", pwdFlag);
		return "member/pwdCheckForm";
	}
	
	// 비밀번호 확인처리후 지정된 위치로 보내기처리
	@RequestMapping(value = "/pwdCheck/{pwdFlag}", method = RequestMethod.POST)
	public String pwdCheckPost(HttpSession session, @PathVariable String pwdFlag, String pwd) {
		String mid = session.getAttribute("sMid")+"";
		//MemberVo vo = memberService.getMemberIdCheck(mid); 
		//passwordEncoder.matches(pwd, vo.getPwd()); 이렇게도 쓸수있는데 밑처럼쓰는게 효율적
		System.out.println("pwdFlag=> " + pwdFlag);
		System.out.println("pwd=> " + pwd);
		if(!passwordEncoder.matches(pwd, memberService.getMemberIdCheck(mid).getPwd())) {
			if(pwdFlag.equals("d")) {
				return "redirect:/message/pwdCheckNo";
			}else if(pwdFlag.equals("p")) {
				return "redirect:/message/pwdCheckNoP";
			}else if(pwdFlag.equals("u")) {
				return "redirect:/message/pwdCheckNoU";
			}
		}
		
		//탈퇴신청하기 (바로 회원삭제시키는게아님)
		if(pwdFlag.equals("d")) {
			memberService.setMemberDeleteCheck(mid);
			return "redirect:/message/memberDeleteCheck";
		}
		//비밀번호 변경
		else if(pwdFlag.equals("p")) {	
			//return "member/memberPassCheckForm";
			return "redirect:/member/memberPassCheckForm";
		}
		//회원정보 수정
		else if(pwdFlag.equals("u")) {
			return "redirect:/member/memberUpdate";
		}
		
		return "/";
	}
	
	
	//멤버리스트
	// 전체 회원 보기
		@GetMapping("/memberList")
		public String memberListGet(Model model, HttpSession session,
				@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
				@RequestParam(name="pageSize", defaultValue = "5", required = false) int pageSize,
				@RequestParam(name="level", defaultValue = "99", required = false) int level
			) {
			int totRecCnt = adminService.getMemberTotRecCnt(level);
			int totPage = (totRecCnt % pageSize) == 0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize) + 1;
			int startIndexNo = (pag - 1) * pageSize;
			int curScrStartNo = totRecCnt - startIndexNo;
			
			int blockSize = 3;
			int curBlock = (pag - 1) / blockSize;
			int lastBlock = (totPage - 1) / blockSize;
			List<MemberVo> vos = memberService.getMemberList(startIndexNo, pageSize, level);
			
			model.addAttribute("vos", vos);
			model.addAttribute("pag", pag);
			model.addAttribute("pageSize", pageSize);
			model.addAttribute("totPage", totPage);
			model.addAttribute("curScrStartNo", curScrStartNo);
			model.addAttribute("blockSize", blockSize);
			model.addAttribute("curBlock", curBlock);
			model.addAttribute("lastBlock", lastBlock);
			model.addAttribute("level", level);
			
			return "member/memberList";
		}
	
	//비밀번호 변경처리
	@PostMapping("/pwdChange")
	public String pwdChangePost(HttpSession session, String pwd) {
		String mid = session.getAttribute("sMid") + "";
		
		//비밀번호 암호화
		pwd = passwordEncoder.encode(pwd);
		int res = memberService.setMemberPwdChange(mid, pwd);
		
		if(res != 0) return "redirect:/message/pwdChangeOk";
		else return "redirect:/message/pwdChangeNo";
	}
	
	// 비밀번호 찾기 폼보기
	@RequestMapping(value = "/pwdSearch", method = RequestMethod.GET)
	public String pwdSearchGet() {
		return "member/pwdSearch";
	}
	
	// 비밀번호 찾기 처리
	@RequestMapping(value = "/pwdSearch", method = RequestMethod.POST)
	public String pwdSearchPost(HttpSession session, String email, String mid) throws MessagingException {
		System.out.println("email=> " + email);
		System.out.println("mid=> " + mid);
		
		MemberVo vo = memberService.getMemberIdCheck(mid); 
		System.out.println("vo=> " + vo);
		
		if(vo != null) {
			if(mid.equals(vo.getMid()) && email.equals(vo.getEmail())) {
				UUID uid = UUID.randomUUID();
				String pwdKey = uid.toString().substring(0,8);
				
				//현재시간 + 2분을 변수에 저장
				LocalDateTime imsitime = LocalDateTime.now().plusMinutes(2);
				//LocalDateTime imsitime = LocalDateTime.now().plusSeconds(1);
				//db에 저장시키는게 베스트지만 저장할열을 만들지않아서 세션에 저장
				session.setAttribute("imsitime", imsitime);
				
				mailSend(email, "임시 비밀번호입니다 ", "임시 비밀번호 : " + pwdKey);
				System.out.println("pwdKey=> " + pwdKey);
				//임시비밀번호 다시 암호화해서 vo에 넣고
				vo.setPwd(passwordEncoder.encode(pwdKey));
				//그 암호화된 비번이 담긴 vo를 db에 넣어서 임시비번으로 업데이트
				int res = memberService.setMemberPwdChange(mid, vo.getPwd());
				
				if(res != 0) return "redirect:/message/pwdSearchOk";
				else return "redirect:/message/pwdSearchNo";
			}
		}

		return "redirect:/message/pwdSearchNo";
	}
	
	// 아이디 찾기 폼보기
	@RequestMapping(value = "/midSearch", method = RequestMethod.GET)
	public String midSearchGet() {
		return "member/midSearch";
	}
	
	//아이디 찾기 처리
	@RequestMapping(value = "/midSearch", method = RequestMethod.POST)
	public String midSearchPost(Model model, String email) {
		System.out.println("midSearch email=> "+email);
		List<MemberVo> vos =  memberService.getEmailList(email);
		System.out.println("vos=> " + vos);
		
		if(vos != null && !vos.isEmpty()) {//리스트값이 널이 아니거나 비어있지 않을경우
			// 모든 이메일을 마스킹 처리한 새로운 리스트 생성
			for (MemberVo vo : vos) {
			    vo.setEmail(maskEmail(vo.getEmail()));
			}
			model.addAttribute("vos", vos);
			return "member/midSearch";
		}else {	
			model.addAttribute("notemail", "검색된 이메일이 없습니다");
			return "member/midSearch";
		}
	}
	
	
	//아이디찾기에서 쓸 이메일 마스킹처리 메서드
    public String maskEmail(String email) {
        if (email == null || !email.contains("@")) {
            return email; // 이메일 형식이 아니면 그대로 반환
        }

        //이메일 분리
        String emailId = email.substring(0, email.indexOf('@'));//@ 앞
        String emailDomain = email.substring(email.indexOf('@'));//@ 뒤

        // StringBuilder로 변환 (setCharAt() 사용 가능 / 그냥 String타입은 setCharAt()사용불가)
        StringBuilder maskedEmailId = new StringBuilder(emailId);
        
        //짝수 번째 인덱스에 있는 글자만 마스킹처리
        for (int i = 1; i < emailId.length(); i += 2) { 
        	maskedEmailId.setCharAt(i, '*');//
        }

        return maskedEmailId + emailDomain;
    }
    
    //회원정보 수정 폼보기
	@RequestMapping(value = "/memberUpdate", method = RequestMethod.GET)
	public String memberUpdateGet(Model model, HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		MemberVo vo = memberService.getMemberIdCheck(mid);
		System.out.println("memberUpdateGet vo=>" + vo);
		model.addAttribute("vo", vo);
		
		return "member/memberUpdate";
	}
	
	//회원정보 수정 처리
	@RequestMapping(value = "/memberUpdate", method = RequestMethod.POST)
	public String memberUpdatePost(HttpSession session, MemberVo vo, MultipartFile fName) {
		String nickName = session.getAttribute("sNickName")+"";
		
		//입력받은 닉네임이랑 일치하는 닉네임이 db에 존재하는지 확인
		MemberVo nickcheckVo = memberService.memberNickChcek(vo.getNickName());
		
		//입력받은 닉네임이 db에 존재하지 않으면 nickcheckVo가 null반환해서 if문실행 x
		if(nickcheckVo != null && !nickName.equals(vo.getNickName())) {
			return "redirect:/message/NickCheckNo";
		}
		
		//회원 사진 처리
		//수정폼에서 사진을 수정한 경우체크(fName.getOriginalFilename()이 널이나 ""가 아니면 사진이 콘트롤러로 넘어온거임)
		if(fName.getOriginalFilename() != null && !fName.getOriginalFilename().equals("")) {
			//fileUpload매개값 => 업로드할사진, 아이디, 사진이름
			vo.setPhoto(memberService.fileUpload(fName, vo.getMid(), vo.getPhoto()));
		}
		//수정폼에서 사진을 수정하지않았다면 폼에서 히든인풋으로 vo.photo로 기존 사진이 넘어와서 기존꺼 그대로 유지가 됨
		
		//회원정보 업데이트하기
		int res = memberService.setMemberUpdateOk(vo);
		
		if(res != 0) {
			//닉네임 수정시에는 새로운 닉네임을 세션에 저장해야하기에 세션에 같은이름으로 닉네임값 덮어쓰기
			session.setAttribute("sNickName", vo.getNickName());
			return "redirect:/message/memberUpdateOk";
		}
		else return "redirect:/message/memberUpdateNo";
	}

	

}
