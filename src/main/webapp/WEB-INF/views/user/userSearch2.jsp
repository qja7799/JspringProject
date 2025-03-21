<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>userSearch2.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    function idSearch(flag) {
    	let mid = document.getElementById("mid").value;
    	if(mid.trim() == "") {
    		alert("검색할 아이디를 입력하세요");
    		document.getElementById("mid").focus();
    	}
    	else {
    		if(flag == 's') location.href = "${ctp}/user/userSearchList?mid="+mid;
    		else location.href = "${ctp}/user/userSearchListOk?mid="+mid;
    	}
    }
  </script>
  <style>
    /* th {background-color: #ddd} */
  </style>
</head>
<body>
<p><br/></p>
<div class="container">
  <h2>개별 회원 조회</h2>
  <c:if test="${!empty vo}">
	  <hr/>
	  <table class="table table-bordered text-center border-secondary">
	  	<tr>
	  	  <th class="bg-secondary-subtle">아이디</th><td>${vo.mid}</td>
	  	</tr>
	  	<tr>
	  	  <th class="bg-secondary-subtle">비밀번호</th><td>${vo.pwd}</td>
	  	</tr>
	  	<tr>
	  	  <th class="bg-secondary-subtle">성명</th><td>${vo.name}</td>
	  	</tr>
	  	<tr>
	  	  <th class="bg-secondary-subtle">나이</th><td>${vo.age}</td>
	  	</tr>
	  	<tr>
	  	  <th class="bg-secondary-subtle">성별</th><td>${vo.gender}</td>
	  	</tr>
	  	<tr>
	  	  <th class="bg-secondary-subtle">주소</th><td>${vo.address}</td>
	  </table>
	  <hr/>
  </c:if>
  <c:if test="${!empty vos}">
		<table class="table table-hover text-center">
	    <tr class="table-secondary">
	      <th>번호</th>
	      <th>아이디</th>
	      <th>성명</th>
	      <th>비밀번호</th>
	      <th>나이</th>
	      <th>성별</th>
	      <th>주소</th>
	      <th>비고</th>
	    </tr>
	    <c:forEach var="vo" items="${vos}" varStatus="st">
	      <tr>
	        <td>${vo.idx}</td>
	        <td>${vo.mid}</td>
	        <td>${vo.name}</td>
	        <td>${vo.pwd}</td>
	        <td>${vo.age}</td>
	        <td>${vo.gender}</td>
	        <td>${vo.address}</td>
	        <td>
	          <a href="${ctp}/user/userUpdate?idx=${vo.idx}" class="badge bg-warning text-decoration-none">수정</a> /
	          <a href="javascript:delCheck(${vo.idx})" class="badge bg-danger text-decoration-none">삭제</a>
	        </td>
	      </tr>
	    </c:forEach>
	  </table>
  </c:if>
  <div class="input-group">
    <input type="text" name="mid" id="mid" placeholder="검색할 아이디를 입력하세요" autofocus class="form-control"/>
    <div class="input-group-append">
      <input type="button" value="아이디검색(완전일치)" onclick="idSearch('s')" class="btn btn-success ms-1 me-1"/>
    </div>
    <div class="input-group-append">
      <input type="button" value="아이디검색(부분일치)" onclick="idSearch('l')" class="btn btn-info"/>
    </div>
  </div>
</div>
<br/>
<div class="text-center"><a href="${ctp}/user/userMain" class="btn btn-warning">돌아가기</a></div>
<p><br/></p>
</body>
</html>