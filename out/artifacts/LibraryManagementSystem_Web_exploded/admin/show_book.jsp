<%@ page import="com.demo.javabean.Books" %>
<%@ page import="com.demo.dao.BookDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.awt.print.Book" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 引入JSTL标签库 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <title>图书信息 - 图书馆管理系统</title>
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
        .search-form {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
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
        .book-icon {
            color: #3498db;
            margin-right: 8px;
        }
        .author-info {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .category-badge {
            background-color: #e9ecef;
            color: #495057;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
        }
        .amount-badge {
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        .amount-high {
            background-color: rgba(40, 167, 69, 0.2);
            color: #155724;
        }
        .amount-medium {
            background-color: rgba(255, 193, 7, 0.2);
            color: #856404;
        }
        .amount-low {
            background-color: rgba(220, 53, 69, 0.2);
            color: #721c24;
        }
        .action-buttons {
            display: flex;
            gap: 8px;
        }
        .update-btn {
            padding: 6px 12px;
            font-size: 0.85rem;
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
        <h2><i class="bi bi-book"></i> 所有图书信息</h2>
    </div>

    <!-- 搜索表单 -->
    <div class="search-form">
        <form action="PageServlet.do" method="get" class="row g-3 align-items-center">
            <div class="col-md-8">
                <input type="text" name="name" class="form-control" placeholder="请输入图书名称">
                <input type="text" name="method" value="showBook" hidden>
            </div>
            <div class="col-md-4">
                <button type="submit" class="btn btn-primary w-100">
                    <i class="bi bi-search"></i> 查询
                </button>
            </div>
        </form>
    </div>

    <!-- 图书表格 -->
    <div class="table-container">
        <table class="table table-hover">
            <thead>
            <tr>
                <th width="30%">图书名称</th>
                <th width="25%">图书作者</th>
                <th width="20%">图书类别</th>
                <th width="15%">图书数量</th>
                <th width="10%">操作</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty list}">
                    <c:forEach items="${list}" var="b">
                        <tr>
                            <td>
                                <i class="bi bi-book book-icon"></i>
                                <strong>${b.name}</strong>
                            </td>
                            <td class="author-info">
                                <i class="bi bi-person"></i> ${b.author}
                            </td>
                            <td>
                                <span class="category-badge">${b.category}</span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${b.amount > 10}">
                                                <span class="amount-badge amount-high">
                                                    <i class="bi bi-check-circle"></i> ${b.amount}
                                                </span>
                                    </c:when>
                                    <c:when test="${b.amount > 5}">
                                                <span class="amount-badge amount-medium">
                                                    <i class="bi bi-exclamation-circle"></i> ${b.amount}
                                                </span>
                                    </c:when>
                                    <c:otherwise>
                                                <span class="amount-badge amount-low">
                                                    <i class="bi bi-x-circle"></i> ${b.amount}
                                                </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <a href="manageBookServlet.do?action=update&sid=${b.id}"
                                       class="btn btn-outline-primary btn-sm update-btn">
                                        <i class="bi bi-pencil"></i> 更改
                                    </a>
                                    <a href="manageBookServlet.do?action=delbook&name=${b.name}"
                                       class="btn btn-outline-danger btn-sm delete-btn"
                                       onclick="return confirmDelete('${b.name}')">
                                        <i class="bi bi-trash"></i> 删除
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5">
                            <div class="empty-state">
                                <i class="bi bi-inbox"></i>
                                <h4>暂无图书信息</h4>
                                <p>没有找到符合条件的图书。</p>
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
    function confirmDelete(bookName) {
        return confirm('确定要删除图书《' + bookName + '》吗？此操作不可恢复！');
    }
</script>
</body>
</html>