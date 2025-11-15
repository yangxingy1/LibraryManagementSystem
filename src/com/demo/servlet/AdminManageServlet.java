package com.demo.servlet;

import com.demo.dao.AdminDAO;
import com.demo.javabean.Admins;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

public class AdminManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // (LoginFilter 已保护此 Servlet，无需手动检查 "a_user")

        String action = request.getParameter("action");
        if (action == null) {
            action = "myProfile"; // 默认操作
        }

        AdminDAO adminDAO = new AdminDAO();
        HttpSession session = request.getSession(false);
        // 获取当前登录的管理员用户名
        String currentAdminUser = (String) session.getAttribute("a_user");
        PrintWriter out = response.getWriter();

        try {
            switch (action) {
                // (功能 - 查) 显示当前管理员信息
                case "myProfile":
                    Admins currentAdmin = adminDAO.getAdminByUsername(currentAdminUser);
                    request.setAttribute("admin", currentAdmin);
                    request.getRequestDispatcher("admin/my_profile.jsp").forward(request, response);
                    break;

                // (功能 - 改) 显示更新表单
                case "showUpdateForm":
                    Admins adminToUpdate = adminDAO.getAdminByUsername(currentAdminUser);
                    request.setAttribute("admin", adminToUpdate);
                    request.getRequestDispatcher("admin/update_profile.jsp").forward(request, response);
                    break;

                // (功能 - 改) 执行更新 (只能改自己)
                case "doUpdate":
                    Admins updatedAdmin = new Admins();
                    updatedAdmin.setAdmin(currentAdminUser); // 关键：确保只更新自己
                    updatedAdmin.setPassword(request.getParameter("password"));
                    updatedAdmin.setRealname(request.getParameter("realname"));
                    updatedAdmin.setPhone(request.getParameter("phone"));
                    updatedAdmin.setEmail(request.getParameter("email"));
                    updatedAdmin.setAddress(request.getParameter("address"));

                    if (adminDAO.updateAdmin(updatedAdmin)) {
                        out.println("<script>alert('信息更新成功！');" +
                                "window.location.href='adminManageServlet.do?action=myProfile';" + "</script>");
                    } else {
                        out.println("<script>alert('信息更新失败！');" +
                                "window.history.back();" + "</script>");
                    }
                    break;

                // (功能 - 增) 显示添加表单
                case "showAddForm":
                    response.sendRedirect("admin/add_admin.jsp");
                    break;

                // (功能 - 增) 执行添加
                case "doAdd":
                    String newAdminUser = request.getParameter("admin");
                    if (adminDAO.isExist(newAdminUser)) {
                        out.println("<script>alert('添加失败：该管理员用户名已存在！');" +
                                "window.history.back();" + "</script>");
                        return;
                    }
                    Admins newAdmin = new Admins();
                    // 数据库的 ID 字段不是自增的，需要手动提供
                    // 这是一个高风险操作，我们暂时使用随机数或时间戳作为ID
                    // 更好的设计是修改数据库使ID自增
                    newAdmin.setId((int) (System.currentTimeMillis() % 100000)); // 临时解决方案
                    newAdmin.setAdmin(newAdminUser);
                    newAdmin.setPassword(request.getParameter("password"));
                    newAdmin.setRealname(request.getParameter("realname"));
                    newAdmin.setPhone(request.getParameter("phone"));
                    newAdmin.setEmail(request.getParameter("email"));
                    newAdmin.setAddress(request.getParameter("address"));

                    if (adminDAO.addAdmin(newAdmin)) {
                        out.println("<script>alert('新管理员添加成功！');" +
                                "window.location.href='adminManageServlet.do?action=myProfile';" + "</script>");
                    } else {
                        out.println("<script>alert('添加失败！');" +
                                "window.history.back();" + "</script>");
                    }
                    break;

                // (功能 - 删) 显示删除列表
                case "showDeleteList":
                    // (约束：不能删除自己)
                    ArrayList<Admins> otherAdmins = adminDAO.getAllAdminsExceptSelf(currentAdminUser);
                    request.setAttribute("otherAdmins", otherAdmins);
                    request.getRequestDispatcher("admin/delete_admin.jsp").forward(request, response);
                    break;

                // (功能 - 删) 执行删除
                case "doDelete":
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    // (约束：不能删除自己 - DAO层面已保证)
                    if (adminDAO.deleteAdmin(deleteId)) {
                        out.println("<script>alert('删除成功！');" +
                                "window.location.href='adminManageServlet.do?action=showDeleteList';" + "</script>");
                    } else {
                        out.println("<script>alert('删除失败！');" +
                                "window.history.back();" + "</script>");
                    }
                    break;

                default:
                    out.println("无效的操作请求！");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}