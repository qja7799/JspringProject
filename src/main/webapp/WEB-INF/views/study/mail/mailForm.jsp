<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>mailForm.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">메일 보내기 연습</h2>
  <form method="post">
  	<table class="table table-bordered text-center">
      <tr>
        <th>받는사람</th>
        <td>
          <input type="text" name="toMail" id="toMail" placeholder="받는사람 메일주소를 입력하세요" autofocus required class="form-control" />
        </td>
      </tr>
      <tr>
        <th>메일제목</th>
        <td><input type="text" name="title" id="title" placeholder="메일 제목을 입력하세요." required class="form-control" /></td>
      </tr>
      <tr>
        <th>메일내용</th>
        <td><textarea rows="7" name="content" id="content" placeholder="메일 내용을 입력하세요" required class="form-control"></textarea></td>
      </tr>
      <tr>
        <td colspan="2">
          <input type="submit" value="메일보내기" class="btn btn-success me-2"/>
          <input type="reset" value="다시입력" class="btn btn-warning me-2"/>
        </td>
      </tr>
    </table>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>