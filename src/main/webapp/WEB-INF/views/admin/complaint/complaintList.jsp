<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>complaintList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    function contentHide(contentIdx) {
    	let ans = confirm("해당 게시글을 감출까요?");
    	if(!ans) return false;
    	
    	$.ajax({
    		url  : "${ctp}/admin/complaint/contentChange",
    		type : "post",
    		data : {
    			contentIdx : contentIdx,
    			contentSw  : 'H',
    		},
    		success:function(res) {
    			if(res != "0") {
    				alert("해당 게시글을 화면에서 감추었습니다.");
    				location.reload();
    			}
    			else alert("작업 실패~~");
    		},
    		error : function() { alert("전송오류"); }
    	});
    }
  </script>
  <style>
    a {text-decoration: none}
    a:hover {
      text-decoration: underline;
      color: orange;
    }
  </style>
</head>
<body>
<p><br/></p>
<div class="container">
  <h2 class="text-center">신 고 리 스 트</h2>
  <table class="table table-hover text-center">
    <tr class="table-secondary">
      <th>번호</th>
      <th>분류</th>
      <th>글제목</th>
      <th>글쓴이</th>
      <th>신고자</th>
      <th>신고내역</th>
      <th>신고날짜</th>
      <th>표시여부</th>
    </tr>
    <c:set var="complaintCnt" value="${fn:length(vos)}"/>
    <c:forEach var="vo" items="${vos}" varStatus="st">
      <tr>
	    	<td>${complaintCnt}</td>
	    	<td>${vo.part}</td>
	    	<td><a href="">${vo.title}</a></td>
	    	<td>${vo.nickName}</td>
	    	<td>${vo.cpMid}</td>
	    	<td>${vo.cpContent}</td>
	    	<td>${vo.cpDate}</td>
	    	<td>
	    	  <c:if test="${vo.complaint == 'OK'}"><a href="javascript:contentHide(${vo.boardIdx})" class="badge bg-warning">감추기</a></c:if>
	    	  <c:if test="${vo.complaint != 'OK'}"><a href="" class="badge bg-success">보이기</a></c:if>/
	    	  <a href="" class="badge bg-danger">삭제</a>
	    	</td>
    	</tr>
    	<c:set var="complaintCnt" value="${complaintCnt - 1}"/>
    </c:forEach>
  </table>
</div>
<p><br/></p>
</body>
</html>