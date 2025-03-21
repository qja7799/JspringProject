<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
<h2 class="text-center">관 리 자 인 증</h2>
  <form name="myform" method="post">
    <table class="table table-bordered border-secondary-subtle" >
      <tr>
        <th class="bg-secondary-subtle align-middle text-center">아이디</th>
        <td><input type="text" name="mid" id="mid" placeholder="아이디를 입력하세요" value="admin" required autofocus class="form-control"/></td>
      </tr>
      <tr>
        <th class="bg-secondary-subtle align-middle text-center">비밀번호</th>
        <td><input type="password" name="pwd" id="pwd" placeholder="비밀번호를 입력하세요" value="1234" class="form-control"/></td>
      </tr>
    </table>
    <div class="text-center">
     <input type="submit" value="관리자 로그인" class="btn btn-success me-2"/>
     <input type="reset" value="다시쓰기" class="btn btn-warning me-2"/>
     <input type="button" value="돌아가기" onclick="location.href='guestList';" class="btn btn-info"/>
    </div>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>