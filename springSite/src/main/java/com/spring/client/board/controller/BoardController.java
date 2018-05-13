package com.spring.client.board.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.client.board.service.BoardService;
import com.spring.client.board.vo.BoardVO;
import com.spring.common.file.FileUploadUtil;
import com.spring.common.page.Paging;
import com.spring.common.util.Util;

@Controller
@RequestMapping(value = "/board")
public class BoardController {
	Logger logger = Logger.getLogger(BoardController.class);

	@Autowired
	private BoardService boardService;

	// 글 목록 구현하기
	@RequestMapping(value = "/boardList", method = RequestMethod.GET)
	public String boardList(@ModelAttribute BoardVO bvo, Model model) {
		logger.info("boardList 호출 성공");

		// 페이지 셋팅
		Paging.setPage(bvo);

		// 전체 레코드 수 구현
		int total = boardService.boardListCnt(bvo);
		logger.info("total = " + total);

		// 글 번호 재설정
		int count = total - (Util.nvl(bvo.getPage()) - 1) * Util.nvl(bvo.getPageSize());
		logger.info("count = " + count);

		List<BoardVO> boardList = boardService.boardList(bvo);
		model.addAttribute("boardList", boardList);
		model.addAttribute("count", count);
		model.addAttribute("total", total);
		model.addAttribute("data", bvo);
		return "board/boardList";
	}

	// 글쓰기 폼 출력
	@RequestMapping(value = "/writeForm.do")
	public String writeForm() {
		logger.info("writeForm 호출 성공");
		return "board/writeForm";
	}

	// 글 쓰기 구현
	@RequestMapping(value = "/boardInsert", method = RequestMethod.POST)
	public String boardInsert(@ModelAttribute BoardVO bvo, Model model, HttpServletRequest request)
			throws IllegalStateException, IOException {
		logger.info("boardInsert 호출 성공");
		int result = 0;
		String url = "";

		if (bvo.getFile() != null) {
			String b_file = FileUploadUtil.fileUpload(bvo.getFile(), request, "board");
			bvo.setB_file(b_file);
		}

		result = boardService.boardInsert(bvo);
		if (result == 1) {
			url = "/board/boardList.do";
		} else {
			model.addAttribute("code", 1);
			url = "/board/writeForm.do";
		}
		return "redirect:" + url;
	}

	// 글 상세 보기
	@RequestMapping(value = "/boardDetail.do", method = RequestMethod.GET)
	public String boardDetail(@ModelAttribute BoardVO pvo, Model model) {
		logger.info("boardDetail 호출 성공");
		logger.info("b_num = " + pvo.getB_num());
		BoardVO detail = new BoardVO();
		detail = boardService.boardDetail(pvo);
		if (detail != null && (!detail.equals(""))) {
			detail.setB_content(detail.getB_content().toString().replaceAll("\n", "<br>"));
		}
		model.addAttribute("detail", detail);
		return "board/boardDetail";
	}

	/**************************************************************
	 * 비밀번호 확인
	 * 
	 * @param b_num
	 * @param b_pwd
	 * @return int로 result를 0 또는 1를 리턴할 수도 있고, String로 result 값을 "성공 or 실패"를 리턴할 수도
	 *         있다.(현재 문자열 리턴) 참고 : @ResponseBody는 전달된 뷰를 통해서 출력하는 것이 아니라 HTTP
	 *         Response Body에 직접 출력하는 방식. produces 속성은 지정한 미디어 타입과 관련된 응답을 생성하는데 사용한
	 *         실제 컨텐트 타입을 보장.
	 **************************************************************/
	@ResponseBody
	@RequestMapping(value = "/pwdConfirm.do", method = RequestMethod.POST, produces = "text/plain; charset=UTF-8")
	public String pwdConfirm(@ModelAttribute BoardVO bvo) {
		logger.info("pwdConfirm 호출 성공");
		String value = "";

		// 아래 변수에는 입력 성공에 대한 상태값 저장(1 or 0)
		int result = boardService.pwdConfirm(bvo);
		if (result == 1) {
			value = "성공";
		} else {
			value = "실패";
		}
		logger.info("result = " + result);
		return value + "";
	}

	// 글 수정 폼 출력
	@RequestMapping(value = "/updateForm.do")
	public String updateForm(@ModelAttribute BoardVO bvo, Model model) {
		logger.info("updateForm 호출 성공");
		logger.info("b_num = " + bvo.getB_num());
		BoardVO updateData = new BoardVO();
		updateData = boardService.boardDetail(bvo);
		model.addAttribute("updateData", updateData);
		return "board/updateForm";
	}

	// 글 수정 구현
	@RequestMapping(value = "/boardUpdate.do", method = RequestMethod.POST)
	public String boardUpdate(@ModelAttribute BoardVO bvo, HttpServletRequest request)
			throws IllegalStateException, IOException {
		logger.info("boardUpdate 호출 성공");
		int result = 0;
		String url = "";
		String b_file = "";
		if (!bvo.getFile().isEmpty()) {
			logger.info("======== file = " + bvo.getFile().getOriginalFilename());
			if (!bvo.getB_file().isEmpty()) {
				FileUploadUtil.fileDelete(bvo.getB_file(), request);
			}
			b_file = FileUploadUtil.fileUpload(bvo.getFile(), request, "board");
			bvo.setB_file(b_file);
		} else {
			logger.info("첨부파일 없음");
			bvo.setB_file("");
		}
		result = boardService.boardUpdate(bvo);
		if (result == 1) {
			// url="/board/boardList.do";
			// 수정 후 목록으로 이동
			url = "/board/boardDetail.do?b_num=" + bvo.getB_num();
		} else {
			// 아래 url은 수정 후 상세 페이지로 이동
			url = "/board/updateForm.do??b_num=" + bvo.getB_num();
		}
		return "redirect:" + url;
	}

	// 글 삭제 구현
	@RequestMapping(value = "/boardDelete.do")
	public String boardDelete(@ModelAttribute BoardVO bvo, HttpServletRequest request) throws IOException {
		logger.info("boardDelete 호출 성공");

		// 아래 변수에는 입력 성공에 대한 상태값 담습니다.(1 or 0)
		int result = 0;
		String url = "";

		if (!bvo.getB_file().isEmpty()) {
			FileUploadUtil.fileDelete(bvo.getB_file(), request);
		}
		result = boardService.boardDelete(bvo.getB_num());
		if (result == 1) {
			url = "/board/boardList.do";
		} else {
			url = "/board/boardDetail.do?b_num=" + bvo.getB_num();
		}
		return "redirect:" + url;
	}
}
