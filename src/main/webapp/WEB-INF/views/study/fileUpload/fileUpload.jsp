<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>fileUpload.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    // 파일 업로드 처리
    function fCheck() {
    	let fName = document.getElementById("fName").value;
    	let ext = fName.substring(fName.lastIndexOf(".")+1).toLowerCase();
    	let maxSize = 1024 * 1024 * 20;	// 한번에 업로드할 파일의 최대용량을 20MByte로 한정
    	
    	if(fName.trim() == "") {
    		alert("업로드할 파일을 선택하세요");
    		return false;
    	}
    	
    	let fileSize = document.getElementById("fName").files[0].size;
    	if(fileSize > maxSize) alert("업로드할 파일의 최대용량은 20MByte입니다.");
    	else if(ext != "jpg" && ext != "gif" && ext != "png" && ext != "zip" && ext != "ppt" && ext != "pptx" && ext != "hwp") {
    		alert("업로드 가능파일은 'jpg/gif/png/zip/ppt/pptx/hwp' 입니다.");
    	}
    	else myform.submit();
    }
    
    // 선택된 파일 서버에서 삭제처리
    function fileDelete(file) {
    	let ans = confirm("선택된 파일을 삭제하시겠습니까?");
    	if(!ans) return false;
    	
    	$.ajax({
    		url  : "${ctp}/study/fileUpload/fileDelete",
    		type : "post",
    		data : {file : file},
    		success:function(res) {
    			if(res != "0") {
    				alert("파일이 삭제 되었습니다.");
    				location.reload();
    			}
    			else alert("파일 삭제 실패~~");
    		},
    		error : function() { alert("전송오류!"); }
    	});
    }
    
    // 모든 파일 삭제처리
    function fileDeleteAll() {
    	let ans = confirm("모든 파일을 삭제하시겠습니까?");
    	if(!ans) return false;
    	
    	$.ajax({
    		url  : "${ctp}/study/fileUpload/fileDeleteAll",
    		type : "post",
    		success:function(res) {
    			if(res != "0") {
    				alert("파일이 삭제 되었습니다.");
    				location.reload();
    			}
    			else alert("파일 삭제 실패~~");
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
  <h2>파일 업로드 연습</h2>
  <form name="myform" method="post" enctype="multipart/form-data">
    <p>올린이 :
      <input type="text" name="mid" value="${sMid}" readonly />
    </p>
    <p>파일명 :
      <input type="file" name="fName" id="fName" class="form-control" accept=".jpg,.gif,.png,.zip,.ppt,.pptx,.hwp" />
    </p>
    <p>
      <input type="button" value="파일업로드" onclick="fCheck()" class="btn btn-success"/>
      <input type="reset" value="다시선택" class="btn btn-warning"/>
      <input type="button" value="멀티파일연습" onclick="location.href='multiFile';" class="btn btn-primary"/>
    </p>
  </form>
  <br/>
  <hr class="border border-dark">
  <br/>
  <div id="uploadFile">
    <h3>서버에 저장된 파일정보(총 : ${fn:length(files)} 개)</h3>
    <div class="row mb-2">
      <div class="col">저장경로 : ${ctp}/resources/data/fileUpload/*.*</div>
      <div class="col text-end">
        <input type="button" value="폴더내 모든파일 삭제" onclick="fileDeleteAll()" class="btn btn-danger"/>
      </div>
    </div>
    <table class="table table-hover text-center">
      <tr class="table-secondary">
        <th>번호</th>
        <th>파일명</th>
        <th>파일형식</th>
        <th>비고</th>
      </tr>
      <c:forEach var="file" items="${files}" varStatus="st">
        <tr>
          <td>${st.count}</td>
          <td>${file}</td>
          <td>
			<!-- .을 구분자로 두고 문자를 쪼개서 배열로 저장 -->
    		<c:set var="fNameArray" value="${fn:split(file,'.')}"/>	
			<!-- 배열 길이 저장 -->
			<c:set var="arrayLength" value="${fn:length(fNameArray)}" />
			
			<!-- 마지막 인덱스 계산 -->
			<c:set var="lastIndex" value="${arrayLength - 1}" />
			
			<!-- 확장자 추출 후 소문자로 변환 -->
			<c:set var="extName" value="${fn:toLowerCase(fNameArray[lastIndex])}" />
<!-- 		file이름이 qwe.asd.jpg 라고한다면 스플릿으로 나눴을때 배열길이가 3이되게되고 배열길이-1 = 2 
			즉, fNameArray배열의 2번째인덱스값(인덱스는 0부터시작이니 마지막자리값임)을 추출함. 즉, 확장자명을 추출   -->
            <c:if test="${extName == 'jpg' || extName == 'gif' || extName == 'png'}"><a href="${ctp}/fileUpload/${file}" target="_blank" title="원본사진보기"><img src="${ctp}/fileUpload/${file}" width="150px"/></a></c:if>
            <c:if test="${extName == 'zip'}">압축파일</c:if>
            <c:if test="${extName == 'ppt' || extName == 'pptx'}">파워포인파일</c:if>
            <c:if test="${extName == 'xls' || extName == 'xlsx'}">엑셀파일</c:if>
            <c:if test="${extName == 'hwp' || extName == 'hwpx'}">한글 문서파일</c:if>
          </td>
          <td>
            <input type="button" value="삭제" onclick="fileDelete('${file}')" class="btn btn-danger btn-sm"/><br/>
            <!-- 사진을 제외한 집파일이나 ppt파일은 그냥 링크만걸어줘도 누르면 자동으로 다운받게됨 -->
         <%-- <a href="${ctp}/fileUpload/${file}" class="btn btn-primary btn-sm mt-2">다운로드</a>  --%>
         <!-- download속성을 넣으면 그림파일도 다운로드되도록 할수있음 -->
            <a href="${ctp}/fileUpload/${file}" download class="btn btn-primary btn-sm mt-2">다운로드</a>
          </td>
        </tr>
      </c:forEach>
    </table>
  </div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>