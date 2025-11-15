<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>学生注册 - 图书馆管理系统</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <!-- 原有CSS -->
    <link rel="stylesheet" type="text/css" href="css/reg.css">

    <style>
        body {
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .register-container {
            max-width: 600px;
            width: 100%;
        }
        .register-card {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }
        .register-header {
            background: linear-gradient(90deg, #2575fc 0%, #6a11cb 100%);
            color: white;
            padding: 25px 30px;
            text-align: center;
        }
        .register-header h2 {
            margin: 0;
            font-weight: 600;
            font-size: 1.8rem;
        }
        .register-body {
            padding: 30px;
        }
        .form-label {
            font-weight: 500;
            color: #495057;
            margin-bottom: 8px;
        }
        .form-control {
            border-radius: 8px;
            padding: 10px 15px;
            border: 1px solid #ced4da;
            transition: all 0.3s;
        }
        .form-control:focus {
            border-color: #6a11cb;
            box-shadow: 0 0 0 0.2rem rgba(106, 17, 203, 0.25);
        }
        .return-btn {
            position: absolute;
            top: 20px;
            left: 20px;
            border-radius: 8px;
            padding: 8px 16px;
            font-weight: 500;
            transition: all 0.3s;
        }
        .submit-btn {
            background: linear-gradient(90deg, #2575fc 0%, #6a11cb 100%);
            border: none;
            border-radius: 8px;
            padding: 12px 30px;
            font-weight: 500;
            font-size: 1.1rem;
            transition: all 0.3s;
            width: 100%;
            margin-top: 10px;
        }
        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        .form-row {
            margin-bottom: 20px;
        }
        .password-match {
            font-size: 0.875rem;
            margin-top: 5px;
        }
        .password-match.valid {
            color: #28a745;
        }
        .password-match.invalid {
            color: #dc3545;
        }
    </style>
</head>
<body>
<div class="register-container">
    <!-- 返回按钮 -->
    <button onclick="window.location.href='login.jsp'" class="btn btn-outline-primary return-btn">
        <i class="bi bi-arrow-left"></i> 返回登录
    </button>

    <div class="register-card">
        <div class="register-header">
            <h2><i class="bi bi-person-plus"></i> 学生信息注册</h2>
        </div>

        <div class="register-body">
            <form action="userLoginServlet?method=register" method="post" name="form" id="registerForm">
                <div class="row form-row">
                    <div class="col-md-6 mb-3">
                        <label for="user" class="form-label">学生学号</label>
                        <input type="text" class="form-control" id="user" name="user" placeholder="请输入学号" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="name" class="form-label">姓名</label>
                        <input type="text" class="form-control" id="name" name="name" placeholder="请输入姓名" required>
                    </div>
                </div>

                <div class="row form-row">
                    <div class="col-md-6 mb-3">
                        <label for="password" class="form-label">密码</label>
                        <input type="password" class="form-control" id="password" name="password" placeholder="请输入密码" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="repwd" class="form-label">确认密码</label>
                        <input type="password" class="form-control" id="repwd" name="repwd" placeholder="请再次输入密码" required>
                        <div id="passwordMatch" class="password-match"></div>
                    </div>
                </div>

                <div class="row form-row">
                    <div class="col-md-6 mb-3">
                        <label for="grade" class="form-label">年级</label>
                        <input type="text" class="form-control" id="grade" name="grade" placeholder="请输入年级" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="classes" class="form-label">班级</label>
                        <input type="text" class="form-control" id="classes" name="classes" placeholder="请输入班级" required>
                    </div>
                </div>

                <div class="mb-4">
                    <label for="email" class="form-label">电子邮箱</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="请输入电子邮箱" required>
                </div>

                <button type="submit" class="btn btn-primary submit-btn">
                    <i class="bi bi-person-check"></i> 注册
                </button>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

<!-- 密码匹配验证脚本 -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const password = document.getElementById('password');
        const repwd = document.getElementById('repwd');
        const passwordMatch = document.getElementById('passwordMatch');

        function validatePassword() {
            if (password.value === '' || repwd.value === '') {
                passwordMatch.textContent = '';
                passwordMatch.className = 'password-match';
            } else if (password.value === repwd.value) {
                passwordMatch.textContent = '✓ 密码匹配';
                passwordMatch.className = 'password-match valid';
            } else {
                passwordMatch.textContent = '✗ 密码不匹配';
                passwordMatch.className = 'password-match invalid';
            }
        }

        password.addEventListener('input', validatePassword);
        repwd.addEventListener('input', validatePassword);

        // 表单提交验证
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            if (password.value !== repwd.value) {
                e.preventDefault();
                alert('密码不匹配，请重新输入！');
                password.focus();
            }
        });
    });
</script>
</body>
</html>