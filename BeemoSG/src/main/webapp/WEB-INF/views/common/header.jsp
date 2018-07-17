<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
	.login_btn{
	    background: no-repeat;
	    border: none;
	    outline: 0;
	    color: #9d9d9d;
	    position: relative;
    	float: right;
	}
	.logout_btn{
		font-size: 14px;
		float: right;
	}
	.header-input{
		border: medium none;
	    border-radius: 4px;
	    box-shadow: none;
	    color: #8a8a8a;
	    float: left;
	    height: 34px;
	    width: 200px;
	    padding: 0 10px;
	}
	.header-btn{
		display: inline-block;
		background: none repeat scroll 0 0 #bfbfbf;
	    padding: 6px 12px;
	    margin-bottom: 0;
	    font-size: 14px;
	    font-weight: normal;
	    line-height: 1.42857143;
	    text-align: center;
	    white-space: nowrap;
	    vertical-align: middle;
	    -ms-touch-action: manipulation;
	    touch-action: manipulation;
	    cursor: pointer;
	    -webkit-user-select: none;
	    -moz-user-select: none;
	    -ms-user-select: none;
	    user-select: none;
	    background-image: none;
	    border: 1px solid transparent;
	    border-radius: 4px;
	}
</style>
<%--
<div id="sidebar-wrapper">
	<div class="sidebar-nav">
		<div>
			<img src="${path_root}/resources/bootstrap/images/profile.png" class="img-responsive center-block" alt="">
		</div>
		<c:if test="${!empty sessionScope.user}">
		<div class="profile-usertitle">
			<div class="profile-usertitle-name">
				이름 : ${sessionScope.user.cust_name}<br/>
	 			아이디 : ${sessionScope.user.cust_id}<br/>
			</div>
		</div>
		</c:if>
		<!-- END SIDEBAR USER TITLE -->
		<!-- SIDEBAR BUTTONS -->
		<div class="profile-userbuttons">
		<c:if test="${!empty sessionScope.user}">
			<button type="button" class="btn btn-danger btn-sm">로그아웃</button>
		</c:if>
		<c:if test="${empty sessionScope.user}">
			<button type="button" class="btn btn-success btn-sm">로그인</button>
		</c:if>
		</div>
	</div>
</div>
--%>
<div class="container">
	<form id="broadcastForm" name="broadcastForm" method="post">
		<input type="hidden" id="searchWord" name="searchWord"	value="${searchWord}">
		<input type="hidden" id="rnum" 		 name="rnum" 		value="${rnum}">
		<input type="hidden" id="prev" 		 name="prev" 		value="${prev}">
		<input type="hidden" id="next" 		 name="next" 		value="${next}">
		<input type="hidden" id="category" 	 name="category" 	value="${category}">
		<input type="hidden" id="genre"  	 name="genre"  		value="${genre}">
		<input type="hidden" id="foldername" name="foldername"	value="${foldername}">
		<input type="hidden" id="country" 	 name="country" 	value="${country}">
	</form>
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
    	<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="/defaults/main.do">BeemoSG</a>
        <c:if test="${empty sessionScope.user}">
        	<button class="modal-footer button login_btn" data-toggle="modal" data-target="#myModal" style="height:auto;">로그인</button>
        </c:if>
        <c:if test="${!empty sessionScope.user}">
        	<a class="navbar-brand logout_btn" href="/defaults/logout.do">로그아웃</a>
        </c:if>
    </div>
    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
        <ul class="nav navbar-nav navbar-right">
            <li class="<c:if test="${dropdown == 'sgCloud'}">active</c:if>">
                <a href="javascript:goUrlHeader('/sgCloud/sgCloud_main.do');">sgCloud</a>
            </li>
            <li class="<c:if test="${dropdown == 'level'}">active</c:if>">
                <a href="javascript:goUrlHeader('/sgCloud/sgCloud_board.do?gubun=level');">등업게시판</a>
            </li>
            <li class="<c:if test="${dropdown == 'request'}">active</c:if>">
                <a href="javascript:goUrlHeader('/sgCloud/sgCloud_board.do?gubun=request');">자료요청게시판</a>
            </li>
            <c:if test="${sessionScope.user.admin_yn == '1'}">
            <li class="<c:if test="${dropdown == 'file_add'}">active</c:if>">
                <a href="javascript:goUrlHeader('/sgCloud/sgCloud_add.do');">파일등록</a>
            </li>
            </c:if>
            <li style="padding: 8px;">
                <input type="text" class="header-input" placeholder="파일 검색" id="headerSearchWord" onkeydown="javascript:headerEventSearchGo(event);">
                <button class="header-btn" type="button" onClick="headerSearchGo();"><i class="fas fa-search"></i></button>
            </li>
            <!-- 
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Portfolio <b class="caret"></b></a>
                <ul class="dropdown-menu">
                    <li>
                        <a href="#">1 Column Portfolio</a>
                    </li>
                    <li>
                        <a href="#">2 Column Portfolio</a>
                    </li>
                    <li>
                        <a href="#">3 Column Portfolio</a>
                    </li>
                    <li>
                        <a href="#">4 Column Portfolio</a>
                    </li>
                    <li>
                        <a href="#">Single Portfolio Item</a>
                    </li>
                </ul>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Other Pages <b class="caret"></b></a>
                <ul class="dropdown-menu">
                    <li>
                        <a href="#">Full Width Page</a>
                    </li>
                    <li>
                        <a href="#">Sidebar Page</a>
                    </li>
                    <li>
                        <a href="#">FAQ</a>
                    </li>
                    <li>
                        <a href="#">404</a>
                    </li>
                    <li>
                        <a href="#">Pricing Table</a>
                    </li>
                </ul>
            </li>
            <li>
				<a id="menu-toggle" href="#" class="point-hover btn-lg toggle"><i class="fas fa-bars"></i></a>
			</li>
			 -->
        </ul>
    </div>
    <!-- /.navbar-collapse -->
</div>

<script type="text/javascript">
	var tmpUser = navigator.userAgent;
	
	function goUrlHeader(url){
		if("${sessionScope.user}" == "" || "${sessionScope.user}" == null){
			alert("로그인 후 이용 가능합니다.");
			$(".login_btn").trigger("click");
			return;
		}
		
		if (!(tmpUser.indexOf("iPhone") > 0 || tmpUser.indexOf("iPod") > 0 || tmpUser.indexOf("Android ") > 0 )){
			location.href = url;
		}else{
			location.href = url + "#view_position";
		}
	}
	
	/* 검색 - enter값 이벤트   */
	function headerEventSearchGo(e){
		if(e.keyCode == '13'){
			headerSearchGo();
		}
	}
	
	function headerSearchGo(){
		var form = document.broadcastForm;
		var searchWord = $("#headerSearchWord").val();
		
		form.category.value = "";
		form.genre.value = "";
		form.foldername.value = "";
		form.country.value = "";
		form.rnum.value = "";
		form.searchWord.value = searchWord;
		if (!(tmpUser.indexOf("iPhone") > 0 || tmpUser.indexOf("iPod") > 0 || tmpUser.indexOf("Android ") > 0 )){
			//location.href = "/sgCloud/sgCloud_main.do?searchWord="+searchWord;
			form.action = "/sgCloud/sgCloud_main.do";
		}else{
			//location.href = "/sgCloud/sgCloud_main.do?searchWord="+searchWord  + "#view_position";
			form.action = "/sgCloud/sgCloud_main.do#view_position";
		}
		form.submit();
	}
	
	/* 검색 - enter값 이벤트   */
	function EventSearchGo(e){
		if(e.keyCode == '13'){
			searchGo();
		}
	}
	
	function searchGo(){
		var form = document.broadcastForm;
		var searchWord = $("#mainSearchWord").val();
		
		form.category.value = "";
		form.genre.value = "";
		form.foldername.value = "";
		form.country.value = "";
		form.rnum.value = "";
		form.searchWord.value = searchWord;
		if (!(tmpUser.indexOf("iPhone") > 0 || tmpUser.indexOf("iPod") > 0 || tmpUser.indexOf("Android ") > 0 )){
		//location.href = "/sgCloud/sgCloud_main.do?searchWord="+searchWord;
			form.action = "/sgCloud/sgCloud_main.do";
		}else{
			form.action = "/sgCloud/sgCloud_main.do#view_position";
		}
		form.submit();
	}
	
	function fileSearch(category, genre, country){
		var form = document.broadcastForm;
		form.category.value = category;
		form.genre.value = genre;
		form.foldername.value = "";
		form.country.value = country;
		form.rnum.value = "";
		form.searchWord.value = "";
		if (!(tmpUser.indexOf("iPhone") > 0 || tmpUser.indexOf("iPod") > 0 || tmpUser.indexOf("Android ") > 0 )){
			//location.href = "/sgCloud/sgCloud_main.do?category=" + category + "&genre=" + genre + "&country=" + country;
			form.action = "/sgCloud/sgCloud_main.do";
		}else{
			//location.href = "/sgCloud/sgCloud_main.do?category=" + category + "&genre=" + genre + "&country=" + country + "#view_position";
			form.action = "/sgCloud/sgCloud_main.do#view_position";
		}
		form.submit();
	}
	
	function folderSearch(category, genre, foldername){
		var form = document.broadcastForm;
		form.category.value = category;
		form.genre.value = genre;
		form.foldername.value = foldername;
		form.country.value = "";
		form.rnum.value = "";
		form.searchWord.value = "";
		if (!(tmpUser.indexOf("iPhone") > 0 || tmpUser.indexOf("iPod") > 0 || tmpUser.indexOf("Android ") > 0 )){
			//location.href = "/sgCloud/sgCloud_main.do?category=" + category + "&genre=" + genre + "&foldername=" + foldername;
			form.action = "/sgCloud/sgCloud_main.do";
		}else{
			//location.href = "/sgCloud/sgCloud_main.do?category=" + category + "&genre=" + genre + "&foldername=" + foldername + "#view_position";
			form.action = "/sgCloud/sgCloud_main.do#view_position";
		}
		form.submit();
	}
</script> 
