<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<c:set var="path_root"  value="${pageContext.request.contextPath}" scope="application"/>

<!DOCTYPE html>
<html lang="ko">

<head>
	<c:import url="../common/includecommon.jsp" />
<style type="text/css">
video{
	width:100%;
	max-width:720px;
	height:auto;
}

.col-video{
	width: 100%;
	max-width:720px;
	margin: 10px auto;
	height:auto;
}
@media ( min-width : 100px) {
	.title{
		font-size: 21px;	
	}
	.title span{	
		font-size: 12px;
	}
}

@media ( min-width : 460px) {
	.title{
		font-size: 28px;	
	}
	.title span{	
		font-size: 20px;
	}
}
.title{
	overflow: hidden;
	font-family: 'Noto Sans KR';
	padding-left: 5px;
	padding-right: 5px;
}

.title span{
	float: right;
	margin-top: 10px;
}
</style>

<link href="http://vjs.zencdn.net/c/video-js.css" rel="stylesheet" />
<script src="http://vjs.zencdn.net/c/video.js"></script>

<script type="text/javascript">
	var tmpUser = navigator.userAgent;
	
	function copy_trackback(trb) {
		
        var IE=(document.all)?true:false;
        if (IE) {
            if(confirm("복사하시겠습니까?"))
                window.clipboardData.setData("Text", "http://beemosg.gq:8081/LocalUser/data/" + encodeURI(trb));
        } else {
            temp = prompt("Ctrl+C를 눌러 클립보드로 복사하세요", "http://beemosg.gq:8081/LocalUser/data/" + encodeURI(trb));
        }
    }
	
	function vidEvent() {
		var videos = document.getElementsByTagName('video');
		var vidCount = videos.length;
		for(i=0;i<vidCount;i++) {
			videos[i].addEventListener('click',bang,false);
		}
	}
	function bang() { this.play(); }
	
	window.onload = vidEvent;
	
	function fileDownload(fileUrl, fileName){
		//var eFileUrl = encodeURIComponent(fileUrl);
		//var eFileName = encodeURIComponent(fileName);
		//alert(eFileUrl);
		if(tmpUser.indexOf("iPhone") > 0 || tmpUser.indexOf("iPod") > 0){
			alert("아이폰은 파일을 다운로드 할 수 없습니다.");
			return;
		}
		
		location.href = "/sgCloud/fileDownload.do?fileName="+fileName+"&fileUrl="+fileUrl;
	}
	
	function folderSearch(category, genre, foldername){
		if (!(tmpUser.indexOf("iPhone") > 0 || tmpUser.indexOf("iPod") > 0 || tmpUser.indexOf("Android ") > 0 )){
			location.href = "/sgCloud/sgCloud_main.do?category=" + category + "&genre=" + encodeURI(genre) + "&foldername=" + encodeURI(foldername);
		}else{
			location.href = "/sgCloud/sgCloud_main.do?category=" + category + "&genre=" + encodeURI(genre) + "&foldername=" + encodeURI(foldername) + "#view_position";
		}
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
                    	<a href="/defaults/main.do">Home</a>
                    </li>
                    <li>
                    	<a href="/sgCloud/sgCloud_main.do">sgCloud</a>
                    </li>
                    <li class="active">View</li>
                </ol>
            </div>
        </div>
        <!-- /.row -->

        <!-- Content Row -->
        <div class="row">
			<!-- sgCloud Sidebar Widgets Column -->
            <!-- sgCloud View Content Column -->
            <div class="col-lg-8" style="width: 100%;">
                <fmt:parseDate var="dateString" value="${broadcastDetail.play_date}" pattern="yyyy-MM-dd" />
                <h2 class="title">
                	${broadcastDetail.title} (
                	<a href="javascript:;" onclick="fileDownload('${broadcastDetail.file_url}','${broadcastDetail.filename}');">
				      	<i class="fa fa-download"></i>다운
					</a>
				    <c:if test="${broadcastDetail.sub_url != ''}">
				    	,&nbsp;
				    	<a href="javascript:;" onclick="fileDownload('${broadcastDetail.category}/${broadcastDetail.genre}/${broadcastDetail.foldername}/${broadcastDetail.sub_url}.smi','${broadcastDetail.sub_url}.smi');">
				        	 <i class="fa fa-cc"></i>자막
				        </a>
					</c:if>
					)<span><i class="fa fa-clock-o"></i>&nbsp;<fmt:formatDate value="${dateString}" pattern="yyyy년 MM월 dd일(E)"/></span>
				</h2>
                <hr>
                <c:if test="${broadcastDetail.category != 'UTILITY'}">
	                <div class="col-video">
		      			<video controls autoplay>
		      				<source src="http://devsg.gq:8081/LocalUser/data/${broadcastDetail.file_url}" />
		      				<c:if test="${broadcastDetail.sub_url != ''}">
				   				<track kind="subtitles" src="${path_root}/resources/subtitles/${broadcastDetail.sub_url}.vtt" srclang="ko" label="Korean" default/>
				   			</c:if>
		      			</video>
	      			</div>
	      			<div class="" style="text-align:center;">
	      				<a href="javascript:folderSearch('${broadcastDetail.category}','${broadcastDetail.genre}','${broadcastDetail.foldername}');" class="btn btn-default"><i class="fa fa-list-ul"></i> 파일목록</a>
	      				<br>
	      			</div>
	      			<div>
		      			<p>영상이 재생되지 않을 경우에는 아래 링크를 눌러주세요. <a href="http://beemosg.gq:8081/LocalUser/data/${broadcastDetail.file_url}">링크</a></p>
		      			<p>링크 복사를 통해  URL재생을 이용하시면 됩니다.(아이폰) <a href="#" onclick="copy_trackback('${broadcastDetail.file_url}');">링크복사</a></p>
	      			</div>
      			</c:if>
      			<c:if test="${broadcastDetail.category == 'UTILITY'}">
      				<div>
      					<p>${broadcastDetail.explanation}</p>
      				</div>
      				<div class="" style="text-align:center;">
	      				<a href="javascript:folderSearch('${broadcastDetail.category}','${broadcastDetail.genre}','${broadcastDetail.foldername}');" class="btn btn-default"><i class="fa fa-list-ul"></i> 파일목록</a>
	      				<br>
	      			</div>
      			</c:if>
				<c:if test="${customer.admin_yn == '1'}">
					<div class="" style="text-align:right;">
	                    <a href="/sgCloud/sgCloud_add.do?idx=${idx}" class="btn btn-default">modify</a>
	                </div>      			
				</c:if>
                <hr>
                <!-- sgCloud Comments -->
                <!-- Comments Form -->
                <div class="well">
                    <h4>Leave a Comment:</h4>
                    <form action="/broadcast/comment_ok.do" name="tbroadcast_comment" method="post" class="bd_wrt cmt_wrt clear">
						<input type="hidden" name="idx" value="${broadcastDetail.idx }">
						<input type="hidden" name="seq_re" value="0">
						<input type="hidden" name="gap" value="0">
						<div class="form-group">
							<textarea id="comment" name="comment" cols="50" rows="4" style="overflow: hidden; min-height: 4em; height: 52px; width: 100%;"></textarea>
						</div>
						<button type="submit" class="btn btn-primary">Submit</button>
					</form>
                </div>

                <hr>

                <!-- Viewed Comments -->

                <!-- Comment -->
                <c:forEach var="tbroadcast_comment_list" items="${tbroadcast_comment_list}">
                <div class="media">
                   	<a class="pull-left" href="#">
                        <img class="media-object" src="http://placehold.it/64x64" alt="">
                    </a>
                    <div class="media-body">
                        <h4 class="media-heading">${tbroadcast_comment_list.insert_id}
                            <small><fmt:formatDate value="${tbroadcast_comment_list.insert_date}" pattern="yyyy-MM-dd HH:mm"/></small>
                        </h4>
                        ${tbroadcast_comment_list.comment}
                    </div>
                </div>
				</c:forEach>
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