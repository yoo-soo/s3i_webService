<%@ page language="java" contentType="text/html; charset=UTF-8	"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="soo.BoardDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html>
<head>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Gowun+Dodum&display=swap" rel="stylesheet">

<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="style.css" rel="stylesheet" type="text/css">
<meta charset="UTF-8">

<title>보안 취약점 정보 통합검색 사이트</title>

<h1 align="center">
보안 취약점 정보 통합검색
</h1>
</head>

<body style="background-color:#E8F5FF">
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*"%>
<%@ page import="javax.naming.*"%>
<%
	Connection conn = null;
	Statement stmt = null;
	// 쿼리문 작성
	String SQL = "select * from cve_information"
 	 		+ " where (description not like '%reserved%'"
 			+ " and cvss_v3_version not like '%null%'"
			+ " and cvss_v2_score not like '%none%')"
	 		+ " order by cvss_v3_version desc";
 	ResultSet rs = null;
	
	try {
		// 커넥션풀 
		Context init = new InitialContext();
		DataSource ds = (DataSource) init.lookup("java:comp/env/jdbc/cveDB");
		conn = ds.getConnection();
		stmt = conn.createStatement();
%>	
 
	<%
	
		BoardDAO bdao = new BoardDAO();
	%>
	
	<table>
	<div class="alert alert-light" align="center" style="padding-top: 5px; padding-bottom: 5px;">	
		</strong>
	 	<strong>오늘은 <%=bdao.getDate().substring(0,4) + "년 "
			+ bdao.getDate().substring(5, 7) + "월 " + bdao.getDate().substring(8, 10) + "일"%> 입니다. </strong>
	</div>
	</table>	

<div class="container">
		<div class="row">
			<form method="get" action="index.jsp">
				<table align = "left"> <!-- 오른쪽 정렬 -->
 					<tr>
	 					<td><select class="form-control" name="searchField">
								<option value="">상세선택</option>
								<option value="cveid">CVE-ID</option>
								<option value="descriptionKR">내용</option>
								<option value="cvss_v2_score">CVSS_v2 Score</option>
								<option value="cvss_v2_lv">CVSS_v2 Lv</option>
								<option value="cvss_v3_score">CVSS_v3 Score</option>
								<option value="cvss_v3_lv">CVSS_v3 Lv</option>
								<option value="publish_date">취약점 등록 날짜</option>
								<option value="upadte_date">업데이트 날짜</option>
								<option value="cvss_v3_version">VERSION</option>
						</select></td>
						<td><input type="text" class="form-control" placeholder="검색어 입력" name="searchText" maxlength="100"></td>
						<td><button type="submit" class="btn btn-success">검색</button></td>
					</tr>
				</table>
				
					<br><dir class="container" style="width:130px; margin-top:13px; margin-bottom:0px; margin-left:225px;">
		<div id="jb-title" align = "left">Search TIP</div>
   		<div id="jb-text">CVEID, Score(0.0~10.0), Lv(HIGH, MIDEUM, LOW), Date(xxxx-xx-xx)<br></div>
			</form>
		</div>
	</div>
	
	<div class = "container">
		<form method="get" action = "index.jsp">
			<table align = "right">
				<%-- 정렬 버튼 구현 --%>
				<div align="right" id="btn_group" style="margin-bottom:6px">
					<button type = "button" name = "NewVersion" onclick="location.href='NewVersion.jsp'" id="btn">최신 버전 순</button>
				    <button type = "button" name = "HighScoreV2" onclick="location.href='HighScoreV2.jsp'" id="btn">높은 점수 순(V2)</button>
				    <button type = "button" name = "HighScoreV3" onclick="location.href='HighScoreV3.jsp'" id="btn">높은 점수 순(V3)</button>
					<br>
				</div>
			</table>
		</form>
	</div>

<%
	String searchText = request.getParameter("searchText");
	String searchField = request.getParameter("searchField");
	
	try {
/* 		SQL = "select * from cve_information" 
 	 		+ " where (description not like '%reserved%'"
			+ " and cvss_v3_version not like '%null%'" 
			+ " and cvss_v2_score not like '%none%')" 
	 		+ " order by cveid desc";
		 */
	 	// 검색 기능 구현
		if (searchText != null){ %>

<%			
			// 검색 기능 구현
			// 검색어 필드(드롭 다운)에 맞는 검색어 검색하는 쿼리
			if (searchField != null){
			SQL = "select * from cve_information"
					+ " where " + searchField +" like '%" + searchText + "%'"
 					+ " and description not like '%reserved%'"
					+ " and cvss_v2_score not like '%null%'"
					+ " and cvss_v3_score not like '%none%'"
					+ " and cvss_v2_"
					+ " order by cveid desc";
			}
		}
	}catch(Exception e){
        out.println("Failure!!!");
        e.printStackTrace();
    }
		
%>

	<div class="container">
		<div class="row">
			<table class="active table table-striped">
				<thead>
					<tr>
						<th id="list">List</th>
					</tr>
				</thead>
			</table>
		</div>
			
 <hr>
   	  		<%
   	  		rs = stmt.executeQuery(SQL);
   	  		
		   	while(rs.next()){  %>
		  		<% String description = rs.getString("description"); 
		  			pageContext.setAttribute("description", description);
		  			String descriptionKR = rs.getString("descriptionKR"); 
		  			pageContext.setAttribute("descriptionKR", descriptionKR);
		  		
		  		%>
		  		
		  		
			   <div id="cve">[CVE] <%=rs.getString("cveid") + "<br>"%></div><br>
	
			   <div><c:out value = "${description}" escapeXml = "true"></c:out></div>
			   <br><div><c:out value = "${descriptionKR}" escapeXml = "true"></c:out></div>

			   
			   <br><div>V2 Score : <%=rs.getString("cvss_v2_score")%>
			   &nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;&nbsp;V2 LV : <%=rs.getString("cvss_v2_lv")%></div>
			   <br><div>V3 Score : <%=rs.getString("cvss_v3_score")%>
			   &nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;&nbsp;V3 LV : <%=rs.getString("cvss_v3_lv")%></div>
			   
			   <br><div>Version : <%=rs.getString("cvss_v3_version")%></div>
			   
			   <br><div align="center" id="ForestGreen">등록일 : <%=rs.getString("publish_date")%>
			   &nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp;
			   최종 수정일 : <%=rs.getString("update_date") + "<br>"%></div> 
			   <hr>
<%
		   	}
		
	} catch (SQLException e) {
		e.printStackTrace();
		System.out.println("DB 연결 실패");
	} finally {
		try {
			if(conn != null) conn.close();
			if(stmt != null) stmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
%>

	</div>
</body>
</html>
