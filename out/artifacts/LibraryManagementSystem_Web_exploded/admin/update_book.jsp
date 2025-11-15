<%@ page import="com.demo.javabean.Books" %>
<%@ page import="com.demo.dao.BookDAO" %>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<html>
<head>
    <title>更新图书 - 图书馆管理系统</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">

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
        .update-container {
            max-width: 600px;
            width: 100%;
        }
        .update-card {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }
        .update-header {
            background: linear-gradient(90deg, #2575fc 0%, #6a11cb 100%);
            color: white;
            padding: 25px 30px;
            text-align: center;
        }
        .update-header h2 {
            margin: 0;
            font-weight: 600;
            font-size: 1.8rem;
        }
        .update-body {
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
        .back-btn {
            position: absolute;
            top: 20px;
            left: 20px;
        }
    </style>
</head>
<body>
<!-- 返回按钮 -->
<a href="javascript:history.back()" class="btn btn-outline-primary back-btn">
    <i class="bi bi-arrow-left"></i> 返回
</a>

<div class="update-container">
    <div class="update-card">
        <div class="update-header">
            <h2><i class="bi bi-pencil-square"></i> 更新图书信息</h2>
        </div>

        <div class="update-body">
            <form action="manageBookServlet.do?action=updatebook" method="post" id="updateBookForm">
                <!-- 隐藏字段 -->
                <input type="hidden" name="sid" value="${book.id}"/>

                <div class="mb-3">
                    <label for="name" class="form-label">图书名称</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-book"></i></span>
                        <input type="text" class="form-control" id="name" name="name" value="${book.name}" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="author" class="form-label">图书作者</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                        <input type="text" class="form-control" id="author" name="author" value="${book.author}" required>
                    </div>
                </div>

                <div class="row form-row">
                    <div class="col-md-6 mb-3">
                        <label for="amount" class="form-label">图书数量</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-123"></i></span>
                            <input type="number" class="form-control" id="amount" name="amount" value="${book.amount}" min="0" required>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="category" class="form-label">图书类型</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-tags"></i></span>
                            <input type="text" class="form-control" id="category" name="category" value="${book.category}" required>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary submit-btn" onclick="return validateForm()">
                    <i class="bi bi-check-lg"></i> 更新图书
                </button>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

<!-- 表单验证脚本 -->
<script>
    function validateForm() {
        // 获取表单元素
        const name = document.getElementById('name');
        const author = document.getElementById('author');
        const amount = document.getElementById('amount');
        const category = document.getElementById('category');

        // 检查图书名称
        if (name.value.trim() === '') {
            alert('请输入图书名称！');
            name.focus();
            return false;
        }

        // 检查作者
        if (author.value.trim() === '') {
            alert('请输入图书作者！');
            author.focus();
            return false;
        }

        // 检查数量
        if (amount.value.trim() === '' || parseInt(amount.value) < 0) {
            alert('请输入有效的图书数量！');
            amount.focus();
            return false;
        }

        // 检查类型
        if (category.value.trim() === '') {
            alert('请输入图书类型！');
            category.focus();
            return false;
        }

        // 所有验证通过
        return true;
    }

    // 添加实时验证
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('updateBookForm');
        const inputs = form.querySelectorAll('input[required]');

        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (this.value.trim() === '') {
                    this.classList.add('is-invalid');
                } else {
                    this.classList.remove('is-invalid');
                }
            });
        });
    });
</script>
</body>
</html>