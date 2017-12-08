package com.beemosg.main.service;

import java.util.List;

import com.beemosg.model.Tbroadcast;
import com.beemosg.model.Tcustomer;

public interface MainService {
	
	Tcustomer getCustomer(String cust_id, String password);

	public List getFolderList(String category, String genre);

	List<Tbroadcast> getBroadcastList();
	
}
