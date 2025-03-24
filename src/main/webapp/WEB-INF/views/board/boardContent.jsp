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
  <title>boardContent.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    function delCheck() {
    	let ans = confirm("현재 게시글을 삭제 하시겠습니다.?");
    	if(ans) location.href = "boardDelete?idx=${vo.idx}";
    }
    
    // 좋아요
    function goodCheck1() {
    	$.ajax({
    		url  : "${ctp}/board/boardGoodCheck1",
    		type : "post",
    		data : {idx : ${vo.idx}},
    		success:function(res) {
    			if(res != "0") location.reload();
    			else alert("이미 좋아요를 눌러주셨습니다.");
    		},
    		error : function() { alert("전송오류!"); }
    	});
    }
    
    // '좋아요/싫어요'
    function goodCheck2(goodCnt) {
    	$.ajax({
    		url  : "${ctp}/board/boardGoodCheck2",
    		type : "post",
    		data : {
    			idx : ${vo.idx},
    			goodCnt : goodCnt
    		},
    		success:function(res) {
    			if(res != "0") location.reload();
    			else alert("이미 좋아요를 눌러주셨습니다.");
    		},
    		error : function() { alert("전송오류!"); }
    	});
    }
    

    // 댓글 달기
    function replyCheck() {
    	let content = $("#content").val();
    	if(content.trim() == "") {
    		alert("댓글을 입력하세요");
    		$("#content").focus();
    		return false;
    	}
    	let query = {
    			boardIdx : ${vo.idx},
    			mid      : '${sMid}',
    			nickName : '${sNickName}',
    			hostIp	 : '${pageContext.request.remoteAddr}',
    			content  : content
    	}
    	
    	$.ajax({
    		url  : "${ctp}/board/boardReplyInput",
    		type : "post",
    		data : query,
    		success:function(res) {
    			if(res != "0") {
    				alert("댓글이 입력되었습니다.");
    				location.reload();
    			}
    			else alert("댓글 입력 실패~~");
    		}
    	});
    }
  </script>
  <style>
    a {text-decoration: none}
    a:hover {
      text-decoration: underline;
      color: orange;
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">글 내용 보기</h2>
  <table class="table table-bordered text-center border-secondary-subtle">
    <tr>
      <th class="table-secondary">글쓴이</th>
      <td>${vo.nickName}</td>
      <th class="table-secondary">글쓴날짜</th>
      <td>${fn:substring(vo.WDate,0,19)}</td>
    </tr>
    <tr>
      <th class="table-secondary">글조회수</th>
      <td>${vo.readNum}</td>
      <th class="table-secondary">접속IP</th>
      <td>${vo.hostIp}</td>
    </tr>
    <tr>
      <th class="table-secondary">글제목</th>
      <td colspan="3" class="text-start">${vo.title}
        (<a href="javascript:goodCheck1()" title="좋아요">❤</a>(${vo.good}))
        (<a href="javascript:goodCheck2(1)" title="좋아요">👍</a>
         <a href="javascript:goodCheck2(-1)" title="싫어요">👎</a>(${vo.good}))
      </td>
    </tr>
    <tr>
      <th class="table-secondary">글내용</th>
      <td colspan="3" style="height:250px" class="text-start">${fn:replace(vo.content, newLine, "<br/>")}</td>
    </tr>
  </table>
  <div class="row">
  	<div class="col"><input type="button" value="돌아가기" onclick="location.href='boardList?pag=${pag}&pageSize=${pageSize}&search=${search}&searchString=${searchString}'" class="btn btn-info"/></div>
  	<c:if test="${sNickName == vo.nickName || sLevel == 0}">
	  	<div class="col text-end">
	  	  <c:if test="${sNickName == vo.nickName}">
			  	<input type="button" value="수정" onclick="location.href='boardUpdate?idx=${vo.idx}&pag=${pag}&pageSize=${pageSize}&search=${search}&searchString=${searchString}'" class="btn btn-warning"/>
			  </c:if>
			  <input type="button" value="삭제" onclick="delCheck()" class="btn btn-danger"/>
	  	</div>
  	</c:if>
  </div> 
  <hr/>
  <!-- 이전글/다음글 시작-->
  <div class="row">
  	<div class="col">
  		<c:if test="${!empty nextVo.title}"><!-- 다음글이 없다면 다음글보기 숨김 -->
  			☝ <a href="boardContent?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}&idx=${nextVo.idx}&search=${pageVo.search}&searchString=${pageVo.searchString}">다음글 : ${nextVo.title}</a><br/>
  		</c:if>
  		<c:if test="${!empty preVo.title}"><!-- 이전글이 없다면 이전글보기 숨김 -->
  			👇 <a href="boardContent?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}&idx=${preVo.idx}&search=${pageVo.search}&searchString=${pageVo.searchString}">이전글 : ${preVo.title}</a><br/>
  		</c:if>
  	</div>
  </div>
  <!-- 이전글/다음글 끝 -->
 <hr/>
 
  <!-- 댓글철(리스트/입력) -->
  <!-- 댓글 리스트 -->
  <table class="table table-hover text-center">
    <tr class="table-secondary">
      <th>작성자</th>
      <th>댓글내용</th>
      <th>댓글일자</th>
      <th>접속IP</th>
    </tr>
    <c:forEach var="replyVo" items="${replyVos}" varStatus="st">
      <tr>
        <td>${replyVo.nickName}</td>
        <td>${fn:replace(replyVo.content, newLine, "<br/>")}</td>
        <td>${fn:substring(replyVo.WDate, 0, 10)}</td>
        <td>${replyVo.hostIp}</td>
      </tr>
    </c:forEach>
  </table>
  
  <!-- 댓글 입력창 -->
  <form name="replyForm">
    <table class="table table-center">
      <tr>
        <td class="text-start" style="85%">
          글내용 :
          <textarea rows="4" name="content" id="content" class="form-control"></textarea>
        </td>
        <td style="15%">
          <p>작성자 : ${sNickName}</p>
          <p><input type="button" value="댓글달기" onclick="replyCheck()" class="btn btn-info btm-sm"/></p>
        </td>
      </tr>
    </table>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>