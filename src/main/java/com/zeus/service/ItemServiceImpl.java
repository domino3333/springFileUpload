package com.zeus.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.zeus.domain.Item;
import com.zeus.mapper.ItemMapper;

@Service
public class ItemServiceImpl implements ItemService{

	
	@Autowired
	private ItemMapper itemMapper;
	
	@Override
	@Transactional
	public int create(Item item) throws Exception {
		int count = itemMapper.create(item);
		return count;
	}

	@Override
	public Item read(Item item) throws Exception {
		return itemMapper.read(item);
	}

	@Override
	@Transactional
	public int update(Item item) throws Exception {
		return itemMapper.update(item);
	}

	@Override
	@Transactional
	public int delete(Item item) throws Exception {
		return itemMapper.delete(item);
	}

	@Override
	public List<Item> list() throws Exception {
		return itemMapper.list();
	}

	@Override
	public String getPicture(Item item) throws Exception {
		return itemMapper.getPicture(item);
	}
	
	

}
