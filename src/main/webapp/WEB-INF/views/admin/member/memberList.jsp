<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>memberList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    // 등급별 화면 출력처리
    function levelItemCheck() {
    	let level = $("#levelItem").val();
    	location.href = "memberList?level=" + level;
    }
    
    // 회원 등급 변경처리
    function levelChange(e) {
    	//alert("value : " + myform.level.value);
    	//alert("value : " + e.value);
    	//console.log("e", e);
    	let ans = confirm("선택한 회원의 등급을 변경하시겠습니까?");
    	if(!ans) {
    		location.reload();
    		return false;
    	}
    	
    	let items = e.value.split("/");
    	let query = {
    			level : items[0],
    			idx   : items[1]
    	}
    	
    	$.ajax({
    		url  : "${ctp}/admin/memberLevelChange",
    		type : "post",
    		data : query,
    		success:function(res) {
    			if(res != "0") {
    				alert("등급 수정 완료!");
    				location.reload();
    			}
    			else alert("등급 수정 실패~~");
    		},
    		error : function() { alert("전송오류!"); }
    	});
    }
    
    // 닉네임 클릭시 모달을 통해서 회원 '닉네임/아이디/사진' 보여주기
    function imgInfor(nickName, mid, photo) {
    	$("#myModal1 .modal-header .nickName").html(nickName);
    	$("#myModal1 .modal-body .mid").html(mid);
    	$("#myModal1 .modal-body .imgSrc").attr("src","${ctp}/resources/data/member/"+photo)
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
<p><br/></p>
<div class="container">
  <h2>전체 회원 리스트</h2>
  <div class="row">
    <div class="col text-end mb-2">
      <select name="levelItem" id="levelItem" onchange="levelItemCheck()">
        <option value="99"  ${level == 99  ? 'selected' : ''}>전체보기</option>
        <option value="1"   ${level == 1   ? 'selected' : ''}>우수회원</option>
        <option value="2"   ${level == 2   ? 'selected' : ''}>정회원</option>
        <option value="3"   ${level == 3   ? 'selected' : ''}>준회원</option>
        <option value="999" ${level == 999 ? 'selected' : ''}>탈퇴신청회원</option>
        <option value="0"   ${level == 0   ? 'selected' : ''}>관리자</option>
      </select>
    </div>
  </div>
  <form name="myform">
    <table class="table table-hover text-center">
      <tr class="table-secondary">
        <th>번호</th>
        <th>아이디</th>
        <th>닉네임</th>
        <th>성명</th>
        <th>생일</th>
        <th>성별</th>
        <th>최종방문일</th>
        <th>오늘방문횟수</th>
        <th>활동여부</th>
        <th>현재레벨</th>
      </tr>
      <c:forEach var="vo" items="${vos}" varStatus="st">
        <tr>
          <td>${vo.idx}</td>
          <td><a href="${ctp}/admin/memberInfor/${vo.idx}" title="회원정보 상세보기">${vo.mid}</a></td>
          <!-- <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#myModal1">Open modal 1</button> -->
          <td><a href="#" onclick="imgInfor('${vo.nickName}','${vo.mid}','${vo.photo}')" data-bs-toggle="modal" data-bs-target="#myModal1">${vo.nickName}</a></td>
          <td>${vo.name}</td>
          <td>${fn:substring(vo.birthday,0,10)}</td>
          <td>${vo.gender}</td>
          <td>${fn:substring(vo.lastDate,0,10)}</td>
          <td>${vo.todayCnt}</td>
          <td>
          	${vo.userDel == 'NO' ? '활동중' : '<font color=red>탈퇴신청</font>'}
          	<c:if test="${vo.userDel == 'OK'}">(${vo.deleteDiff}일 지남)</c:if>
          </td>
          <td>
            <select name="level" id="level" onchange="levelChange(this)">
              <option value="1/${vo.idx}"   ${vo.level == 1 ? 'selected' : ''}>우수회원</option>
              <option value="2/${vo.idx}"   ${vo.level == 2 ? 'selected' : ''}>정회원</option>
              <option value="3/${vo.idx}"   ${vo.level == 3 ? 'selected' : ''}>준회원</option>
              <option value="0/${vo.idx}"   ${vo.level == 0 ? 'selected' : ''}>관리자</option>
              <option value="999/${vo.idx}" ${vo.level == 999 ? 'selected' : ''}>탈퇴신청회원</option>
            </select>
          </td>
        </tr>
      </c:forEach>
    </table>
  </form>
</div>

<!-- The Modal -->
<div class="modal fade" id="myModal1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title nickName"></h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p>아이디 : <span class="mid"></span></p>
        <p>포토<br/>
          <img class="imgSrc" width="250px"/>
        </p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<p><br/></p>
</body>
</html>