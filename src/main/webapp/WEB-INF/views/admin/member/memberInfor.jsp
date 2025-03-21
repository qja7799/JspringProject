<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>memberInfor.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
</head>
<body>
<p><br/></p>
<div class="container">
  <h2>회원 개인정보 상세보기</h2>
  <div>고유번호 : ${vo.idx}</div>
  <div>아이디 : ${vo.mid}</div>
  <div>닉네임 : ${vo.nickName}</div>
  <div>성명 : ${vo.name}</div>
  <div>성별 : ${vo.gender}</div>
  <div>생일 : ${vo.birthday}</div>
  <div>전화번호 : ${vo.tel}</div>
  <div>주소 : ${vo.address}</div>
  <div>이메일 : ${vo.email}</div>
  <div>직업 : ${vo.job}</div>
  <div>취미 : ${vo.hobby}</div>
  <div>자기소개 : ${vo.content}</div>
  <div>정보공개유무 : ${vo.userInfor}</div>
  <div>활동상태 : ${vo.userDel}</div>
  <div>총 포인트 : ${vo.point}</div>
  <div>회원등급 : ${vo.level}</div>
  <div>총 방문횟수 : ${vo.visitCnt}</div>
  <div>오늘 방문횟수 : ${vo.todayCnt}</div>
  <div>최초 가입일자 : ${vo.startDate}</div>
  <div>최근 방문일자 : ${vo.lastDate}</div>
  <div>회원사진 : <img src="${ctp}/resources/data/member/${vo.photo}" width="150px"/></div>
  <hr/>
  <div><a href="${ctp}/admin/member/memberList" class="btn btn-success">돌아가기</a></div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>