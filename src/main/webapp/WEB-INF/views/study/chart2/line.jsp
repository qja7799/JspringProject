<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>line.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <script type="text/javascript">
    google.charts.load('current', {'packages':['line']});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
      var data = new google.visualization.DataTable();
      data.addColumn('string', '${xTitle}');
      data.addColumn('number', '${regend}');

      data.addRows([
    	  <c:forEach var="i" begin="0" end="6" varStatus="st">
    	    ['${visitDates[6-i]}', ${visitCounts[6-i]}],
    	  </c:forEach>
      ]);

      var options = {
        chart: {
          title: '${title}',
          subtitle: '${subTitle}'
        },
        width: 900,
        height: 500,
        axes: {
          x: {
            0: {side: 'top'}
          }
        }
      };

      var chart = new google.charts.Line(document.getElementById('line_top_x'));

      chart.draw(data, google.charts.Line.convertOptions(options));
    }
  </script>
</head>
<body>
<p><br/></p>
<div class="container">
  <div id="line_top_x"></div>
  <h1>
  	여긴 라인jsp
  	${visitDates}
  </h1>
</div>
<p><br/></p>
</body>
</html>