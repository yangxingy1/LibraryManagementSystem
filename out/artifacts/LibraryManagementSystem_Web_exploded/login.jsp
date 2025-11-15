<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
	<title>图书馆管理系统 - 登录</title>
	<!-- Bootstrap 5 CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Bootstrap Icons -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
	<!-- 保留原有CSS，确保样式一致性 -->
	<link rel="stylesheet" type="text/css" href="css/login.css">
	<style>
		/* 自定义样式增强Bootstrap效果 */
		.login-container {
			min-height: 100vh;
			background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
			display: flex;
			align-items: center;
			justify-content: center;
			padding: 20px;
		}
		.login-card {
			border-radius: 15px;
			box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
			overflow: hidden;
			max-width: 800px;
			width: 100%;
		}
		.login-header {
			background: rgba(255, 255, 255, 0.1);
			backdrop-filter: blur(10px);
			padding: 20px;
			text-align: center;
			color: white;
			border-bottom: 1px solid rgba(255, 255, 255, 0.2);
		}
		.nav-tabs {
			border-bottom: none;
			justify-content: center;
		}
		.nav-tabs .nav-link {
			color: white;
			border: none;
			padding: 12px 25px;
			margin: 0 5px;
			border-radius: 30px;
			transition: all 0.3s;
		}
		.nav-tabs .nav-link:hover {
			background-color: rgba(255, 255, 255, 0.2);
		}
		.nav-tabs .nav-link.active {
			background-color: white;
			color: #2575fc;
			font-weight: bold;
		}
		.tab-content {
			background-color: white;
			padding: 30px;
		}
		.form-label {
			font-weight: 500;
			color: #495057;
		}
		.reg-link {
			font-size: 0.85rem;
			float: right;
		}
		.remember-me {
			font-size: 0.9rem;
		}
		.admin-note {
			font-size: 0.85rem;
			color: #6c757d;
			text-align: center;
			margin-top: 10px;
		}
	</style>
</head>
<body>
<div class="login-container">
	<div class="login-card">
		<div class="login-header">
			<h2><i class="bi bi-book-half"></i> 图书馆管理系统</h2>
			<p class="mb-0">请选择身份登录</p>
		</div>

		<!-- 选项卡导航 -->
		<ul class="nav nav-tabs" id="loginTab" role="tablist">
			<li class="nav-item" role="presentation">
				<button class="nav-link active" id="student-tab" data-bs-toggle="tab"
						data-bs-target="#student" type="button" role="tab"
						aria-controls="student" aria-selected="true">
					<i class="bi bi-person"></i> 学生登录
				</button>
			</li>
			<li class="nav-item" role="presentation">
				<button class="nav-link" id="admin-tab" data-bs-toggle="tab"
						data-bs-target="#admin" type="button" role="tab"
						aria-controls="admin" aria-selected="false">
					<i class="bi bi-person-gear"></i> 管理员登录
				</button>
			</li>
		</ul>

		<!-- 选项卡内容 -->
		<div class="tab-content" id="loginTabContent">
			<!-- 学生登录表单 -->
			<div class="tab-pane fade show active" id="student" role="tabpanel"
				 aria-labelledby="student-tab">
				<form action="userLoginServlet?method=login" method="post" name="form_user">
					<div class="mb-3">
						<label for="user" class="form-label">
							学号 <a href="reg.jsp" class="reg-link">没有账号?立即注册</a>
						</label>
						<div class="input-group">
							<span class="input-group-text"><i class="bi bi-person"></i></span>
							<input type="text" class="form-control" id="user" name="user"
								   placeholder="输入您的学号" autocomplete="off" required>
						</div>
					</div>

					<div class="mb-3">
						<label for="password" class="form-label">密码</label>
						<div class="input-group">
							<span class="input-group-text"><i class="bi bi-lock"></i></span>
							<input type="password" class="form-control" id="password" name="password"
								   placeholder="输入您的登录密码" autocomplete="off" required>
						</div>
					</div>

					<div class="mb-3 form-check remember-me">
						<input type="checkbox" class="form-check-input" id="remember" name="remember" value="1" checked>
						<label class="form-check-label" for="remember">记住密码</label>
					</div>

					<div class="d-grid">
						<button type="submit" class="btn btn-primary btn-lg">
							<i class="bi bi-box-arrow-in-right"></i> 登录
						</button>
					</div>
				</form>
			</div>

			<!-- 管理员登录表单 -->
			<div class="tab-pane fade" id="admin" role="tabpanel"
				 aria-labelledby="admin-tab">
				<form action="adminLoginServlet?method=login" method="post" name="form_admin">
					<div class="mb-3">
						<label for="a_user" class="form-label">管理员账号</label>
						<div class="input-group">
							<span class="input-group-text"><i class="bi bi-person-gear"></i></span>
							<input type="text" class="form-control" id="a_user" name="a_user"
								   placeholder="输入管理员账号" autocomplete="off" required>
						</div>
					</div>

					<div class="mb-3">
						<label for="a_password" class="form-label">管理员密码</label>
						<div class="input-group">
							<span class="input-group-text"><i class="bi bi-shield-lock"></i></span>
							<input type="password" class="form-control" id="a_password" name="a_password"
								   placeholder="输入您的管理员密码" autocomplete="off" required>
						</div>
					</div>

					<div class="admin-note">
						<p>暂不支持记住密码和注册</p>
					</div>

					<div class="d-grid">
						<button type="submit" class="btn btn-primary btn-lg">
							<i class="bi bi-box-arrow-in-right"></i> 登录
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>