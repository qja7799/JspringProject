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
  <title>scheduleMenu.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
  	'use strict';
  	
  	// 일정등록 폼보기
  	function scheduleInputView() {
  		let str = '<div id="scheduleInputForm">';
  		str += '<form name="myform">';
  		str += '<table class="table table-bordered">';
  		str += '<tr><th>일정분류</th><td>';
  		str += '<select name="part" id="part" class="form-select">';
  		str += '<option>모임</option>';
  		str += '<option>업무</option>';
  		str += '<option selected>학습</option>';
  		str += '<option>여행</option>';
  		str += '<option>기타</option>';
  		str += '</select>';
  		str += '</td></tr>';
  		str += '<tr><th>내용</th><td>';
  		str += '<textarea rows="4" name="content" class="form-control"></textarea>';
  		str += '</td></tr>';
  		str += '<tr><td colspan="2" class="text-center">';
  		str += '<input type="button" value="일정등록" onclick="scheduleInputOk()" class="btn btn-success me-3"/>';
  		str += '<input type="button" value="등록취소" onclick="location.reload()" class="btn btn-secondary"/>';
  		str += '</td></tr>';
  		str += '</table>';
  		str += '</form>';
  		str += '</div>';
  		
  		$("#scheduleInputView").hide();
  		$("#demo").html(str);
  	}
  	
  	// 일정 등록 처리하기
  	function scheduleInputOk() {
  		let part = myform.part.value;
  		let content = myform.content.value;
  		if(content == "") {
  			alert("일정 내역을 입력하세요");
  			myform.content.focus();
  			return false;
  		}
  		let query = {
  				mid   : '${sMid}',
  				ymd   : '${ymd}',
  				part  : part,
  				content : content
  		}
  		
  		$.ajax({
  			url  : "scheduleInputOk",
  			type : "post",
  			data : query,
  			success:function(res) {
  				if(res != "0") {
  					alert('일정이 등록되었습니다.');
  					location.reload();
  				}
  				else alert("일정등록 실패~~");
  			},
  			error : function() { alert("전송오류!"); }
  		});
  	}
  	
  	// 일정 수정처리폼 보기
  	function updateCheck(idx, part, content) {
  		let str = '<div id="scheduleUpdateForm'+idx+'">';
  		str += '<form name="updateform'+idx+'">';
  		str += '<table class="table table-bordered">';
  		str += '<tr><th>일정분류</th><td>';
  		str += '<select name="part" id="part'+idx+'" class="form-select">';
  		if(part == "모임") {
  			str += '<option selected>모임</option>';
  	  		str += '<option>업무</option>';
  	  		str += '<option>학습</option>';
  	  		str += '<option>여행</option>';
  	  		str += '<option>기타</option>';
  		}
  		if(part == "업무") {
  			str += '<option selected>업무</option>';
  	  		str += '<option>모임</option>';
  	  		str += '<option>학습</option>';
  	  		str += '<option>여행</option>';
  	  		str += '<option>기타</option>';
  		}
  		if(part == "학습") {
  			str += '<option selected>학습</option>';
  	  		str += '<option>모임</option>';
  	  		str += '<option>업무</option>';
  	  		str += '<option>여행</option>';
  	  		str += '<option>기타</option>';
  		}
  		if(part == "여행") {
  			str += '<option selected>여행</option>';
  	  		str += '<option>모임</option>';
  	  		str += '<option>업무</option>';
  	  		str += '<option>학습</option>';
  	  		str += '<option>기타</option>';
  		}
  		if(part == "기타") {
  			str += '<option selected>기타</option>';
  	  		str += '<option>모임</option>';
  	  		str += '<option>업무</option>';
  	  		str += '<option>학습</option>';
  	  		str += '<option>여행</option>';
  		}

  		str += '</select>';
  		str += '</td></tr>';
  		str += '<tr><th>내용</th><td>';
  		str += '<textarea rows="4" name="content" id="content'+idx+'" class="form-control">'+content.replaceAll("<br/>","\n")+'</textarea>';
  		str += '</td></tr>';
  		str += '<tr><td colspan="2" class="text-center">';
  		str += '<input type="button" value="일정수정" onclick="scheduleUpdateOk('+idx+')" class="btn btn-success me-3"/>';
  		str += '<input type="button" value="수정취소" onclick="location.reload()" class="btn btn-secondary"/>';
  		str += '</td></tr>';
  		str += '</table>';
  		str += '</form>';
  		str += '</div>';
  		
  		$(".updateDemo").hide();
  		$(".scheduleUpdateOpen").show();
  		$("#scheduleUpdateOpen"+idx).hide();
  		$("#updateDemo"+idx).show();
  		$("#updateDemo"+idx).html(str);
  	}
  	
  	// 일정 수정처리
  	function scheduleUpdateOk(idx) {
  		let part = $("#part"+idx).val();
  		let content = $("#content"+idx).val();
  		let query = {
  				idx  : idx,
  				part : part,
  				content : content
  		}
  		
  		$.ajax({
  			url  : "scheduleUpdateOk",
  			type : "post",
  			data : query,
  			success:function(res) {
  				if(res != "0") {
  					alert('일정이 수정되었습니다.');
  					location.reload();
  				}
  				else alert("일정수정 실패~~");
  			},
  			error : function() { alert("전송오류!"); }
  		});
  	}
  	
  	// 스케줄 삭제처리
  	function delCheck(idx) {
  		let ans = confirm("선택된 일정을 삭제하시겠습니까?");
  		if(!ans) return false;
  		
  		$.ajax({
  			url  : "scheduleDeleteOk",
  			type : "post",
  			data : {idx : idx},
  			success:function(res) {
  				if(res != "0") {
  					alert('일정이 삭제되었습니다.');
  					location.reload();
  				}
  				else alert("일정삭제 실패~~");
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
  <h4>${ymd} 일정입니다.</h4>
  <p>오늘의 일정은 총 <font color="blue"><b>${scheduleCnt}</b></font>건 있습니다.</p>
  <hr class="border">
  
  <div>
    <input type="button" value="일정등록" onclick="scheduleInputView()" id="scheduleInputView" class="btn btn-primary mb-2"/>
    <input type="button" value="돌아가기" onclick="location.href='schedule?yy=${fn:split(ymd,'-')[0]}&mm=${fn:split(ymd,'-')[1]-1}';" class="btn btn-info mb-2"/>
  </div>
  <div id="demo"></div>
  <hr class="border">
  
  <c:if test="${scheduleCnt != 0}">
  	<table class="table table-hover text-center">
  	  <tr class="table-secondary">
  	    <th>번호</th>
  	    <th>내역</th>
  	    <th>분류</th>
  	    <th>비고</th>
  	  </tr>
  	  <c:forEach var="vo" items="${vos}" varStatus="st">
  	    <tr>
  	      <td>${st.count}</td>
  	      <td class="text-start">${fn:replace(vo.content, newLine, '<br/>')}</td>
  	      <td>${vo.part}</td>
  	      <td>
  	        <input type="button" value="수정" onclick="updateCheck('${vo.idx}','${vo.part}','${fn:replace(vo.content,newLine,'<br/>')}')" id="scheduleUpdateOpen${vo.idx}" class="btn btn-warning btn-sm scheduleUpdateOpen"/>
  	        <input type="button" value="삭제" onclick="delCheck(${vo.idx})" class="btn btn-danger btn-sm"/>
  	      </td>
  	    </tr>
  	    <tr><td colspan="4" class="m-0 p-0"><div id="updateDemo${vo.idx}" class="updateDemo"></div></td></tr>
  	  </c:forEach>
  	</table>
  </c:if>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>