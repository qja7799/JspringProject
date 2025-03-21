<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>adminLeft.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <style>
    a {text-decoration: none}
    a:hover {
      text-decoration: underline;
      color: orange;
    }
  </style>
</head>
<body style="background-color:#eee">
<div class="text-center">
  <div class="card m-1 p-1"><a href="${ctp}/admin/adminContent" target="adminContent">관리자메뉴</a></div>
  <div class="card m-1 p-1"><a href="${ctp}/" target="_top">홈으로</a></div>
  <div id="accordion">
    <div class="card m-1">
      <div class="card-header p-0"><a href="#one" class="btn" data-bs-toggle="collapse">게시글관리</a></div>
	    <div id="one">
	      <div class="card-body">
		      <div><a href="${ctp}/guest/guestList" target="adminContent">방명록리스트</a></div>
		      <div><a href="">게시판리스트</a></div>
		      <div><a href="">자료실리스트</a></div>
	      </div>
	    </div>
  	</div>
  </div>
  <div id="accordion">
    <div class="card m-1">
    	<div class="card-header p-0"><a href="#two" class="btn" data-bs-toggle="collapse">회원관리</a></div>
	    <div id="two">
	    	<div class="card-body">
		      <div><a href="${ctp}/admin/member/memberList" target="adminContent">회원리스트</a></div>
		      <div><a href="">신고리스트</a></div>
	      </div>
	    </div>
    </div>
  </div>
</div>
<p><br/></p>
</body>
</html>