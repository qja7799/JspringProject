<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>memberJoin.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <script src="${ctp}/js/woo.js"></script>
  <script>
    'use strict';
  
  	// 정규식정의...(아이디,닉네임(한글/영문,숫자,밑줄),성명(한글/영문),이메일,전화번화({2,3}/{3,4}/{4}))
  	// 아이디: 영문 대소문자, 숫자, _ 포함, 4~20자
	let regMid = /^[a-zA-Z0-9_]{4,20}$/; 
	
	// 비밀번호: 영문, 숫자, 특수문자(@$!%*?&) 포함, 8~20자
	let regPwd = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$/; 
	
	// 닉네임: 한글, 영문, 숫자 포함, 2~10자
	let regNick = /^[a-zA-Z0-9가-힣]{2,10}$/; 
	
	// 이름: 한글만 가능, 2~5자
	let regName = /^[가-힣]{2,5}$/; 
	
	// 이메일: 일반적인 이메일 형식 ↓
	//^[a-zA-Z0-9._%+-] => @ 앞의 사용자 이름 (영문 대소문자, 숫자, ._%+- 가능)
	//@[a-zA-Z0-9.-] => @반드시 포함, @뒤에 (영문대소문자, 숫자, .- 가능)
	// \. => .이 반드시 포함되어야 함
	//[a-zA-Z]{2,}$ => .이후 마지막자리(도메인주소)는 영문대소문자 최소 2글자 이상 (kr, com, io 등)
	let regEmail = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/; 

	// 전화번호: (000-0000-0000 또는 00-000-0000 형식)
	let regTel = /^\d{2,3}-\d{3,4}-\d{4}$/; 
	
	
	//중복체크 실행했는지 확인용 변수
	let isIdChecked = false; // idCheck() 실행 여부를 저장하는 변수
	let isNickChecked = false; // nickCheck() 실행 여부를 저장하는 변수
	let isFileChecked = false; // 파일업로드() 실행 여부를 저장하는 변수
	
    // 회원가입에 필요한 정보 체크(정규식)
    function fCheck() {
    	let mid = myform.mid.value.trim();
    	let pwd = myform.pwd.value.trim();
    	let nickName = myform.nickName.value.trim();
    	let name = myform.name.value.trim();
    	
    	let tel1 = myform.tel1.value.trim();
    	let tel2 = myform.tel2.value.trim();
    	let tel3 = myform.tel3.value.trim();
    	let tel = tel1 + "-" + tel2 + "-" + tel3;
    	
    	let email1 = myform.email1.value.trim();
    	let email2 = myform.email2.value.trim();
    	let email = email1 + "@" + email2;
    	console.log("처음 email=>", email);
    	let postcode = myform.postcode.value + " ";
    	let roadAddress = myform.roadAddress.value + " ";
    	let detailAddress = myform.detailAddress.value + " ";
    	let extraAddress = myform.extraAddress.value + " ";
    	let address = postcode + "/" + roadAddress + "/" + detailAddress + "/" + extraAddress;
    	
    	let submitFlag = 0;
    	
    	// 아이디,비번,닉네임,이름,이메일 유효성검사   	
    	if(!regMid.test(mid)) {
    		alert("아이디는 4~20자리의 영문 대/소문자와 숫자, 언더바(_)만 가능합니다.");
    		myform.mid.focus();
    		return false;
    	}
    	else if(!regPwd.test(pwd)) {
    		alert("비밀번호는 영문, 숫자, 특수문자(@$!%*?&) 포함, 8~20자만 가능합니다");
    		myform.pwd.focus();
    		return false;
    	}
    	else if(!regNick.test(nickName)) {
    		alert("닉네임은 한글, 영문, 숫자 포함, 2~10자만 가능합니다.");
    		myform.nickName.focus();
    		return false;
    	}
    	else if(!regName.test(name)) {
    		alert("이름은 한글만 가능하며, 2~5자만 가능합니다.");
    		myform.name.focus();
    		return false;
    	}
    	else if(!regEmail.test(email)) {
    		alert("이메일 형식에 맞지않습니다. 다시 입력해주세요");
    		myform.email1.focus();
    		return false;
    	}else {
    		submitFlag = 1;
    	}	
    	
    	
    	if (tel2 !== "" && tel3 !== "") {
    	    let fullTel = tel1 + "-" + tel2 + "-" + tel3; // 전체 전화번호

    	    if (!regTel.test(fullTel)) {
    	        alert("전화번호 형식에 맞지않습니다. \n 다시 입력해주세요 (예: 000-0000-0000)");
    	        myform.tel2.focus();
    	        return false;
    	    }else {
    	    	submitFlag = 1;
			}
    	}else{
    		alert("전화번호를 입력해주세요");
    		myform.tel2.focus();
    		return false;
    	}

    	
    	
    	
    	// 앞에서 모든 항목에 대한 유효성검사를 마치면 중복체크(아이디/닉네임)부분 확인처리
    	if(submitFlag == 1) {
    		// 아이디 중복버튼체크
    		if (!isIdChecked) {
		        alert("아이디 중복 체크를 해주세요.");
		        document.getElementById("midBtn").focus();
		    }
    		// 닉네임 중복버튼체크
    		else if (!isNickChecked) {
		        alert("닉네임 중복 체크를 해주세요.");
		        document.getElementById("nickName").focus();
		    }
    		else if (!isFileChecked) {
		        alert("파일 체크를 해주세요.");
		        
		    }
    		else {
    			console.log("마지막 email=>", email);
     			myform.email.value = email;
	    		myform.tel.value = tel;
	    		myform.address.value = address; 
	    		
	    		myform.submit();
    		}
    	}
    	else {
    		alert("회원폼의 내용을 확인하세요");
    		return false;
    	}	
    }
    
	function imgCheck() {
		
		// 사진(jpg/gif/png)에 대한 체크, 용량은 1MByte 이내
		let fName = document.getElementById("file").value;
		let ext = fName.substring(fName.lastIndexOf(".")+1).toLowerCase();// 확장자명을 추출(밑에서 지정한 확장자가 아니면 펄스를 반환하게끔 함)
		let maxSize = 1024 * 1024; // 한번에 업로드할 파일의 최대용량을 1메가로 제한
		
		if(fName.trim() == ""){
			alert("업로드할 파일을 선택하세요");
			return false;
		}
		
    	let fileSize = document.getElementById("file").files[0].size;
    	if(fileSize > maxSize) {
    		alert("업로드할 파일의 최대용량은 1MByte입니다.");
    		return false;
    	}
    	else if(ext != "jpg" && ext != "gif" && ext != "png" && ext != "zip" && ext != "ppt" && ext != "pptx" && ext != "hwp") {
    		alert("업로드 가능파일은 'jpg/gif/png/zip/ppt/pptx/hwp' 입니다.");
    		return false;
    	}
    	else isFileChecked = true;
		
	}
	
    
    // 아이디 중복검사
    function idCheck() {
    	let mid = myform.mid.value;
    	
    	if(mid.trim() == "") {
    		alert("아이디를 입력하세요");
    		myform.mid.focus();
    	}
    	else {
    		$.ajax({
    			url  : "${ctp}/member/memberIdChcek",
    			type : "get",
    			data : {mid : mid},
    			success:function(res) {
    				if(res != '0') {
    					alert("이미 사용중인 아이디 입니다. 다시 입력하세요");
    					myform.mid.focus();
    					
    				}
    				else {
    					alert("사용 가능한 아이디 입니다.");
    					$("#mid").attr("readonly", true);//아이디수정불가로 변경
    					isIdChecked = true; 
    				}
    			},
    			error : function() { alert("전송오류!"); }
    		});
    	}
    }
    
    
    // 닉네임 중복검사
    function nickCheck() {
    	let nickName = myform.nickName.value;
    	
    	if(nickName.trim() == "") {
    		alert("닉네임을 입력하세요");
    		myform.nickName.focus();
    	}
    	else {
    		$.ajax({
    			url  : "${ctp}/member/memberNickChcek",
    			type : "get",
    			data : {nickName : nickName},
    			success:function(res) {
    				if(res != '0') {
    					alert("이미 사용중인 닉네임 입니다. 다시 입력하세요");
    					myform.nickName.focus();
    					 
    				}
    				else {
    					alert("사용 가능한 닉네임 입니다.");
    					$("#nickName").attr("readonly", true);//닉네임수정불가로 변경

    					isNickChecked = true;
    				}
    			},
    			error : function() { alert("전송오류!"); }
    		});
    	}
    }
    
    // 이메일 인증번호 받기
    function emailCertification() {
    	// 필수입력사항 유효성 체크 완료후 인증번호를 받는다.
    	let mid = myform.mid.value;
    	let pwd = myform.pwd.value;
    	let nickName = myform.nickName.value;
    	let name = myform.name.value;
    	let email1 = myform.email1.value.trim();
    	let email2 = myform.email2.value.trim();
    	let email = email1 + "@" + email2;
    	
    	if(email1.trim() == "") {
    		alert("이메일을 입력해주세요");
    		myform.email1.focus();
    		return false;
    	}
    	else if(!regEmail.test(email)) {
    		alert("이메일 형식에 맞지않습니다. 다시 입력해주세요");
    		myform.email1.focus();
    		return false;
    	}
    	else if (!isIdChecked) {
	        alert("아이디 중복 체크를 해주세요.");
	        document.getElementById("midBtn").focus();
	        return false;
	    }
		else if (!isNickChecked) {
	        alert("닉네임 중복 체크를 해주세요.");
	        document.getElementById("nickName").focus();
	        return false;
	    }
		else if(pwd.trim() == "") {
    		alert("비밀번호를 입력해주세요");
    		myform.pwd.focus();
    		return false;
    	}
    	else if(name.trim() == "") {
    		alert("이름을 입력해주세요");
    		myform.name.focus();
    		return false;
    	}
    	
    	
    	
    	//로딩스피너 띄우기 / emailCertification실행끝나면 저절로 사라지는게 맞는듯 
    	//emailCeritificationOk에서 하이드시키는데 emailCeritificationOk 실행도 안했는데 emailCertification가 끝나면 저절로 사라짐
    	let spinner = "<div class='text-center'><div class='spinner-border'></div> 메일 발송중입니다. 잠시만 기다려주세요. <div class='spinner-border'></div></div>";
    	$("#demo").html(spinner);
    	
    	// 인증번호 보내기
    	$.ajax({
    		url  : "${ctp}/member/memberEmailCheck",
    		type : "post",
    		data : {email : email},
    		success:function(res) {
    			if(res != '0') {
    				alert("인증번호가 발송되었습니다.\n메일 확인후 인증번호를 아래에 입력해 주세요.");
    				let str = '<div class="input-group">';
    				str += '<input type="text" name="checkKey" id="checkKey" class="form-control"/>';
    				str += '<input type="button" value="인증번호확인" onclick="emailCeritificationOk()" class="btn btn-primary btn-sm"/>';
    				str += '</div>';
    				$("#demo").html(str);
    			}
    			else alert("인증확인버튼을 다시 눌러주세요.");
    		},
    		error : function() { alert("전송오류!"); }
    	});
    }
    
    // 인증번호 검사
    function emailCeritificationOk() {
    	let checkKey = $("#checkKey").val();
    	if(checkKey.trim() == "") {
	    	alert("전송받은 메일에서 인증받은 키를 입력해주세요.");
    		$("#checkKey").focus();
    		return false;
    	}
    	
    	// ajax처리한다.
    	$.ajax({
    		url  : "${ctp}/member/memberEmailCheckOk",
    		type : "get",
    		data : {checkKey : checkKey},
    		success:function(res) {
    			if(res != '0') {
    				alert("인증번호가 일치합니다");			
    		    	
    		    	$("#demo").hide();
    		    	$("#certificationBtn").hide();
    		    	$("#addContent").show();
    			}
    			else {
    				alert("인증번호가 일치하지않습니다");
    				return false;
    			}
    		},
    		error : function() { alert("전송오류!");}
    	});
    }
    
    //리셋버튼 클릭시
    function freset() {
    	//중복체크 초기화
    	isIdChecked = false; 
    	isNickChecked = false; 
    	isFileChecked = false;
    	
    	//아이디 닉네임 수정불가해제
    	$("#nickName").attr("readonly", false);
    	$("#mid").attr("readonly", false);

	}
    
    $(document).ready(function() {
        $("#toggleBtn").click(function() {
            $("#chooseContent").toggle();
        });
    });
    
  </script>
  <style type="text/css">
  	
  
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
	<form name="myform" method="post" enctype="multipart/form-data">
  	<table class="table table-bordered text-center">
      <tr>
        <td colspan="2"><font size="5">회 원 가 입</font></td>
      </tr>
      <tr>
        <th>아이디</th>
        <td>
          <div class="input-group">
	          <input type="text" name="mid" id="mid" placeholder="아이디를 입력하세요" autofocus required class="form-control" />
	          <input type="button" value="아이디중복체크" id="midBtn" onclick="idCheck()" class="btn btn-secondary btn-sm"/>
          </div>
        </td>
      </tr>
      <tr>
        <th>비밀번호</th>
        <td><input type="password" name="pwd" id="pwd" placeholder="비밀번호를 입력하세요." required class="form-control" /></td>
      </tr>
      <tr>
        <th>닉네임</th>
        <td>
          <div class="input-group">
	          <input type="text" name="nickName" id="nickName" placeholder="닉네임을 입력하세요" required class="form-control" />
	          <input type="button" value="닉네임중복체크" id="nickNameBtn" onclick="nickCheck()" class="btn btn-secondary btn-sm"/>
          </div>
        </td>
      </tr>
      <tr>
        <th>성명</th>
        <td><input type="text" name="name" id="name" placeholder="성명을 입력하세요" required class="form-control" /></td>
      </tr>
      <tr>
        <th>성별</th>
        <td>
        	<input type="radio" name="gender" id="gender1" value="남자" />남자 &nbsp;
        	<input type="radio" name="gender" id="gender2" value="여자" checked />여자
        </td>
      </tr>
      <tr>
        <th>이메일</th>
        <td>
          <div class="input-group">
	          <input type="text" name="email1" id="email1" class="form-control" required />@
	          <select name="email2" id="email2" class="form-select">
	          	<option>naver.com</option>
	          	<option>hanmail.net</option>
	          	<option>gmail.com</option>
	          	<option>daum.net</option>
	          	<option>yahoo.com</option>
	          	<option>hatmail.com</option>
	          	<option>nate.com</option>
	          </select>
          </div>
        </td>
      </tr>
      <!--  -->
  <tr>
    <td colspan="2">
      <input type="button" value="인증번호받기" onclick="emailCertification()" id="certificationBtn" class="btn btn-success btn-sm" />
    </td>
  </tr>
        <tr><td colspan="2"><div id="demo"></div></td></tr>
  <tr>
    <td colspan="2">
          <button type="button" id="toggleBtn" class="btn btn-warning btn-sm">선택사항입력란 보이기</button>
    </td>
  </tr>
  <tr style="border-bottom: 3px solid red;"><td colspan="2"><div></div></td></tr>
  <tbody id="chooseContent" style="display: none; border: 1px solid red;">
  <tr>
    <th>직업</th>
    <td>
      <select  name="job" class="form-control">
        <option>학생</option>
        <option>회사원</option>
        <option>공무원</option>
        <option>군인</option>
        <option>자영업</option>
        <option>의사</option>
        <option>법조인</option>
        <option>세무인</option>
        <option>가사</option>
        <option selected>기타</option>
      </select>
    </td>
  </tr>
  <tr>
    <th>취미</th>
    <td>
      <input type="checkbox" name="hobby" value="등산">등산
      <input type="checkbox" name="hobby" value="낚시">낚시
      <input type="checkbox" name="hobby" value="바둑">바둑
      <input type="checkbox" name="hobby" value="수영">수영
      <input type="checkbox" name="hobby" value="독서">독서
      <input type="checkbox" name="hobby" value="승마">승마
      <input type="checkbox" name="hobby" value="영화감상">영화감상
      <input type="checkbox" name="hobby" value="축구">축구
      <input type="checkbox" name="hobby" value="농구">농구
      <input type="checkbox" name="hobby" value="배구">배구
      <input type="checkbox" name="hobby" value="기타" checked>기타
    </td>
  </tr>
  <tr>
    <th>자기소개</th>
    <td>
      <textarea rows="5" class="form-control" name="content" placeholder="자기소개를 입력하세요."></textarea>
    </td>
  </tr>
  <tr>
    <th>주소</th>
    <td>
      	<div class="form-group">
	        <div class="input-group">
	            <input type="text" name="postcode" id="sample6_postcode" placeholder="우편번호" class="form-control">
				<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기" class="btn btn-info">
			</div>
			<input type="text" name="roadAddress" id="sample6_address" placeholder="주소" class="form-control">
			<div class="input-group">
				<input type="text" name="detailAddress" id="sample6_detailAddress" placeholder="상세주소" class="form-control">
				<input type="text" name="extraAddress" id="sample6_extraAddress" placeholder="참고항목" class="form-control">
			</div>
		</div>
    </td>
  </tr>
  <tr>
    <th>정보공개</th>
    <td>
    	<input type="radio" name="userInfor" id="userInfor1" value="공개" checked />공개 &nbsp;
    	<input type="radio" name="userInfor" id="userInfor2" value="비공개" />비공개
    </td>
  </tr>
  </tbody>
   <!--    <tbody id="addContent" style="display:none"> -->
      <tbody id="addContent" style="display: none;" >
	      <tr>
	        <th>생일</th>
	        <td><input type="date" name="birthday" id="birthday" value="<%=java.time.LocalDate.now()%>" class="form-control" /></td>
	      </tr>
	      <tr>
	        <th>전화번호</th>
	        <td>
	          <div class="input-group">
		          <select name="tel1" class="form-select">
		            <option value="010" selected>010</option>
		            <option value="02">서울</option>
		            <option value="031">경기</option>
		            <option value="032">인천</option>
		            <option value="041">충남</option>
		            <option value="042">대전</option>
		            <option value="043">충북</option>
		            <option value="051">부산</option>
		            <option value="052">울산</option>
		            <option value="051">부산</option>
		            <option value="054">경북</option>
		            <option value="055">경남</option>
		            <option value="061">전남</option>
		            <option value="062">광주</option>
		            <option value="063">전북</option>
		            <option value="064">제주</option>
		          </select>-
		          <input type="text" name="tel2" id="tel2" class="form-control" />-
		          <input type="text" name="tel3" id="tel3" class="form-control" />
	          </div>
	        </td>
	      </tr>

	      <tr>
		    <th>회원사진</th>
		    <td>
		      <input type="file" name="fName" id="file" onchange="imgCheck(this)" class="form-control" />
		    </td>
		  </tr>
	      <tr>
	        <td colspan="2">
	          <input type="button" value="회원가입" onclick="fCheck()" class="btn btn-success me-2"/>
	          <input type="reset" value="다시입력" onclick="freset()" class="btn btn-warning me-2"/>
	          <input type="button" value="돌아가기" onclick="location.href='${ctp}/user/userMain';" class="btn btn-primary"/>
	          <input type="hidden" name="email" />
		      <input type="hidden" name="tel" />
		      <input type="hidden" name="address" />
	        </td>
	      </tr>
      </tbody>
    </table>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>