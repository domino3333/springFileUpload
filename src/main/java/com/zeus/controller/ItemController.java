package com.zeus.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import com.zeus.domain.Item;
import com.zeus.service.ItemService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/item")
@Controller
@MapperScan(basePackages = "com.zeus.mapper")
public class ItemController {

	@Autowired
	private ItemService itemService;

	@Value("${upload.path}")
	private String uploadPath; // D:/upload 로 매핑됨

	@GetMapping("/createForm")
	public String itemCreateForm(Model model) {
		log.info("createForm");
		return "item/createForm";
	}

	@PostMapping("/create")
	public String itemCreate(Item item, Model model) throws IOException, Exception {
		log.info("itemCreate: " + item.toString());
		// 1. 파일 업로드한 것을 가져오기
		MultipartFile file = item.getPicture();
		// 2. 파일 정보를 로그 파일에 남긴다
		log.info("originalName: " + file.getOriginalFilename());
		log.info("size: " + file.getSize());
		log.info("contentType: " + file.getContentType());

		// 3. 파일을 외장하드에 저장
		String createdFileName = uploadFile(file.getOriginalFilename(), file.getBytes());

		// 4. 저장된 새로 생성된 파일명을 item 도메인에 저장
		item.setUrl(createdFileName);
		// 5. 테이블에 상품 화면 정보를 저장
		int count = itemService.create(item);

		if (count > 0) {
			model.addAttribute("message", "성공 %s".formatted(file.getOriginalFilename()));
			return "item/success";
		}

		model.addAttribute("message", "실패 %s".formatted(file.getOriginalFilename()));
		return "item/failed";
	}

	private String uploadFile(String originalName, byte[] fileData) throws Exception {
		UUID uid = UUID.randomUUID();
		String createdFileName = uid.toString() + "_" + originalName;
		File target = new File(uploadPath, createdFileName);
		FileCopyUtils.copy(fileData, target);
		return createdFileName;
	}

	@GetMapping("/list")
	public String itemList(Model model) throws Exception {
		log.info("list");

		List<Item> itemList = itemService.list();
		model.addAttribute("itemList", itemList);
		
		return "item/list";
	}
	@GetMapping("/detail")
	public String itemDetail(Item item,Model model) throws Exception {
		log.info("detail");
		
		return 
	}

}
