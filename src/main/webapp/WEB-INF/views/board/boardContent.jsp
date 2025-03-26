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
    
    $(function() {
    	$(".replyUpdateForm").hide();
    });
    
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
    
    // '좋아요/싫어요' : 중복불허
    function goodCheck2(goodCnt) {
    	$.ajax({
    		url  : "${ctp}/board/boardGoodCheck2",
    		type : "post",
    		data : {
    			idx : ${vo.idx},
    			goodCnt : goodCnt
    		},
    		success:function(res) {
    			if(res == "0") location.reload();
    			else {
    				if(res == "1") alert("이미 좋아요를 눌렀습니다.");
    				else alert("이미 싫어요를 눌렀습니다.");
    			}
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
    
    // 댓글 삭제
    function replyDeleteCheck(idx) {
    	let ans = confirm("선택한 댓글을 삭제 하시겠습니까?");
    	if(!ans) return false;
    	
    	$.ajax({
    		url  : "boardReplyDelete",
    		type : "post",
    		data : {
    			idx : idx,
    		},
    		success:function(res) {
    			if(res != "0") {
    				alert("댓글이 삭제 되었습니다.");
    				location.reload();
    			}
    			else alert("삭제 실패~~");
    		},
    		error : function() { alert("전송오류!"); }
    	});
    }
    
    // 댓글 수정폼 보여주기
    function replyUpdateCheck(idx) {
    	$(".replyUpdateForm").hide();
    	$("#replyUpdateForm"+idx).show();
    }
    
    // 댓글 수정창 닫기
    function replyUpdateViewClose(idx) {
    	$("#replyUpdateForm"+idx).hide();
    }
    
    // 댓글 수정하기
    function replyUpdateCheckOk(idx) {
    	let content = $("#content"+idx).val();
    	if(content.trim() == "") {
    		alert("수정할 댓글을 입력하세요");
    		return false;
    	}
    	let query = {
    			idx : idx,
    			content : content,
    			hostIp	 : '${pageContext.request.remoteAddr}'
    	}
    	
    	$.ajax({
    		url  : "boardReplyUpdateCheckOk",
    		type : "post",
    		data : query,
    		success:function(res) {
    			if(res != "0") {
    				alert("댓글이 수정 되었습니다.");
    				location.reload();
    			}
    			else alert("수정 실패~~");
    		},
    		error : function() { alert("전송오류!"); }
    	});
    }
    
    // 모달에 기타내용 입력창 보여주기
    function etcShow() {
    	$("#claimTxt").show();
    }
    
    // 모달창에서 신고항목 선택후 '확인'버튼 클릭시 수행처리
    function claimCheck() {
    	if(!$("input[type=radio][name=claim]:checked").is(':checked')) {
    		alert("신고항목을 선택하세요");
    		return false;
    	}
    	if($("input[type=radio]:checked").val() == '기타' && $("#claimTxt").val() == '') {
    		alert("기타 사유를 입력해 주세요");
    		return false;
    	}
    	
    	let claimContent = modalForm.claim.value;//신고사유중에 선택한걸 변수 claimContent에 저장
    	//신고사유(=신고항목)이 db에 저장되는데
    	if(claimContent == '기타') claimContent += '/' + $("#claimTxt").val();//신고사유가 기타라면 신고사유/신고내용으로 db에 저장
    	//나는 나중에 신고테이블 만들때 신고사유와 신고내용 열을 따로줘서 분리해서 저장시켜야겠다

    	let query = {
    			part   : 'board',
    			boardIdx: ${vo.idx},
    			cpMid  : '${sMid}',
    			cpContent: claimContent
    	}
    	
    	$.ajax({
    		url  : "boardComplaintInput",
    		type : "post",
    		data : query,
    		success:function(res) {
    			if(res != "0") {
    				alert("신고 되었습니다.");
    				location.reload();
    			}
    			else alert("신고 실패~~");
    		},
    		error : function() { alert("전송오류!"); }
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
  <h2 class="text-center mb-4">글 내용 보기</h2>
  
  <c:if test="${vo.complaint == 'HI'}"><!-- 관리자가 신고된글을 감추기할경우 보여줄것들  -->
  	<hr class="border border-dark">
  	<h3 class="text-center">해당 게시글은 신고된 글입니다</h3>  
  	<hr class="border border-dark">
  	<div class="text-center">
  		<input type="button" value="돌아가기" onclick="location.href='boardList?pag=${pag}&pageSize=${pageSize}&search=${search}&searchString=${searchString}'" class="btn btn-info"/>
  	</div>
  </c:if>
  
  <c:if test="${vo.complaint != 'HI'}">
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
	  	<div class="col">
	  	  <c:if test="${sMid != vo.mid && vo.complaint == 'NO'}"><a href="#" data-bs-toggle="modal" data-bs-target="#myModal" class="btn btn-danger">신고하기</a></c:if>
	  	  <c:if test="${vo.complaint == 'OK'}"><font color="red"><b>현재 게시글은 신고된 글입니다.</b></font></c:if>
	  	</div>
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
	  <!-- 이전글/다음글 -->
	  <div class="row">
	  	<div class="col">
	  	  <c:if test="${!empty nextVo.title}">
	  			☝ <a href="boardContent?idx=${nextVo.idx}">다음글 : ${nextVo.title}</a><br/>
	  		</c:if>
	  	  <c:if test="${!empty preVo.title}">
	  			👇 <a href="boardContent?idx=${preVo.idx}">이전글 : ${preVo.title}</a><br/>
	  		</c:if>
	  	</div>
	  </div>
	  <hr/>
	  
	  <!-- 댓글처리(리스트/입력) -->
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
	        <td>${replyVo.nickName}
	          <c:if test="${sMid == replyVo.mid || sLevel == 0}">
		          (<a href="javascript:replyDeleteCheck(${replyVo.idx})" title="댓글삭제">x</a>)
		          <c:if test="${sMid == replyVo.mid}">
		           	(<a href="javascript:replyUpdateCheck(${replyVo.idx})" title="댓글수정">√</a>)
		          </c:if>
	          </c:if>
	        </td>
	        <td class="text-start">${fn:replace(replyVo.content, newLine, "<br/>")}</td>
	        <td>${fn:substring(replyVo.WDate, 0, 10)}</td>
	        <td>${replyVo.hostIp}</td>
	      </tr>
	      <!-- 아래로 댓글 수정 폼 보기 -->
	      <tr>
	        <td colspan="4">
	          <div id="replyUpdateForm${replyVo.idx}" class="replyUpdateForm">
							<form name="replyUpdateForm">
						    <table class="table text-center">
						      <tr>
						        <td class="text-start" style="width:85%">
						          글내용 :
						          <textarea rows="4" name="content" id="content${replyVo.idx}" class="form-control">${replyVo.content}</textarea>
						        </td>
						        <td style="width:15%"><br/>
						          <p>작성자 : ${sNickName}</p>
						          <p>
						            <a href="javascript:replyUpdateCheckOk(${replyVo.idx})" class="badge bg-primary">댓글수정</a>
						            <a href="javascript:replyUpdateViewClose(${replyVo.idx})" class="badge bg-warning">창닫기</a>
						          </p>
						        </td>
						      </tr>
						    </table>
						  </form>
					  </div>
	        </td>
	      </tr>
	    </c:forEach>
	  </table>
	  <hr/>
	  
	  <!-- 댓글 입력창 -->
	  <form name="replyForm">
	    <table class="table text-center">
	      <tr>
	        <td class="text-start" style="width:85%">
	          글내용 :
	          <textarea rows="4" name="content" id="content" class="form-control"></textarea>
	        </td>
	        <td style="width:15%"><br/>
	          <p>작성자 : ${sNickName}</p>
	          <p><input type="button" value="댓글달기" onclick="replyCheck()" class="btn btn-info btn-sm"/></p>
	        </td>
	      </tr>
	    </table>
	  </form>
	</div>
	
	<!-- The Modal -->
	<div class="modal fade" id="myModal">
	  <div class="modal-dialog modal-dialog-centered">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h4 class="modal-title">현재 게시글을 신고합니다.</h4>
	        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	      </div>
	      <div class="modal-body">
	        <h5>신고사유 선택</h5>
	        <hr class="border">
	        <form name="modalForm">
	          <div><input type="radio" name="claim" id="claim1" value="광고,홍보,영리목적"/> 광고,홍보,영리목적</div>
	          <div><input type="radio" name="claim" id="claim2" value="욕설,비방,차별,혐오"/> 설,비방,차별,혐오</div>
	          <div><input type="radio" name="claim" id="claim3" value="불법정보"/> 불법정보</div>
	          <div><input type="radio" name="claim" id="claim4" value="음란,청소년유해"/> 음란,청소년유해</div>
	          <div><input type="radio" name="claim" id="claim5" value="개인정보노출,유포,거래"/> 개인정보노출,유포,거래</div>
	          <div><input type="radio" name="claim" id="claim6" value="도배,스팸"/> 도배,스팸</div>
	          <div><input type="radio" name="claim" id="claim7" value="기타" onclick="etcShow()"/> 기타</div>
	          <div id="etc"><textarea rows="2" id="claimTxt" class="form-control" style="display:none"></textarea></div>
	          <hr class="border">
	          <input type="button" value="확인" onclick="claimCheck()" class="btn btn-success form-control" />
	        </form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
	      </div>
	    </div>
	  </div>
  </c:if>
</div>

<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>