package com.vicloud.board.controller;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.vicloud.board.service.BoardService;
import com.vicloud.model.Tboard;
import com.vicloud.model.Tboard_comment;
import com.vicloud.model.Tbroadcast;
import com.vicloud.model.Tbroadcast_comment;
import com.vicloud.model.Tcustomer;

@Controller
public class BoardController {
	
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Resource(name="boardService")
	private BoardService boardService;
	
	// sgCloud 이동
	@RequestMapping(value = "/sgCloud/sgCloud_main.do", method = RequestMethod.GET)
	public String displaySgCloud(@RequestParam(value="rnum", defaultValue="1") int rnum, 
			@RequestParam(value="category", defaultValue="") String category,
			@RequestParam(value="genre", defaultValue="") String genre,			
			@RequestParam(value="genre2", defaultValue="") String genre2,			
			@RequestParam(value="foldername", defaultValue="") String foldername,			
			@RequestParam(value="searchWord", defaultValue="") String searchWord,
			HttpSession session, Model model){
		logger.info("main page start");
		System.out.println("start page sgCloud_main");
		/*
		if(session.getAttribute("userLoginInfo") == null || "".equals(session.getAttribute("userLoginInfo"))){
			logger.info("You don't login.");
			System.out.println("You don't login.");
			return "defaults/login";
		}
		*/
		int totalBroadcast = 0;
		int prev = 0;
		int next = 0;
		List genreList = null;
		List folderList = null;
		
		if(!"".equals(searchWord) && searchWord != null){
			searchWord = "%"+ searchWord +"%";
		}else{
			searchWord = "%%";
		}
		//if(category.equals("all") || category.equals("")){
			//category = "%%";
			//genre = "%%";
			//foldername = "%%";
		//}else{
			category = "%" + category + "%";
			genreList = this.boardService.getGenerList(category);
			//if(!genre.equals("")){
				genre = "%" + genre + "%";
				foldername = "%" + foldername.replaceAll("%20", " ") + "%";
				folderList = this.boardService.getFolderList(category, genre);
			//}else{
				//genre = "%%";
				//foldername = "%%";
			//}
		//}

		System.out.println("rnum : " + rnum);
		System.out.println("category : " + category + ", genre : " + genre + ", foldername : " + foldername + ", searchWord : " + searchWord);
		
		List<Tbroadcast> broadcastList = this.boardService.getBroadcastList((rnum * 13) - 12, category, genre, foldername, searchWord);
		totalBroadcast = boardService.totalBroadcast(category, genre, foldername, searchWord);
		
		if(rnum > 1){
			prev = rnum - 1;
		}
		if(rnum < totalBroadcast / 13 ){
			next = rnum + 1;
		}else if(rnum == totalBroadcast / 13){
			if(totalBroadcast % 13 > 0){
				next = rnum + 1;
			}
		}
		System.out.println("prev : " + prev + ", next : " + next);
		
		List categoryList = this.boardService.getCategoryList();
		
		model.addAttribute("broadcastList", broadcastList);
		model.addAttribute("searchWord", searchWord.replaceAll("%", ""));
		model.addAttribute("categoryList", categoryList);
		model.addAttribute("category", category.replaceAll("%", ""));
		model.addAttribute("genreList", genreList);
		model.addAttribute("genre", genre.replaceAll("%", ""));
		model.addAttribute("folderList", folderList);
		model.addAttribute("foldername", foldername.replaceAll("%", ""));
		model.addAttribute("totalBroadcast", totalBroadcast);
		model.addAttribute("rnum", rnum);
		model.addAttribute("prev", prev);
		model.addAttribute("next", next);
		model.addAttribute("dropdown", "sgCloud");
		
		return "sgCloud/sgCloud_main";
	}
	
	// 게시판 상세보기
    // PathVariable 어노테이션을 이용하여 RESTful 방식 적용
    // board/1 -> id = 1; id = 게시물 번호로 인식함.
    // 일반 적으로 (@ReuqstParam(value = "board", required = false, defaultValue = "0"), int idx, Model model)
    @RequestMapping("/sgCloud/{idx}.do")
    public String displaySgCloudDetailView(@PathVariable int idx, Model model, HttpSession session) {
        logger.info("display view Board view idx = {}", idx);
        System.out.println("display view Board view idx = " + idx);
        /*
		if(session.getAttribute("userLoginInfo") == null || "".equals(session.getAttribute("userLoginInfo"))){
			logger.info("You don't login.");
			System.out.println("You don't login.");
			return "defaults/login";
		}
		*/
        Tcustomer customer = (Tcustomer) session.getAttribute("userLoginInfo");
        
        Tbroadcast broadcastDetail = this.boardService.broadcastDetail(idx);
        
        List<Tbroadcast_comment> tbroadcast_comment_list = this.boardService.broadcastCommentList(idx); // 댓글 보기

        model.addAttribute("broadcastDetail", broadcastDetail);
        model.addAttribute("tbroadcast_comment_list", tbroadcast_comment_list);
        model.addAttribute("idx", idx);
        model.addAttribute("customer", customer);
        //model.addAttribute("total_comments", tboard_comment_list.size());
        model.addAttribute("dropdown", "sgCloud");
        
        return "sgCloud/sgCloud_view";
    }
    
    // 게시판 쓰기 폼
    @RequestMapping(value = "/sgCloud/sgCloud_add.do", method = RequestMethod.GET)
    public String displayBroadcastAdd(@RequestParam(value="idx", defaultValue="0") int idx, Model model, HttpSession session, HttpServletRequest request) {
        logger.info("display view Board add");
        System.out.println("display view Board add");
        
        if(session.getAttribute("userLoginInfo") == null || "".equals(session.getAttribute("userLoginInfo"))){
			logger.info("You don't login.");
			System.out.println("You don't login.");
			//request.setAttribute("forwardUrl", "/sgCloud/sgCloud_add.do");
			model.addAttribute("forwardUrl", "/sgCloud/sgCloud_add.do");
			return "defaults/login";
		}
        
        if (idx > 0) { // 수정하기를 눌렀을 경우
        	logger.info("display view Board modify");
        	System.out.println("display view Board modify");
        	Tbroadcast tbroadcast = this.boardService.getSelectBroadcast(idx);
        	if(!tbroadcast.getSub_url().equals("")){
        		tbroadcast.setSub_check(true);
        	}
        	int nFileIndex = tbroadcast.getFilename().lastIndexOf(".");
        	int lastIndex = tbroadcast.getFilename().length();
        	
        	tbroadcast.setExtension(tbroadcast.getFilename().substring(nFileIndex, lastIndex));
            model.addAttribute("broadcast", tbroadcast);
        }
        model.addAttribute("dropdown", "sgCloud");

        return "sgCloud/sgCloud_add";
    }
    
    // 게시판 쓰기 저장
    @RequestMapping(value = "/sgCloud/add_ok.do", method = RequestMethod.POST)
    public String procBroadcastAdd(@ModelAttribute("tbroadcast") Tbroadcast tbroadcast, RedirectAttributes redirectAttributes, HttpSession session) {
    	logger.info("display view Broadcast write_ok");
        System.out.println("display view Broadcast write_ok");
        
        if(session.getAttribute("userLoginInfo") == null || "".equals(session.getAttribute("userLoginInfo"))){
			logger.info("You don't login.");
			System.out.println("You don't login.");
			return "defaults/login";
		}
        
        if(tbroadcast.getExtension() == null || tbroadcast.getExtension().equals("")){
        	tbroadcast.setExtension(".mp4");
        }
        
        Tcustomer customer = (Tcustomer) session.getAttribute("userLoginInfo");

        tbroadcast.setFilename(tbroadcast.getTitle()+tbroadcast.getExtension());
        
        //int nFileIndex = tbroadcast.getFilename().lastIndexOf(".");        
        
        Integer idx = tbroadcast.getIdx();
        if(tbroadcast.getCategory().equals("MUSIC")){
        	tbroadcast.setFile_url(tbroadcast.getCategory() + "/" + tbroadcast.getGenre() + "/" + tbroadcast.getFoldername() + "/" + tbroadcast.getAlbumname() + "/" + tbroadcast.getFilename());
        }else{
        	tbroadcast.setFile_url(tbroadcast.getCategory() + "/" + tbroadcast.getGenre() + "/" + tbroadcast.getFoldername() + "/" + tbroadcast.getFilename());
        }
        if(tbroadcast.isSub_check()){
        	tbroadcast.setSub_url(tbroadcast.getTitle());
        }else{
        	tbroadcast.setSub_url("");
        }
        
        if (idx == null || idx == 0) { //새로입력
            this.boardService.insertBroadcast(tbroadcast);
            redirectAttributes.addFlashAttribute("message", "추가되었습니다.");
            System.out.println("Sucess Board insert");
            return "redirect:/sgCloud/sgCloud_main.do";
        } else { //수정
            this.boardService.updateBroadcast(tbroadcast);
            redirectAttributes.addFlashAttribute("message", "수정되었습니다.");
            System.out.println("Sucess Board modify");
            return "redirect:/sgCloud/sgCloud_main.do";
        }
    }
    
    //댓글 저장
    @RequestMapping(value = "/broadcast/comment_ok.do", method = RequestMethod.POST)
    public String procBroadcastCommentWrite(@ModelAttribute("tbroadcast_comment") Tbroadcast_comment tbroadcast_comment, HttpSession session){
    	logger.info("Start Broadcast comment write.");
        System.out.println("Start Broadcast comment write.");
    	
    	Tcustomer customer = (Tcustomer) session.getAttribute("userLoginInfo");
    	
    	int idx 	= tbroadcast_comment.getIdx();
    	int seq_re	= tbroadcast_comment.getSeq_re();
    	int gap 	= tbroadcast_comment.getGap();
    	
    	if(seq_re == 0){ //가장 최상위 댓글일 경우
    		Integer maxSeqNo = this.boardService.maxSeqNo(idx);
    		if(maxSeqNo == null){
    			maxSeqNo = 0;
    		}
    		Integer maxIdxNo = this.boardService.maxIdxNo(idx);
    		if(maxIdxNo == null){
    			maxIdxNo = 0;
    		}
    		tbroadcast_comment.setSeq_no(maxSeqNo + 1);
    		tbroadcast_comment.setIdx_no(maxIdxNo + 1);
    		tbroadcast_comment.setGap(0);
    	}else{
    		int seq = tbroadcast_comment.getSeq();
    		int idx_no	= tbroadcast_comment.getIdx_no();
    		int seq_no 	= tbroadcast_comment.getSeq_no();
    		Integer max_seq_no = this.boardService.maxSeqReNo(idx, idx_no, seq, gap); //댓글 쓰려는 곳 중에 마지막 번호
    		if(max_seq_no != null){
    			seq_no = max_seq_no;
    		}
    		this.boardService.updateSeqNo(idx, seq_no); //댓글의 순서를 정하기 위해 기존 댓글을 1씩 증가한다.
    		tbroadcast_comment.setSeq_no(seq_no + 1); //지금 쓸 댓글의 순서를 정한다.
    		tbroadcast_comment.setGap(gap + 2); //댓글의 간격을 증가한다.
    		tbroadcast_comment.setSeq_re(seq); //상위 댓글번호를  seq_re에 입력
    	}
    	
    	tbroadcast_comment.setAuthor(customer.getCust_name());
    	tbroadcast_comment.setInsert_id(customer.getCust_id());
    	
    	this.boardService.insertBroadcastComment(tbroadcast_comment);
    	System.out.println("Sucess Broadcast comment insert");
    	
    	return "redirect:/sgCloud/"+ idx +".do";
    }
    
    // 파일다운로드
    @RequestMapping(value = "/sgCloud/fileDownload.do", method = RequestMethod.GET)
    public void fileDownload(@RequestParam(value="fileUrl", defaultValue="") String fileUrl, Model model,
    		@RequestParam(value="fileName", defaultValue="") String fileName, @RequestHeader("User-Agent") String userAgent, 
    		HttpServletResponse response, HttpServletRequest request) throws IOException{
    	
        //File file = new File(fileUrl);
        
        InputStream is = null;
        
        System.out.println("------Download Start------");
        System.out.println(fileUrl);
        System.out.println(fileName);
        
        char[] txtChar = fileUrl.toCharArray();
        for (int j = 0; j < txtChar.length; j++) {
            if (txtChar[j] >= '\uAC00' && txtChar[j] <= '\uD7A3' || txtChar[j] == '\u0020' || txtChar[j] == 'ㆍ') {
                String targetText = String.valueOf(txtChar[j]);
                try {
                	if(txtChar[j] == '\u0020'){ //공백 문자변환
                		fileUrl = fileUrl.replace(targetText, "%20");
                	} else if(txtChar[j] == 'ㆍ'){//ㆍ 문자변환
                		fileUrl = fileUrl.replace(targetText, "%E3%86%8D");
                	} else{
                		fileUrl = fileUrl.replace(targetText, URLEncoder.encode(targetText, "UTF-8"));
                	} 
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
            } 
        }
        
        URL url = new URL("http://devsg.gq:8081/LocalUser/data/" + fileUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        is = conn.getInputStream();
        
        switch (getBrowser(userAgent)) {
            case Chrome:
            case Opear:
            case Firefox:
                response.setHeader("Content-Disposition", "attachment; filename=\""
                        + new String(fileName.getBytes("UTF-8"), "ISO-8859-1").replaceAll("\\+", "%20") + "\"");
                break;
            case MSIE:
                response.setHeader("Content-Disposition", "attachment;filename="
                        + URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20") + ";");
                
                break;
            default:
                response.setHeader("Content-Disposition", "attachment;filename=" 
                		+ URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20") + ";");
                break;
        }

        response.setContentType("application/download;charset=utf-8");
        //response.setContentLengthLong();
        response.setHeader("Pragma", "no-cache;");
        response.setHeader("Expires", "-1;");
        response.setHeader("Content-Transfer-Encoding", "binary");
        response.setHeader("Connection", "close");
        FileCopyUtils.copy(is, response.getOutputStream());
    	
    	
    	/*
    	OutputStream os = null;
    	URLConnection uCon = null;
    	
    	InputStream is = null;
    	try {
			System.out.println("------Download Start------");
			
			byte[] buf;
			int byteRead;
			int byteWritten = 0;
			
			URL url = new URL(fileurl);
			os = new BufferedOutputStream(new FileOutputStream(""));
			
			uCon = url.openConnection();
			is = uCon.getInputStream();
			buf = new byte[size];
			
			while((byteRead = is.read(buf)) != -1){
				os.write(buf, 0, byteRead);
				byteWritten += byteRead;
			}
			
			System.out.println("Download Successfully.");
			System.out.println("of bytes : " + byteWritten);
			System.out.println("------Download End-------");
    	
    	} catch (Exception e) {
			e.printStackTrace();
		} finally{
			try{
				is.close();
				os.close();
			} catch(IOException e){
				e.printStackTrace();
			}
		}
    	*/
    	/*
    	model.addAttribute("fileName", fileName);
    	model.addAttribute("fileUrl", fileUrl);
    	
    	request.setAttribute("fileName", fileName);
    	request.setAttribute("fileUrl", fileUrl);
    	
    	return "sgCloud/fileDownload";
    	*/
    }
    
    private Browser getBrowser(String userAgent) {
        if (userAgent.contains("MSIE") || userAgent.contains("Trident")) {
            return Browser.MSIE;
        } else if (userAgent.contains("Chrome")) {
            return Browser.Chrome;
        } else if (userAgent.contains("Opera")) {
            return Browser.Opear;
        }
        return Browser.Firefox;
    }

    private enum Browser {
        MSIE, Chrome, Opear, Firefox
    }
    
/* 
 * ************************************************************************************************************
 * */
	// 메인페이지 이동
	@RequestMapping(value = "/board/board.do", method = RequestMethod.GET)
	public String displayMain(HttpSession session, Model model){
		logger.info("board page start");
		System.out.println("board page start");
		if(session.getAttribute("userLoginInfo") == null || "".equals(session.getAttribute("userLoginInfo"))){
			logger.info("You don't login.");
			System.out.println("You don't login.");
			return "defaults/login";
		}
		
		logger.info("display view Board list");
		System.out.println("display view Board list");
        List<Tboard> tboard_list = this.boardService.getBoardList();
        model.addAttribute("tboard_list", tboard_list);
        model.addAttribute("dropdown", "board");

        logger.info("total count" + tboard_list.size() );
		

		return "board/board";
	}
	
	// 게시판 상세보기
    // PathVariable 어노테이션을 이용하여 RESTful 방식 적용
    // board/1 -> id = 1; id = 게시물 번호로 인식함.
    // 일반 적으로 (@ReuqstParam(value = "board", required = false, defaultValue = "0"), int idx, Model model)
    @RequestMapping("/board/{idx}.do")
    public String displayBoardDetailView(@PathVariable int idx, Model model, HttpSession session) {
        logger.info("display view Board view idx = {}", idx);
        System.out.println("display view Board view idx = " + idx);
        
        if(session.getAttribute("userLoginInfo") == null || "".equals(session.getAttribute("userLoginInfo"))){
			logger.info("You don't login.");
			System.out.println("You don't login.");
			return "defaults/login";
		}
        Tboard tboard = this.boardService.getSelectOne(idx);
        
        List<Tboard_comment> tboard_comment_list = this.boardService.boardCommentList(idx); // 댓글 보기

        model.addAttribute("tboard", tboard);
        model.addAttribute("tboard_comment_list", tboard_comment_list);
        model.addAttribute("total_comments", tboard_comment_list.size());
        model.addAttribute("dropdown", "board");
        return "board/view";
    }
    
    // 게시판 쓰기 폼
    @RequestMapping(value = "/board/write.do", method = RequestMethod.GET)
    public String displayBoardWrite(@RequestParam(value="idx", defaultValue="0") int idx, Model model, HttpSession session) {
        logger.info("display view Board write");
        System.out.println("display view Board write");
        
        if(session.getAttribute("userLoginInfo") == null || "".equals(session.getAttribute("userLoginInfo"))){
			logger.info("You don't login.");
			System.out.println("You don't login.");
			return "defaults/login";
		}

        if (idx > 0) { // 수정하기를 눌렀을 경우
        	logger.info("display view Board modify");
        	System.out.println("display view Board modify");
            Tboard tboard = this.boardService.getSelectOne(idx);
            model.addAttribute("tboard", tboard);
        }
        model.addAttribute("dropdown", "board");

        return "board/write";
    }
    
    // 게시판 쓰기 저장
    @RequestMapping(value = "/board/write_ok.do", method = RequestMethod.POST)
    public String procBoardWrite(@ModelAttribute("tboard") Tboard tboard, RedirectAttributes redirectAttributes, HttpSession session) {
    	logger.info("display view Board write_ok");
        System.out.println("display view Board write_ok");
        
        Tcustomer customer = (Tcustomer) session.getAttribute("userLoginInfo");
        
        if(session.getAttribute("userLoginInfo") == null || "".equals(session.getAttribute("userLoginInfo"))){
			logger.info("You don't login.");
			System.out.println("You don't login.");
			return "defaults/login";
		}
        
        Integer idx = tboard.getIdx();
        tboard.setAuthor(customer.getCust_name());
        tboard.setInsert_id(customer.getCust_id());
        
        if (idx == null || idx == 0) { //새로입력
            this.boardService.insertBoard(tboard);
            redirectAttributes.addFlashAttribute("message", "추가되었습니다.");
            System.out.println("Sucess Board insert");
            return "redirect:/board/board.do";
        } else { //수정
            this.boardService.updateBoard(tboard);
            redirectAttributes.addFlashAttribute("message", "수정되었습니다.");
            System.out.println("Sucess Board modify");
            return "redirect:/board/board.do";
        }
    }
    
    //댓글 저장
    @RequestMapping(value = "/board/comment_ok.do", method = RequestMethod.POST)
    public String procBoardCommentWrite(@ModelAttribute("tboard_comment") Tboard_comment tboard_comment, HttpSession session){
    	logger.info("Start Board comment write.");
        System.out.println("Start Board comment write.");
    	
    	Tcustomer customer = (Tcustomer) session.getAttribute("userLoginInfo");
    	
    	int idx 	= tboard_comment.getIdx();
    	int seq 	= tboard_comment.getSeq();
    	int idx_no	= tboard_comment.getIdx_no();
    	int seq_re	= tboard_comment.getSeq_re();
    	int seq_no 	= tboard_comment.getSeq_no();
    	int gap 	= tboard_comment.getGap();
    	
    	System.out.println("idx : " + idx + ", seq : " + seq + ", seq_re : " + seq_re + ", seq_no : " + seq_no + ", gap : " + gap);
    	
    	if("0".equals(seq_re) || "".equals(seq_re)){ //가장 최상위 댓글일 경우
    		Integer maxSeqNo = this.boardService.maxSeqNo(idx);
    		Integer maxIdxNo = this.boardService.maxIdxNo(idx);
    		tboard_comment.setSeq_no(maxSeqNo + 1);
    		tboard_comment.setIdx_no(maxIdxNo + 1);
    	}else{
    		Integer max_seq_no = this.boardService.maxSeqReNo(idx, idx_no, seq, gap); //댓글 쓰려는 곳 중에 마지막 번호
    		if(max_seq_no != null){
    			seq_no = max_seq_no;
    		}
    		this.boardService.updateSeqNo(idx, seq_no); //댓글의 순서를 정하기 위해 기존 댓글을 1씩 증가한다.
    		tboard_comment.setSeq_no(seq_no + 1); //지금 쓸 댓글의 순서를 정한다.
    		tboard_comment.setGap(gap + 2); //댓글의 간격을 증가한다.
    		tboard_comment.setSeq_re(seq); //상위 댓글번호를  seq_re에 입력
    	}
    	
    	tboard_comment.setAuthor(customer.getCust_name());
    	tboard_comment.setInsert_id(customer.getCust_id());
    	
    	this.boardService.insertBoardComment(tboard_comment);
    	System.out.println("Sucess Board comment insert");
    	
    	return "redirect:/board/"+ idx +".do";
    }
    
    //댓글 삭제
    @RequestMapping(value = "/board/comment_delete.do", method = RequestMethod.GET)
    public String deleteBoardComment(@RequestParam(value="idx") int idx, @RequestParam(value="idx_no") int idx_no, 
    		@RequestParam(value="seq") int seq, @RequestParam(value="gap") int gap, HttpSession session){
    	logger.info("Start Board comment delete.");
        System.out.println("Start Board comment delete.");
        
        System.out.println("idx : " + idx + ", seq : " + seq);
        Tcustomer customer = (Tcustomer) session.getAttribute("userLoginInfo");
        
        this.boardService.deleteBoardComment(seq, customer.getCust_id()); //선택 댓글 삭제
        System.out.println("Sucess Board comment delete.");
        this.boardService.deleteBoardReComment(idx, idx_no, seq, gap); //선택 댓글의 하위 댓글 삭제
        System.out.println("Sucess Board reComment delete.");
        
    	return "redirect:/board/"+ idx +".do";
    }
}
