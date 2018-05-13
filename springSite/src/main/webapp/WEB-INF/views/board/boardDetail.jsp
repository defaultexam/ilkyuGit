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
	var butChk = 0; // 수정버튼과 삭제버튼을 구별하기 위한 변수 
	$(function() {
		$("#pwdChk").hide();
		/* 첨부파일 이미지 보여주기 위한 속성 추가 */
		var file = "<c:out value='${detail.b_file}' />";
		if (file != "") {
			$("#fileImage").attr({
				src : "/uploadStorage/board/${detail.b_file}",
				width : "450px",
				height : "200px"
			});
		}
		/* 수정 버튼 클릭 시 처리 이벤트 */
		$("#updateFormBtn").click(function() {
			$("#pwdChk").show();
			$("#msg").text("작성시 입력한 비밀번호를 입력해 주세요.").css("color", "#000099");
			butChk = 1;
		});

		/* 삭제 버튼 클릭 시 처리 이벤트 */
		$("#boardDeleteBtn").click(function() {
			$("#pwdChk").show();
			$("#msg").text("작성시 입력한 비밀번호를 입력해 주세요.").css("color", "#000099");
			butChk = 2;
		});

		/* 비밀번호 확인 버튼 클릭 시 처리 이벤트 */
		$("#pwdBtn").click(function() {
			boardPwdConfirm();
		});

		/* 목록 버튼 클릭 시 처리 이벤트 */
		$("#boardListBtn").click(function() {
			location.href = "/board/boardList.do";
		});
	});

	/* 비밀번호 확인 버튼 클릭시 실질적인 처리 함수 */
	function boardPwdConfirm() {
		if (!chkSubmit($('#b_pwd'), "비밀번호를")) return; else {
			$.ajax({
				url : "/board/pwdConfirm.do",
				type : "post",
				data : $("#f_pwd").serialize(),
				dataType : "text",
				error : function() {
					alert('시스템 오류 입니다.  관리자에게 문의 하세요');
				},
				success : function(resultData) {
					var goUrl = "";
					if (resultData == "실패") {
						$("#msg").text("작성시 입력한 비밀번호가  일치하지 않습니다.").css("color", "red"); $("#b_pwd").select();
					} else if (resultData == "성공") {
						$("#msg").text("");
						if (butChk == 1) {
							goUrl = "/board/updateForm.do";
						} else if (butChk == 2) {
							goUrl = "/board/boardDelete.do";
						}
						$("#f_data").attr("action", goUrl); $("#f_data").submit();
					}
				}
			});
		}
	}
</script>
</head>
<body>
	<div class="contentContainer">
		<div class="contentTit">
			<h3>게시판 상세보기</h3>
		</div>
		<form name="f_data" id="f_data" method="POST">
			<input type="hidden" name="b_num" value="${detail.b_num}" />
		</form>
		<%-- ========= 비밀번호 확인 버튼 및 버튼 추가 시작 ====== --%>
		<table id="boardPwdBut">
			<tr>
				<td id="btd1">
					<div id="pwdChk">
						<form name="f_pwd" id="f_pwd">
							<input type="hidden" name="b_num" id="b_num"
								value="${detail.b_num}" /> <label for="b_pwd" id="l_pwd">비밀번호
								: </label> <input type="password" name="b_pwd" id="b_pwd" /> <input
								type="button" id="pwdBtn" value="확인" /> <span id="msg"></span>
						</form>
					</div>
				</td>
				<td id="btd2"><input type="button" value="수정"
					id="updateFormBtn"> <input type="button" value="삭제"
					id="boardDeleteBtn"> <input type="button" value="목록"
					id="boardListBtn"></td>
			</tr>
		</table>
		<%-- =========== 비밀번호 확인 버튼 및 버튼 추가 종료 ====== --%>
		<%-- =============== 상세 정보 보여주기 시작 ============ --%>
		<div class="contentTB">
			<table>
				<colgroup>
					<col width="17%" />
					<col width="33%" />
					<col width="17%" />
					<col width="33%" />
				</colgroup>
				<tbody>
					<tr>
						<td class="ac">작성자</td>
						<td>${detail.b_name}</td>
						<td class="ac">작성일</td>
						<td>${detail.b_date}</td>
					</tr>
					<tr>
						<td class="ac">제목</td>
						<td colspan="3">${detail.b_title}</td>
					</tr>
					<tr>
						<td class="ac vm">내용</td>
						<td colspan="3">${detail.b_content}</td>
					</tr>
					<c:if test="${detail.b_file !=''}">
						<tr>
							<td class="ac vm">첨부파일 이미지</td>
							<td colspan="3"><img id="fileImage"></td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
		<%-- =============== 상세 정보 보여주기 종료 ============ --%>
		<jsp:include page="reply.jsp"></jsp:include>
	</div>
</body>
</html>