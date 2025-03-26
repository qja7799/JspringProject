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
    
    // 전체선택
    function allCheck() {
      for(let i=0; i<myform.idxFlag.length; i++) {
        myform.idxFlag[i].checked = true;
      }
    }

    // 전체취소
    function allReset() {
      for(let i=0; i<myform.idxFlag.length; i++) {
        myform.idxFlag[i].checked = false;
      }
    }

    // 선택반전
    function reverseCheck() {
      for(let i=0; i<myform.idxFlag.length; i++) {
        myform.idxFlag[i].checked = !myform.idxFlag[i].checked;
      }
    }
    
    // 여러개 선택항목 등급변경처리
    function levelSelectCheck() {
    	let select = document.getElementById("levelSelect");
    	let levelSelectText = select.options[select.selectedIndex].text;
    	let levelSelect = select.options[select.selectedIndex].value;
    	let idxSelectArray = '';
    	
      for(let i=0; i<myform.idxFlag.length; i++) {
        if(myform.idxFlag[i].checked) idxSelectArray += myform.idxFlag[i].value + "/";
      }
    	if(idxSelectArray == '') {
    		alert("등급을 변경할 항목을 1개 이상 선택하세요");
    		return false;
    	}
    	
    	let ans = confirm("선택한 항목의 등급을 "+levelSelectText+"등급으로 변경하시겠습니까?");
    	if(!ans) return false;
    	
      idxSelectArray = idxSelectArray.substring(0,idxSelectArray.lastIndexOf("/"));
      let query = {
    		  idxSelectArray : idxSelectArray,
    		  levelSelect : levelSelect
      }
      
      $.ajax({
    	  url  : "${ctp}/admin/member/memberLevelSelectCheck",
    	  type : "post",
    	  data : query,
    	  success:function(res) {
    		  if(res != "0") alert("선택한 항목들이 "+levelSelectText+"(으)로 변경되었습니다.");
    		  else alert("등급변경 실패~");
  			  location.reload();
    	  },
    	  error : function() {
    		  alert("전송 실패~~");
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
<p><br/></p>
<div class="container">
  <h2 class="text-center mb-4">전체 회원 리스트</h2>
  <div class="row mb-1">
    <div class="col-7">
	    <div class="input-group">
	      <input type="button" value="전체선택" onclick="allCheck()" class="btn btn-success btn-sm"/>
	      <input type="button" value="전체취소" onclick="allReset()" class="btn btn-primary btn-sm"/>
	      <input type="button" value="선택반전" onclick="reverseCheck()" class="btn btn-info btn-sm me-2"/>
	      <select name="levelSelect" id="levelSelect" class="form-select form-select-sm">
	        <option value="2">정회원</option>
	        <option value="3">준회원</option>
	        <option value="1">우수회원</option>
	      </select>
	      <input type="button" value="선택항목등급변경" onclick="levelSelectCheck()" class="btn btn-warning btn-sm" />
	    </div>
    </div>
    <div class="col-2"></div>
    <div class="col-3 text-end">
      <select name="levelItem" id="levelItem" onchange="levelItemCheck()" class="form-select form-select-sm">
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
          <td>
            <c:if test="${vo.level != 0}"><input type="checkbox" name="idxFlag" id="idxFlag${vo.idx}" value="${vo.idx}"/></c:if>
	          <c:if test="${vo.level == 0}"><input type="checkbox" name="idxFlag" id="idxFlag${vo.idx}" value="${vo.idx}" disabled /></c:if>
	          ${vo.idx}
          </td>
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
          	<c:if test="${vo.userDel == 'OK'}">(<font color="blue"><b>${vo.deleteDiff}</b></font>)</c:if>
          </td>
          <td>
            <select name="level" id="level" onchange="levelChange(this)" class="form-select form-select-sm">
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
  
	<!-- 블록페이지 시작(1블록의 크기를 3개(3Page)로 한다. -->
	<div class="text-center">
	  <ul class="pagination justify-content-center">
	    <c:if test="${pag > 1}"><li class="page-item"><a class="page-link text-secondary" href="memberList?pag=1">첫페이지</a></li></c:if>
	  	<c:if test="${curBlock > 0}"><li class="page-item"><a class="page-link text-secondary" href="memberList?pag=${(curBlock-1)*blockSize+1}">이전블록</a></li></c:if>
	  	<c:forEach var="i" begin="${(curBlock*blockSize)+1}" end="${(curBlock*blockSize)+blockSize}" varStatus="st">
		    <c:if test="${i <= totPage && i == pag}"><li class="page-item active"><a class="page-link bg-secondary border-secondary" href="memberList?pag=${i}">${i}</a></li></c:if>
		    <c:if test="${i <= totPage && i != pag}"><li class="page-item"><a class="page-link text-secondary" href="memberList?pag=${i}">${i}</a></li></c:if>
	  	</c:forEach>
	  	<c:if test="${curBlock < lastBlock}"><li class="page-item"><a class="page-link text-secondary" href="memberList?pag=${(curBlock+1)*blockSize+1}">다음블록</a></li></c:if>
	  	<c:if test="${pag < totPage}"><li class="page-item"><a class="page-link text-secondary" href="memberList?pag=${totPage}">마지막페이지</a></li></c:if>
	  </ul>
	</div>
	<!-- 블록페이지 끝 -->
  
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