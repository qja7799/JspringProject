<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>memberList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    // 닉네임 클릭시 모달을 통해서 회원 '닉네임/아이디/사진' 보여주기
    function imgInfor(nickName, mid, photo) {
    	$("#myModal1 .modal-header .nickName").html(nickName);
    	$("#myModal1 .modal-body .mid").html(mid);
    	$("#myModal1 .modal-body .imgSrc").attr("src","${ctp}/resources/data/member/"+photo)
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
  <h2 class="text-center mb-3">전체 회원 리스트</h2>
  <div class="row">
    
  </div>
  <form name="myform">
    <table class="table table-hover text-center">
      <tr class="table-secondary">
        <th>번호</th>
        <th>아이디</th>
        <th>닉네임</th>
        <th>성명</th>
        <th>생일</th>
        <th>성별</th>
        <th>최종방문일</th>
        <th>오늘방문횟수</th>
      </tr>
      <c:forEach var="vo" items="${vos}" varStatus="st">
        <tr>
          <td>${vo.idx}</td>
          <td>${vo.mid}</td>
          <td><a href="#" onclick="imgInfor('${vo.nickName}','${vo.mid}','${vo.photo}')" data-bs-toggle="modal" data-bs-target="#myModal1">${vo.nickName}</a></td>
          <td>${vo.name}</td>
          <td>${fn:substring(vo.birthday,0,10)}</td>
          <td>${vo.gender}</td>
          <td>${fn:substring(vo.lastDate,0,10)}</td>
          <td>${vo.todayCnt}</td>
        </tr>
      </c:forEach>
    </table>
  </form>
  
	<!-- 블록페이지 시작(1블록의 크기를 3개(3Page)로 한다. -->
	<div class="text-center">
	  <ul class="pagination justify-content-center">
	    <c:if test="${pag > 1}"><li class="page-item"><a class="page-link text-secondary" href="memberList?pag=1">첫페이지</a></li></c:if>
	  	<c:if test="${curBlock > 0}"><li class="page-item"><a class="page-link text-secondary" href="memberList?pag=${(curBlock-1)*blockSize+1}">이전블록</a></li></c:if>
	  	<c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}" varStatus="st">
		    <c:if test="${i <= totPage && i == pag}"><li class="page-item active"><a class="page-link bg-secondary border-secondary" href="memberList?pag=${i}">${i}</a></li></c:if>
		    <c:if test="${i <= totPage && i != pag}"><li class="page-item"><a class="page-link text-secondary" href="memberList?pag=${i}">${i}</a></li></c:if>
	  	</c:forEach>
	  	<c:if test="${curBlock < lastBlock}"><li class="page-item"><a class="page-link text-secondary" href="memberList?pag=${(curBlock+1)*blockSize+1}">다음블록</a></li></c:if>
	  	<c:if test="${pag < totPage}"><li class="page-item"><a class="page-link text-secondary" href="memberList?pag=${totPage}">마지막페이지</a></li></c:if>
	  </ul>
	</div>
	<!-- 블록페이지 끝 --> 
  
</div>

<!-- The Modal -->
<div class="modal fade" id="myModal1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title nickName"></h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p>아이디 : <span class="mid"></span></p>
        <p>포토<br/>
          <img class="imgSrc" width="250px"/>
        </p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>