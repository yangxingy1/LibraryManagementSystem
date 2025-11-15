<%--
  Created by IntelliJ IDEA.
  User: asus
  Date: 2025/11/15
  Time: 下午2:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>我的所有借阅申请 - 图书馆管理系统</title>
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
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        .status-pending {
            background-color: rgba(255, 193, 7, 0.2);
            color: #856404;
        }
        .status-approved {
            background-color: rgba(40, 167, 69, 0.2);
            color: #155724;
        }
        .status-denied {
            background-color: rgba(220, 53, 69, 0.2);
            color: #721c24;
        }
        .status-returned {
            background-color: rgba(108, 117, 125, 0.2);
            color: #383d41;
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
        .date-info {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .action-badge {
            font-size: 0.8rem;
            padding: 3px 8px;
            border-radius: 4px;
            margin-left: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="page-header">
        <h2><i class="bi bi-file-earmark-text"></i> 我的借阅申请</h2>
        <p class="mb-0">按申请时间排序</p>
    </div>

    <div class="table-container">
        <table class="table table-hover">
            <thead>
            <tr>
                <th width="30%">图书名称</th>
                <th width="20%">申请时间</th>
                <th width="25%">审批/归还时间</th>
                <th width="25%">当前状态</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <%-- (新功能) 遍历 MyBorrowsServlet 传来的 allMyBorrows --%>
                <c:when test="${not empty allMyBorrows}">
                    <c:forEach items="${allMyBorrows}" var="borrow">
                        <tr>
                            <td>
                                <i class="bi bi-book book-icon"></i>
                                <strong>${borrow.book.name}</strong>
                            </td>
                            <td class="date-info">
                                <fmt:formatDate value="${borrow.request_date}" pattern="yyyy-MM-dd HH:mm"/>
                            </td>
                            <td class="date-info">
                                    <%-- 根据状态显示不同的日期 --%>
                                <c:choose>
                                    <c:when test="${borrow.status == 'approved'}">
                                        <fmt:formatDate value="${borrow.approval_date}" pattern="yyyy-MM-dd HH:mm"/>
                                        <span class="badge bg-success action-badge">批准</span>
                                    </c:when>
                                    <c:when test="${borrow.status == 'denied'}">
                                        <fmt:formatDate value="${borrow.approval_date}" pattern="yyyy-MM-dd HH:mm"/>
                                        <span class="badge bg-danger action-badge">拒绝</span>
                                    </c:when>
                                    <c:when test="${borrow.status == 'returned'}">
                                        <fmt:formatDate value="${borrow.return_date}" pattern="yyyy-MM-dd HH:mm"/>
                                        <span class="badge bg-secondary action-badge">归还</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                    <%-- (新功能) 根据状态显示不同样式 --%>
                                <c:choose>
                                    <c:when test="${borrow.status == 'pending'}">
                                                <span class="status-badge status-pending">
                                                    <i class="bi bi-clock"></i> 待审批
                                                </span>
                                    </c:when>
                                    <c:when test="${borrow.status == 'approved'}">
                                                <span class="status-badge status-approved">
                                                    <i class="bi bi-check-circle"></i> 已批准 (已借出)
                                                </span>
                                    </c:when>
                                    <c:when test="${borrow.status == 'denied'}">
                                                <span class="status-badge status-denied">
                                                    <i class="bi bi-x-circle"></i> 已拒绝
                                                </span>
                                    </c:when>
                                    <c:when test="${borrow.status == 'returned'}">
                                                <span class="status-badge status-returned">
                                                    <i class="bi bi-arrow-return-left"></i> 已归还
                                                </span>
                                    </c:when>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <%-- 如果列表为空 --%>
                <c:otherwise>
                    <tr>
                        <td colspan="4">
                            <div class="empty-state">
                                <i class="bi bi-inbox"></i>
                                <h4>暂无借阅申请</h4>
                                <p>您还没有提交过任何借阅申请。</p>
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
</body>
</html>