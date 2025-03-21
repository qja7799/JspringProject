<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>아이디찾기.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script type="text/javascript">
  
	  //이메일 유효성체크
	  let regEmail = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/; 
	  
	  //폼체크
	  function fCheck() {
	  	let email1 = myform.email1.value.trim();
	  	let email2 = myform.email2.value.trim();
	  	let email = email1 + "@" + email2;
	  	
		  	if(email1.trim() == "") {
		  		alert("이메일을 입력해주세요");
		  		myform.email1.focus();
		  		return false;
		  	}
		  	else if(!regEmail.test(email)) {
		  		alert("이메일 형식에 맞지않습니다. 다시 입력해주세요");
		  		myform.email1.focus();
		  		return false;
		  	}  
		  	
			myform.email.value = email;
			myform.submit();	
	  }
	  
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
	<c:if test="${!empty vos or !empty notemail}">
		<h2 class="text-center">이메일 목록</h2>
	</c:if>
	
	<c:if test="${empty vos and empty notemail}">
		<h2 class="text-center">아이디 찾기</h2>
	</c:if>
	
  	<c:if test="${!empty vos or !empty notemail}">
	   <table class="table table-hover text-center">
	   		
	      <tr class="table-secondary">
	        <th>번호</th>
	        <th>이메일</th>
	      </tr>
	      
	      <c:if test="${!empty notemail}">
	      	<td colspan="2">
	      		${notemail }
	      	</td>
	      </c:if>
	      
	      <c:forEach var="vo" items="${vos}" varStatus="st">
	        <tr>
	          <td>${st.count}</td>
	          <td>${vo.email}</td>
	        </tr>
	      </c:forEach>
	      
	    </table>
  	</c:if>
    
  <form name="myform" method="post">
  	<table class="table table-bordered text-center">
      <tr>
        <th>이메일</th>
        <td>
          <div class="input-group">
	          <input type="text" name="email1" id="email1" class="form-control" required />@
	          <select name="email2" id="email2" class="form-select">
	          	<option>naver.com</option>
	          	<option>hanmail.net</option>
	          	<option>gmail.com</option>
	          	<option>daum.net</option>
	          	<option>yahoo.com</option>
	          	<option>hatmail.com</option>
	          	<option>nate.com</option>
	          </select>
          </div>
        </td>
      </tr>
      <tr>
        <td colspan="2">
          <input type="submit" value="아이디 찾기" onclick="return fCheck()" class="btn btn-success me-2"/>
          <input type="reset" value="다시입력" class="btn btn-warning me-2"/>
          <input type="button" value="돌아가기" onclick="location.href='${ctp}/member/memberLogin';" class="btn btn-primary"/>
          <input type="hidden" name="email" />
        </td>
      </tr>
    </table>
  </form>
  
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>