<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록하기</title>
<style>
/* 밝은 톤 & 파랑 계열 */
:root {
	--t1-blue: #007BFF;     /* 강조 색상 */
	--t1-light: #f8f9fa;    /* 배경 밝은 색 */
	--t1-gray: #e0e0e0;     /* 컨테이너 배경 */
	--t1-dark: #343a40;     /* 글자 기본 */
	--t1-white: #ffffff;     /* 글자 밝은 색 */
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
		<h1>
			ITEM <span>UPLOAD</span>
		</h1>
	</div>

	<form action="/item/create" method="post" enctype="multipart/form-data">

		<div class="form-group">
			<label for="name">상품이름</label>
			<input type="text" id="name" name="name" placeholder="상품명을 입력하세요" required>
		</div>

		<div class="form-group">
			<label for="price">상품가격(KRW)</label>
			<input type="number" id="price" name="price" placeholder="상품가격을 입력하세요" required>
		</div>

		<div class="form-group">
			<label>Item Image</label>
			<div class="file-upload-wrapper">
				<input type="file" id="picture" name="picture" class="file-input" onchange="updateFileName(this)">
				<label for="picture" class="file-label">
					<span class="file-btn">파일 선택</span>
					<span id="file-name" class="file-name-text">선택된 파일 없음</span>
				</label>
			</div>
		</div>

		<div class="form-group">
			<label for="description">상품 상세 설명</label>
			<textarea id="description" name="description" placeholder="상품 상세 설명을 입력하세요"></textarea>
		</div>

		<div class="btn-area">
			<a href="/item/list" class="btn btn-list">상품 목록</a>
			<button type="submit" class="btn btn-submit">상품 등록</button>
			<button type="reset" class="btn btn-cancel">상품 등록 취소</button>
		</div>
	</form>

	<div class="bottom-deco">[ SYSTEM: MULTIPART DATA READY TO UPLOAD ]</div>
</div>
</body>
</html>
