<%@ page import="com.demo.javabean.Students"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.demo.dao.StudentDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%-- 【重要】 确保JSTL标签库已引入 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<title>学生详细信息 - 图书馆管理系统</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
	<link rel="stylesheet" href="../css/list.css">

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
			text-align: center;
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
			max-width: 800px;
			margin: 0 auto;
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
		.borrowed-count {
			background-color: rgba(52, 152, 219, 0.2);
			color: #0c5460;
		}
		.back-btn {
			position: absolute;
			top: 20px;
			left: 20px;
		}
		/* (新功能) 锁定模块的样式 */
		.lock-section {
			background-color: #fff3cd; /* Bootstrap 警告黄色背景 */
			border: 1px solid #ffeeba;
			border-radius: 8px;
			padding: 20px;
			margin: 20px auto;
			max-width: 800px;
		}
	</style>
</head>
<body>
<a href="${pageContext.request.contextPath}/PageServlet.do?method=showStudent" class="btn btn-outline-primary back-btn">
	<i class="bi bi-arrow-left"></i> 返回列表
</a>


<div class="container">
	<div class="page-header">
		<h2><i class="bi bi-person-lines-fill"></i> 学生账户信息</h2>
	</div>

	<%-- (您在上一步中修复的 <c:choose> 逻辑) --%>
	<c:choose>
		<c:when test="${not empty student}">
			<div class="info-card">
				<div class="info-item">
					<div class="info-icon">
						<i class="bi bi-person-badge"></i>
					</div>
					<div class="info-label">学生学号</div>
					<div class="info-value">${student.user}</div>
				</div>

				<div class="info-item">
					<div class="info-icon">
						<i class="bi bi-key"></i>
					</div>
					<div class="info-label">学生密码</div>
					<div class="info-value">${student.password}</div>
				</div>

				<div class="info-item">
					<div class="info-icon">
						<i class="bi bi-person"></i>
					</div>
					<div class="info-label">学生姓名</div>
					<div class="info-value">${student.name}</div>
				</div>

				<div class="info-item">
					<div class="info-icon">
						<i class="bi bi-mortarboard"></i>
					</div>
					<div class="info-label">学生年级</div>
					<div class="info-value">${student.grade}</div>
				</div>

				<div class="info-item">
					<div class="info-icon">
						<i class="bi bi-people"></i>
					</div>
					<div class="info-label">学生班级</div>
					<div class="info-value">${student.classes}</div>
				</div>

				<div class="info-item">
					<div class="info-icon">
						<i class="bi bi-envelope"></i>
					</div>
					<div class="info-label">电子邮箱</div>
					<div class="info-value">${student.email}</div>
				</div>

				<div class="info-item">
					<div class="info-icon">
						<i class="bi bi-book"></i>
					</div>
					<div class="info-label">借书数量</div>
					<div class="info-value">
                            <span class="book-count borrowed-count">
                          ${student.amount} 本
                            </span>
					</div>
				</div>
			</div>

			<%-- 【修改点 4】: (新功能) 账号锁定模块 --%>
			<div class="lock-section">
				<h5><i class="bi bi-lock-fill"></i> 账号管理 (管理员操作)</h5>
				<hr>
				<div class="form-check form-switch fs-5">
					<input class="form-check-input" type="checkbox"
						   id="lockCheckbox"
						${student.locked ? 'checked' : ''}
						   onclick="updateLockStatus(${student.id})">

					<label class="form-check-label" for="lockCheckbox" id="lockLabel">
						<c:if test="${student.locked}">
							<strong class="text-danger">账号已锁定 (禁止借书)</strong>
						</c:if>
						<c:if test="${!student.locked}">
							<span class="text-success">账号正常 (允许借书)</span>
						</c:if>
					</label>
				</div>
				<small class="form-text text-muted">
					勾选此框将立即锁定该学生账号，使其无法借阅新书，但仍可还书。
				</small>
			</div>


			<div class="row mt-4" style="max-width: 800px; margin: 0 auto;">
				<div class="col-md-4">
					<div class="card text-center">
						<div class="card-body">
							<h5 class="card-title">可借书籍</h5>
							<h3 class="text-primary">${10 - student.amount}</h3>
							<p class="card-text">剩余可借数量</p>
						</div>
					</div>
				</div>
				<div class="col-md-4">
					<div class="card text-center">
						<div class="card-body">
							<h5 class="card-title">已借书籍</h5>
							<h3 class="text-info">${student.amount}</h3>
							<p class="card-text">当前借阅数量</p>
						</div>
					</div>
				</div>
				<div class="col-md-4">
					<div class="card text-center">
						<div class="card-body">
							<h5 class="card-title">借阅上限</h5>
							<h3 class="text-success">10</h3>
							<p class="card-text">最大借阅数量</p>
						</div>
					</div>
				</div>
			</div>
		</c:when>

		<%-- (您删除的 <c:otherwise> 逻辑，为保险起见我加回来) --%>
		<c:otherwise>
			<div class="empty-state info-card">
				<i class="bi bi-search-heart"></i>
				<h4>未找到学生</h4>
				<p>您所查询的学生信息不存在。</p>
			</div>
		</c:otherwise>

	</c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

<%-- 【修改点 5】: (新功能) 添加 JavaScript (AJAX) --%>
<script>
	function updateLockStatus(studentId) {
		const checkbox = document.getElementById('lockCheckbox');
		const label = document.getElementById('lockLabel');
		const isLocked = checkbox.checked;

		// (1) 准备要发送的数据
		const formData = new URLSearchParams();
		formData.append('s_id', studentId);
		formData.append('isLocked', isLocked);

		// (2) 立即更新UI (乐观更新)
		if (isLocked) {
			label.innerHTML = '<strong class=\"text-danger\"><i>正在锁定...</i></strong>';
		} else {
			label.innerHTML = '<span class=\"text-success\"><i>正在解锁...</i></span>';
		}

		// (3) 发送 AJAX 请求到新 Servlet
		fetch('${pageContext.request.contextPath}/studentLockServlet.do', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded',
			},
			body: formData
		})
				.then(response => {
					if (!response.ok) {
						throw new Error('服务器响应失败');
					}
					return response.json();
				})
				.then(data => {
					if (data.success) {
						// (4) 根据服务器返回的最终状态更新UI
						if (data.newState) {
							label.innerHTML = '<strong class=\"text-danger\">账号已锁定 (禁止借书)</strong>';
							checkbox.checked = true;
						} else {
							label.innerHTML = '<span class=\"text-success\">账号正常 (允许借书)</span>';
							checkbox.checked = false;
						}
					} else {
						throw new Error(data.message || '更新失败');
					}
				})
				.catch(error => {
					// (5) 如果失败，回滚UI
					console.error('Error:', error);
					alert('更新失败！请刷新页面重试。');
					// 回滚复选框状态
					checkbox.checked = !isLocked;
					label.innerHTML = isLocked ? '<span class=\"text-success\">账号正常 (允许借书)</span>' : '<strong class=\"text-danger\">账号已锁定 (禁止借书)</strong>';
				});
	}
</script>
</body>
</html>