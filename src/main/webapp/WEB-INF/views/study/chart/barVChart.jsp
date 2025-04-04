<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>barVChart.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <script type="text/javascript">
    google.charts.load('current', {'packages':['bar']});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
      var data = google.visualization.arrayToDataTable([
        ['년도', '서울', '부산', '청주', '대전'],
        ['2021', 1000, 400, 200, 300],
        ['2022', 1170, 460, 250, 320],
        ['2023', 660, 1120, 300, 400],
        ['2024', 1030, 540, 350, 550]
      ]);

      var options = {
        chart: {
          title: '2021~2024 동안의 각 지역별 판매실적',
          subtitle: '서울 부산 청주 대전',
        }
      };

      var chart = new google.charts.Bar(document.getElementById('columnchart_material'));

      chart.draw(data, google.charts.Bar.convertOptions(options));
    }
  </script>
</head>
<body>
<p><br/></p>
<div class="container">
  <h2>수직 막대 차트</h2>
  <div id="columnchart_material" style="width: 800px; height: 500px;"></div>
</div>
<p><br/></p>
</body>
</html>