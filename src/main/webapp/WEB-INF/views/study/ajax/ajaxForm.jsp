<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>ajaxForm.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    function ajaxTest1(idx) {
    	//location.href = "${ctp}/study/ajax/ajaxTest1?idx="+idx;	// 동기식
    	
    	$.ajax({
    		url : "${ctp}/study/ajax/ajaxTest1",
    		type : "post",
    		data : {idx : idx},
    		success:function(res) {
    			$("#demo1").html(res);
    		},
    		error : function() { alert("전송오류!"); }
    	});
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>AJAX 연습</h2>
  <hr/>
  <div>기본
    <a href="javascript:ajaxTest1(10)" class="btn btn-success me-2 mb-2">값전달1</a>
    : <span id="demo1"></span>
  </div>
  <hr/>
  <div>응용(String 배열) - 시(도)/구(시,군,읍) 출력<br/>
    <a href="${ctp}/study/ajax/ajaxTest2_1" class="btn btn-primary mr-2">String배열</a>
  </div>
  <div>응용(객체 - vos) - 시(도)/구(시,군,읍) 출력<br/>
    <a href="${ctp}/study/ajax/ajaxTest2_2" class="btn btn-info mr-2">vos 객체</a>
  </div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>