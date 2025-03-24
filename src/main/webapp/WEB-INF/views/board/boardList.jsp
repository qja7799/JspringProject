<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>boardList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    function pageSizeCheck() {
    	let pageSize = document.getElementById("pageSize").value;
    	location.href = "boardList?pageSize="+pageSize;
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
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">게 시 판 리 스 트</h2>
  <table class="table table-borderless m-0 p-0">
    <tr>
      <td><a href="boardInput" class="btn btn-success btn-sm">글쓰기</a></td>
      <c:if test="${empty pageVo.search}">
	      <td class="text-end">
	        <select name="pageSize" id="pageSize" onchange="pageSizeCheck()">
	          <option ${pageVo.pageSize==5  ? 'selected' : ''}>5</option>
	          <option ${pageVo.pageSize==10 ? 'selected' : ''}>10</option>
	          <option ${pageVo.pageSize==15 ? 'selected' : ''}>15</option>
	          <option ${pageVo.pageSize==20 ? 'selected' : ''}>20</option>
	          <option ${pageVo.pageSize==30 ? 'selected' : ''}>30</option>
	          <option ${pageVo.pageSize==50 ? 'selected' : ''}>50</option>
	        </select>
	      </td>
      </c:if>
      <c:if test="${!empty pageVo.searchStr}">
        <td class="text-end">
      		<font color='blue'>${pageVo.searchStr}</font>(으)로 <font color='orange'><b>${pageVo.searchString}</b></font>을(를) 검색한 결과 <font color='red'>${fn:length(vos)}</font>건이 출력되었습니다.
      	</td>
      </c:if>
    </tr>
  </table>
  <table class="table table-hover text-center m-0 p-0">
    <tr class="table-secondary">
      <th>글번호</th>
      <th>글제목</th>
      <th>글쓴이</th>
      <th>글쓴날짜</th>
      <th>조회수(좋아요)</th>
    </tr>
    <c:set var="curScrStartNo" value="${pageVo.curScrStartNo}"/>
    <c:forEach var="vo" items="${vos}" varStatus="st">
	    <tr>
	      <td>${curScrStartNo}</td>
	      <td class="text-start">
	        <a href="boardContent?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}&idx=${vo.idx}&search=${pageVo.search}&searchString=${pageVo.searchString}">${vo.title}</a>
	        <c:if test="${vo.dateDiff == 0}"><img src="${ctp}/images/new.gif"/></c:if>
	      </td>
	      <td>${vo.nickName}</td>
	      <td>${fn:substring(vo.WDate,0,10)}</td>
	      <td>${vo.readNum}(${vo.good})</td>
	    </tr>
	    <c:set var="curScrStartNo" value="${curScrStartNo - 1}"/>
    </c:forEach>
  </table>
  <br/>
  
	<!-- 블록페이지 시작 -->
	<div class="text-center">
	  <ul class="pagination justify-content-center">
	    <c:if test="${pageVo.pag > 1}"><li class="page-item"><a class="page-link text-secondary" href="boardList?pag=1&pageSize=${pageSize}">첫페이지</a></li></c:if>
	  	<c:if test="${pageVo.curBlock > 0}"><li class="page-item"><a class="page-link text-secondary" href="boardList?pag=${(curBlock-1)*blockSize+1}&pageSize=${pageVo.pageSize}">이전블록</a></li></c:if>
	  	<c:forEach var="i" begin="${(pageVo.curBlock*pageVo.blockSize)+1}" end="${(pageVo.curBlock*pageVo.blockSize)+pageVo.blockSize}" varStatus="st">
		    <c:if test="${i <= pageVo.totPage && i == pageVo.pag}"><li class="page-item active"><a class="page-link bg-secondary border-secondary" href="boardList?pag=${i}&pageSize=${pageVo.pageSize}">${i}</a></li></c:if>
		    <c:if test="${i <= pageVo.totPage && i != pageVo.pag}"><li class="page-item"><a class="page-link text-secondary" href="boardList?pag=${i}&pageSize=${pageVo.pageSize}">${i}</a></li></c:if>
	  	</c:forEach>
	  	<c:if test="${pageVo.curBlock < pageVo.lastBlock}"><li class="page-item"><a class="page-link text-secondary" href="boardList?pag=${(pageVo.curBlock+1)*pageVo.blockSize+1}&pageSize=${pageVo.pageSize}">다음블록</a></li></c:if>
	  	<c:if test="${pageVo.pag < pageVo.totPage}"><li class="page-item"><a class="page-link text-secondary" href="boardList?pag=${pageVo.totPage}&pageSize=${pageVo.pageSize}">마지막페이지</a></li></c:if>
	  </ul>
	</div>
	<!-- 블록페이지 끝 -->
	<br/>
	<!-- 검색기 시작 -->
	<div class="text-center">
	  <!-- <form name="searchForm" method="post" action="boardSearh"> -->
	  <form name="searchForm" method="get">
	  	<b>검색 : </b>
	  	<select name="search" id="search">
	  	  <option value="title">글제목</option>
	  	  <option value="nickName">글쓴이</option>
	  	  <option value="content">글내용</option>
	  	</select>
	  	<input type="text" name="searchString" id="searchString" required />
	  	<input type="submit" value="검색" class="btn btn-secondary btn-sm" />
	  	<input type="hidden" name="pag" value="${pageVo.pag}" />
	  	<input type="hidden" name="pageSize" value="${pageVo.pageSize}" />
	  </form>
	</div>
	<!-- 검색기 끝 -->
  
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>