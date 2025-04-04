<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>pieChart.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <script type="text/javascript">
    google.charts.load('current', {'packages':['corechart']});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {

      var data = google.visualization.arrayToDataTable([
        ['Task', 'Hours per Day'],
        ['${vo.subTitle1}', ${vo.value1}],//숫자는 '' 안붙이는게 좋음
        ['${vo.subTitle2}', ${vo.value2}],
        ['${vo.subTitle3}', ${vo.value3}],
        ['${vo.subTitle4}', ${vo.value4}],
        ['${vo.subTitle5}', ${vo.value5}]
      ]);

      var options = {
        title: '${vo.title}'
      };

      var chart = new google.visualization.PieChart(document.getElementById('piechart'));

      chart.draw(data, options);
    }
  </script>
</head>
<body>
<p><br/></p>
<div class="container">
  <h2>원형 차트</h2>
  <div id="piechart" style="width: 900px; height: 500px;"></div>
</div>
<p><br/></p>
</body>
</html>