<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<c:set var="path_root"  value="${pageContext.request.contextPath}" scope="application"/>

<!DOCTYPE html>
<html lang="ko">

<head>
	<c:import url="../common/includecommon.jsp" />

<script type="text/javascript">

$(document).ready(function () {
	if(${empty broadcast}){
		$("#category").val("TV");
		$("#genre").val("드라마");
		$("#grade").val("전체");
	}
	
	if(${!empty broadcast}){
		$("#category").val("${broadcast.category}");
	    $("#select_genre").html("");
	    if("${broadcast.category}" == "TV"){
	    	$("#select_genre").html("<option <c:if test="${broadcast.genre == '드라마'}">selected</c:if>>드라마</option>"+
	    			"<option <c:if test="${broadcast.genre == '스릴러ㆍ범죄'}">selected</c:if>>예능</option>");
	    	$("#genre").val("${broadcast.genre}");
	    }else if("${broadcast.category}" == "MOVIE"){
	    	$("#select_genre").html("<option <c:if test="${broadcast.genre == '액션ㆍ전쟁'}">selected</c:if>>액션ㆍ전쟁</option>"+
	    			"<option <c:if test="${broadcast.genre == '스릴러ㆍ범죄'}">selected</c:if>>스릴러ㆍ범죄</option>"+
	    			"<option <c:if test="${broadcast.genre == '로멘스ㆍ멜로'}">selected</c:if>>로멘스ㆍ멜로</option>"+
	    			"<option <c:if test="${broadcast.genre == '드라마ㆍ가족'}">selected</c:if>>드라마ㆍ가족</option>"+
	    			"<option <c:if test="${broadcast.genre == 'SFㆍ환타지'}">selected</c:if>>SFㆍ환타지</option>"+
	    			"<option <c:if test="${broadcast.genre == '공포ㆍ호러'}">selected</c:if>>공포ㆍ호러</option>"+
	    			"<option <c:if test="${broadcast.genre == '코미디'}">selected</c:if>>코미디</option>"+
	    			"<option <c:if test="${broadcast.genre == '애니'}">selected</c:if>>애니</option>"+
	    			"<option <c:if test="${broadcast.genre == '뮤지컬ㆍ음악'}">selected</c:if>>뮤지컬ㆍ음악</option>"+
	    			"<option <c:if test="${broadcast.genre == '다큐멘터리'}">selected</c:if>>다큐멘터리</option>"+
	    			"<option <c:if test="${broadcast.genre == '스포츠'}">selected</c:if>>스포츠</option>");
	    	$("#genre").val("${broadcast.genre}");
	    }else if("${broadcast.category}" == "INTERNET"){
	    	$("#select_genre").html("<option <c:if test="${broadcast.genre == 'CF'}">selected</c:if>>CF</option>"+
	    			"<option <c:if test="${broadcast.genre == '뮤비'}">selected</c:if>>뮤비</option>"+
	    			"<option <c:if test="${broadcast.genre == '게임'}">selected</c:if>>게임</option>");
	    	$("#genre").val("${broadcast.genre}");	    	
	    }else if("${broadcast.category}" == "MUSIC"){
	    	$("#select_genre").html("<option <c:if test="${broadcast.genre == '음악'}">selected</c:if>>음악</option>");
	    	$("#genre").val("${broadcast.genre}");
	    	$("#album_div").removeAttr("style");
	    }else if("${broadcast.category}" == "ETC"){
	    	$("#select_genre").html("<option <c:if test="${broadcast.genre == 'ETC'}">selected</c:if>>ETC</option>");
	    	$("#genre").val("${broadcast.genre}");
	    }
	}

	$("#select_category").change(function(){
	    $("#category").val($(this).val());
	    $("#select_genre").html("");
	    if($(this).val() == "TV"){
	    	$("#select_genre").html("<option>드라마</option>"+"<option>예능</option>"+"<option>스포츠</option>");
	    	$("#genre").val("드라마");
	    	$("#album_div").attr("style","display:none;");
	    	$("#extension4").parents("label").removeClass("active");
	    	$("#extension4").removeAttr("checked");
	    	$("#extension1").attr("checked","checked");
	    	$("#extension1").parents("label").addClass("active");
	    }else if($(this).val() == "MOVIE"){
	    	$("#select_genre").html("<option>액션ㆍ전쟁</option>"+"<option>스릴러ㆍ범죄</option>"+"<option>로멘스ㆍ멜로</option>"+
	    			"<option>드라마ㆍ가족</option>"+"<option>SFㆍ환타지</option>"+"<option>공포ㆍ호러</option>"+
	    			"<option>코미디</option>"+"<option>애니</option>"+"<option>뮤지컬ㆍ음악</option>"+
	    			"<option>다큐멘터리</option>"+"<option>스포츠</option>");
	    	$("#genre").val("액션ㆍ전쟁");
	    	$("#album_div").attr("style","display:none;");
	    	$("#extension4").parents("label").removeClass("active");
	    	$("#extension4").removeAttr("checked");
	    	$("#extension1").attr("checked","checked");
	    	$("#extension1").parents("label").addClass("active");
	    }else if($(this).val() == "INTERNET"){
	    	$("#select_genre").html("<option>CF</option>"+"<option>뮤비</option>"+"<option>게임</option>");
	    	$("#genre").val("CF");
	    	$("#album_div").attr("style","display:none;");
	    }else if($(this).val() == "MUSIC"){
	    	$("#select_genre").html("<option>음악</option>");
	    	$("#genre").val("음악");
	    	$("#album_div").removeAttr("style");
	    	$("#extension1").parents("label").removeClass("active");
	    	$("#extension1").removeAttr("checked");
	    	$("#extension4").attr("checked","checked");
	    	$("#extension4").parents("label").addClass("active");
	    }else if($(this).val() == "ETC"){
	    	$("#select_genre").html("<option>ETC</option>");
	    	$("#genre").val("ETC");
	    	$("#album_div").attr("style","display:none;");
	    }
	});
	$("#select_genre").change(function(){
	    $("#genre").val($(this).val());
	});
	$("#select_grade").change(function(){
	    $("#grade").val($(this).val());
	});
});
</script>

<style>
.buying-selling.active {
    background: #777777;       
}

.buying-selling.active.focus{
	background-color: #777777;
}

.buying-selling {
    width: 75px; 
    padding: 6px;
    position: relative;
}

.buying-selling-word {
    font-size: 14px;
    font-weight: 600;
    margin-left: 15px;
}

.radio-dot:before, .radio-dot:after {
    content: "";
    display: block;
    position: absolute;
    background: #fff;
    border-radius: 100%;
}

.radio-dot:before {
    width: 16px;
    height: 16px;
    border: 1px solid #ccc;
    top: 8px;
    left: 8px;
}

.radio-dot:after {
    width: 12px;
    height: 12px;
    border-radius: 100%;
    top: 10px;
    left: 10px;
}

.buying-selling.active .buying-selling-word {
    color: #fff;
}

.buying-selling.active .radio-dot:after {
    background: #777777;
}

.buying-selling.active .radio-dot:before {
    background: #fff;
    border-color: #777777;
}

.buying-selling:hover .radio-dot:before {
    border-color: #777777;
}

.buying-selling.active:hover .radio-dot:before {
    border-color: #545454;
}


.buying-selling.active .radio-dot:after {
    background: #545454;
}

.buying-selling:hover .radio-dot:after {
    background: #777777;
}

.buying-selling.active:hover .radio-dot:after {
    background: #777777;
    
}

</style>

</head>

<body>

    <!-- Navigation -->
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <c:import url="../common/header.jsp" />
        <!-- /.container -->
    </nav>

    <!-- Page Content -->
    <div class="container">

        <!-- Page Heading/Breadcrumbs -->
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">
                	<c:if test="${empty broadcast}">
                		파일등록
                	</c:if>
                	<c:if test="${!empty broadcast}">
                		파일수정
                	</c:if>
                </h1>
                <ol class="breadcrumb">
                    <li>
                    	<a href="/defaults/main.do">Home</a>
                    </li>
                    <li>
                    	<a href="/sgCloud/sgCloud_main.do">sgCloud</a>
                    </li>
                    <li class="active">sgCloud Registration</li>
                </ol>
            </div>
        </div>
        <!-- /.row -->

        <!-- Content Row -->
        <div class="row">

			<!-- sgCloud Sidebar Widgets Column -->

            <!-- sgCloud Post Content Column -->
            <div class="well">
	            <form id="form" name="form" method="post" action="/sgCloud/add_ok.do">
	            	<input type="hidden" name="idx" id="idx" value="${broadcast.idx}" />
            		<div class="form-group">
						<label for="title" class="cols-sm-2 control-label">제목</label>
						<div class="cols-sm-10">
							<div class="input-group">
								<span class="input-group-addon"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></span>
								<input type="text" class="form-control" id="title" name="title" value="${broadcast.title}" placeholder="Enter your Title" required data-validation-required-message="Please enter title.">
							</div>
						</div>
					</div>
					<div class="form-group">
						<label for="category" class="cols-sm-2 control-label">카테고리</label>
						<div class="cols-sm-10">
							<div class="input-group">
								<span class="input-group-addon"><i class="fa fa-list-ul" aria-hidden="true"></i></span>
								<select class="form-control" id="select_category">
									<option <c:if test="${broadcast.category == 'TV'}">selected</c:if>>TV</option>
									<option <c:if test="${broadcast.category == 'MOVIE'}">selected</c:if>>MOVIE</option>
									<option <c:if test="${broadcast.category == 'MUSIC'}">selected</c:if>>MUSIC</option>
									<option <c:if test="${broadcast.category == 'INTERNET'}">selected</c:if>>INTERNET</option>
									<option <c:if test="${broadcast.category == 'ETC'}">selected</c:if>>ETC</option>
								</select>
	                            <input type="hidden" class="form-control" id="category" name="category" value="${broadcast.category}" required data-validation-required-message="Please enter category." />
							</div>
						</div>
					</div>
					<div class="form-group">
						<label for="genre" class="cols-sm-2 control-label">장르</label>
						<div class="cols-sm-10">
							<div class="input-group">
								<span class="input-group-addon"><i class="fa fa-list-ul" aria-hidden="true"></i></span>
								<select class="form-control" id="select_genre">
	                            	<option>드라마</option>
									<option>예능</option>
								</select>
	                            <input type="hidden" class="form-control" id="genre" name="genre" value="${broadcast.genre}" required data-validation-required-message="Please enter genre." />
							</div>
						</div>
					</div>                     
					<div class="form-group">
						<label for="grade" class="cols-sm-2 control-label">등급</label>
						<div class="cols-sm-10">
							<div class="input-group">
								<span class="input-group-addon"><i class="fa fa-list-ul" aria-hidden="true"></i></span>
								<select class="form-control" id="select_grade">
	                            	<option <c:if test="${broadcast.grade == '전체'}">selected</c:if>>전체</option>
									<option <c:if test="${broadcast.grade == '19'}">selected</c:if>>19</option>
									<option <c:if test="${broadcast.grade == '15'}">selected</c:if>>15</option>
									<option <c:if test="${broadcast.grade == '12'}">selected</c:if>>12</option>
									<option <c:if test="${broadcast.grade == '7'}">selected</c:if>>7</option>
								</select>
	                            <input type="hidden" class="form-control" id="grade" name="grade" value="${broadcast.grade}" required data-validation-required-message="Please enter grade." />
							</div>
						</div>
					</div>   
					<div class="form-group">
						<label for="foldername" class="cols-sm-2 control-label">폴더명</label>
						<div class="cols-sm-10">
							<div class="input-group">
								<span class="input-group-addon"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></span>
								<input type="text" class="form-control" id="foldername" name="foldername" value="${broadcast.foldername}" placeholder="Enter your FolderName" required data-validation-required-message="Please enter Foldername." />
							</div>
						</div>
					</div>					                  
					<div class="form-group" id="album_div" style="display:none;">
						<label for="albumname" class="cols-sm-2 control-label">앨범명</label>
						<div class="cols-sm-10">
							<div class="input-group">
								<span class="input-group-addon"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></span>
								<input type="text" class="form-control" id="albumname" name="albumname" value="${broadcast.albumname}" placeholder="Enter your AlbumName"/>
							</div>
						</div>
					</div>					                  
					<div class="form-group">
						<label for="play_date" class="cols-sm-2 control-label">개봉ㆍ방송일</label>
						<div class="cols-sm-10">
							<div class="input-group">
								<span class="input-group-addon" id="basic-addon1"><i class="fa fa-calendar" aria-hidden="true"></i></span>
								<input type="date" class="form-control" id="play_date" name="play_date" value="${broadcast.play_date}"/>
							</div>
						</div>
					</div>					                  
					<div class="form-group">
						<label for="filename" class="cols-sm-2 control-label">확장자</label>
						<div class="buying-selling-group" id="buying-selling-group" data-toggle="buttons">
					        <label class="btn btn-default buying-selling <c:if test="${broadcast.extension == '.mp4' || empty broadcast}">active</c:if>">
					        	<input type="radio" name="extension" id="extension1" value=".mp4" autocomplete="off" <c:if test="${broadcast.extension == '.mp4' || empty broadcast}">checked</c:if>>
					            <span class="radio-dot"></span>
					            <span class="buying-selling-word">.mp4</span>
					        </label>
					        <label class="btn btn-default buying-selling <c:if test="${broadcast.extension == '.mkv'}">active</c:if>">
					            <input type="radio" name="extension" id="extension2" value=".mkv" autocomplete="off" <c:if test="${broadcast.extension == '.mkv'}">checked</c:if>>
					            <span class="radio-dot"></span>
					            <span class="buying-selling-word">.mkv</span>
					        </label>
					        <label class="btn btn-default buying-selling <c:if test="${broadcast.extension == '.avi'}">active</c:if>">
					            <input type="radio" name="extension" id="extension3" value=".avi" autocomplete="off" <c:if test="${broadcast.extension == '.avi'}">checked</c:if>>
					            <span class="radio-dot"></span>
					            <span class="buying-selling-word">.avi</span>
					        </label>
					        <label class="btn btn-default buying-selling <c:if test="${broadcast.extension == '.mp3'}">active</c:if>">
					            <input type="radio" name="extension" id="extension4" value=".mp3" autocomplete="off" <c:if test="${broadcast.extension == '.mp3'}">checked</c:if>>
					            <span class="radio-dot"></span>
					            <span class="buying-selling-word">.mp3</span>
					        </label>
						</div>
					</div>                  
                    <div class="form-group">
						<div class="checkbox">
							<label style="padding-left:0px;">
								<input type="checkbox" id="sub_check" name="sub_check" <c:if test="${broadcast.sub_check }">checked</c:if>/>
								<span class="cr"><i class="cr-icon glyphicon glyphicon-ok"></i></span>
								자막여부				            
							</label>
						</div>
					</div>
					<div class="form-group">
						<button type="submit" class="btn btn-primary btn-lg btn-block">Register</button>
					</div>
                </form>
            </div>
        </div>
        <!-- /.row -->

        <hr>

        <!-- Footer -->
        <footer>
            <c:import url="../common/footer.jsp" />
        </footer>

    </div>
    <!-- /.container -->

    <!-- jQuery -->
</body>

</html>
