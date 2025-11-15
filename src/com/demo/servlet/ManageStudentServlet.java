package com.demo.servlet;


import com.demo.dao.StudentDAO;
import com.demo.javabean.*;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
@WebServlet("/manageStudent")

public class ManageStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = (String) request.getParameter("action");
        if (action == null) {
            PrintWriter out = response.getWriter();
            out.println("invalid request!");
        }
        // ✅ 新增：处理锁定操作
        else if (action.equals("lock")) {
            lockStudent(request, response);
        }
        // ✅ 新增：处理解锁操作
        else if (action.equals("unlock")) {
            unlockStudent(request, response);
        }
        // ✅ 新增：处理重置密码操作
        else if (action.equals("resetPass")) {
            resetPassword(request, response);
        }
        // 🔁 保留原有功能
        else if (action.equals("addstudent")) {
            AddStudent(request, response);
        } else if (action.equals("delstudent")) {
            DelStudent(request, response);
        } else if (action.equals("showstudent")) {
            ShowStudent(request, response);
        }
    }

    // ✅ 新增：锁定学生账号
    private void lockStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        StudentDAO dao = new StudentDAO();
        boolean success = dao.updateLockStatus(id, 1); // 1 = 锁定

        // 重定向回学生管理页（你原来的页面路径）
        response.sendRedirect("PageServlet.do?method=showStudent");
    }

    // ✅ 新增：解锁学生账号
    private void unlockStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        StudentDAO dao = new StudentDAO();
        boolean success = dao.updateLockStatus(id, 0); // 0 = 解锁

        response.sendRedirect("PageServlet.do?method=showStudent");
    }

    // ✅ 新增：重置学生密码
    private void resetPassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String newPass = request.getParameter("newPass");
        StudentDAO dao = new StudentDAO();

        if (newPass != null && !newPass.trim().isEmpty()) {
            boolean success = dao.resetPassword(id, newPass);
        }

        response.sendRedirect("PageServlet.do?method=showStudent");
    }

    // 🔁 保留原有 ShowStudent 方法（无需修改）
    private void ShowStudent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("user");
        StudentDAO studao = new StudentDAO();
        Students student = new Students();
        try {
            student = studao.getStudentByName(user);
            request.setAttribute("student", student);
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("admin/show_student.jsp").forward(request, response);
    }

    // 🔁 保留原有 DelStudent 方法（无需修改）
    private void DelStudent(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");
        resp.setCharacterEncoding("utf-8");
        resp.setContentType("text/html;charset=utf-8");
        PrintWriter out = resp.getWriter();
        String user = req.getParameter("user");
        StudentDAO s_dao = new StudentDAO();
        if (user != null) {
            System.out.println(user);
            try {
                if (s_dao.delStudentByName(user)) {
                    out.println("<script>alert('删除成功！');" +
                            "window.location.href=\"PageServlet.do?method=showStudent\";" + "</script>");
                    return;
                } else
                    out.println("<script>alert('删除失败！');" +
                            "window.location.href=\"admin/del_student.jsp\";" + "</script>");
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            out.println("<script>alert('删除失败，无此账号！');" +
                    "window.location.href=\"admin/del_student.jsp\";" + "</script>");
        }
    }

    // 🔁 修改 AddStudent：显式设置 isLocked = 0
    private void AddStudent(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        PrintWriter out = resp.getWriter();
        String user = req.getParameter("user");
        String password = req.getParameter("password");
        String relpwd = req.getParameter("relpwd");
        String name = req.getParameter("name");
        String grade = req.getParameter("grade");
        String classes = req.getParameter("classes");
        String email = req.getParameter("email");
        String admin = req.getParameter("admin");

        if ("".equals(user) || "".equals(password) || "".equals(relpwd) || !password.equals(relpwd)
                || "".equals(name) || "".equals(grade) || "".equals(classes) || "".equals(email)) {
            out.println("<script>alert('添加失败，信息不全!');" +
                    "window.location.href = \"admin/add_student.jsp\";" +
                    "</script>");
            return;
        } else {
            StudentDAO a_dao = new StudentDAO();
            Students student = new Students();
            boolean isExist = a_dao.isExist(user);
            if (isExist) {
                out.println("<script>alert('此学号已注册！');" +
                        "window.location.href = \"admin/add_student.jsp\";" +
                        "</script>");
            } else {
                student = new Students();
                student.setUser(user);
                student.setPassword(password);
                student.setName(name);
                student.setGrade(grade);
                student.setClasses(classes);
                student.setEmail(email);
                student.setAmount(0);
                // ✅ 新增：显式设置 isLocked = 0（确保新账号未锁定）
                student.setIsLocked(0);

                try {
                    if (a_dao.add(student)) {
                        student = a_dao.getStudentByName(student.getUser());
                        req.getSession().setAttribute("student", student);
                        out.println("<script>alert('添加成功！');" +
                                "window.location.href = \"admin/add_student.jsp\";" +
                                "</script>");
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}