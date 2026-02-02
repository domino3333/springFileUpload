<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 정보 상세</title>
<style>
:root {
	--t1-red: rgb(0, 128, 255);
	--t1-black: #0f0f0f;
	--t1-gray: #1a1a1a;
	--t1-gold: #C69C6D;
}

body {
	background-color: var(--t1-black);
	font-family: 'Pretendard', sans-serif;
	color: #ffffff;
	margin: 0;
	padding: 50px 0;
}

/* 상품 설명 textarea 스타일 */
.detail-textarea {
	width: calc(100% - 60px);
	margin: 30px;
	padding: 20px;
	min-height: 200px;
	background: #0b1c2d; /* 파랑 톤 배경 */
	border: 2px solid var(--t1-red); /* 파랑 테두리 */
	border-radius: 10px;
	color: #ffffff;
	font-size: 1rem;
	line-height: 1.7;
	resize: none; /* 크기 조절 막기 */
	outline: none;
	box-sizing: border-box;
}

/* 포커스 시 은은한 파랑 강조 */
.detail-textarea:focus {
	box-shadow: 0 0 15px rgba(0, 128, 255, 0.4);
}

/* 스크롤바 파랑 톤 (크롬 기준) */
.detail-textarea::-webkit-scrollbar {
	width: 8px;
}

.detail-textarea::-webkit-scrollbar-thumb {
	background: rgba(0, 128, 255, 0.6);
	border-radius: 4px;
}

.detail-textarea::-webkit-scrollbar-track {
	background: #081420;
}

.detail-container {
	max-width: 800px;
	margin: 0 auto;
	background: var(--t1-gray);
	border: 2px solid var(--t1-red);
	border-radius: 15px;
	box-shadow: 0 0 30px rgba(226, 1, 45, 0.2);
	overflow: hidden;
}

/* 상단 헤더 영역 */
.detail-header {
	background: #222;
	padding: 30px;
	border-bottom: 1px solid #333;
}

.detail-header .post-no {
	color: var(--t1-red);
	font-weight: bold;
	font-size: 0.9rem;
	margin-bottom: 10px;
	display: block;
}

.detail-header h1 {
	margin: 0;
	font-size: 1.8rem;
	letter-spacing: -1px;
}

.post-info {
	margin-top: 15px;
	font-size: 0.9rem;
	color: #888;
	display: flex;
	gap: 20px;
}

.post-info span b {
	color: var(--t1-gold);
}

/* 본문 영역 */
.detail-content {
	padding: 40px 30px;
	min-height: 300px;
	line-height: 1.8;
	font-size: 1.1rem;
	white-space: pre-wrap; /* 줄바꿈 유지 */
	border-bottom: 1px solid #333;
}

/* 하단 버튼 영역 */
.btn-area {
	padding: 20px 30px;
	background: #151515;
	display: flex;
	justify-content: space-between;
}

.btn {
	padding: 10px 25px;
	font-weight: bold;
	border-radius: 5px;
	text-decoration: none;
	transition: 0.3s;
	cursor: pointer;
	border: none;
	font-size: 0.9rem;
}

.btn-list {
	background: #333;
	color: #fff;
}

.btn-list:hover {
	background: #444;
}

.btn-group {
	display: flex;
	gap: 10px;
}

.btn-edit {
	background: var(--t1-gold);
	color: #000;
}

.btn-delete {
	background: var(--t1-red);
	color: #fff;
}

.btn:hover {
	transform: translateY(-2px);
	opacity: 0.9;
}

/* 데코레이션 */
.footer-deco {
	padding: 15px;
	text-align: center;
	font-size: 0.75rem;
	color: #444;
	background: #0f0f0f;
}
</style>
</head>
<body>



	<div class="detail-container">
		<div class="detail-header">
			<span class="post-no">상품 ID: ${item.id}</span>
			<h1>${item.name}</h1>
			<div class="post-info">
				<span>price <b>${item.price}</b></span>
			</div>
		</div>

		<div class="btn-area">
			<img alt="상품 이미지${item.name}" src="/item/display?id=${item.id}"
				width="300">
		</div>
		<textarea class="detail-textarea" readonly>${item.description}</textarea>

		<div class="btn-area">
			<a href="/item/list" class="btn btn-list">상품 목록</a>

			<div class="btn-group">
				<a href="/item/updateForm?id=${item.id}" class="btn btn-edit">
					수정하기</a> <a href="/item/delete?id=${item.id}" class="btn btn-delete"
					onclick="return confirm('정말 삭제하시겠습니까?')">삭제하기</a>
			</div>
		</div>

		<div class="footer-deco">[ domino ]</div>
	</div>

</body>
</html>