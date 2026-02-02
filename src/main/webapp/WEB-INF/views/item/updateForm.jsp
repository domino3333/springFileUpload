<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 수정 화면</title>
<style>
/* 밝은 톤 & 파랑 계열 */
:root {
	--t1-blue: #007BFF; /* 강조 색상 */
	--t1-light: #f8f9fa; /* 배경 밝은 색 */
	--t1-gray: #rgb(0, 0, 0) /* 컨테이너 배경 */
	--t1-dark: #343a40; /* 글자 기본 */
	--t1-white: #ffffff; /* 글자 밝은 색 */
}

body {
	background-color: var(--t1-light);
	font-family: 'Pretendard', sans-serif;
	color: var(--t1-dark);
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: 100vh;
	margin: 0;
	padding: 50px 0;
}

.write-container {
	width: 100%;
	max-width: 700px;
	background: var(--t1-gray);
	padding: 40px;
	border-radius: 15px;
	border: 2px solid var(--t1-blue);
	box-shadow: 0 0 30px rgba(0, 123, 255, 0.2);
}

.header {
	text-align: center;
	margin-bottom: 40px;
}

.header h1 {
	font-size: 2rem;
	font-weight: 900;
	letter-spacing: -1px;
	color: var(--t1-dark);
}

.header span {
	color: var(--t1-blue);
}

.form-group {
	margin-bottom: 25px;
}

.form-group label {
	display: block;
	font-size: 0.9rem;
	color: var(--t1-blue);
	margin-bottom: 8px;
	text-transform: uppercase;
	font-weight: bold;
}

/* 입력 필드 공통 스타일 */
input[type="text"], input[type="number"], textarea {
	width: 100%;
	padding: 12px 15px;
	background: #ffffff;
	border: 1px solid #ccc;
	border-radius: 5px;
	color: var(--t1-dark);
	font-size: 1rem;
	box-sizing: border-box;
	transition: 0.3s;
}

.btn-cancel {
	background: #adb5bd;
	color: #ffffff;
}

.btn-cancel:hover {
	background: #9aa0a6;
	transform: translateY(-3px);
}

textarea {
	height: 120px;
	resize: none;
}

input:focus, textarea:focus {
	border-color: var(--t1-blue);
	outline: none;
	box-shadow: 0 0 10px rgba(0, 123, 255, 0.3);
}

.btn-area {
	display: flex;
	gap: 15px;
	margin-top: 30px;
}

.btn {
	flex: 1;
	padding: 15px;
	font-size: 1rem;
	font-weight: bold;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	transition: 0.3s;
	text-transform: uppercase;
	text-align: center;
	text-decoration: none;
	color: var(--t1-white);
}

.btn-submit {
	background: var(--t1-blue);
}

.btn-submit:hover {
	background: #0056b3;
	transform: translateY(-3px);
	box-shadow: 0 5px 15px rgba(0, 123, 255, 0.5);
}

.btn-list {
	background: #6c757d;
}

.btn-list:hover {
	background: #5a6268;
	transform: translateY(-3px);
}

.bottom-deco {
	margin-top: 30px;
	font-size: 12px;
	color: #555;
	text-align: center;
	font-family: monospace;
}

/* 파일 업로드 래퍼 */
.file-upload-wrapper {
	position: relative;
	width: 100%;
}

/* 실제 인풋은 숨김 */
.file-input {
	display: none;
}

/* 커스텀 레이블 (버튼처럼 보이게) */
.file-label {
	display: flex;
	align-items: center;
	background: #ffffff;
	border: 1px solid #ccc;
	border-radius: 5px;
	cursor: pointer;
	overflow: hidden;
	transition: 0.3s;
}

.file-label:hover {
	border-color: var(--t1-blue);
}

/* 왼쪽 '파일 선택' 영역 */
.file-btn {
	background: var(--t1-blue);
	color: var(--t1-white);
	padding: 12px 20px;
	font-size: 0.85rem;
	font-weight: bold;
	border-right: 1px solid #ccc;
}

/* 오른쪽 파일명 표시 영역 */
.file-name-text {
	padding: 0 15px;
	color: #555;
	font-size: 0.9rem;
}
</style>
</head>
<body>
	<script>
		function updateFileName(input) {
			const fileNameDisplay = document.getElementById('file-name');
			if (input.files && input.files.length > 0) {
				const name = input.files[0].name;
				fileNameDisplay.innerText = name;
				fileNameDisplay.style.color = "#343a40";
			} else {
				fileNameDisplay.innerText = "선택된 파일 없음";
				fileNameDisplay.style.color = "#555";
			}
		}
	</script>


	<div class="write-container">
		<div class="header">
			<h1>ITEM UPDATE</h1>
		</div>

		<form action="/item/update" method="post"
			enctype="multipart/form-data">

			<div class="form-group">
				<label for="id">상품 아이디</label> <input type="text" id="id" name="id"
					value="${item.id}" readonly>
			</div>

			<div class="form-group">
				<label for="name">상품이름</label> <input type="text" id="name"
					name="name" value="${item.name}" required>
			</div>

			<div class="form-group">
				<label for="price">상품가격</label> <input type="number" id="price"
					name="price" value="${item.price}" required>
			</div>

			<div class="form-group">
				<label>현재 상품 이미지</label><br> <img id="previewImage"
					src="/item/display?id=${item.id}" alt="상품 이미지" width="300">
			</div>

			<div class="form-group">
				<label>상품 이미지 변경</label> <input type="file" id="pictureInput"
					name="picture" onchange="updateFileName(this)"> <span
					id="file-name">선택된 파일 없음</span>
			</div>

			<div class="form-group">
				<label for="description">상품 상세 설명</label>
				<textarea id="description" name="description">${item.description}</textarea>
			</div>

			<div class="btn-area">
				<a href="/item/list" class="btn btn-list">상품 목록</a>
				<button type="submit" class="btn btn-submit">완료</button>
				<button type="reset" class="btn btn-cancel">취소</button>
			</div>

		</form>
	</div>

</body>
</html>