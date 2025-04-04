<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>chart1.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    function chartChange() {
    	chartForm.submit();
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>구글 차트 연습</h2>
  <div>
    <div>학습할 차트를 선택하세요</div>
    <div>선택된 차트 : ${part}</div>
    <form name="chartForm">
      <select name="part" id="part" onchange="chartChange()">
        <option value="">차트선택</option>
        <option value="barV"   ${part == 'barV'   ? 'selected' : ''}>수직막대차트</option>
        <option value="barH"   ${part == 'barH'   ? 'selected' : ''}>수평막대차트</option>
        <option value="line"   ${part == 'line'   ? 'selected' : ''}>꺽은선차트</option>
        <option value="pie"    ${part == 'pie'    ? 'selected' : ''}>원형차트</option>
        <option value="pie3D"  ${part == 'pie3D'  ? 'selected' : ''}>3D원형차트</option>
        <option value="bubble"  ${part == 'bubble' ? 'selected' : ''}>버블차트</option>
        <option value="gant"    ${part == 'gant'   ? 'selected' : ''}>간트차트</option>
        <option value="timeLine" ${part == 'timeLine' ? 'selected' : ''}>TimeLines</option>
        <option value="combo"   ${part == 'combo'    ? 'selected' : ''}>콤보차트</option>
      </select>
    </form>
  </div>
  <hr class="border-secondary">
  <div>
    <c:if test="${part == 'barV'}"><jsp:include page="barVChart.jsp" /></c:if>
    <c:if test="${part == 'barH'}"><jsp:include page="barHChart.jsp" /></c:if>
    <c:if test="${part == 'line'}"><jsp:include page="lineChart.jsp" /></c:if>
    <c:if test="${part == 'pie'}"><jsp:include page="pieChart.jsp" /></c:if>
    <c:if test="${part == 'pie3D'}"><jsp:include page="pie3DChart.jsp" /></c:if>
    <c:if test="${part == 'bubble'}"><jsp:include page="bubbleChart.jsp" /></c:if>
    <c:if test="${part == 'gant'}"><jsp:include page="gantChart.jsp" /></c:if>
    <c:if test="${part == 'timeLine'}"><jsp:include page="timeLineChart.jsp" /></c:if>
    <c:if test="${part == 'combo'}"><jsp:include page="comboChart.jsp" /></c:if>
  </div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>