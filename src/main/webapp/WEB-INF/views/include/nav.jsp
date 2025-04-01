<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<script>
  'use strict';
  
  function deleteCheck() {
	  let ans = confirm("정말 탈퇴 하실겁니까?");
	  if(ans) {
		  ans = confirm("탈퇴후 1달간 같은 아이디로 재가입할수 없습니다.\n\n계속 진행할까요?");
		  if(ans) location.href = "${ctp}/member/pwdCheck/d";<!-- 쿼리스트링이 아니라 패스밸리어블이용 -->
	  }
  }
</script>
<!-- Navbar -->
<div class="w3-top">
  <div class="w3-bar w3-black w3-card">
    <a class="w3-bar-item w3-button w3-padding-large w3-hide-medium w3-hide-large w3-right" href="javascript:void(0)" onclick="myFunction()" title="Toggle Navigation Menu"><i class="fa fa-bars"></i></a>
    <a href="http://192.168.50.51:8090/JspringProject" class="w3-bar-item w3-button w3-padding-large">HOME</a>
    <a href="${ctp}/guest/guestList" class="w3-bar-item w3-button w3-padding-large w3-hide-small">Guest</a>
    <c:if test="${!empty sLevel}">
	    <a href="${ctp}/board/boardList" class="w3-bar-item w3-button w3-padding-large w3-hide-small">Board</a>
	    <a href="${ctp}/pds/pdsList" class="w3-bar-item w3-button w3-padding-large w3-hide-small">PDS</a>
	    <div class="w3-dropdown-hover w3-hide-small">
	      <button class="w3-padding-large w3-button" title="More">Study1 <i class="fa fa-caret-down"></i></button>     
	      <div class="w3-dropdown-content w3-bar-block w3-card-4">
	        <a href="${ctp}/user/userMain" class="w3-bar-item w3-button">SessionTempleat</a>
	        <a href="${ctp}/user2/userMain" class="w3-bar-item w3-button">Mybatis 연습</a>
	        <a href="${ctp}/study/ajax/ajaxForm" class="w3-bar-item w3-button">Ajax연습</a>
	        <a href="${ctp}/study/fileUpload/fileUpload" class="w3-bar-item w3-button">파일업로드연습</a>
	        <a href="${ctp}/study/mail/mailForm" class="w3-bar-item w3-button">메일 연습</a>
	        <a href="${ctp}/study/modal/modalForm" class="w3-bar-item w3-button">모달 연습</a>
	        <a href="${ctp}/study/calendar" class="w3-bar-item w3-button">인터넷 달력</a>
	      </div>
	    </div>
	    <div class="w3-dropdown-hover w3-hide-small">
	      <button class="w3-padding-large w3-button" title="More">Study2 <i class="fa fa-caret-down"></i></button>     
	      <div class="w3-dropdown-content w3-bar-block w3-card-4">
	        <a href="#" class="w3-bar-item w3-button">카카오맵</a>
	        <a href="#" class="w3-bar-item w3-button">날씨API</a>
	        <a href="#" class="w3-bar-item w3-button">웹차트</a>
	        <a href="${ctp}/study/crawling/jsoup" class="w3-bar-item w3-button">웹크롤링(jsoup)</a>
	        <a href="${ctp}/study/crawling/selenium" class="w3-bar-item w3-button">웹크롤링(selenium)</a>
	      </div>
	    </div>
	    <div class="w3-dropdown-hover w3-hide-small">
	      <button class="w3-padding-large w3-button" title="More" onclick="location.href='${ctp}/member/memberMain'">MyPage <i class="fa fa-caret-down"></i></button>     
	      <div class="w3-dropdown-content w3-bar-block w3-card-4">
	        <a href="${ctp}/schedule/schedule" class="w3-bar-item w3-button">일정관리</a>
	        <a href="${ctp}/member/memberList" class="w3-bar-item w3-button">회원리스트</a>
	        <a href="${ctp}/member/pwdCheck/p" class="w3-bar-item w3-button">비밀번호변경</a>
	        <a href="${ctp}/member/pwdCheck/u" class="w3-bar-item w3-button">회원정보수정</a>
	        <a href="javascript:deleteCheck()" class="w3-bar-item w3-button">회원탈퇴</a>
	        <c:if test="${sLevel == 0}"><a href="${ctp}/admin/adminMain" class="w3-bar-item w3-button">관리자메뉴</a></c:if>
	      </div>
	    </div>
	    <a href="${ctp}/member/memberLogout" class="w3-bar-item w3-button w3-padding-large w3-hide-small">Logout</a>
    </c:if>
    <c:if test="${empty sLevel}">
    	<a href="${ctp}/member/memberLogin" class="w3-bar-item w3-button w3-padding-large w3-hide-small">Login</a>
    <a href="${ctp}/member/memberJoin" class="w3-bar-item w3-button w3-padding-large w3-hide-small">Join</a>
    </c:if>
  </div>
</div>

<!-- Navbar on small screens (remove the onclick attribute if you want the navbar to always show on top of the content when clicking on the links) -->
<div id="navDemo" class="w3-bar-block w3-black w3-hide w3-hide-large w3-hide-medium w3-top" style="margin-top:46px">
  <a href="${ctp}/guest/guestList" class="w3-bar-item w3-button w3-padding-large" onclick="myFunction()">Guest</a>
  <a href="${ctp}/board/boardList" class="w3-bar-item w3-button w3-padding-large" onclick="myFunction()">Board</a>
  <a href="${ctp}/pds/pdsList" class="w3-bar-item w3-button w3-padding-large" onclick="myFunction()">PDS</a>
  <a href="${ctp}/member/memberLogin" class="w3-bar-item w3-button w3-padding-large" onclick="myFunction()">Login</a>
  <a href="${ctp}/member/memberLogout" class="w3-bar-item w3-button w3-padding-large" onclick="myFunction()">Logout</a>
  <a href="${ctp}/member/memberJoin" class="w3-bar-item w3-button w3-padding-large" onclick="myFunction()">Join</a>
</div>