package com.beemosg.cust.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.beemosg.common.Const;
import com.beemosg.cust.service.CustService;
import com.beemosg.main.service.MainService;
import com.beemosg.model.Tcustomer;

@Controller
public class CustController {

	private static final Logger logger = LoggerFactory.getLogger(CustController.class);
	
	@Resource(name="custService")
	private CustService custService;
	
	// 회원가입 페이지 이동
	@RequestMapping(value = "/cust/custJoin.do", method = RequestMethod.GET)
	public String custJoinForm(){
		logger.info("custJoin input page");
		return "cust/custJoinForm";
	}
	// 아이디 중복 체크
	@RequestMapping(value = "/cust/idCheck.do", method = RequestMethod.GET)
	public void AjaxIdCheck(@RequestParam("cust_id") String cust_id, HttpServletResponse response) throws Exception{
		
		String checkId = "";
		Tcustomer customer = null;
		
	    try {
	    	customer = custService.selectCustomer(cust_id);
	    	if(customer != null){
	    		checkId = "no";
	    	}
	    	else{
	    		checkId = "ok";
	    	}
	        response.getWriter().print(checkId);
	    } catch (IOException e) {
	        e.printStackTrace();
	    }   
	}
	// 회원가입 페이지 이동
	@RequestMapping(value = "/cust/custInfo.do", method = RequestMethod.GET)
	public String custInfo(@RequestParam(value="cust_id", defaultValue="") String cust_id,
			Model model, HttpSession session) throws Exception{
		logger.info("custInfo start");
		
		Tcustomer customer = null;
		
		try {
			if(session.getAttribute(Const.USER_KEY) == null || "".equals(session.getAttribute(Const.USER_KEY))){
        		logger.info("You don't login.");
        		return "defaults/login";
        	}else{
        		customer = (Tcustomer)session.getAttribute(Const.USER_KEY);
        		if(!customer.getAdmin_yn().equals("1")){
        			return "redirect:/defaults/main.do";
        		}
        	}

			customer = custService.selectCustomer(cust_id);
			
			model.addAttribute("customer", customer);
			
		} catch (Exception e) {
			logger.error("defaults/main.do ERROR, " + e.getMessage());
		}
		
		return "cust/custInfo";
	}
	// 회원가입 시작
	@RequestMapping(value = "/cust/custJoinOk.do", method = RequestMethod.POST)
	public String custJoinOk(@ModelAttribute("tcustomer") Tcustomer tcustomer, Model model){
		logger.info("custJoinOk start");
		
		String strDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
		
		String cust_no = strDate + String.format("%02d", custService.getMaxCustNo(strDate + "%"));
		System.out.println("cust_no : " + cust_no );
		
		tcustomer.setCust_no(cust_no);
		
		custService.insertCust(tcustomer);
		
		model.addAttribute("joinCheck", "joinOk");
		
		return "defaults/login";
	}
}
