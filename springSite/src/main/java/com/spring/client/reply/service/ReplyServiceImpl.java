package com.spring.client.reply.service;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.client.reply.dao.ReplyDao;
import com.spring.client.reply.vo.ReplyVO;

@Service
@Transactional
public class ReplyServiceImpl implements ReplyService {
	Logger logger = Logger.getLogger(ReplyServiceImpl.class);

	@Autowired
	private ReplyDao replyDao;

	// 댓글 목록 구현
	@Override
	public List<ReplyVO> replyList(Integer b_num) {
		List<ReplyVO> myList = null;
		myList = replyDao.replyList(b_num);
		return myList;
	}

	// 댓글 입력 구현
	@Override
	public int replyInsert(ReplyVO rvo) {
		int result = 0;
		try {
			result = replyDao.replyInsert(rvo);
		} catch (Exception e) {
			e.printStackTrace();
			result = 0;
		}
		return result;
	}

	@Override
	public int pwdConfirm(ReplyVO rvo) {
		int result = 0;
		result = replyDao.pwdConfirm(rvo);
		return result;
	}

	// 댓글 수정 구현
	@Override
	public int replyUpdate(ReplyVO rvo) {
		int result = 0;
		try {
			result = replyDao.replyUpdate(rvo);
		} catch (Exception e) {
			e.printStackTrace();
			result = 0;
		}
		return result;
	}

	// 댓글 삭제 구현
	@Override
	public int replyDelete(int r_num) {
		int result = 0;
		try {
			result = replyDao.replyDelete(r_num);
		} catch (Exception e) {
			e.printStackTrace();
			result = 0;
		}
		return result;
	}
}
