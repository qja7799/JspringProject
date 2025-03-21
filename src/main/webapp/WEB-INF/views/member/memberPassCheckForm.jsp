<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>memberPassCheckForm.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    function pwdCheck() {
    	let pwd = document.getElementById("pwd").value;
    	let rePwd = document.getElementById("rePwd").value;
    	
    	if(pwd != rePwd) {
    		alert("비밀번호가 일치하지 않습니다. 확인후 다시 변경하세요");
    		document.getElementById("pwd").focus();
    	}
    	else myform.submit();
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">비밀번호 변경</h2>
  <form name="myform" method="post" action="${ctp}/member/pwdChange">
  	<table class="table table-bordered text-center">
      <tr>
        <th>새로운 비밀번호</th>
        <td><input type="password" name="pwd" id="pwd" placeholder="새로운 비밀번호를 입력하세요." required class="form-control" /></td>
      </tr>
      <tr>
        <th>비밀번호 확인</th>
        <td><input type="password" name="rePwd" id="rePwd" placeholder="비밀번호를 한번더 입력해 주세요." required class="form-control" /></td>
      </tr>
      <tr>
        <td colspan="2">
          <input type="button" value="비밀번호변경" onclick="pwdCheck()" class="btn btn-success me-2"/>
          <input type="reset" value="다시입력" class="btn btn-warning me-2"/>
          <input type="button" value="돌아가기" onclick="location.href='${ctp}/member/memberMain';" class="btn btn-primary"/>
        </td>
      </tr>
    </table>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>