<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>boardContent.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    function delCheck() {
    	let ans = confirm("현재 게시글을 삭제 하시겠습니다.?");
    	if(ans) location.href = "boardDelete?idx=${vo.idx}";
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">글 내용 보기</h2>
  <table class="table table-bordered text-center border-secondary-subtle">
    <tr>
      <th class="table-secondary">글쓴이</th>
      <td>${vo.nickName}</td>
      <th class="table-secondary">글쓴날짜</th>
      <td>${fn:substring(vo.WDate,0,19)}</td>
    </tr>
    <tr>
      <th class="table-secondary">글조회수</th>
      <td>${vo.readNum}</td>
      <th class="table-secondary">접속IP</th>
      <td>${vo.hostIp}</td>
    </tr>
    <tr>
      <th class="table-secondary">글제목</th>
      <td colspan="3" class="text-start">${vo.title}</td>
    </tr>
    <tr>
      <th class="table-secondary">글내용</th>
      <td colspan="3" style="height:250px" class="text-start">${fn:replace(vo.content, newLine, "<br/>")}</td>
    </tr>
  </table>
  <div class="row">
  	<div class="col"><input type="button" value="돌아가기" onclick="location.href='boardList?pag=${pag}&pageSize=${pageSize}'" class="btn btn-info"/></div>
  	<c:if test="${sNickName == vo.nickName || sLevel == 0}">
	  	<div class="col text-end">
	  	  <c:if test="${sNickName == vo.nickName}">
			  	<input type="button" value="수정" onclick="location.href='boardUpdate?idx=${vo.idx}'" class="btn btn-warning"/>
			  </c:if>
			  <input type="button" value="삭제" onclick="delCheck()" class="btn btn-danger"/>
	  	</div>
  	</c:if>
  </div> 
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>