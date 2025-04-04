package com.spring.JspringProject.controller;

import java.io.File;
import java.io.IOException;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.JspringProject.service.MemberService;
import com.spring.JspringProject.service.StudyService;
import com.spring.JspringProject.vo.ChartVo;
import com.spring.JspringProject.vo.GuestVo;
import com.spring.JspringProject.vo.MailVo;
import com.spring.JspringProject.vo.MemberVo;
import com.spring.JspringProject.vo.ReviewReplyVo;

import io.github.bonigarcia.wdm.WebDriverManager;

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
	
	//싱글 파일업로드 폼보기
	@RequestMapping(value="/fileUpload/fileUpload", method = RequestMethod.GET)
	public String fileUploadGet(HttpServletRequest request, Model model) {
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/fileUpload");
		String[] files = new File(realPath).list();//파일명들이 담긴 리스트
        
        model.addAttribute("files", files);//파일명 리스트
	
		return "study/fileUpload/fileUpload";
	}
	
	//싱글 파일업로드 처리
	@RequestMapping(value="/fileUpload/fileUpload", method = RequestMethod.POST)
	public String fileUploadPost(MultipartFile fName, String mid) {
		int res = studyService.fileUpload(fName, mid);
		
		if(res != 0) return "redirect:/message/fileUploadOk";
		return "redirect:/message/fileUploadNo";
	}
	
	//선택된 파일 1개 삭제처리
	@ResponseBody
	@RequestMapping(value="/fileUpload/fileDelete", method = RequestMethod.POST)
	public String fileDeletePost(String file, HttpServletRequest request) {
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/fileUpload/");//특정 1개만 삭제할거라 fileUpload뒤에 /붙임
		
		String res = "0";
		File fName = new File(realPath + file);
		
		if(fName.exists()) {
			fName.delete();
			res = "1";
		}
		
		return res;
	}
	
	//모든파일 삭제처리
	@ResponseBody
	@RequestMapping(value="/fileUpload/fileDeleteAll", method = RequestMethod.POST)
	public String fileDeleteAllPost(HttpServletRequest request) {
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/fileUpload/");
		String res = "0";
		File folder = new File(realPath);
		if(!folder.exists()) {
			return res;
		}
		File[] files = folder.listFiles();
		if(files.length != 0) {
			for(File fils : files) {
				fils.delete();			
			}
			res = "1";
		}
		
		return res;
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
		model.addAttribute("name", "홍길동");
		model.addAttribute("age", "22");
		model.addAttribute("address", "서울");
		
		// 관리자의 정보를 front에 modal로 출력하시오.
		MemberVo vo = memberService.getMemberIdCheck("admin");
		model.addAttribute("vo", vo);
		System.out.println("vo : " + vo);
		
		List<MemberVo> vos = memberService.getMemberList(0, 1000, 99);	// level 99는 전체자료 조회(0번 인덱스부터 1000건 조회)
		model.addAttribute("vos", vos);
		
		return "study/modal/modalForm";
	}
	
	
	//멀티파일 업로드 폼보기
	@RequestMapping(value="/fileUpload/multiFile", method = RequestMethod.GET)
	public String multiFileGet() {
		return "study/fileUpload/multiFile";
	}
	
	//멀티파일 업로드 처리
	@RequestMapping(value="/fileUpload/multiFile", method = RequestMethod.POST)
	public String multiFilePost(MultipartHttpServletRequest mFile) {
		int res = studyService.multiFileUpload(mFile);
		
		if(res != 0) return "redirect:/message/multiFileUploadOk";
		return "redirect:/message/multiFileUploadNo";
	}
	
	
	
	//인터넷 달력 연습
	@RequestMapping(value="/calendar", method = RequestMethod.GET)
	public String calendarGet() {
		studyService.getCalendar();
		return "study/calendar/calendar";
	}
	
	
	//크롤링(jsoup) 폼 보기
	@RequestMapping(value="/crawling/jsoup", method = RequestMethod.GET)
	public String jsoupGet() {
		
		return "study/crawling/jsoup";
	}
	
	//크롤링(jsoup) 처리
	@ResponseBody
	@RequestMapping(value="/crawling/jsoup", method = RequestMethod.POST, produces="application/text; charset=utf-8")
	public String jsoupPost(String url, String selector) throws IOException {
		Connection conn = Jsoup.connect(url);
		Document document = conn.get();
		
		Elements elements = document.select(selector);
		
		int i = 0;
		String str = "";
		for(Element element : elements) {
			i++;
			//System.out.println("element : " + element);
			//System.out.println("element : " + element.text());
			System.out.println(i + ". " + element.text());
			str += i + ". " + element.text()+"<br>";
		}

		return str;
	}
	
	//크롤링(jsoup) 처리2
	@ResponseBody
	@RequestMapping(value="/crawling/jsoup2", method = RequestMethod.POST)
	//문자로 갈때만 produces="application/text; charset=utf-8"를 써줘야함
	//지금은 객체(리스트)로 보내니 쓰면안됨
	public List<String> jsoup2Post(String url, String selector) throws IOException {
		Connection conn = Jsoup.connect(url);
		Document document = conn.get();
		
		Elements elements = document.select(selector);
		
		int i = 0;
		List<String> vos = new ArrayList<String>();
		for(Element element : elements) {
			i++;
			System.out.println(i + ". " + element.text());
			vos.add(i + ". " + element.text());
		}
		
		return vos;
	}
	
	// 크롤링(jsoup) 처리3...
	@ResponseBody
	@RequestMapping(value = "/crawling/jsoup3", method = RequestMethod.POST)
	public List<String> jsoup3Post(String url, String selector) throws IOException {
		Connection conn = Jsoup.connect(url);
		Document document = conn.get();
		
		Elements elements = document.select(selector);
		
		int i = 0;
		List<String> vos = new ArrayList<String>();
		for(Element element : elements) {
			i++;
			System.out.println("element : " + element);
			//System.out.println(i + ". " + element.text());
			vos.add(i + ". " + element.html().replace("data-", ""));
		}
		return vos;
	}
	
	// 크롤링(jsoup) 처리4...
	@ResponseBody
	@RequestMapping(value = "/crawling/jsoup4", method = RequestMethod.POST)
	public List<String> jsoup4Post(String search, String searchSelector) throws IOException {
		Connection conn = Jsoup.connect(search);
		Document document = conn.get();
		
		Elements elements = document.select(searchSelector);
		
		int i = 0;
		List<String> vos = new ArrayList<String>();
		for(Element element : elements) {
			i++;
			System.out.println("element : " + element);
			//System.out.println(i + ". " + element.text());
			//vos.add(i + ". " + element);
			//vos.add(i + ". " + element.html());
			//리플레이스 쓴이유 data-lazysrc= 에서 data-lazy를 없애 src속성으로 만드려고 그런거
			vos.add(i + ". " + element.html().replace("data-lazy", ""));
		}
		return vos;
	}
	
	// 크롤링(jsoup) 처리5(daum)...
	@ResponseBody
	@RequestMapping(value = "/crawling/jsoup5", method = RequestMethod.POST)
	public List<List<String>> jsoup5Post(String url, String selector) throws IOException {
		Connection conn = Jsoup.connect(url);
		Document document = conn.get();
		
		Elements elements = null;
		String[] selectors = selector.split("/");
		
		elements = document.select(selectors[0]);
		ArrayList<String> titleVos = new ArrayList<String>();
		for(Element element : elements) {
			titleVos.add(element.html());
		}
		
		elements = document.select(selectors[1]);
		ArrayList<String> imageVos = new ArrayList<String>();
		for(Element element : elements) {
			imageVos.add(element.html());
		}
		
		elements = document.select(selectors[2]);
		ArrayList<String> broadcastVos = new ArrayList<String>();
		for(Element element : elements) {
			broadcastVos.add(element.html());
		}
		
		List<List<String>> allstr = new ArrayList<>();
		allstr.add(titleVos);
		allstr.add(imageVos);
		allstr.add(broadcastVos);
		
		System.out.println("allstr: "+allstr);
		
		
		return allstr;
	}
	
	// 크롤링(jsoup) 처리6(숙제/멜론차트)
	@ResponseBody
	@RequestMapping(value = "/crawling/jsoup6", method = RequestMethod.POST)
	public List<List<String>> jsoup6Post() throws IOException {
		Connection conn = Jsoup.connect("https://www.melon.com/chart/index.htm");
		Document document = conn.get();
			
		String coverImage = "div.wrap .image_typeAll";
		String musicName = ".rank01";
		String albumName = ".rank03";
		String singer = ".rank02";
		
		Elements elements = null;
		
		elements = document.select(coverImage);
		ArrayList<String> coverImageVos = new ArrayList<String>();
		for(Element element : elements) {
			coverImageVos.add(element.html());
		}
		
		elements = document.select(musicName);
		ArrayList<String> musicNameVos = new ArrayList<String>();
		for(Element element : elements) {
			musicNameVos.add(element.html());
		}
		
		elements = document.select(albumName);
		ArrayList<String> albumNameVos = new ArrayList<String>();
		for(Element element : elements) {
			albumNameVos.add(element.html());
		}
		elements = document.select(singer);
		ArrayList<String> singerVos = new ArrayList<String>();
		for(Element element : elements) {
			singerVos.add(element.html());
		}

		
		List<List<String>> allstr = new ArrayList<>();
		allstr.add(coverImageVos);
		allstr.add(musicNameVos);
		allstr.add(albumNameVos);
		allstr.add(singerVos);
		
		System.out.println("allstr: "+allstr);
		
		
		return allstr;
	}
	
	
	//동적크롤링(selenium) 폼 보기
	@RequestMapping(value="/crawling/selenium", method = RequestMethod.GET)
	public String seleniumGet() {
		
		return "study/crawling/selenium";
	}
	
	//동적크롤링(selenium) 처리하기
	@ResponseBody
	@RequestMapping(value="/crawling/selenium1", method = RequestMethod.POST)
	public String selenium1Post(String url, String searchString, HttpServletRequest request) throws IOException {
		//외부 드라이버를 다운받아서 '/resources/crawling'폴더에 넣어두었다면?
		//String realPath = request.getSession().getServletContext().getRealPath("/resources/crawling/");
		//System.setProperty("webdriver.chrome.driver", realPath + "chromedriver.exe"); 
		//옛날버전(크롬버전이 130대 이하)일경우 위처럼 브라우저(크롬,엣지)에맞는 드라이버 다운받아서 폴더에 넣어주고 그거 가져다가 드라이버 설정해줘야함
		
		WebDriver driver = new ChromeDriver();
		
		//지연시키는명령어 
		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
		WebDriverManager.chromedriver().setup();//
		
		driver.get(url);//크롬으로 url에 맞는 창열기
		
		WebElement btnSearch = driver.findElement(By.name("q"));//열린 창에서 네임값이 q인걸 찾음
		btnSearch.sendKeys(searchString);//네임값이 q인 태그에 검색어 입력처리
		btnSearch.sendKeys(Keys.ENTER);//검색어입력처리 후 엔터누름처리
		
		
		//driver.close();//창닫기
		
		return "";
	}
	
	//동적크롤링(selenium) 처리하기2
	@ResponseBody
	@RequestMapping(value="/crawling/selenium2", method = RequestMethod.POST)
	public List<Map<String, Object>> selenium2Post(HttpServletRequest request) throws IOException {
		List<Map<String, Object>> vos = new ArrayList<>();
		
		WebDriver driver = new ChromeDriver();
		//동적크롤링할땐 무조건 중간중간에 강제로 세워줘야함
		//창을 띄우고 그 창에서 명령을 실행하면 그 창에서 페이지를 불러오는데 짧지만 시간이 걸리기에
		//그때 다른 명령과 충돌이나면 이후의 명령이 실행안될수있고 크롤링 해온것들이 db에도 제대로 저장이안될수있음
		//세워주는시간은 명령실행후 페이지로딩이 오래걸릴거같으면 그만큼 오래줘야함
		
		//기껏 강제로 세워주는 wait변수 만들었지만 여기선 트라이캐치로 해결해서 안쓰였음
		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
		
		WebDriverManager.chromedriver().setup();
		
		driver.get("http://www.cgv.co.kr/movies/?lt=1&ft=0");//크롬으로 cgv영화목록 창열기
		
		WebElement btnMore = driver.findElement(By.id("chk_nowshow"));//열린 창에서 id값이 chk_nowshow인걸 찾음
		btnMore.click();//chk_nowshow를 클릭처리
		
		try { Thread.sleep(1000); } catch (Exception e) {}//클릭명령 실행후 강제로 세워주기(1초)/ 클릭후 확실히 페이지불러온후 다음명령이 실행되도록 
		
		btnMore = driver.findElement(By.className("link-more"));
		btnMore.click();
		
		try { Thread.sleep(2000); } catch (Exception e) {}//클릭명령 실행후 강제로 세워주기(2초)/ 클릭후 확실히 페이지불러온후 다음명령이 실행되도록 
		
		List<WebElement> elements  = driver.findElements(By.cssSelector("div.sect-movie-chart ol li"));//(findElements)cssSelector => 태그를 하나가 아닌 뭉탱이로 가져올떄 사용
		
		//int i = 0;
		for(WebElement element : elements) {// 그 뭉탱이로 가져온 태그에서 필요한것 뽑아내기
			Map<String, Object> map = new HashMap<>();
			//i++;
			String link = element.findElement(By.tagName("a")).getAttribute("href");
			String title = "<a href='"+link+"' target='_blank'>" +element.findElement(By.className("title")).getText()+ "</a>";
			String image = "<img src='"+ element.findElement(By.tagName("img")).getAttribute("src") +"' width='200px' />";
			String tiketPercent = element.findElement(By.className("percent")).getText();
			//밑은 xpath(절대위치)로 위치 지정한거 xpath위치는 웹페이지의 개발자도구(f12)에서 원하는 태그 마우스 우클릭하면 나오는 copy xpath 누르면 얻을수있음 
			//String moviePercent = element.findElement(By.xpath("//*[@id=\"contents\"]/div[1]/div[3]/ol[1]/li["+i+"]/div[2]/div/div/span[2]")).getText();
			
			System.out.println("title: " + title);
			System.out.println("image: " + image);
			System.out.println("tiketPercent: " + tiketPercent);
			//System.out.println("moviePercent: " + moviePercent);
			
			map.put("title", title);
			map.put("image", image);
			map.put("tiketPercent", tiketPercent);
			
			vos.add(map);
		}
		
		//db저장 처리
		
		
		
		driver.close();//창닫기
		
		return vos;
	}
	
	
	//동적크롤링(selenium) 처리하기3(숙제,멜론차트)
	@ResponseBody
	@RequestMapping(value="/crawling/selenium3", method = RequestMethod.POST)
	public List<Map<String, Object>> selenium3Post(HttpServletRequest request) throws IOException {
		List<Map<String, Object>> vos = new ArrayList<>();
		
		WebDriver driver = new ChromeDriver();
		WebDriverManager.chromedriver().setup();
		
		driver.get("https://www.melon.com/chart/index.htm");//크롬으로 cgv영화목록 창열기


		
		List<WebElement> elements  = driver.findElements(By.cssSelector("tr.lst50"));//(findElements)cssSelector => 태그를 하나가 아닌 뭉탱이로 가져올떄 사용
		
		//int i = 0;
		for(WebElement element : elements) {// 그 뭉탱이로 가져온 태그에서 필요한것 뽑아내기
			Map<String, Object> map = new HashMap<>();
			//i++;
			
			String coverImage = "<img src='"+ element.findElement(By.tagName("img")).getAttribute("src") +"' width='200px' />";
			String musicName = element.findElement(By.className("rank01")).getText();
			String albumName = element.findElement(By.className("rank03")).getText();
			String singer = element.findElement(By.className("rank02")).getText();
			String likeCnt = element.findElement(By.className("cnt")).getText();
			
			System.out.println("coverImage: " + coverImage);
			System.out.println("musicName: " + musicName);
			System.out.println("albumName: " + albumName);
			System.out.println("singer: " + singer);
			System.out.println("likeCnt: " + likeCnt);
			
			map.put("coverImage", coverImage);
			map.put("musicName", musicName);
			map.put("albumName", albumName);
			map.put("singer", singer);
			map.put("likeCnt", likeCnt);
			
			vos.add(map);
		}
		
		//db저장 처리
		
		
		
		driver.close();//창닫기
		
		return vos;
	}
	
	// 크롤링연습 처리(selenium) - SRT 열차 조회하기
	@ResponseBody
	@RequestMapping(value = "/crawling/train", method = RequestMethod.POST)
	public List<HashMap<String, Object>> trainPost(HttpServletRequest request, String stationStart, String stationStop) {
		List<HashMap<String, Object>> array = new ArrayList<HashMap<String,Object>>();
		try {
			WebDriver driver = new ChromeDriver();
			
      WebDriverManager.chromedriver().setup();			
			
			driver.get("http://srtplay.com/train/schedule");

			WebElement btnMore = driver.findElement(By.xpath("//*[@id=\"station-start\"]/span"));
			btnMore.click();
      try { Thread.sleep(2000);} catch (InterruptedException e) {}
      
      btnMore = driver.findElement(By.xpath("//*[@id=\"station-pos-input\"]"));
      btnMore.sendKeys(stationStart);
      btnMore = driver.findElement(By.xpath("//*[@id=\"stationListArea\"]/li/label/div/div[2]"));
      btnMore.click();
      btnMore = driver.findElement(By.xpath("//*[@id=\"stationDiv\"]/div/div[3]/div/button"));
      btnMore.click();
      try { Thread.sleep(2000);} catch (InterruptedException e) {}
      
      btnMore = driver.findElement(By.xpath("//*[@id=\"station-arrive\"]/span"));
      btnMore.click();
      try { Thread.sleep(2000);} catch (InterruptedException e) {}
      btnMore = driver.findElement(By.id("station-pos-input"));
      
      btnMore.sendKeys(stationStop);
      btnMore = driver.findElement(By.xpath("//*[@id=\"stationListArea\"]/li/label/div/div[2]"));
      btnMore.click();
      btnMore = driver.findElement(By.xpath("//*[@id=\"stationDiv\"]/div/div[3]/div/button"));
      btnMore.click();
      try { Thread.sleep(2000);} catch (InterruptedException e) {}

      btnMore = driver.findElement(By.xpath("//*[@id=\"sr-train-schedule-btn\"]/div/button"));
      btnMore.click();
      try { Thread.sleep(2000);} catch (InterruptedException e) {}
      
      List<WebElement> timeElements = driver.findElements(By.cssSelector(".table-body ul.time-list li"));
 			
      HashMap<String, Object> map = null;
      
			for(WebElement element : timeElements){
				map = new HashMap<String, Object>();
				String train=element.findElement(By.className("train")).getText();
				String start=element.findElement(By.className("start")).getText();
				String arrive=element.findElement(By.className("arrive")).getText();
				String time=element.findElement(By.className("time")).getText();
				String price=element.findElement(By.className("price")).getText();
				map.put("train", train);
				map.put("start", start);
				map.put("arrive", arrive);
				map.put("time", time);
				map.put("price", price);
				array.add(map);
			}
			
      // 요금조회하기 버튼을 클릭한다.(처리 안됨 - 스크린샷으로 대체)
      btnMore = driver.findElement(By.xpath("//*[@id=\"scheduleDiv\"]/div[2]/div/ul/li[1]/div/div[5]/button"));
      //System.out.println("요금 조회버튼클릭");
      btnMore.click();
      try { Thread.sleep(2000);} catch (InterruptedException e) {}
      
      driver.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return array;
	}

	
	//웹(구글) 차트 연습1
	@GetMapping("/chart/chart1")
	public String chart1Get(Model model,
			@RequestParam(name = "part", defaultValue = "barV", required = false) String part
			) {
		model.addAttribute("part", part);
		return "study/chart/chart1";
	}
	
	//웹(구글) 차트 연습2
	@GetMapping("/chart2/chart2")
	public String chart2Get(Model model,
			@RequestParam(name = "part", defaultValue = "barV", required = false) String part
			) {
		model.addAttribute("part", part);
		return "study/chart2/chart2";
	}
	
	//웹(구글) 차트 연습2 차트출력
	@RequestMapping(value = "/chart2/googleChart2", method = RequestMethod.POST)
	public String googleChart2Post(Model model, ChartVo vo) {
		model.addAttribute("vo", vo);
		//System.out.println("vo=>"+ vo);
		return "study/chart2/chart2";
	}
	
	
	@RequestMapping(value = "/chart2/googleChart2Recently", method = RequestMethod.GET )
	public String googleChart2RecentlyGet(Model model, ChartVo vo) {
		System.out.println("part : " + vo.getPart());
		
		List<ChartVo> vos = null;
		if(vo.getPart().equals("line")) {
			vos = studyService.getRecentlyVisitCount(1);

			// vos자료를 차트에 표시처리가 잘 되지 않을경우에는 각각의 자료를 다시 편집해서 차트로 보내줘야 한다.
			//이게 무슨 소리냐? vos로 그냥 넘겨도 되는데 지금 웹차트 방법자체가 애초에 값넣고 구글차트에서 차트변환시킨걸 가져오는거라 인터넷이 느릴경우
			//구글차트에서 차트변환된걸 가져오는게 제대로 안가져와져서 차트가 제대로 출력이 안될수있음 그렇기에
			//
			String[] visitDates = new String[7];
			int[] visitCounts = new int[7];
			
			for(int i=0; i<7; i++) {
				visitDates[i] = vos.get(i).getVisitDate();
				visitCounts[i] = vos.get(i).getVisitCount();
				System.out.println("visitDates["+i+"]=>"+visitDates[i]);
				System.out.println("visitCounts["+i+"]"+visitCounts[i]);
			}
			System.out.println("googleChart2RecentlyGet vo=>"+vo);
			
			model.addAttribute("vo", vo);//
			model.addAttribute("part", vo.getPart());
			model.addAttribute("xTitle", "방문날짜");
			model.addAttribute("regend", "하루 총 방문자수");
			
			model.addAttribute("visitDates", visitDates);
			model.addAttribute("visitCounts", visitCounts);
			model.addAttribute("title", "최근 7일간 방문횟수");
			model.addAttribute("subTitle", "(최근 7일간 방문한 해당일자의 방문자 총수를 표시합니다.");
		}
		return "study/chart2/chart2";
	}
	
	
	
	
	
	
	
	
	
}
