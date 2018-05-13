<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Insert title here</title>
<link rel="stylesheet" type="text/css"
	href="/resources/include/css/common.css" />
<link rel="stylesheet" type="text/css"
	href="/resources/include/css/board.css" />
<script type="text/javascript"
	src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script type="text/javascript" src="/resources/include/js/common.js"></script>
<script type="text/javascript">
	$(function() {
		/* 첨부 파일 */
		var value = "${updateData.b_file}";
		if (value != "") {
			var img = $("<img>");
			$('#imgView').hover(function() {
				img.attr({
					src : "/uploadStorage/board/${updateData.b_file}",
					width : "450px",
					height : "200px"
				}); img.addClass("imgViewData"); $('#imgArea').append(img);
			}, function() {
				img.remove();
			});
		} else {
			$('#imgView').hide();
		}
		/* 수정 버튼 클릭 시 처리 이벤트 */
		$("#boardUpdateBtn").click(function() {
			//입력값 체크 
			if (!chkSubmit($('#b_title'), "제목을")) return;
			else if (!chkSubmit($('#b_content'), "작성할 내용을")) return;else {
				$("#f_writeForm").attr({
					"method" : "POST",
					"action" : "/board/boardUpdate.do"
				});
				$("#f_writeForm").submit();
			}
		});
		/* 목록 버튼 클릭 시 처리 이벤트 */
		$("#boardListBtn").click(function() {
			location.href = "/board/boardList.do";
		});
	});
</script>
</head>
<body>
	<div class="contentContainer">
		<div class="contentTit">
			<h3>게시판 글수정</h3>
		</div>
		<div class="contentTB">
			<form id="f_writeForm" name="f_writeForm"
				enctype="multipart/form-data">
				<input type="hidden" id="b_num" name="b_num"
					value="${updateData.b_num}" /> <input type="hidden" name="b_file"
					id="b_file" value="${updateData.b_file}" /> <input type="hidden"
					name="page" id="page" value="${param.page}" /> <input
					type="hidden" name="pageSize" id="pageSize"
					value="${param.pageSize}" />
				<table>
					<colgroup>
						<col width="17%" />
						<col width="33%" />
						<col width="17%" />
						<col width="33%" />
					</colgroup>
					<tbody>
						<tr>
							<td class="ac">글번호</td>
							<td>${updateData.b_num}</td>
							<td class="ac">작성일</td>
							<td>${updateData.b_date}</td>
						</tr>
						<tr>
							<td class="ac">작성자</td>
							<td colspan="3">${updateData.b_name}</td>
						</tr>
						<tr>
							<td class="ac">글제목</td>
							<td colspan="3"><input type="text" name="b_title"
								id="b_title" value="${updateData.b_title}" /></td>
						</tr>
						<tr>
							<td class="ac vm">내용</td>
							<td colspan="3"><textarea name="b_content" id="b_content">${updateData.b_content} </textarea></td>
						</tr>
						<tr>
							<td class="ac">첨부파일</td>
							<td colspan="3"><input type="file" name="file" id="file">
								<span id="imgView">기존 이미지파일명: ${updateData.b_file}<span
									id="imgArea"> </span></span></td>
						</tr>
						<tr>
							<td class="ac">비밀번호</td>
							<td colspan="3"><input type="password" name="b_pwd"
								id="b_pwd" /> <label>수정할 비밀번호를 입력해 주세요.</label></td>
						</tr>
				</table>
			</form>
		</div>
		<div class="contentBtn">
			<input type="button" value="수정" id="boardUpdateBtn"> <input
				type="button" value="목록" id="boardListBtn">
		</div>
	</div>
</body>
</html>