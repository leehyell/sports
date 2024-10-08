package com.mbc.sports.comment;

import java.util.ArrayList;

public interface CommentService {
	//���� �� ��� �Լ�
	int getStep(int playernum);
	void input(int playernum, int step, String id, String writer, String comment);
	void updatePlayerStep(int step, int playernum);

	//��� �� ���Ǵ� �Լ�
	int total(int playernum);
	ArrayList<CommentDTO> comment(int playernum, int start, int end);

	void delete(int playernum, int step);

	void update(int playernum, int step, String ucomment);
	
	void heartUp(int playernum, String step);
	int heart(int playernum, String step);
}