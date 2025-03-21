<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>guestInput.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <style>
    th { text-align: center}
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">방 명 록 글 쓰 기</h2>
  <form name="myform" method="post">
    <table class="table table-bordered border-secondary-subtle">
      <tr>
        <th class="bg-secondary-subtle align-middle">성명</th>
        <td><input type="text" name="name" id="name" placeholder="작성자명을 입력하세요" required autofocus class="form-control"/></td>
      </tr>
      <tr>
        <th class="bg-secondary-subtle align-middle">이메일</th>
        <td><input type="text" name="email" id="email" placeholder="이메일 주소를 입력하세요" class="form-control"/></td>
      </tr>
      <tr>
        <th class="bg-secondary-subtle align-middle">홈페이지</th>
        <td><input type="text" name="homePage" id="homePage" value="http://" placeholder="홈페이지(블로그)주소를 입력하세요" class="form-control"/></td>
      </tr>
      <tr>
        <th class="bg-secondary-subtle align-middle">글내용</th>
        <td><textarea rows="5" name="content" id="content" placeholder="글내용을 입력하세요" required class="form-control"></textarea></td>
      </tr>
    </table>
    <table class="table table-borderless">
      <tr>
        <td>
          <input type="submit" value="방명록 등록" class="btn btn-success me-2"/>
          <input type="reset" value="다시쓰기" class="btn btn-warning me-2"/>
        </td>
        <td class="text-end">
          <input type="button" value="돌아가기" onclick="location.href='guestList';" class="btn btn-info"/>
        </td>
      </tr>
    </table>
    <input type="hidden" name="hostIp" value="${pageContext.request.remoteAddr}"/>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>