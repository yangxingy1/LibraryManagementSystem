package com.demo.servlet;

import com.demo.dao.AdminDAO;
import com.demo.javabean.Admins;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/manageAdmin")
public class ManageAdminServlet extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("list".equals(action)) {
            listAdmins(request, response);
        } else if ("addForm".equals(action)) {
            showAddForm(request, response);
        } else if ("editForm".equals(action)) {
            showEditForm(request, response);
        } else if ("delete".equals(action)) {
            deleteAdmin(request, response);
        } else {
            listAdmins(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addAdmin(request, response);
        } else if ("edit".equals(action)) {
            editAdmin(request, response);
        } else {
            listAdmins(request, response);
        }
    }

    private void listAdmins(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArrayList<Admins> admins = adminDAO.getAllAdmins();
        request.setAttribute("admins", admins);
        request.getRequestDispatcher("/admin/admin_list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/admin_add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Admins admin = adminDAO.getAdminById(id);
        if (admin != null) {
            request.setAttribute("admin", admin);
            request.getRequestDispatcher("/admin/admin_edit.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "管理员不存在");
        }
    }

    private void addAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String adminName = request.getParameter("admin");
        String password = request.getParameter("password");
        String realname = request.getParameter("realname");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        int isLocked = "on".equals(request.getParameter("isLocked")) ? 1 : 0;

        // 参数验证
        if (adminName == null || adminName.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            response.sendRedirect("manageAdmin?action=addForm");
            return;
        }

        Admins newAdmin = new Admins();
        newAdmin.setAdmin(adminName.trim());
        newAdmin.setPassword(password.trim());
        newAdmin.setRealname(realname != null ? realname.trim() : "");
        newAdmin.setPhone(phone != null ? phone.trim() : "");
        newAdmin.setEmail(email != null ? email.trim() : "");
        newAdmin.setAddress(address != null ? address.trim() : "");
        newAdmin.setIsLocked(isLocked);

        boolean success = adminDAO.addAdmin(newAdmin);
        // ✅ 关键：使用重定向刷新列表
        response.sendRedirect("manageAdmin?action=list");
    }

    private void editAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String adminName = request.getParameter("admin");
        String password = request.getParameter("password");
        String realname = request.getParameter("realname");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        int isLocked = "on".equals(request.getParameter("isLocked")) ? 1 : 0;

        Admins existingAdmin = adminDAO.getAdminById(id);
        if (existingAdmin != null) {
            existingAdmin.setAdmin(adminName.trim());
            // 只有输入新密码才更新
            if (password != null && !password.trim().isEmpty()) {
                existingAdmin.setPassword(password.trim());
            }
            existingAdmin.setRealname(realname != null ? realname.trim() : "");
            existingAdmin.setPhone(phone != null ? phone.trim() : "");
            existingAdmin.setEmail(email != null ? email.trim() : "");
            existingAdmin.setAddress(address != null ? address.trim() : "");
            existingAdmin.setIsLocked(isLocked);

            adminDAO.updateAdmin(existingAdmin);
        }
        // ✅ 关键：使用重定向刷新列表
        response.sendRedirect("manageAdmin?action=list");
    }

    private void deleteAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        adminDAO.deleteAdmin(id);
        // ✅ 关键：使用重定向刷新列表
        response.sendRedirect("manageAdmin?action=list");
    }
}