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
  <title>guestList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    function delCheck(idx) {
    	let ans = confirm("현재 게시글을 삭제 하시겠습니까?");
    	if(!ans) return false;
    	else location.href = "guestDelete?idx="+idx;
    }
  </script>
  <style>
    th {
      text-align: center;
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">방명록 리스트</h2>
  <table class="table table-borderless m-0 p-0">
  	<tr>
  	  <td><a href="guestInput" class="btn btn-success btn-sm">글쓰기</a></td>
  	  <td><a href="insertDummy" class="btn btn-success btn-sm">더미 게시글 생성</a></td>
  	  <td class="text-end">
  	  	<c:if test="${sAdmin != 'adminOk'}"><a href="admin" class="btn btn-primary btn-sm">관리자</a></c:if>
  	  	<c:if test="${sAdmin == 'adminOk'}"><a href="adminLogout" class="btn btn-warning btn-sm">관리자 로그아웃</a></c:if>
  	  </td>
  	</tr>
  	<tr>
  	  <td colspan="2" class="text-end">
  	    <c:if test="${pag > 1}">
  	      <a href="guestList?pag=1" title="첫페이지" class="text-decoration-none">첫페이지로 이동</a>
  	      <a href="guestList?pag=${pag-1}" title="이전페이지" class="text-decoration-none">◀</a>
  	    </c:if>
  	    ${pag}  / ${totPage}
  	    <c:if test="${pag < totPage}">
  	      <a href="guestList?pag=${pag+1}" title="다음페이지" class="text-decoration-none">▶</a>
  	      <a href="guestList?pag=${totPage}" title="마지막페이지" class="text-decoration-none">마지막페이지로 이동</a>
  	    </c:if>
  	  </td>
  	</tr>
  </table>
  <c:forEach var="vo" items="${vos}" varStatus="st">
	  <table class="table table-borderless m-0 p-0">
			<tr>
			  <td>글번호 : ${vo.idx}
			    <c:if test="${sAdmin == 'adminOk'}"><a href="javascript:delCheck(${vo.idx})" class="btn btn-danger btn-sm">삭제</a></c:if>
			  </td>
			  <td class="text-end">방문IP : ${vo.hostIp}</td>
			</tr>
	  </table>
  	<table class="table table-bordered border-secondary-subtle mb-5">
  		<tr>
  		  <th class="bg-secondary-subtle">글쓴이</th><td>${vo.name}</td>
  		  <th class="bg-secondary-subtle">방문일자</th><td>${fn:substring(vo.visitDate,0,19)}</td>
  		</tr>
  		<tr>
  		  <th class="bg-secondary-subtle">메일주소</th>
  		  <td colspan="3">
  		    <c:if test="${empty vo.email || fn:length(vo.email)<6 || fn:indexOf(vo.email,'@')==-1 || fn:indexOf(vo.email,'.')==-1}">- 없음 -</c:if>
  		    <c:if test="${!empty vo.email && fn:length(vo.email)>=6 && fn:indexOf(vo.email,'@')!=-1 && fn:indexOf(vo.email,'.')!=-1}">${vo.email}</c:if>
  		  </td>
  		</tr>
  		<tr>
  		  <th class="bg-secondary-subtle">홈페이지</th>
  		  <td colspan="3">
					<c:if test="${empty vo.homePage || fn:length(vo.homePage)<10 || fn:indexOf(vo.homePage,'.')==-1}">- 없음 -</c:if>
					<c:if test="${!empty vo.homePage && fn:length(vo.homePage)>=10 && fn:indexOf(vo.homePage,'.')!=-1}"><a href="${vo.homePage}" target="_blank">${vo.homePage}</a></c:if>
  		  </td>
  		</tr>
  		<tr>
  		  <th class="bg-secondary-subtle">방문소감</th>
  		  <td colspan="3" style="height:150px;">${fn:replace(vo.content, newLine, "<br/>")}</td>
  		</tr>
  	</table>
  </c:forEach>
  <br>
	<!-- 블록페이지 시작 -->
	<div class="text-center">
	  <c:if test="${pag > 1}">[<a href="guestList?pag=1">첫페이지</a>]</c:if>
	  <c:if test="${curBlock > 0}">[<a href="guestList?pag=${(curBlock-1)*blockSize+1}">이전블록</a>]</c:if>
	  <c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}" varStatus="st">
		<c:if test="${i <= totPage && i == pag}"><a href="guestList?pag=${i}">[<font color="red"><b>${i}</b></font>]</a></c:if>
		<c:if test="${i <= totPage && i != pag}"><a href="guestList?pag=${i}">[${i}]</a></c:if> 
	  </c:forEach>
	  <c:if test="${curBlock < lastBlock}">[<a href="guestList?pag=${(curBlock+1)*blockSize+1}">다음블록</a>]</c:if>
	  <c:if test="${pag < totPage}">[<a href="guestList?pag=${totPage}">마지막페이지</a>]</c:if>
	</div>
	<!-- 블록페이지 끝 -->
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>