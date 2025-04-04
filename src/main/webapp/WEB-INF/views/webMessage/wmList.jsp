<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>wmList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script type="text/javascript">
  	
  	setTimeout("location.reload()", 1000*5);
  	
  	
  </script>
</head>
<body>
<p><br/></p>
<div class="container">
<h3>여기는 wmList.jsp입니다</h3>
	<!-- 1:받은메세지, 2:새메세지, 3:보낸메세지, 4:수신확인, 5:휴지통 -->
  <table class="table table-hover">
    <tr class="table-secondary">
      <th>번호</th>
      <th>
      	<c:if test="${mSw==1 || mSw==2 || mSw==5}">보낸사람</c:if>
      	<c:if test="${mSw==3 || mSw==4}">받은사람</c:if>
      </th>
      <th>제목</th>
      <th>
      	<c:if test="${mSw==1 || mSw==2 || mSw==5}">보낸/확인(날짜)</c:if>
      	<c:if test="${mSw==3 || mSw==4}">받은날짜</c:if>
      </th>
    </tr>
    <c:set var="curScrStartNo" value="${pageVo.curScrStartNo}"/>
    <c:forEach var="vo" items="${vos}" varStatus="st">
    	<tr>
    		<%-- <td>${curScrStartNo}</td> --%>
    		<td>${st.count}</td>
    		<td>
		    	<c:if test="${mSw==1 || mSw==2 || mSw==5}">${vo.sendId}</c:if>
		      	<c:if test="${mSw==3 || mSw==4}">${vo.receiveId}</c:if>
    		</td>
    		<td class="text-start">
    			<c:if test="${mSw!=4 && mSw!=5}"><a href="webMessage?mSw=6&mFlag=${mSw}&idx=${vo.idx}">${vo.title}</a></c:if>
    	 		<c:if test="${mSw==4 && vo.sendId == sMid}"><span style="font-weight: bolder; color: red">[보낸메세지]</span> ${vo.title}</c:if> 
    	 		
    	 		<c:if test="${mSw==5 && vo.sendId == sMid}">
    	 			<a href="webMessage?mSw=6&mFlag=${mSw}&idx=${vo.idx}">
    	 				<span style="font-weight: bolder; color: red">[보낸메세지]</span> ${vo.title}
    	 			</a>
    	 		</c:if> 
    			<c:if test="${mSw==5 && vo.receiveId == sMid}">
    				<a href="webMessage?mSw=6&mFlag=${mSw}&idx=${vo.idx}">
    					<span style="font-weight: bolder; color: blue">[받은메세지]</span> ${vo.title}
    				</a>
    			</c:if>
    			
    			<c:if test="${vo.receiveSw == 'n' && Sw!=3 && Sw!=4 && Sw!=5}"><img src="${ctp}/images/new.gif"></c:if>
    		</td>
    		<td>
		    	<c:if test="${mSw==1 || mSw==2 || mSw==5}">${fn:substring(vo.sendDate, 0, 19)}</c:if>
		      	<c:if test="${mSw==3 || mSw==4}">${fn:substring(vo.receiveDate, 0, 19)}</c:if>
    		</td>
    	</tr>
    	<c:set var="curScrStartNo" value="${curScrStartNo - 1}"/>
    </c:forEach>
  </table>
</div>
<p><br/></p>
</body>
</html>