<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="path_root"  value="${pageContext.request.contextPath}" scope="application"/>

<!DOCTYPE html>
<html lang="ko">

<head>
<c:import url="../common/includecommon.jsp" />

   <!-- google charts -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<style type="text/css">

</style>

<script type="text/javascript">
	var tmpUser = navigator.userAgent;
	
	$(document).ready(function() {
		if("${check}" == "ok"){
			alert("회원등급 요청을 해야 이용이 가능합니다.\n자유게시판에서 등업 신청을 해주세요.");
			return;
		}
	});
	
	function paging(rnum){
		if (!(tmpUser.indexOf("iPhone") > 0 || tmpUser.indexOf("iPod") > 0 || tmpUser.indexOf("Android ") > 0 )){		
			location.href = "/sgCloud/sgCloud_analysis.do?rnum=" + rnum;
		}else{
			location.href = "/sgCloud/sgCloud_analysis.do?rnum=" + rnum + "#view_position";
		}
	}

	function goUrl(gubun){
		if (!(tmpUser.indexOf("iPhone") > 0 || tmpUser.indexOf("iPod") > 0 || tmpUser.indexOf("Android ") > 0 )){
			location.href = "/sgCloud/sgCloud_board.do?gubun=" + gubun;
		}else{
			location.href = "/sgCloud/sgCloud_board.do?gubun=" + gubun + "#view_position";
		}
	}
	
	google.charts.load('current', {'packages' : [ 'bar' ]});
	google.charts.setOnLoadCallback(drawChart);

	function drawChart() {
		
		var arrData = [['일자', '수']];
		var resJson = JSON.parse('${loginHistoryListJson}');
		for (var i = 0; i < resJson.length; i++) {
			arrData = arrData.concat([[resJson[i].login_date, resJson[i].count]]);			
		}

		var data = google.visualization.arrayToDataTable(arrData);

		var options = {
			legend: { position: 'none' },
			axes: {
				x: {
					0: { side: 'bottom', label: ''}
				}
			}
		};

		var chart = new google.charts.Bar(document.getElementById('barChartArea'));

		window.addEventListener('resize', function() {
			chart.draw(data, google.charts.Bar.convertOptions(options));
		}, false); //화면 크기에 따라 그래프 크기 변경
		chart.draw(data, google.charts.Bar.convertOptions(options));
	}
</script>
</head>

<body>

    <!-- Navigation -->
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <c:import url="../common/header.jsp" />
        <!-- /.container -->
    </nav>

    <!-- Page Content -->
    <div class="container" style="background-color: #fff; box-shadow: 0px 0px 10px 0px #6f6f6f;">
        <!-- Page Heading/Breadcrumbs -->
        <div class="row">
            <div class="col-lg-12">
                <ol class="breadcrumb_sgcloud">
                    <li>
                    	<a href="/defaults/main.do"><i class="fas fa-home fa-fw"></i> Home</a>
                    </li>
                    <li>
                    	<a href="/sgCloud/sgCloud_main.do">sgCloud</a>
                    </li>
                    <li class="active">사용자분석</li>
                </ol>
            </div>
        </div>
        <!-- Page Heading/Breadcrumbs -->
        <div class="">
            <div class="inbox-head">
	            <h3>sgCloud</h3>
                <div class="input-append pull-right position">
                    <input type="text" class="sr-input" placeholder="파일 검색" id="mainSearchWord" onkeydown="javascript:EventSearchGo(event);">
                    <button class="btn sr-btn" type="button" onClick="searchGo();"><i class="fas fa-search fa-fw"></i></button>
                </div>
	        </div>
        </div>
        <!-- /.row -->

        <!-- Content Row -->
        <div class="row">
			<div class="col-md-3">
	            <div class="side-menu">
					<nav class="navbar navbar-default" role="navigation">
		            	<div class="side-menu-container">
		            		<ul class="nav navbar-nav">
			            		<li class="active"><a href="/sgCloud/sgCloud_main.do"><i class="fas fa-cloud fa-fw"></i> 전체</a></li>
			            		<!-- Dropdown-->
					            <li class="panel panel-default" id="dropdown">
					                <a data-toggle="collapse" href="#dropdown-tv1">
					                    <i class="fas fa-tv fa-fw"></i> TV프로그램 <span class="caret"></span>
					                </a>
					
					                <!-- Dropdown level 1 -->
					                <div id="dropdown-tv1" class="panel-collapse collapse" >
					                    <div class="panel-body">
					                        <ul class="nav navbar-nav">
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('TV','','');"><i class="fas fa-caret-right fa-fw"></i>전체</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('TV','드라마','KO');"><i class="fas fa-caret-right fa-fw"></i>한국드라마</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('TV','드라마','EN');"><i class="fas fa-caret-right fa-fw"></i>외국드라마</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('TV','예능','');"><i class="fas fa-caret-right fa-fw"></i>예능</a></li>
					                        </ul>
					                    </div>
					                </div>
					            </li>
					            <!-- Dropdown-->
					            <li class="panel panel-default" id="dropdown">
					                <a style="" data-toggle="collapse" href="#dropdown-movie1" >
					                    <i class="fas fa-video fa-fw"></i> 영화 <span class="caret"></span>
					                </a>
					
					                <!-- Dropdown level 1 -->
					                <div id="dropdown-movie1" class="panel-collapse collapse " >
					                    <div class="panel-body">
					                        <ul class="nav navbar-nav">
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('MOVIE','','');"><i class="fas fa-caret-right fa-fw"></i>전체</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('MOVIE','액션ㆍ전쟁','');"><i class="fas fa-caret-right fa-fw"></i>액션ㆍ전쟁</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('MOVIE','스릴러ㆍ범죄','');"><i class="fas fa-caret-right fa-fw"></i>스릴러ㆍ범죄</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('MOVIE','로멘스ㆍ멜로','');"><i class="fas fa-caret-right fa-fw"></i>로멘스ㆍ멜로</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('MOVIE','드라마ㆍ가족','');"><i class="fas fa-caret-right fa-fw"></i>드라마ㆍ가족</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('MOVIE','SFㆍ환타지','');"><i class="fas fa-caret-right fa-fw"></i>SFㆍ환타지</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('MOVIE','공포ㆍ호러','');"><i class="fas fa-caret-right fa-fw"></i>공포ㆍ호러</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('MOVIE','코미디','');"><i class="fas fa-caret-right fa-fw"></i>코미디</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('MOVIE','애니','');"><i class="fas fa-caret-right fa-fw"></i>애니</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('MOVIE','뮤지컬ㆍ음악','');"><i class="fas fa-caret-right fa-fw"></i>뮤지컬ㆍ음악</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('MOVIE','다큐멘터리','');"><i class="fas fa-caret-right fa-fw"></i>다큐멘터리</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('MOVIE','스포츠','');"><i class="fas fa-caret-right fa-fw"></i>스포츠</a></li>
					                        </ul>
					                    </div>
					                </div>
					            </li>
					            <li class=""><a style="" href="javascript:fileSearch('ANIMATION','','');"><i class="fab fa-leanpub fa-fw"></i> 애니</a></li>
					            <li class=""><a style="" href="javascript:fileSearch('MUSIC','','');"><i class="fas fa-music fa-fw"></i> 노래</a></li>
					            <!-- Dropdown-->
					            <li class="panel panel-default" id="dropdown">
					                <a style="" data-toggle="collapse" href="#dropdown-utility1" >
					                    <i class="fas fa-database fa-fw"></i> 유틸리티 <span class="caret"></span>
					                </a>
					
					                <!-- Dropdown level 1 -->
					                <div id="dropdown-utility1" class="panel-collapse collapse">
					                    <div class="panel-body">
					                        <ul class="nav navbar-nav">
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('UTILITY','','');"><i class="fas fa-caret-right fa-fw"></i>전체</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('UTILITY','소프트웨어','');"><i class="fas fa-caret-right fa-fw"></i>소프트웨어</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('UTILITY','보안ㆍ백신','');"><i class="fas fa-caret-right fa-fw"></i>보안ㆍ백신</a></li>
	                                            <li style="padding-left:30px;"><a style="" href="javascript:fileSearch('UTILITY','기타설치','');"><i class="fas fa-caret-right fa-fw"></i>기타설치</a></li>
					                        </ul>
					                    </div>
					                </div>
					            </li>

					            <li class="panel panel-default" id="dropdown">
					                <a style="" data-toggle="collapse" href="#dropdown-board1" aria-expanded="true">
					                    <i class="fas fa-list-alt fa-fw"></i> 자유게시판 <span class="caret"></span>
					                </a>
					
					                <!-- Dropdown level 1 -->
					                <div id="dropdown-board1" class="panel-collapse collapse">
					                    <div class="panel-body">
					                        <ul class="nav navbar-nav">
	                                            <li style="padding-left:30px;"><a href="javascript:goUrl('level');"><i class="fas fa-caret-right fa-fw"></i>등업게시판</a></li>
	                                            <li style="padding-left:30px;"><a href="javascript:goUrl('request');"><i class="fas fa-caret-right fa-fw"></i>자료요청게시판</a></li>
					                        </ul>
					                    </div>
					                </div>
					            </li>
					            <!-- Dropdown-->
					            <li class=""><a href="javascript:goUrlHeader('/sgCloud/sgCloud_analysis.do')" style="font-weight: 600; color: #333;"><i class="fas fa-chart-line fa-fw"></i> 사용자분석</a></li>
					            <li class="" id="view_position"><a href="/sgCloud/sgCloud_add.do"><i class="fas fa-upload fa-fw"></i> 파일등록</a></li>
							</ul>
			            </div>
		            </nav>
	            </div>
            </div>
            
            <div class="col-md-9">
				<div class="panel panel-default">
					<!-- Default panel contents -->
					<div id=bar_controls_chart>
						<!-- 라인 차트 생성할 영역 -->
						<div id="barChartArea"></div>
						<!-- 컨트롤바를 생성할 영역--> 
					</div>
				</div>
				<div id="tableArea">
					<table class="table">
						<tbody>
							<tr>
								<th>번호</th>
								<th>아이디</th>
			                    <th>이름</th>
			                    <th>접속일</th>					                    					                    
							</tr>
							<c:forEach var="loginHistoryList" items="${loginHistoryList}">
							<tr>
		                    	<td class="view-message">${loginHistoryList.rnum1}</td>
			                    <td class="view-message">${loginHistoryList.cust_id}</td>
			                    <td class="view-message">${loginHistoryList.cust_name}</td>
			                    <td class="view-message"><fmt:formatDate value="${loginHistoryList.insert_date}" pattern="yyyy.MM.dd(E) HH:mm:ss"/></td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<!-- Pager -->
                <ul class="pager">
                	<c:if test="${prev != 0 }">
	                    <li class="previous">
	                        <a href="javascript:paging('${prev}');">&larr; Prev</a>
	                    </li>
                    </c:if>
                    <c:if test="${next != 0 }">
	                    <li class="next">
	                        <a href="javascript:paging('${next}');">Next &rarr;</a>
	                    </li>
	                </c:if>
                </ul>
            </div>
        </div>
        <!-- /.row -->

        <!-- Footer -->
        <footer>
            <c:import url="../common/footer.jsp" />
        </footer>
	</div>
    <!-- /.container -->

    <!-- jQuery -->

</body>

</html>
