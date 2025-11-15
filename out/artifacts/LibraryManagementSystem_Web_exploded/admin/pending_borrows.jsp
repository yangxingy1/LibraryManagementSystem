<%--
  Created by IntelliJ IDEA.
  User: asus
  Date: 2025/11/15
  Time: 下午2:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>待审批的借阅申请 - 图书馆管理系统</title>
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
        .student-info {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .action-buttons {
            display: flex;
            gap: 8px;
        }
        .approve-btn {
            padding: 6px 12px;
            font-size: 0.85rem;
        }
        .deny-btn {
            padding: 6px 12px;
            font-size: 0.85rem;
        }
        .book-icon {
            color: #3498db;
            margin-right: 8px;
        }
        .user-icon {
            color: #6c757d;
            margin-right: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="page-header">
        <h2><i class="bi bi-clock-history"></i> 待审批的借阅申请</h2>
        <p class="mb-0">按申请时间排序</p>
    </div>

    <div class="table-container">
        <table class="table table-hover">
            <thead>
            <tr>
                <th width="25%">申请学生</th>
                <th width="15%">学生学号</th>
                <th width="30%">申请书籍</th>
                <th width="15%">申请时间</th>
                <th width="15%">操作</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <%-- (功能1) 遍历 BorrowAdminServlet 传来的 pendingList --%>
                <c:when test="${not empty pendingList}">
                    <c:forEach items="${pendingList}" var="borrow">
                        <tr>
                                <%-- (BorrowDAO中已帮我们获取了关联的 Student 和 Book 对象) --%>
                            <td>
                                <i class="bi bi-person user-icon"></i>
                                <strong>${borrow.student.name}</strong>
                            </td>
                            <td class="student-info">
                                    ${borrow.student.user}
                            </td>
                            <td>
                                <i class="bi bi-book book-icon"></i>
                                <strong>${borrow.book.name}</strong>
                            </td>
                                <%-- 格式化日期 --%>
                            <td class="student-info">
                                <fmt:formatDate value="${borrow.request_date}" pattern="yyyy-MM-dd HH:mm"/>
                            </td>
                            <td>
                                <div class="action-buttons">
                                        <%-- (功能1) 批准和拒绝链接 --%>
                                    <a href="${pageContext.request.contextPath}/borrowAdminServlet.do?action=approve&borrow_id=${borrow.id}"
                                       class="btn btn-success btn-sm approve-btn"
                                       onclick="return confirmApprove('${borrow.student.name}', '${borrow.book.name}')">
                                        <i class="bi bi-check-lg"></i> 批准
                                    </a>
                                    <a href="${pageContext.request.contextPath}/borrowAdminServlet.do?action=deny&borrow_id=${borrow.id}"
                                       class="btn btn-danger btn-sm deny-btn"
                                       onclick="return confirmDeny('${borrow.student.name}', '${borrow.book.name}')">
                                        <i class="bi bi-x-lg"></i> 拒绝
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <%-- 如果列表为空 --%>
                <c:otherwise>
                    <tr>
                        <td colspan="5">
                            <div class="empty-state">
                                <i class="bi bi-inbox"></i>
                                <h4>暂无待审批申请</h4>
                                <p>当前没有待审批的借阅申请。</p>
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
    function confirmApprove(studentName, bookName) {
        return confirm('确定批准学生 "' + studentName + '" 借阅《' + bookName + '》的申请吗？');
    }

    function confirmDeny(studentName, bookName) {
        return confirm('确定拒绝学生 "' + studentName + '" 借阅《' + bookName + '》的申请吗？');
    }
</script>
</body>
</html>