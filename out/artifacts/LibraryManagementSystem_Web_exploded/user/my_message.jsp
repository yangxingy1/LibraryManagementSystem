<%@ page import="com.demo.javabean.Students"%>
<%@ page import="com.demo.dao.StudentDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
	<title>我的基本信息 - 图书馆管理系统</title>
	<!-- Bootstrap 5 CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Bootstrap Icons -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">

	<style>
		body {
			background-color: #f8f9fa;
			font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
			padding: 20px;
		}
		.page-header {
			background: linear-gradient(90deg, #2575fc 0%, #6a11cb 100%);
			color: white;
			border-radius: 10px;
			padding: 20px;
			margin-bottom: 25px;
			box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
		}
		.page-header h2 {
			margin: 0;
			font-weight: 600;
		}
		.info-card {
			background-color: white;
			border-radius: 10px;
			box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
			overflow: hidden;
		}
		.info-item {
			padding: 15px 20px;
			border-bottom: 1px solid #f1f1f1;
			display: flex;
			align-items: center;
		}
		.info-item:last-child {
			border-bottom: none;
		}
		.info-label {
			font-weight: 600;
			color: #495057;
			width: 150px;
			flex-shrink: 0;
		}
		.info-value {
			color: #6c757d;
			flex-grow: 1;
		}
		.info-icon {
			width: 30px;
			text-align: center;
			margin-right: 10px;
			color: #3498db;
		}
		.empty-state {
			text-align: center;
			padding: 40px;
			color: #6c757d;
		}
		.empty-state i {
			font-size: 3rem;
			margin-bottom: 15px;
			color: #adb5bd;
		}
		.book-count {
			display: inline-block;
			padding: 4px 12px;
			border-radius: 20px;
			font-weight: 500;
			font-size: 0.9rem;
		}
		.available-count {
			background-color: rgba(40, 167, 69, 0.2);
			color: #155724;
		}
		.borrowed-count {
			background-color: rgba(52, 152, 219, 0.2);
			color: #0c5460;
		}
	</style>
</head>
<body>
<%
	StudentDAO s_dao = new StudentDAO();
	Students student = (Students)session.getAttribute("student");
	if(student != null){
		student = s_dao.getStudentByName(student.getUser());
		session.setAttribute("student",student);
	}
%>

<div class="container">
	<div class="page-header">
		<h2><i class="bi bi-person-lines-fill"></i> 我的基本信息</h2>
	</div>

	<c:choose>
		<c:when test="${student != null}">
			<div class="info-card">
				<div class="info-item">
					<div class="info-icon">
						<i class="bi bi-person-badge"></i>
					</div>
					<div class="info-label">我的学号</div>
					<div class="info-value">${student.user}</div>
				</div>

				<div class="info-item">
					<div class="info-icon">
						<i class="bi bi-person"></i>
					</div>
					<div class="info-label">我的姓名</div>
					<div class="info-value">${student.name}</div>
				</div>

				<div class="info-item">
					<div class="info-icon">
						<i class="bi bi-mortarboard"></i>
					</div>
					<div class="info-label">我的年级</div>
					<div class="info-value">${student.grade}</div>
				</div>

				<div class="info-item">
					<div class="info-icon">
						<i class="bi bi-people"></i>
					</div>
					<div class="info-label">我的班级</div>
					<div class="info-value">${student.classes}</div>
				</div>

				<div class="info-item">
					<div class="info-icon">
						<i class="bi bi-envelope"></i>
					</div>
					<div class="info-label">我的邮箱</div>
					<div class="info-value">${student.email}</div>
				</div>

				<div class="info-item">
					<div class="info-icon">
						<i class="bi bi-bookmark-check"></i>
					</div>
					<div class="info-label">可借书籍</div>
					<div class="info-value">
                            <span class="book-count available-count">
                                ${10 - student.amount} 本
                            </span>
					</div>
				</div>

				<div class="info-item">
					<div class="info-icon">
						<i class="bi bi-book"></i>
					</div>
					<div class="info-label">已借书籍</div>
					<div class="info-value">
                            <span class="book-count borrowed-count">
                                ${student.amount} 本
                            </span>
					</div>
				</div>
			</div>

			<!-- 添加一些使用提示 -->
			<div class="mt-4 p-3 bg-light rounded">
				<h5><i class="bi bi-info-circle"></i> 使用提示</h5>
				<ul class="mb-0">
					<li>每位学生最多可借阅 10 本书籍</li>
					<li>请按时归还书籍，避免产生逾期费用</li>
					<li>如需修改个人信息，请联系图书馆管理员</li>
				</ul>
			</div>
		</c:when>
		<c:otherwise>
			<div class="empty-state">
				<i class="bi bi-exclamation-circle"></i>
				<h4>无法获取信息</h4>
				<p>请先登录系统</p>
				<a href="login.jsp" class="btn btn-primary mt-2">
					<i class="bi bi-box-arrow-in-right"></i> 前往登录
				</a>
			</div>
		</c:otherwise>
	</c:choose>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>