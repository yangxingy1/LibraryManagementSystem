<%@ page import="com.demo.javabean.Students"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.demo.dao.StudentDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!-- 引入JSTL标签库 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
	<title>所有学生 - 图书馆管理系统</title>
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
		.table-container {
			background-color: white;
			border-radius: 10px;
			box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
			overflow: hidden;
		}
		.table th {
			background-color: #2c3e50;
			color: white;
			font-weight: 500;
			border: none;
			padding: 15px;
		}
		.table td {
			padding: 15px;
			vertical-align: middle;
			border-color: #f1f1f1;
		}
		.table tbody tr:hover {
			background-color: rgba(52, 152, 219, 0.05);
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
		.user-icon {
			color: #3498db;
			margin-right: 8px;
		}
		.delete-btn {
			padding: 6px 12px;
			font-size: 0.85rem;
		}
		.pagination-container {
			background-color: white;
			border-radius: 10px;
			padding: 15px;
			margin-top: 20px;
			box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
			text-align: center;
		}
	</style>
</head>
<body>
<div class="container">
	<div class="page-header">
		<h2><i class="bi bi-people"></i> 所有学生账户信息</h2>
	</div>

	<div class="table-container">
		<table class="table table-hover">
			<thead>
			<tr>
				<th width="25%">学生学号</th>
				<th width="25%">学生姓名</th>
				<th width="20%">学生年级</th>
				<th width="20%">学生班级</th>
				<th width="10%">操作</th>
			</tr>
			</thead>
			<tbody>
			<c:choose>
				<c:when test="${not empty list}">
					<c:forEach items="${list}" var="s">
						<tr>
							<td>
								<i class="bi bi-person-badge user-icon"></i>
								<strong>${s.user}</strong>
							</td>
							<td>${s.name}</td>
							<td>${s.grade}</td>
							<td>${s.classes}</td>
							<td>
								<a href="manageStudentServlet.do?action=delstudent&user=${s.user}"
								   class="btn btn-outline-danger btn-sm delete-btn"
								   onclick="return confirmDelete('${s.name}', '${s.user}')">
									<i class="bi bi-trash"></i> 删除
								</a>
							</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="5">
							<div class="empty-state">
								<i class="bi bi-inbox"></i>
								<h4>暂无学生数据</h4>
								<p>没有找到任何学生信息。</p>
							</div>
						</td>
					</tr>
				</c:otherwise>
			</c:choose>
			</tbody>
		</table>
	</div>

	<!-- 分页组件 -->
	<div class="pagination-container">
		${bar} /页
	</div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

<script>
	function confirmDelete(studentName, studentId) {
		return confirm('确定要删除学生 "' + studentName + '" (学号: ' + studentId + ') 吗？此操作不可恢复！');
	}
</script>
</body>
</html>