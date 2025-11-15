package com.demo.servlet;

import com.demo.dao.AdminDAO;
import com.demo.dao.StudentDAO;
import com.demo.javabean.*;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;

public class UserLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String method = (String) request.getParameter("method");
        if (method == null) {
            PrintWriter out = response.getWriter();
            out.println("invalid request!");
        } else if (method.equals("login")) {
            try {
                Login(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (method.equals("register")) {
            try {
                Register(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // 用户登录
    protected void Login(HttpServletRequest request,
                         HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        String a_user = request.getParameter("user");
        String a_password = request.getParameter("password");

        String rem = request.getParameter("remember");
        HttpSession session = request.getSession();
        StudentDAO a_dao = new StudentDAO();

        if ("".equals(a_user) || "".equals(a_password)) {
            out.println("<script>" +
                    "alert('登录失败，账号或密码不能为空!!!');" +
                    "window.location.href = \"login.jsp\";" +
                    "</script>");
            return;
        } else if (a_dao.isExist(a_user)) {
            // ✅ 新增：提前获取学生对象，用于检查是否被锁定
            Students student = a_dao.getStudentByName(a_user);

            // ✅ 新增：检查账号是否被管理员锁定（is_locked == 1）
            if (student.getIsLocked() == 1) {
                out.println("<script>" +
                        "alert('登录失败，您的账号已被管理员锁定，请联系管理员！');" +
                        "window.location.href = \"login.jsp\";" +
                        "</script>");
                return; // 🔁 修改：提前返回，不再验证密码
            }

            // 🔁 修改：将原 valid() 后的 getStudentByName() 提前，避免重复查询
            // 现在直接使用已获取的 student 对象

            if (a_dao.valid(a_user, a_password)) {
                // ✅ 已获取 student，直接设置 session
                session.setAttribute("student", student);
                session.setAttribute("s_user", a_user);
                session.setAttribute("s_name", student.getName());

                if ("1".equals(rem)) {
                    Cookie namecookie = new Cookie("username", a_user);
                    namecookie.setMaxAge(60 * 60 * 24 * 3);
                    Cookie pwdcookie = new Cookie("password", a_password);
                    pwdcookie.setMaxAge(60 * 60 * 24 * 3);
                    response.addCookie(namecookie);
                    response.addCookie(pwdcookie);
                }
                out.println("<script>" +
                        "alert('登录成功!!!');" +
                        "window.location.href = \"user.jsp\";" +
                        "</script>");
            } else {
                out.println("<script>" +
                        "alert('登录失败，密码错误!!!');" +
                        "window.location.href = \"login.jsp\";" +
                        "</script>");
            }
        } else {
            out.println("<script>" +
                    "alert('登录失败，用户名不存在!!!');" +
                    "window.location.href = \"login.jsp\";" +
                    "</script>");
        }
    }

    // 用户退出
    protected void Logout(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("a_user");
        response.sendRedirect("login.jsp");
    }

    // 用户注册
    protected void Register(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        PrintWriter out = response.getWriter();
        String user = request.getParameter("user");
        String password = request.getParameter("password");
        String repwd = request.getParameter("repwd");
        String name = request.getParameter("name");
        String grade = request.getParameter("grade");
        String classes = request.getParameter("classes");
        String email = request.getParameter("email");

        if ("".equals(user) || "".equals(password) || "".equals(repwd) || !password.equals(repwd) || "".equals(name) || "".equals(grade) || "".equals(classes) || "".equals(email)) {
            out.println("<script>" +
                    "alert('注册失败，信息不全!!!');" +
                    "window.location.href = \"reg.jsp\";" +
                    "</script>");
            return;
        } else {
            Students student = null;
            StudentDAO a_dao = new StudentDAO();
            boolean isExist = a_dao.isExist(user);
            if (isExist) {
                out.println("<script>" +
                        "alert('此学号已注册过，请重试!!!');" +
                        "window.location.href = \"reg.jsp\";" +
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
                // ✅ 新增：默认新注册学生账号未锁定
                student.setIsLocked(0); // 虽然数据库有默认值，但显式设置更安全

                try {
                    if (a_dao.add(student)) {
                        student = a_dao.getStudentByName(student.getUser());
                        request.getSession().setAttribute("student", student);
                        out.println("<script>" +
                                "alert('注册成功，即将跳转到主界面!!!');" +
                                "window.location.href = \"login.jsp\";" +
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
        // req.setCharacterEncoding("utf-8");
        this.doGet(req, resp);
    }
}