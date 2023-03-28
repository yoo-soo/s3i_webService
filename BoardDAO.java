package soo;

import java.sql.*;
import java.util.*;

public class BoardDAO {
	// 데이터 베이스에 접근하게 해주는 하나의 객체
	private Connection conn;
	// 정보를 담을 수 있는 객체
	private ResultSet rs;

	// mysql에 접속을 할 수 있게 해줌, 자동으로 데이터베이스 커넥션
	public BoardDAO() {
		try { // 예외처리

			// 데이터베이스 커넥션 생성
			String dbURL = "jdbc:mysql://192.168.1.17:3306/cve?serverTimezone=UTC";
			String dbID = "s3i";
			String dbPassword = "qhdks00!!";
			Class.forName("com.mysql.jdbc.Driver"); // mysql 드라이버 찾기

			// 드라이버는 mysql에 접속할 수 있도록 매개체 역할을 하는 하나의 라이브러리임.
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			System.out.println("DB 연동 성공");

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("DB 연동 실패");
		}
	}

	public String getDate() { // 현재 서버 시간 가져오기
		String SQL = "SELECT NOW()"; // 현재 시간을 가져오는 쿼리문
		try {
			// sql 문장 실행 준비 단계
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); // 실행결과 가져오기

			if (rs.next()) {
				return rs.getString(1); // 현재 날짜 반환
			}
		} catch (Exception e) {
			e.printStackTrace(); // 오류 발생
			System.out.println("날짜 가져오기 오류 발생!!");
		}
		return ""; // 데이터 베이스 오류
	}
}
