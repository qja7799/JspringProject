<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
    'use strict';
    
    function partCheck() {
    	let part = $("#part").val();
    	location.href = "pdsList?pag=1&pageSize=${pageVo.pageSize}&part="+part;
    }
    
    // 선택한 자료글 삭제 + 선택한 자료글의 모든파일 삭제처리
    function pdsDelete(idx, files) {
    	//alert("idx: " + idx + "\nfiles: " + files); // 확인용
    	let ans = confirm("선택한 자료글을 삭제하시겠습니까?");
    	if(!ans) return false;
    	
    	$.ajax({
    		url  : "${ctp}/pds/pdsDelete",
    		type : "post",
    		data : {idx: idx , files: files},
    		success:function(res) {
    			if(res != "0") {
    				alert("자료글이 삭제 되었습니다.");
    				location.reload();
    			}
    			else alert("자료글 삭제 실패~~");
    		},
    		error : function() { alert("전송오류!"); }
    	});
    }
  </script>
  <link rel="stylesheet" type="text/css" href="${ctp}/css/linkOrange.css"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">자 료 실 리 스 트(${pageVo.part})</h2>
  <br/>
  <table class="table table-borderless m-0 p-0">
    <tr>
      <td>
        <form name="partForm">
          <select name="part" id="part" onchange="partCheck()">
            <option ${pageVo.part == '전체' ? 'selected' : ''}>전체</option>
            <option ${pageVo.part == '학습' ? 'selected' : ''}>학습</option>
            <option ${pageVo.part == '여행' ? 'selected' : ''}>여행</option>
            <option ${pageVo.part == '음식' ? 'selected' : ''}>음식</option>
            <option ${pageVo.part == '기타' ? 'selected' : ''}>기타</option>
          </select>
        </form>
      </td>
      <td class="text-end">
        <a href="pdsInput?part=${pageVo.part}" class="btn btn-success btn-sm">자료올리기</a>
      </td>
    </tr>
  </table>
  <table class="table table-hover text-center">
    <tr class="table-secondary">
      <th>번호</th>
      <th>자료제목</th>
      <th>올린이</th>
      <th>올린날짜</th>
      <th>분류</th>
      <th>파일명(크기)</th>
      <th>다운수</th>
      <th>비고</th>
    </tr>
    <c:set var="curScrStartNo" value="${pageVo.curScrStartNo}"/>
    <c:forEach var="vo" items="${vos}" varStatus="st">
      <tr>
	      <td>${curScrStartNo}</td>
	      <td>${vo.title}
	      </td>
	      <td>${vo.nickName}</td>
	      <td>
	        ${vo.dateDiff == 0 ? fn:substring(vo.FDate,11,19) : fn:substring(vo.FDate,0,10)}
	      </td>
	      <td>${vo.part}</td>
	      <td>
	        <c:set var="fNames" value="${fn:split(vo.FName,'/')}"/><!-- 이건 업로드했을때의 파일명 -->
	        <c:set var="fSNames" value="${fn:split(vo.FSName,'/')}"/><!-- 이건 서버에 저장된 파일명 -->
	        <c:forEach var="fName" items="${fNames}" varStatus="st">
	        <!-- download <= 이렇게 태그안에 download속성만 달랑 주게되면 자동으로 서버에 저장된 파일명으로 파일이 다운로드되는데
	        download="${fName}" 이렇게 어떤이름으로 다운받을지 지정해주면 서버에 저장된 파일을 지정한 이름으로 다운받게됨
	        추가정보!
	        경로를 ${fSNames[st.index]} => 250327160111_오샤레기.jpg	이렇게 줬는데 
	        ${ctp}/pds/${fSNames[st.index]} 이렇게 컨텍스트루트 앞에 안붙여주고도 
	        어떻게 다운이 받아지는거냐면 지금 이곳 pdsList.jsp의 경로는 /JspringProject/pds/pdsList 이라서
	        현재위치(제자리)에서 이동하는것이기에 /JspringProject/pds/${fSNames[st.index]} 이렇게 이동이 되는거임
	        그리고 servlet-context.xml에서 <resources mapping="/pds/**" location="/resources/data/pds/"/>
	        이렇게 경로 매핑을 해놓았기에 /JspringProject/pds/${fSNames[st.index]} 이걸로 서버에 있는 파일에 접근이 가능한거
	        -->
	        	<a href="${fSNames[st.index]}" download>${fName}</a><br/>
	        </c:forEach>
	        (<fmt:formatNumber value="${vo.FSize/1024}" pattern="#,##0" />KByte)
	      </td>
	      <td>${vo.downNum}</td>
	      <td>
	        <a href="#" onclick="pdsDelete(${vo.idx},'${vo.FSName}')" class="badge bg-danger">삭제</a>
	        <a href="#" class="badge bg-primary">상세보기</a>
	      </td>
      </tr>
      <c:set var="curScrStartNo" value="${curScrStartNo - 1}"/>
    </c:forEach>
  </table>
</div>

<!-- 블록페이지 시작 -->
<div class="text-center">
  <ul class="pagination justify-content-center">
    <c:if test="${pageVo.pag > 1}"><li class="page-item"><a class="page-link text-secondary" href="pdsList?part=${pageVo.part}&pag=1&pageSize=${pageSize}">첫페이지</a></li></c:if>
  	<c:if test="${pageVo.curBlock > 0}"><li class="page-item"><a class="page-link text-secondary" href="pdsList?part=${pageVo.part}&pag=${(curBlock-1)*blockSize+1}&pageSize=${pageVo.pageSize}">이전블록</a></li></c:if>
  	<c:forEach var="i" begin="${(pageVo.curBlock*pageVo.blockSize)+1}" end="${(pageVo.curBlock*pageVo.blockSize)+pageVo.blockSize}" varStatus="st">
	    <c:if test="${i <= pageVo.totPage && i == pageVo.pag}"><li class="page-item active"><a class="page-link bg-secondary border-secondary" href="pdsList?part=${pageVo.part}&pag=${i}&pageSize=${pageVo.pageSize}">${i}</a></li></c:if>
	    <c:if test="${i <= pageVo.totPage && i != pageVo.pag}"><li class="page-item"><a class="page-link text-secondary" href="pdsList?part=${pageVo.part}&pag=${i}&pageSize=${pageVo.pageSize}">${i}</a></li></c:if>
  	</c:forEach>
  	<c:if test="${pageVo.curBlock < pageVo.lastBlock}"><li class="page-item"><a class="page-link text-secondary" href="pdsList?part=${pageVo.part}&pag=${(pageVo.curBlock+1)*pageVo.blockSize+1}&pageSize=${pageVo.pageSize}">다음블록</a></li></c:if>
  	<c:if test="${pageVo.pag < pageVo.totPage}"><li class="page-item"><a class="page-link text-secondary" href="pdsList?part=${pageVo.part}&pag=${pageVo.totPage}&pageSize=${pageVo.pageSize}">마지막페이지</a></li></c:if>
  </ul>
</div>
<!-- 블록페이지 끝 -->

<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>