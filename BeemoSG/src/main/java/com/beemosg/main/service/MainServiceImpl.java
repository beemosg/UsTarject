package com.beemosg.main.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.beemosg.main.dao.MainDao;
import com.beemosg.model.Tbroadcast;
import com.beemosg.model.Tcustomer;

@Service(value="mainService")
public class MainServiceImpl implements MainService {
	
	@Resource(name="mainDao")
	private MainDao mainDao;

	public Tcustomer getCustomer(String cust_id, String password) throws Exception{
		return mainDao.getCustomer(cust_id, password);
	}

	public List getFolderList(String category, String genre) throws Exception{
		return mainDao.getFolderList(category, genre);
	}

	public List recentFolderList() throws Exception{
		return mainDao.recentFolderList();
	}

	public List<Tbroadcast> getBroadcastList() throws Exception{
		return mainDao.getBroadcastList();
	}
	
	public int insertLoginHistory(Tcustomer customer) throws Exception{
		return mainDao.insertLoginHistory(customer);
	}

}
