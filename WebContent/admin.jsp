<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Calendar" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>图书馆管理系统 - 管理员</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <!-- 原有CSS -->
    <link rel="stylesheet" href="css/head02.css">
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="css/style.css">

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .sidebar {
            background: linear-gradient(180deg, #2c3e50 0%, #3498db 100%);
            color: white;
            height: 100vh;
            position: fixed;
            width: 250px;
            padding-top: 20px;
            box-shadow: 3px 0 10px rgba(0, 0, 0, 0.1);
        }
        .sidebar-header {
            padding: 0 20px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }
        .sidebar-header h3 {
            font-weight: 600;
            font-size: 1.4rem;
        }
        .sidebar ul {
            list-style: none;
            padding-left: 0;
            margin-bottom: 0;
        }
        .sidebar li {
            margin-bottom: 5px;
        }
        .sidebar a {
            display: block;
            color: rgba(255, 255, 255, 0.8);
            padding: 12px 20px;
            text-decoration: none;
            transition: all 0.3s;
            border-radius: 5px;
            margin: 0 10px;
        }
        .sidebar a:hover, .sidebar a.active {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
        }
        .sidebar a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        .main-content {
            margin-left: 250px;
            padding: 20px;
        }
        .header-bar {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }
        .header-bar h1 {
            color: #2c3e50;
            font-weight: 700;
            margin-bottom: 10px;
        }
        .user-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #6c757d;
            font-size: 0.95rem;
        }
        .content-frame {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            height: calc(100vh - 200px);
        }
        .content-frame iframe {
            width: 100%;
            height: 100%;
            border: none;
        }
        .welcome-text {
            color: #3498db;
            font-weight: 500;
        }
        .date-text {
            color: #6c757d;
            font-weight: 400;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }
            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- 侧边栏 -->
        <div class="col-md-3 col-lg-2 d-md-block sidebar">
            <div class="sidebar-header">
                <h3><i class="bi bi-gear-fill"></i> 管理面板</h3>
            </div>
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a href="admin.jsp" class="nav-link active">
                        <i class="bi bi-house-door"></i> 首页
                    </a>
                </li>
                <li class="nav-item">
                    <a href="adminManageServlet.do?action=myProfile" target="showBook" class="nav-link">
                        <i class="bi bi-person-badge"></i> 管理员账号管理
                    </a>
                </li>
                <li class="nav-item">
                    <a href="admin/add_student.jsp" target="showBook" class="nav-link">
                        <i class="bi bi-person-plus"></i> 添加学生
                    </a>
                </li>
                <li class="nav-item">
                    <a href="PageServlet.do?method=showStudent" target="showBook" class="nav-link">
                        <i class="bi bi-people"></i> 查看学生
                    </a>
                </li>
                <li class="nav-item">
                    <a href="PageServlet.do?method=delStudent" target="showBook" class="nav-link">
                        <i class="bi bi-person-dash"></i> 删除学生
                    </a>
                </li>
                <li class="nav-item">
                    <a href="admin/reg_book.jsp" target="showBook" class="nav-link">
                        <i class="bi bi-book"></i> 添加书籍
                    </a>
                </li>
                <li class="nav-item">
                    <a href="PageServlet.do?method=showBook" target="showBook" class="nav-link">
                        <i class="bi bi-book"></i> 查看书籍
                    </a>
                </li>
                <li class="nav-item mt-4">
                    <a href="login.jsp" class="nav-link">
                        <i class="bi bi-box-arrow-right"></i> 切换账号/退出
                    </a>
                </li>
            </ul>
        </div>

        <!-- 主内容区 -->
        <div class="col-md-9 col-lg-10 ml-sm-auto main-content">
            <%
                Calendar cal = Calendar.getInstance();
                SimpleDateFormat format = new SimpleDateFormat("yyyy年-MM月-dd日");
                String currentDate = format.format(cal.getTime());
            %>

            <div class="header-bar">
                <h1><i class="bi bi-book-half"></i> 图书馆管理系统</h1>
                <div class="user-info">
                    <span class="welcome-text">欢迎你，管理员</span>
                    <span class="date-text"><%= currentDate %></span>
                </div>
            </div>

            <div class="content-frame">
                <iframe name="showBook" src="" frameborder="0"></iframe>
            </div>

            <footer class="footer-bar">
                <p>&copy; 2025 图书馆管理系统 (Online Library System). 保留所有权利.</p>
            </footer>

        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>