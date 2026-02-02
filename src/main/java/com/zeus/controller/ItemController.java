package com.zeus.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.UUID;

import org.apache.commons.io.IOUtils;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.zeus.domain.Item;
import com.zeus.service.ItemService;
import com.zeus.service.ItemServiceImpl;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/item")
@Controller
@MapperScan(basePackages = "com.zeus.mapper")
public class ItemController {

	private final ItemServiceImpl itemServiceImpl;

	@Autowired
	private ItemService itemService;

	@Value("${upload.path}")
	private String uploadPath;

	ItemController(ItemServiceImpl itemServiceImpl) {
		this.itemServiceImpl = itemServiceImpl;
	} // D:/upload 로 매핑됨

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

	@ResponseBody
	@GetMapping("/display")
	public ResponseEntity<byte[]> itemDisplay(Item item) throws Exception {
		log.info("itemDisplay");
		// 파일을 읽기 위한 스트림
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;

		String url = itemService.getPicture(item);
		log.info("FILE NAME: " + url);

		try {
			// 파일의 확장자를 가져오는 작업
			String formatName = url.substring(url.lastIndexOf(".") + 1);
			// 확장자가 jpg 라면 MediType.IMAGE_JEPG를 받음
			MediaType mType = getMediaType(formatName);
			// 클라이언트가 서버에게 요청을 보낼 때도 헤더와 바디가 생김<- 이걸 보냄(헤더:정보, 바디:내용)
			HttpHeaders headers = new HttpHeaders();
			// 이미지파일을 inputStream으로 가져옴
			in = new FileInputStream(uploadPath + File.separator + url);
			if (mType != null) {
				// 헤더에 이미지 타입을 저장
				headers.setContentType(mType);
			}
			// IOUtils.toByteArray(in): inputStream에 저장된 파일을 바이트배열로 변환
			// headers 엔 정보가 담겨 있음
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		} finally {
			in.close();
		}
		return entity;
	}

	@GetMapping("/updateForm")
	public String itemUpdateForm(Item i, Model model) throws Exception {
		log.info("updateForm item = " + i.toString());
		Item item = itemService.read(i);
		model.addAttribute("item", item);
		return "item/updateForm";
	}

	@PostMapping("/update")
    public String itemUpdate(Item item, Model model) throws Exception {
        log.info("/update item= " + item.toString());
        MultipartFile file = item.getPicture();
        Item oldItem = itemService.read(item);

        if (file != null && file.getSize() > 0) {
            //새로운업로드 이미지파일
            log.info("originalName: " + file.getOriginalFilename());
            log.info("size: " + file.getSize());
            log.info("contentType: " + file.getContentType());
            String createdFileName = uploadFile(file.getOriginalFilename(), file.getBytes());
            item.setUrl(createdFileName);
            int count = itemService.update(item);
            if (count > 0) {
                //테이블에 수정내용이 완료가 되고 그리고 나서 이전 이미지 파일을 삭제한다.
                if(oldItem.getUrl() != null) deleteFile(oldItem.getUrl());
                model.addAttribute("message", "%s 상품수정 성공".formatted(item.getName()));
                return "item/success";
            }
        }else {
            item.setUrl(oldItem.getUrl());
            int count = itemService.update(item);
            if (count > 0) {
                model.addAttribute("message", "%s 상품수정 성공".formatted(item.getName()));
                return "item/success";
            }
        }
        
        model.addAttribute("message", "%s 상품수정 실패".formatted(item.getName()));
        return "item/failed";
    }

	private MediaType getMediaType(String form) {
		String formatName = form.toUpperCase();
		if (formatName != null) {
			if (formatName.equals("JPG")) {
				return MediaType.IMAGE_JPEG;
			}
			if (formatName.equals("GIF")) {
				return MediaType.IMAGE_GIF;
			}
			if (formatName.equals("PNG")) {
				return MediaType.IMAGE_PNG;
			}
		}
		return null;
	}

	private String uploadFile(String originalName, byte[] fileData) throws Exception {
		UUID uid = UUID.randomUUID();
		String createdFileName = uid.toString() + "_" + originalName;
		File target = new File(uploadPath, createdFileName);
		FileCopyUtils.copy(fileData, target);
		return createdFileName;
	}

	// 외부저장소 자료업로드 파일명생성후 저장
	// c:/upload/"../window/system.ini" 디렉토리 탈출공격(path tarversal)
	private boolean deleteFile(String fileName) throws Exception {
		if (fileName.contains("..")) { // 경로에 ..이 있으면 잘못된거니까 돌려보냄
			throw new IllegalArgumentException("잘못된 경로 입니다.");
		}
		File file = new File(uploadPath, fileName);
		return (file.exists() == true) ? (file.delete()) : (false);
	}

	@GetMapping("/list")
	public String itemList(Model model) throws Exception {
		log.info("list");

		List<Item> itemList = itemService.list();
		model.addAttribute("itemList", itemList);

		return "item/list";
	}

	@GetMapping("/detail")
	public String itemDetail(Item i, Model model) throws Exception {
		log.info("detail");
		Item item = itemService.read(i);
		model.addAttribute("item", item);
		return "item/detail";
	}

	@GetMapping("/delete")
	public String itemDelete(Item item, Model model) throws Exception {
		log.info("delete");
		String url = itemService.getPicture(item); // 상품이 삭제되면 파일도 하드에서 삭제해야 함
		int count = itemService.delete(item);
		
		if (count > 0) {
			if(url != null) deleteFile(url);
			model.addAttribute("message", "삭제 성공 %d".formatted(item.getId()));
			return "item/success";
		}

		model.addAttribute("message", "삭제 실패 %d".formatted(item.getId()));
		return "item/failed";
	}


}
