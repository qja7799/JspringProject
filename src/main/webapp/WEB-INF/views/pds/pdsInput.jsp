<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>pdsInput.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    function fCheck() {
    	let maxSize = 1024 * 1024 * 20;	// 한번에 업로드할 파일의 최대용량을 20MByte로 한정
    	let fName = document.getElementById("fName").value;
    	let ext = "";
    	let fileSize = 0;
    	let title = $("#title").val();
    	
    	if(fName.trim() == "") {
    		alert("업로드할 파일을 선택하세요");
    		return false;
    	}
    	else if(title.trim() == "") {
    		alert("업로드할 파일의 제목을 입력하세요");
    		return false;
    	}
    	
    	let fileLength = document.getElementById("fName").files.length;	// 선택한 파일의 개수
    	
    	for(let i=0; i<fileLength; i++) {
    		fName = document.getElementById("fName").files[i].name;
    		ext = fName.substring(fName.lastIndexOf(".")+1).toLowerCase();
    		fileSize += document.getElementById("fName").files[i].size;
    		if(ext != "jpg" && ext != "jfif" && ext != "gif" && ext != "png" && ext != "zip" && ext != "ppt" && ext != "pptx" && ext != "hwp") {
      		alert("업로드 가능파일은 'jpg/gif/png/zip/ppt/pptx/hwp' 입니다.");
      		return false;
      	}
    	}
    	
    	if(fileSize > maxSize) {
    		alert("업로드할 파일의 최대용량은 20MByte입니다.");
    		return false;
    	}
    	else {
    		//myform.fileSize.value = fileSize;
    		myform.submit();
    	}
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">자 료 올 리 기</h2>
  <br/>
  <form name="myform" method="post" enctype="multipart/form-data">
    <div class="mb-3">
      <input type="file" name="file" id="fName" multiple class="form-control" />
    </div>
    <div class="mb-3">
      올린이 : <input type="text" name="nickName" id="nickName" value="${sNickName}" class="form-control" readonly />
    </div>
    <div class="mb-3">
      제목 : <input type="text" name="title" id="title" placeholder="자료의 제목을 입력하세요" class="form-control" required />
    </div>
    <div class="mb-3">
      내용 : <textarea rows="4" name="content" id="content" placeholder="자료의 상세내역을 입력하세요" class="form-control"></textarea>
    </div>
    <div class="mb-3">
      분류 : 
      <select name="part" id="part" class="form-select">
        <option ${part=='학습' ? 'selected' : ''}>학습</option>
        <option ${part=='여행' ? 'selected' : ''}>여행</option>
        <option ${part=='음식' ? 'selected' : ''}>음식</option>
        <option ${part=='기타' ? 'selected' : ''}>기타</option>
      </select>
    </div>
    <div class="mb-3">
      공개여부 : 
      <input type="radio" name="openSw" value="공개" checked /> 공개 &nbsp;&nbsp;
      <input type="radio" name="openSw" value="비공개" /> 비공개
    </div>
    <div class="row mt-3">
      <div class="col">
	      <input type="button" value="자료올리기" onclick="fCheck()" class="btn btn-success"/>
	      <input type="reset" value="다시쓰기"  class="btn btn-warning"/>
      </div>
      <div class="col text-end">
      	<input type="button" value="돌아가기" onclick="location.href='pdsList?part=${part}';" class="btn btn-info"/>
      </div>
    </div>
    <input type="hidden" name="hostIp" value="${pageContext.request.remoteAddr}" />
    <input type="hidden" name="mid" value="${sMid}" />
    <!-- <input type="hidden" name="fSize" /> -->
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>