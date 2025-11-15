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
    <title>我的所有借阅申请</title>
    <style>
        /* (您可以复用您项目中的 list.css 或 my_borrow.jsp 的样式) */
        body { font-family: Arial, sans-serif; }
        h2 { margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        tr:hover { background-color: #ddd; }
        .empty-list { color: #888; font-style: italic; }

        /* (新功能) 状态样式 */
        .status-pending { color: #FFA500; font-weight: bold; } /* 橙色 - 待审批 */
        .status-approved { color: #28a745; font-weight: bold; } /* 绿色 - 已批准 */
        .status-denied { color: #dc3545; font-weight: bold; }  /* 红色 - 已拒绝 */
        .status-returned { color: #6c757d; } /* 灰色 - 已归还 */
    </style>
</head>
<body>
<h2>我的借阅申请 (按申请时间排序)</h2>

<table>
    <tr>
        <th>图书名称</th>
        <th>申请时间</th>
        <th>审批/归还时间</th>
        <th>当前状态</th>
    </tr>

    <c:choose>
        <%-- (新功能) 遍历 MyBorrowsServlet 传来的 allMyBorrows --%>
        <c:when test="${not empty allMyBorrows}">
            <c:forEach items="${allMyBorrows}" var="borrow">
                <tr>
                    <td>
                            <%-- (BorrowDAO中已帮我们获取了关联的 Book 对象) --%>
                            ${borrow.book.name}
                    </td>
                    <td>
                        <fmt:formatDate value="${borrow.request_date}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                    <td>
                            <%-- 根据状态显示不同的日期 --%>
                        <c:choose>
                            <c:when test="${borrow.status == 'approved'}">
                                <fmt:formatDate value="${borrow.approval_date}" pattern="yyyy-MM-dd HH:mm"/> (批准)
                            </c:when>
                            <c:when test="${borrow.status == 'denied'}">
                                <fmt:formatDate value="${borrow.approval_date}" pattern="yyyy-MM-dd HH:mm"/> (拒绝)
                            </c:when>
                            <c:when test="${borrow.status == 'returned'}">
                                <fmt:formatDate value="${borrow.return_date}" pattern="yyyy-MM-dd HH:mm"/> (归还)
                            </c:when>
                        </c:choose>
                    </td>

                        <%-- (新功能) 根据状态显示不同样式 --%>
                    <td>
                        <c:choose>
                            <c:when test="${borrow.status == 'pending'}">
                                <span class="status-pending">待审批</span>
                            </c:when>
                            <c:when test="${borrow.status == 'approved'}">
                                <span class="status-approved">已批准 (已借出)</span>
                            </c:when>
                            <c:when test="${borrow.status == 'denied'}">
                                <span class="status-denied">已拒绝</span>
                            </c:when>
                            <c:when test="${borrow.status == 'returned'}">
                                <span class="status-returned">已归还</span>
                            </c:when>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </c:when>
        <%-- 如果列表为空 --%>
        <c:otherwise>
            <tr>
                <td colspan="4" class="empty-list">您还没有提交过任何借阅申请。</td>
            </tr>
        </c:otherwise>
    </c:choose>

</table>
</body>
</html>