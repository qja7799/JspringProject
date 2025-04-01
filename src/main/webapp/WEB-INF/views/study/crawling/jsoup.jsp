<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>jsoup.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <style type="text/css">
  a{ text-decoration: none;}
  </style>
  <script>
    'use strict';
    
    function crawling1() {
    	let url = document.getElementById("url").value;
    	let selector = $("#selector").val();
    	
    	if(url.trim() == "" || selector.trim() == "") {
    		alert("크롤링할 주소와 선택자를 입력하세요");
    		return false;
    	}
    	
    	$.ajax({
    		url  : "jsoup",
    		type : "post",
    		data : {
    			url : url,
    			selector : selector
    		},
    		success:function(res) {
    			if(res != "") {
    				$("#demo").html(res);
    			}
    			else $("#demo").html("검색된 자료가 없습니다.");
    		},
    		error : function() { alert("전송오류!!!"); }
    	});
    }
    
    function crawling2() {
    	let url = document.getElementById("url").value;
    	let selector = $("#selector").val();
    	
    	if(url.trim() == "" || selector.trim() == "") {
    		alert("크롤링할 주소와 선택자를 입력하세요");
    		return false;
    	}
    	
    	$.ajax({
    		url  : "jsoup2",
    		type : "post",
    		data : {
    			url : url,
    			selector : selector
    		},
    		success:function(res) {
    			console.log("res",res);
    			if(res != "") {
    				let str = '';
    				for(let i=0; i<res.length; i++) {
    					str += res[i] + "<br/>";
    				}
    				$("#demo").html(str);
    			}
    			else $("#demo").html("검색된 자료가 없습니다.");
    		},
    		error : function() { alert("전송오류!!!"); }
    	});
    }
    
    function crawling3() {
    	let url = document.getElementById("url3").value;
    	let selector = $("#selector3").val();
    	
    	if(url.trim() == "" || selector.trim() == "") {
    		alert("크롤링할 주소와 선택자를 입력하세요");
    		return false;
    	}
    	
    	$.ajax({
    		url  : "jsoup3",
    		type : "post",
    		data : {
    			url : url,
    			selector : selector
    		},
    		success:function(res) {
    			console.log("res",res);
    			if(res != "") {
    				let str = '';
    				for(let i=0; i<res.length; i++) {
    					str += res[i] + "<br/>";
    				}
    				$("#demo").html(str);
    			}
    			else $("#demo").html("검색된 자료가 없습니다.");
    		},
    		error : function() { alert("전송오류!!!"); }
    	});
    }
    
    function crawling4() {
    	//let url = myform.name.url4.value;
    	let searchString = document.getElementById("searchString").value;
    	let page = $("#page").val();
    	let searchSelector = $("#selector4").val();
    	
    	if(searchString.trim() == "" || page.trim() == "") {
    		alert("크롤링할 검색어와 검색페이지를 입력하세요");
    		return false;
    	}
    	let startPage = page*15 + 1;//주의! 네이버는 검색결과나올때 1페이지는 페이지가 0이고 2페이지부터 시작임 
    	//고로 page값으로 2를 넣어서 2*15 + 1 = 31인데 3페이지부터 시작이 아니라 4페이지부터 시작임 왜냐면 2페이지부터 15개씩 불러오니까
    	let search = "https://search.naver.com/search.naver?nso=&page="+page+"&query="+searchString+"&sm=tab_pge&start="+startPage+"&where=web";
    	
    	$.ajax({
    		url  : "jsoup4",
    		type : "post",
    		data : {
    			search : search,
    			searchSelector : searchSelector
    		},
    		success:function(res) {
    			console.log("res",res);
    			if(res != "") {
    				let str = '';
    				for(let i=0; i<res.length; i++) {
    					str += res[i] + "<br/>";
    				}
    				$("#demo").html(str);
    			}
    			else $("#demo").html("검색된 자료가 없습니다.");
    		},
    		error : function() { alert("전송오류!!!"); }
    	});
    }
    
    function crawling5() {
    	let url = myform.url5.value;
    	
    	if(url.trim() == "") {
    		alert("크롤링할 주소를 입력하세요");
    		return false;
    	}
    	//타이틀,사진,언론사
    	let selector = "a.link_txt.valid_link/a.link_thumb/span.info_thumb";
    	
    	$.ajax({
    		url  : "jsoup5",
    		type : "post",
    		data : {
    			url : url,
    			selector : selector
    		},
    		success:function(allstr) {
    			console.log("allstr",allstr);
    			if(allstr != "") {
    			    let output = "";
    			    let maxLength = Math.max(allstr[0].length, allstr[1].length, allstr[2].length); // 가장 긴 리스트 길이 구하기

    			    for (let i = 0; i < maxLength; i++) {
    			        let title = allstr[0][i] || "";   // titleVos에서 i번째 항목
    			        let image = allstr[1][i] || "";   // imageVos에서 i번째 항목
    			        let broadcast = allstr[2][i] || ""; // broadcastVos에서 i번째 항목
    			        
    			        // 각 항목을 한 줄로 출력
    			        output += '<p>제목: '+title+' - 이미지: '+image+' - 방송사: '+broadcast+'</p>';
    			    }
    			    
    			    //
    				$("#demo").html(output);
    			}
    			else $("#demo").html("검색된 자료가 없습니다.");
    		},
    		error : function() { alert("전송오류!!!"); }
    	});
    }
    
    //멜론차트
    function crawling6() {
    	$.ajax({
    		url  : "jsoup6",
    		type : "post",
    		success:function(allstr) {
    			console.log("allstr",allstr);
    			if(allstr != "") {
    			    let maxLength = Math.max(allstr[0].length, allstr[1].length, allstr[2].length, allstr[3].length); // 가장 긴 리스트 길이 구하기
    				let str = '<table class="table table-bordered text-center">';
    				str += '<tr class="table-secondary"><th>번호</th><th>커버이미지</th><th>곡이름</th><th>앨범이름</th><th>가수이름</th></tr>';
    			    for (let i = 0; i < maxLength; i++) {
    			        let coverImage = allstr[0][i] || "";   
    			        let musicName = allstr[1][i] || "";   
    			        let albumName = allstr[2][i] || ""; 
    			        let singer = allstr[3][i] || ""; 
    			        
	    				str += '<tr>';
    					str += '<td>'+(i+1)+'</td>';
    					str += '<td>'+coverImage+'</td>';
    					str += '<td>'+musicName+'</td>';
    					str += '<td>'+albumName+'</td>';
    					str += '<td>'+singer+'</td>';
	    				str += '</tr>';
						
    			    }
    			    
    				str += '<tr><td colspan="5" class="p-0 m-0"></td></tr>';
    				str += '</table>';
	    			$("#demo").html(str);
  
    			}
    			else $("#demo").html("검색된 자료가 없습니다.");
    		},
    		error : function() { alert("전송오류!!!"); }
    	});
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>JSOUP 연습</h2>
  <hr class="border-secondary">
  <div><a href="javascript:location.reload()" class="btn btn-warning form-control">다시검색</a></div>
  <hr class="border-secondary">
  <form name="myform">
    <h4>네이버 뉴스 제목 검색하기</h4>
    <div class="input-group mb-3">
      <div class="input-group-text">URL주소 입력</div>
      <input type="text" name="url" id="url" value="https://news.naver.com/" class="form-control"/>
    </div>
    <div class="input-group mb-3">
      <div class="input-group-text">셀렉터 입력</div>
      <input type="text" name="selector" id="selector" value="strong.cnf_news_title" class="form-control"/>
      <input type="button" value="검색1" onclick="crawling1()" class="btn btn-success me-1"/><!-- 문자로 값넘겨받기 -->
      <input type="button" value="검색2" onclick="crawling2()" class="btn btn-success me-1"/><!-- 객체타입(list)으로 값넘겨받기 -->
    </div>
    <hr class="border-secondary">
    <h4>네이버 뉴스사진 검색하기</h4>
    <div class="input-group mb-3">
      <div class="input-group-text">URL주소 입력</div>
      <input type="text" name="url3" id="url3" value="https://news.naver.com/" class="form-control"/>
    </div>
    <div class="input-group mb-3">
      <div class="input-group-text">셀렉터 입력</div>
      <input type="text" name="selector3" id="selector3" value=".cnf_news_thumb" class="form-control"/>
   <!--    <input type="text" name="selector3_2" id="selector3_2" value="div.cc_clip_mw" class="form-control"/> -->
      <input type="button" value="검색3" onclick="crawling3()" class="btn btn-success me-1"/>
    </div>
    
    <hr class="border-secondary">
    <h4>네이버 검색어로 검색하기</h4>
    <div class="input-group mb-3">
      <div class="input-group-text">검색어 입력</div>
      <input type="text" name="searchString" id="searchString" value="아피차야차이파따마" class="form-control"/>
    </div>
    <div class="input-group mb-3">
      <div class="input-group-text">셀렉터 입력</div>
      <input type="text" name="selector4" id="selector4" value=".total_group" class="form-control"/>
    </div>
    <div class="input-group mb-3">
      <div class="input-group-text">출력페이지</div>
      <input type="text" name="page" id="page" value="0" class="form-control"/>
      <input type="button" value="검색4" onclick="crawling4()" class="btn btn-success me-1"/>
    </div>
    
    <hr class="border-secondary">
    <h4>다음(daum)엔터테이먼트페이지에서 검색어로 검색하기</h4>
    <div class="input-group mb-3">
      <div class="input-group-text">URL주소 입력</div>
      <input type="text" name="url5" id="url5" value="https://entertain.daum.net/" class="form-control"/>
      <input type="button" value="검색5" onclick="crawling5()" class="btn btn-primary me-1"/>
    </div>
    <hr class="border-secondary">
    
    <hr class="border-secondary">
    <h4>멜론차트 리스트검색하기</h4>
    <div class="input-group mb-3">
      <div class="input-group-text">멜론차트 나와라</div>
      <input type="button" value="검색6" onclick="crawling6()" class="btn btn-primary me-1"/>
    </div>
    <hr class="border-secondary">
    
  </form>
  
  <hr class="border-secondary">
  <div id="demo"></div>
  
    <h2>크롤링/스크래핑</h2>
  <pre>
  - 크롤링(crawling)은 웹 페이지의 정보를 자동으로 수집하고 저장하는 작업을 말한다.
    크롤링을 하는 소프트웨어를 크롤러(crawler)라고 부르며, 크롤러를 사용해 웹 사이트의 구조와 링크를 따라가며 데이터를 수집한다.
    인터넷에 존재하는 방대한 양의 정보를 사람이 일일히 파악하는 것이 불가능하다는 점에서 유용하며,
    데이터 분석팀, 마케팅팀, 고객 관리팀 등 다양한 산업군에서 새로운 인사이트를 찾기 위해 사용된다.
  - 스크래핑(scraping)은 특정 웹 페이지에서 필요한 정보만 선택적으로 추출하는 작업을 뜻한다.
  </pre>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>