<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>selenium.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    function crawling1() {
    	let url = document.getElementById("url").value;
    	let searchString = $("#searchString").val();
    	
    	if(url.trim() == "" || searchString.trim() == "") {
    		alert("크롤링할 주소와 검색어를 입력하세요");
    		return false;
    	}
    	
    	$.ajax({
    		url  : "selenium1",
    		type : "post",
    		data : {
    			url : url,
    			searchString : searchString
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
    
    //cgv 영화목록가져오기
    function crawling2() {
    	$("#spinnerIcon").show();
    	
    	$.ajax({
    		url  : "selenium2",
    		type : "post",
    		success:function(vos) {
    			if(vos != "") {
    				let str = '<table class="table table-bordered text-center">';
    				str += '<tr class="table-secondary"><th>번호</th><th>영화제목</th><th>포스터</th><th>예매율</th></tr>';
    				for(let i=0; i<vos.length; i++) {
	    				str += '<tr>';
    					str += '<td>'+(i+1)+'</td>';
    					str += '<td>'+vos[i].title+'</td>';
    					str += '<td>'+vos[i].image+'</td>';
    					str += '<td>'+vos[i].tiketPercent+'</td>';
	    				str += '</tr>';
    				}
    				str += '<tr><td colspan="4" class="p-0 m-0"></td></tr>';
    				str += '</table>';
	    			$("#demo").html(str);
    			}
    			else $("#demo").html("검색된 자료가 없습니다.");
    		},
    		error : function() { alert("전송오류!"); }
    	});
    }
    
    //멜론뮤직
    function crawling3() {
    	$("#spinnerIcon").show();
    	
    	$.ajax({
    		url  : "selenium3",
    		type : "post",
    		success:function(vos) {
    			if(vos != "") {
    				let str = '<table class="table table-bordered text-center">';
    				str += '<tr class="table-secondary"><th>번호</th><th>커버이미지</th><th>곡이름</th><th>앨범이름</th><th>가수이름</th><th>좋아요수</th></tr>';
    				for(let i=0; i<vos.length; i++) {
	    				str += '<tr>';
    					str += '<td>'+(i+1)+'</td>';
    					str += '<td>'+vos[i].coverImage+'</td>';
    					str += '<td>'+vos[i].musicName+'</td>';
    					str += '<td>'+vos[i].albumName+'</td>';
    					str += '<td>'+vos[i].singer+'</td>';
    					str += '<td>'+vos[i].likeCnt+'</td>';
	    				str += '</tr>';
    				}
    				str += '<tr><td colspan="6" class="p-0 m-0"></td></tr>';
    				str += '</table>';
	    			$("#demo").html(str);
    			}
    			else $("#demo").html("검색된 자료가 없습니다.");
    		},
    		error : function() { alert("전송오류!"); }
    	});
    }
    
    // SRT 열차 시간 조회
    function crawlingCheck() {
    	$("#spinnerIcon").show();
    	let stationStart = $("#stationStart").val();
    	let stationStop = $("#stationStop").val();
    	
    	$.ajax({
				url   : "${ctp}/study/crawling/train",
				type  : "post",
				data  : {
					stationStart : stationStart,
					stationStop : stationStop
				},
    		success:function(vos) {
    			if(vos != "") {
    				let str = '';
    				str += '<table class="table table-bordered text-center"><tr class="table-dark text-dark"><th>열차</th><th>출발</th><th>도착</th><th>소요시간</th><th>요금</th></tr>';
    				for(let i=0; i<vos.length; i++) {
	    				str += '<tr>';
	    				str += '<td>'+vos[i].train+'</td>';
	    				str += '<td>'+vos[i].start+'</td>';
	    				str += '<td>'+vos[i].arrive+'</td>';
	    				str += '<td>'+vos[i].time+'</td>';
	    				str += '<td><a href="${ctp}/data/ckeditor/screenshot.png" target="_blank">'+vos[i].price+'</a></td>';
	    				str += '</tr>';
    				}
    				str += '</tr></table>';
    				$("#demo").html(str);
    				
	  				$("#spinnerIcon").hide();
    			}
    			else $("#demo").html("검색한 자료가 없습니다.");
    		}
    	});
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>SELENIUM 연습</h2>
  <hr class="border-secondary">
  <div><a href="javascript:location.reload()" class="btn btn-warning form-control">다시검색</a></div>
  <hr class="border-secondary">
  <form name="myform">
    <h4>1.구글 이미지 검색하기</h4>
    <div class="input-group mb-3">
      <div class="input-group-text">URL주소 입력</div>
      <input type="text" name="url" id="url" value="https://www.google.com/imghp?hl=ko&authuser=0&ogbl" class="form-control"/>
    </div>
    <div class="input-group mb-3">
      <div class="input-group-text">검색어 입력</div>
      <input type="text" name="searchString" id="searchString" value="아이유" class="form-control"/>
      <input type="button" value="검색1" onclick="crawling1()" class="btn btn-success me-1"/>
    </div>
    <hr class="border-secondary">
  </form>
  
  <hr class="border-secondary">
  <div id="demo"></div>
  <hr class="border-secondary">
  <h4>CGV 상영관 무비차트</h4>
  <div class="input-group mb-3">
    <div class="input-group-text">CGV 상영관 무비챠트</div>
    <input type="button" value="크롤링2" onclick="crawling2()" class="btn btn-success"/>
    <div class="input-group-append">
      <span id="spinnerIcon" style="display:none">
	      <span class="spinner-border"></span>
	      &nbsp;&nbsp; 검색중입니다. &nbsp;&nbsp;
	      <span class="spinner-border"></span>
      </span>
    </div>
  </div>
  
  <hr class="border-secondary">
  <h4>멜론뮤직 크롤링</h4>
  <div class="input-group mb-3">
    <div class="input-group-text">멜론뮤직</div>
    <input type="button" value="크롤링3" onclick="crawling3()" class="btn btn-success"/>
    <div class="input-group-append">
      <span id="spinnerIcon" style="display:none">
	      <span class="spinner-border"></span>
	      &nbsp;&nbsp; 검색중입니다. &nbsp;&nbsp;
	      <span class="spinner-border"></span>
      </span>
    </div>
  </div>
  <hr class="border">
  
  
  <hr class="border">
  <h4>SRT 승차권 조회</h4>
  <form name="trainform">
    <div class="input-group mb-3">
      <span class="input-group-text mr-2">출발역</span>
      <div class="input-group-append mr-3"><input type="text" name="stationStart" id="stationStart" value="대전" class="form-control"/></div>
      ~
      <span class="input-group-text ml-3 mr-2">도착역</span>
      <div class="input-group-append"><input type="text" name="stationStop" id="stationStop" value="부산" class="form-control"/></div>
    </div>
	  <div class="input-group mb-3">
	    <div class="input-group-prepend"><input type="button" value="새로고침" onclick="location.reload()" class="btn btn-info" /></div>
	    <span class="input-group-text" style="width:50%">SRT 열차 시간표 조회</span>
	    <div class="input-group-append mr-1"><input type="button" value="웹크롤링2" onclick="crawlingCheck()" class="btn btn-success" /></div>
	    <div class="input-group-append"><span id="spinnerIcon" style="display:none"><span class="spinner-border"></span>검색중입니다.<span class="spinner-border"></span></span></div>
	  </div>
	  <hr class="border">
  </form>
  <hr class="border">
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