<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>memberUpdate.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <script src="${ctp}/js/woo.js"></script>
  <script>
    'use strict';
  
  	// 정규식정의...(아이디,닉네임(한글/영문,숫자,밑줄),성명(한글/영문),이메일,전화번화({2,3}/{3,4}/{4}))
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
	let isNickChecked = false; // nickCheck() 실행 여부를 저장하는 변수
	
    // 회원가입에 필요한 정보 체크(정규식)
    function fCheck() {
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
		if(!regNick.test(nickName)) {
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
    	
    	// 사진(jpg/gif/png)에 대한 체크, 용량은 2MByte 이내 - 사진은 공백이 아닐경우 체크해준다.
    	let fName = document.getElementById("file").value;
    	if(fName.trim() != "") {
	    	let ext = fName.substring(fName.lastIndexOf(".")+1).toLowerCase();
	    	let maxSize = 1024 * 1024 * 2;	// 한번에 업로드할 파일의 최대용량을 2MByte로 한정
	    	let fileSize = document.getElementById("file").files[0].size;
	    	
	    	if(fileSize > maxSize) {
	    		alert("업로드할 파일의 최대용량은 2MByte입니다.");
	    		return false;
	    	}// 확장자명을 추출(밑에서 지정한 확장자가 아니면 펄스를 반환하게끔 함)
	    	else if(ext != "jpg" && ext != "gif" && ext != "png") {
	    		alert("업로드 가능파일은 'jpg/gif/png' 입니다.");
	    		return false;
	    	}
	    	submitFlag = 1;
    	}
    	
    	
    	// 앞에서 모든 항목에 대한 유효성검사를 마치면 중복체크(아이디/닉네임)부분 확인처리
    	if(submitFlag == 1) {
    		// 닉네임 중복버튼체크
    		if (!isNickChecked) {
		        alert("닉네임 중복 체크를 해주세요.");
		        document.getElementById("nickName").focus();
		        return false;
		    }else{
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
    
    
    // 닉네임 중복검사
    function nickCheck() {
    	let nickName = myform.nickName.value;
    	
    	if(nickName.trim() == "") {
    		alert("닉네임을 입력하세요");
    		myform.nickName.focus();
    		return false;
    	}
    	else if(nickName.trim() == '${sNickName}') {
    		alert("현재 닉네임을 그대로 사용합니다.");
    		isNickChecked = true;
		    myform.nickName.readOnly = true;
		    return false;
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
    					myform.nickName.readOnly = true;
    					isNickChecked = true;
    				}
    			},
    			error : function() { alert("전송오류!"); }
    		});
    	}
    }
    
    //리셋버튼 클릭시
    function freset() {
    	//중복체크 초기화
    	isNickChecked = false; 
    	
    	//아이디 닉네임 수정불가해제
    	$("#nickName").attr("readonly", false);

	}
    
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
	          <input type="text" name="mid" id="mid" value="${sMid}" class="form-control" readonly/>
          </div>
        </td>
      </tr>
      <tr>
        <th>닉네임</th>
        <td>
          <div class="input-group">
	          <input type="text" name="nickName" id="nickName" value="${sNickName}" required class="form-control" />
	          <input type="button" value="닉네임중복체크" id="nickNameBtn" onclick="nickCheck()" class="btn btn-secondary btn-sm"/>
          </div>
        </td>
      </tr>
      <tr>
        <th>성명</th>
        <td><input type="text" name="name" id="name" value="${vo.name}" required class="form-control" /></td>
      </tr>
      <tr>
        <th>성별</th>
        <td>
        	<input type="radio" name="gender" id="gender1" value="남자" ${vo.gender == '남자' ? 'checked' : ""}/>남자 &nbsp;
        	<input type="radio" name="gender" id="gender2" value="여자" ${vo.gender == '여자' ? 'checked' : ""}  />여자
        </td>
      </tr>
      <tr>
        <th>이메일</th>
        <td>
          <div class="input-group">
          	  <c:set var="email" value="${fn:split(vo.email, '@')}"/>
	          <input type="text" name="email1" id="email1" value="${email[0]}" class="form-control" required />@
	          <select name="email2" id="email2" class="form-select">
				<option ${email[1]=='naver.com'   ? 'selected' : ''}>naver.com</option>
	          	<option ${email[1]=='hanmail.net' ? 'selected' : ''}>hanmail.net</option>
	          	<option ${email[1]=='gmail.com'   ? 'selected' : ''}>gmail.com</option>
	          	<option ${email[1]=='daum.net'    ? 'selected' : ''}>daum.net</option>
	          	<option ${email[1]=='yahoo.com'   ? 'selected' : ''}>yahoo.com</option>
	          	<option ${email[1]=='hatmail.com' ? 'selected' : ''}>hatmail.com</option>
	          	<option ${email[1]=='nate.com'    ? 'selected' : ''}>nate.com</option>
	          </select>
          </div>
        </td>
      </tr>
  <tr>
    <th class="bg-secondary-subtle">직업</th>
    <td>
      <select name="job" class="form-control">
        <option ${vo.job=='학생'  ? 'selected' : ''}>학생</option>
        <option ${vo.job=='회사원' ? 'selected' : ''}>회사원</option>
        <option ${vo.job=='공무원' ? 'selected' : ''}>공무원</option>
        <option ${vo.job=='군인'  ? 'selected' : ''}>군인</option>
        <option ${vo.job=='자영업' ? 'selected' : ''}>자영업</option>
        <option ${vo.job=='의사'  ? 'selected' : ''}>의사</option>
        <option ${vo.job=='법조인' ? 'selected' : ''}>법조인</option>
        <option ${vo.job=='세무인' ? 'selected' : ''}>세무인</option>
        <option ${vo.job=='가사'  ? 'selected' : ''}>가사</option>
        <option ${vo.job=='기타'  ? 'selected' : ''}>기타</option>
      </select>
    </td>
  </tr>
  <tr>
    <th>취미</th>
    <td>
    <!-- 위에서 한것처럼 하나하나 전부 el문으로 db에서 받아온값 확인해서 체크드 설정 넣어주는 방법을 써도되지만-->
    <!-- 그렇게하면 너무 귀찮기에 아래의 방법을 사용
    	취미는 db에 저장될때 등산,낚시,바둑 이런식으로 저장되잖아
    	일단 취미로 선택될수있는 모든 것들을 넣어서 배열을 만드는데(여기선 스플릿으로 배열을만들었음)
    	그렇게 만든 문자배열에서 문자열비교함수인 fn:contains를 사용하여 / 
    	fn:contains(a, b) => a문자열에 b문자열이 포함되면 트루를 반환  
    	vo.hobby(배열이 아닌 문자열임)가 등산,낚시,바둑 이라고하면
    	vo.hobby에 스플릿으로 만든 배열을 0부터 배열의 길이까지 반복해서 
    	vo.hobby에 스플릿배열안에 있는 문자가 포함되어있으면 트루반환시켜서 checked를 설정시키는 구조 
    	-->
    <c:set var="varHobbys" value="${fn:split('등산/낚시/바둑/수영/독서/승마/영화감상/축구/농구/배구/기타', '/')}"/>
	<c:forEach var="tempHobby" items="${varHobbys}" varStatus="st">
		<input type="checkbox" name="hobby" value="${tempHobby}" <c:if test="${fn:contains(vo.hobby,varHobbys[st.index])}">checked</c:if> /> ${tempHobby} &nbsp;
	</c:forEach>
    </td>
  </tr>
  <tr>
    <th>자기소개</th>
    <td>
      <textarea rows="5" name="content" class="form-control" placeholder="자기소개를 입력하세요.">${vo.content}</textarea>
    </td>
  </tr>
  <tr>
    <th>주소</th>
    <td>
      	<div class="form-group">
	        <div class="input-group">
	        	<c:set var="address" value="${fn:split(vo.address, '/')}"/>
	            <input type="text" name="postcode" id="sample6_postcode" value="${fn:trim(address[0])}" class="form-control">
				<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기" class="btn btn-info">
			</div>
			<input type="text" name="roadAddress" id="sample6_address" value="${fn:trim(address[1])}" class="form-control">
			<div class="input-group">
				<input type="text" name="detailAddress" id="sample6_detailAddress" value="${fn:trim(address[2])}" class="form-control">
				<input type="text" name="extraAddress" id="sample6_extraAddress" value="${fn:trim(address[3])}" class="form-control">
			</div>
		</div>
    </td>
  </tr>
  <tr>
    <th>정보공개</th>
    <td class="text-start">
    	<input type="radio" name="userInfor" id="userinfor1" value="공개"  ${vo.userInfor=='공개'   ? 'checked' : ''} />공개 &nbsp;
    	<input type="radio" name="userInfor" id="userinfor2" value="비공개" ${vo.userInfor=='비공개' ? 'checked' : ''} />비공개
    </td>
  </tr>
	      <tr>
	        <th>생일</th>
	        <td><input type="date" name="birthday" id="birthday" value="${fn:substring(vo.birthday, 0, 10)}" class="form-control" /></td>
	      </tr>
	      <tr>
	        <th>전화번호</th>
	        <td>
	          <div class="input-group">
           		  <c:set var="tel" value="${fn:split(vo.tel, '-')}"/>
		          <select name="tel1" class="form-select">
		            <option value="010" ${tel[0]=='010' ? 'selected' : ''}>010</option>
		            <option value="02"  ${tel[0]=='02'  ? 'selected' : ''}>서울</option>
		            <option value="031" ${tel[0]=='031' ? 'selected' : ''}>경기</option>
		            <option value="032" ${tel[0]=='032' ? 'selected' : ''}>인천</option>
		            <option value="041" ${tel[0]=='041' ? 'selected' : ''}>충남</option>
		            <option value="042" ${tel[0]=='042' ? 'selected' : ''}>대전</option>
		            <option value="043" ${tel[0]=='043' ? 'selected' : ''}>충북</option>
		            <option value="051" ${tel[0]=='051' ? 'selected' : ''}>부산</option>
		            <option value="052" ${tel[0]=='052' ? 'selected' : ''}>울산</option>
		            <option value="051" ${tel[0]=='051' ? 'selected' : ''}>부산</option>
		            <option value="054" ${tel[0]=='054' ? 'selected' : ''}>경북</option>
		            <option value="055" ${tel[0]=='055' ? 'selected' : ''}>경남</option>
		            <option value="061" ${tel[0]=='061' ? 'selected' : ''}>전남</option>
		            <option value="062" ${tel[0]=='062' ? 'selected' : ''}>광주</option>
		            <option value="063" ${tel[0]=='063' ? 'selected' : ''}>전북</option>
		            <option value="064" ${tel[0]=='064' ? 'selected' : ''}>제주</option>
		          </select>-
	        	  <input type="text" name="tel2" id="tel2" value="${fn:trim(tel[1])}" class="form-control" />-
		          <input type="text" name="tel3" id="tel3" value="${fn:trim(tel[2])}" class="form-control" />
	          </div>
	        </td>
	      </tr>

	      <tr>
		    <th>회원사진</th>
		    <td>
		      회원사진 : <img src="${ctp}/member/${vo.photo}" width="100px">
		      <input type="file" name="fName" id="file" class="form-control" />
		    </td>
		  </tr>
	      <tr>
	        <td colspan="2">
	          <input type="button" value="회원정보 수정" onclick="fCheck()" class="btn btn-success me-2"/>
	          <input type="reset" value="다시입력" onclick="freset()" class="btn btn-warning me-2"/>
	          <input type="button" value="돌아가기" onclick="location.href='${ctp}/user/userMain';" class="btn btn-primary"/>
	          <input type="hidden" name="email" />
		      <input type="hidden" name="tel" />
		      <input type="hidden" name="address" />
		      <input type="hidden" name="photo" id="photo" value="${vo.photo}" />
	        </td>
	      </tr>
    </table>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>