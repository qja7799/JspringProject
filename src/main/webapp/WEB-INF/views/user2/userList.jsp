<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>userList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    function delCheck(idx) {
    	let ans = confirm("현재 회원을 삭제하시겠습니까?");
    	if(!ans) return false;
    	else location.href = "${ctp}/user2/userDeleteOk?idx="+idx;
    }
    
    function orderCheck() {
    	let order = document.getElementById("order").value;
    	location.href = "${ctp}/user2/userOrderList/"+order;
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center mb-4">회 원 전 체 리 스 트</h2>
  <table class="table table-borderless m-0">
    <tr>
     <td><a href="insertDummy" class="btn btn-success btn-sm">더미계정 생성</a></td>
      <td class="text-start"><a href="${ctp}/user/userMain" class="btn btn-success btn-sm">돌아가기</a></td>
      <td class="text-end">
        <select name="order" id="order" onchange="orderCheck()">
          <option value="idxDesc" ${order=='idxDesc' 	? 'selected' : ''}>최근가입순</option>
          <option value="idx"  		${order=='idx' 			? 'selected' : ''}>가입순</option>
          <option value="name" 		${order=='name' 		? 'selected' : ''}>성명순</option>
          <option value="age"  		${order=='age' 			? 'selected' : ''}>나이순</option>
        </select>
      </td>
    </tr>
  </table>
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
          <a href="${ctp}/user2/userUpdate?idx=${vo.idx}" class="badge bg-warning text-decoration-none">수정</a> /
          <a href="javascript:delCheck(${vo.idx})" class="badge bg-danger text-decoration-none">삭제</a>
        </td>
      </tr>
    </c:forEach>
  </table>
  <!-- 부트스트랩 적용 페이지 네비 시작 -->
<div class="container2 text-center mt-3">
    <ul class="pagination justify-content-center">
        <c:if test="${pag > 1}">
            <li class="page-item">
                <a class="page-link" href="userList?pag=1" aria-label="First">&laquo;&laquo;</a>
            </li>
        </c:if>
        <c:if test="${curBlock > 0}">
            <li class="page-item">
                <a href="userList?pag=${(curBlock-1)*blockSize+1}" class="page-link">Previous</a>
            </li>
        </c:if>

        <c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize+blockSize)}" varStatus="st">
            <c:if test="${i <= totPage && i == pag}">
                <li class="page-item active" aria-current="page">
                    <a class="page-link" href="userList?pag=${i}">${i}</a>
                </li>
            </c:if>

            <c:if test="${i <= totPage && i != pag}">
                <li class="page-item">
                    <a class="page-link" href="userList?pag=${i}">${i}</a>
                </li>
            </c:if>
        </c:forEach>

        <li class="page-item">
            <a class="page-link" href="userList?pag=${(curBlock+1)*blockSize+1}">Next</a>
        </li>

        <c:if test="${pag < totPage}">
            <li class="page-item">
                <a class="page-link" href="userList?pag=${totPage}">&raquo;&raquo;</a>
            </li>
        </c:if>
    </ul>
</div>
  
<!-- 페이지네비 끝 -->
  <br/>
  <div><a href="${ctp}/user2/userMain" class="btn btn-warning">돌아가기</a></div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>