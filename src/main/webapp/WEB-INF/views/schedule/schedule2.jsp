<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>schedule.jsp</title>
  <!-- 
  
  내가 힘들게 만든 일정 중복체크버전
  강사는 sql문 건드려서 해결했고
  나는 뷰에서 포문과 이프문을 이용해서 해결했는데
  많이 복잡해서 나도 만드는것도 만들고나서 이해하는것도 오래걸렸음
  일단 강사가 만든버전이 훨신 직관적이고
  
   -->
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <style type="text/css">
  	td{
		/* min-height: 120px; 부트스트랩에선 최소높이 최대높이 안먹네 / 근데 내용량에 따라 높이조정되는거보니 자동으로 적용되는듯*/
		height: 120px;
	    font-size: 16px;
  	}
  	td:last-of-type{
  		color: blue;
  	}
  	
  	td:first-of-type{
  		color: red;
  	}
  	/* 부트스트랩은 클래스선택자만 존재하니 아이디로 스타일주거나 td.today 이런식으로 우선순위 높여서 적용시키면됨 */
  	#today {
      background-color: pink;
      color: #fff;
      font-size: 1.5em;
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <div class="text-center">
    <button onclick="location.href='schedule?yy=${yy-1}&mm=${mm}';" class="btn btn-secondary btn-sm" title="이전년도">◁◁</button>
    <button onclick="location.href='schedule?yy=${yy}&mm=${mm-1}';" class="btn btn-secondary btn-sm" title="이전월">◀</button>
    <font size="5">${yy}년 ${mm+1}월</font>
    <button onclick="location.href='schedule?yy=${yy}&mm=${mm+1}';" class="btn btn-secondary btn-sm" title="다음월">▶</button>
    <button onclick="location.href='schedule?yy=${yy+1}&mm=${mm}';" class="btn btn-secondary btn-sm" title="다음년도">▷▷</button>
    &nbsp;&nbsp;
    <button onclick="location.href='schedule';" class="btn btn-secondary btn-sm fa fa-home" title="오늘날짜">오늘날짜</button>
  </div>
  <br/>
  <div class="text-center">
    <table class="table table-bordered" style="height:100%">
      <tr>
        <th style="color:red;width:13%">일</th>
        <th style="width:13%">월</th>
        <th style="width:13%">화</th>
        <th style="width:13%">수</th>
        <th style="width:13%">목</th>
        <th style="width:13%">금</th>
        <th style="color:blue;width:13%">토</th>
      </tr>
      <tr>
      
      <!-- 이전월의 일자를 빈공간에 채운다-->
        <c:set var="cnt" value="1"/>
        <c:forEach var="prevDay" begin="${prevLastDay - (startWeek-2)}" end="${prevLastDay}">
          <td>${prevYear}년 ${prevMonth+1}월 ${prevDay}일</td>
          <c:set var="cnt" value="${cnt=cnt+1}"/>
        </c:forEach>
        
        <!-- 실제 화면에 출력시키는 날짜 -->
        <c:forEach begin="1" end="${lastDay}" varStatus="st">
        <!-- 오늘과 같은 달력의 위치(오늘날짜)에 스타일을 적용시키기위해 변수생성  -->
        <!-- 오늘날짜가 맞으면 1 아니면 0을 저장 -->
        <c:set var="todaySw" value="${yy==toYear && mm==toMonth && st.count==toDay ? 1 : 0}"/>
        	<td id="td${cnt}" ${todaySw == 1 ? 'class=today': ''}>
        	  <c:set var="ymd" value="${yy}-${mm+1}-${st.count}"/>
        	  <a href="scheduleMenu?ymd=${ymd}">${st.count}<br/>
        	  
        	  <c:set var="printedParts" value="" />
	        	  <c:forEach var="vo" items="${vos}">
		            <!-- 출력된 일정 기록 -->
		            
	        	    <c:if test="${fn:substring(vo.SDate,8,10) == st.count}">	<!-- 2025-03-31 11:20:30 -->
		        		<c:set var="filteredParts" value="" />
			            <c:forEach var="v" items="${vos}">
			                <c:if test="${fn:substring(v.SDate,8,10) == st.count and v.part == vo.part}">
			                    <c:set var="filteredParts" value="${filteredParts},${v.part}" />
			                </c:if>
			            </c:forEach>
			            
			            <c:set var="count" value="${fn:length(fn:split(filteredParts, ','))}" />
	            		<!-- 해당 일정이 이미 출력되었는지 확인 -->
	            		<c:set var="zungbok" value=",${vo.part}${count}," />
	            	
        			    <c:if test="${not fn:contains(printedParts, zungbok)}">
				            <!-- 일정 개수에 따라 출력 -->
				            <c:if test="${count > 1}">
				                <br>- ${vo.part}(${count})
				            </c:if>
				            <c:if test="${count == 1}">
				                <br>- ${vo.part}
				            </c:if>
			            </c:if>
			            <!-- 출력된 일정 기록 -->
            			<c:set var="printedParts" value="${printedParts},${vo.part}${count}," />
	        	    </c:if>
	        	    
	        	  </c:forEach>
        	  </a>
        	</td>
        <c:if test="${cnt % 7 == 0}"></tr><tr></c:if>
        <c:set var="cnt" value="${cnt=cnt+1}"/>
        </c:forEach>
        
        <!-- 다음월의 일자를 빈공간에 채운다 -->
        <c:forEach var="nextDay" begin="${nextStartWeek}" end="7" varStatus="st">
          <td>${nextYear}년 ${nextMonth+1}월 ${st.count}일</td>
          <c:set var="cnt" value="${cnt=cnt+1}"/>
        </c:forEach>
      </tr>
    </table>
  </div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>