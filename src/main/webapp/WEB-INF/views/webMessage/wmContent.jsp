<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>wmContent.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <link rel="stylesheet" type="text/css" href="${ctp}/css/linkBlue.css"/>
</head>
<body>
<p><br/></p>
<div class="container">
	<h3>여기는 wmContent.jsp입니다</h3>
	<table class="table table-bordered">
    <tr>
      <th>보내는사람</th>
      <td>${vo.sendId}</td>
    </tr>
    <tr>
      <th>받는사람</th>
      <td>${vo.receiveId}</td>
    </tr>
    <tr>
      <th>메세지 제목</th>
      <td>${vo.title}</td>
    </tr>
    <tr>
      <th>메세지 내용</th>
      <td>${fn:replace(vo.content, newLine, "<br/>")}</td>
    </tr>
    <tr>
      <td colspan="2">
      <!-- 1:받은메세지, 2:새메세지, 3:보낸메세지, 4:수신확인, 5:휴지통 -->
        <c:if test="${param.mFlag == 1 || param.mFlag == 2}">
        	<input type="button" value="답장쓰기" onclick="location.href='webMessage?mSw=0&receiveId=${vo.sendId}';" class="btn btn-primary me-2"/>
        </c:if>
        <c:if test="${param.mFlag != 5}">
        	<input type="button" value="휴지통" onclick="location.href='webDeleteCheck?mSw=5&idx=${vo.idx}&mFlag=${param.mFlag}';" class="btn btn-info me-2">
        </c:if>
        <c:if test="${param.mFlag == 5}">
        	<input type="button" value="복구하기" onclick="location.href='webMessageRecover?idx=${vo.idx}&sendId=${vo.sendId}';" class="btn btn-success me-2">
        </c:if>
        <input type="button" value="돌아가기" onclick="location.href='webMessage?mSw=${param.mFlag}';" class="btn btn-warning"/>
        
        
      </td>
    </tr>
  </table>
</div>
<p><br/></p>
</body>
</html>