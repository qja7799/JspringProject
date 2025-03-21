<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>userMain.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>회 원 관 리</h2>
  <hr/>
  <div>전체 회원수 : ${userCnt}명</div>
  <hr/>
  <div>
    <input type="button" value="회원등록" onclick="location.href='${ctp}/user/userInput';" class="btn btn-success me-3"/>
    <input type="button" value="회원개별조회" onclick="location.href='${ctp}/user/userSearch';" class="btn btn-primary me-3"/>
    <input type="button" value="회원전체조회" onclick="location.href='${ctp}/user/userList';" class="btn btn-secondary"/>
  </div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>