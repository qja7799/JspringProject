<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>memberMain.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>이곳은 회원 메인방입니다.</h2>
  <hr/>
  <p>현재 로그인한 회원 : ${sMid}(<font color="red">${strLevel}</font>)</p>
  <hr/>
  <div class="row">
    <div class="col">
	  	<p>현재 <b><font color="blue">${sNickName}</font>(<font color="red">${strLevel}</font>)</b> 님이 로그인 중이십니다.</p>
	  	<p>총 방문횟수 : <b>${vo.visitCnt}</b> 회</p>
	  	<p>오늘 방문횟수 : <b>${vo.todayCnt}</b> 회</p>
	  	<p>총 보유 포인트 : <b>${vo.point}</b> 점</p>
  	</div>
    <div class="col">
      <p><img src="${ctp}/member/${vo.photo}" width="200px"/></p>
  	</div>
  </div>
  <hr/>
  <div>
    <h5>활동내역</h5>
    <p>방명록에 올린글수 : <b>${count}</b> 건</p>  <!-- 방명록에 올린이가 '성명/아이디/닉네임'과 같은면 모두 같은 사람이 올린글로 간주한다. -->
    <p>게사판에 올린글수 : <b></b>건</p>
    <p>자료실에 올린글수 : <b></b>건</p>
  </div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>