<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.javabean.Students" %>
<%@ page import="com.demo.dao.BorrowDAO" %>
<%@ page import="com.demo.javabean.Borrows" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.demo.dao.BookDAO" %>
<%-- 【重要】引入JSTL --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>我的已借书籍 - 图书馆管理系统</title>
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
        .return-btn {
            padding: 6px 12px;
            font-size: 0.85rem;
        }
        .content-area {
            max-height: 70vh;
            overflow-y: auto;
        }
    </style>
</head>
<body>
<%
    // 获取 Session 中的学生对象
    Students student = (Students) session.getAttribute("student");

    // 创建DAO实例
    BorrowDAO borrowDAO = new BorrowDAO();
    BookDAO bookDAO = new BookDAO();

    // 调用DAO (新的 getActiveBorrowsBySId)
    ArrayList<Borrows> borrows = borrowDAO.getActiveBorrowsBySId(student.getId());

    // 将数据放入pageContext供JSTL使用
    pageContext.setAttribute("borrows", borrows);
    pageContext.setAttribute("student", student);
%>

<div class="container">
    <div class="page-header">
        <h2><i class="bi bi-journal-check"></i> 我的已借书籍</h2>
        <p class="mb-0">仅显示已批准的借阅记录</p>
    </div>

    <div class="table-container content-area">
        <table class="table table-hover">
            <thead>
            <tr>
                <th width="35%">图书名称</th>
                <th width="25%">图书作者</th>
                <th width="20%">图书类型</th>
                <th width="20%">操作</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty borrows}">
                    <c:forEach items="${borrows}" var="borrow">
                        <%
                            // 性能提示: 此处 N+1 查询
                            // 为每条借阅记录查询一次书籍详情
                            Borrows currentBorrow = (Borrows) pageContext.getAttribute("borrow");
                            BookDAO bookDAOInstance = new BookDAO();
                            pageContext.setAttribute("book", bookDAOInstance.getBookById(currentBorrow.getB_id()));
                        %>
                        <tr>
                            <td>
                                <i class="bi bi-book book-icon"></i>
                                <strong>${book.name}</strong>
                            </td>
                            <td class="author-info">
                                <i class="bi bi-person"></i> ${book.author}
                            </td>
                            <td>
                                <span class="category-badge">${book.category}</span>
                            </td>
                            <td>
                                    <%-- 【修改点 3】: 链接到 ReturnServlet 并传递 borrow_id --%>
                                <a href="../returnServlet?borrow_id=${borrow.id}"
                                   class="btn btn-outline-danger btn-sm return-btn"
                                   onclick="return confirmReturn('${book.name}')">
                                    <i class="bi bi-arrow-return-left"></i> 还书
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="4">
                            <div class="empty-state">
                                <i class="bi bi-inbox"></i>
                                <h4>暂无已借书籍</h4>
                                <p>您当前没有已借阅的书籍。</p>
                                <a href="userChoiceServlet.do?signal=1" class="btn btn-primary mt-2">
                                    <i class="bi bi-book"></i> 浏览图书
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function confirmReturn(bookName) {
        return confirm('确定要归还《' + bookName + '》吗？');
    }
</script>
</body>
</html>