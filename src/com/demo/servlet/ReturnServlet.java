package com.demo.servlet;


import com.demo.dao.BookDAO;
import com.demo.dao.BorrowDAO;
import com.demo.dao.StudentDAO;
import com.demo.javabean.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(urlPatterns = "/returnServlet")
public class ReturnServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false); // false表示不创建新session
		if (session == null || session.getAttribute("s_user") == null) {
			// 如果未登录 (session不存在 或 s_user不存在)
			response.getWriter().println("<script>alert('您尚未登录，请先登录！');" +
					"window.location.href='" + request.getContextPath() + "/login.jsp';" +
					"</script>");
			return; // 必须 return，停止后续代码执行
		}
			int s_id = Integer.parseInt(request.getParameter("s_id"));
			int b_id = Integer.parseInt(request.getParameter("b_id"));
			StudentDAO s_dao = new StudentDAO();
			BookDAO b_dao = new BookDAO();
			BorrowDAO bo_dao = new BorrowDAO();
			Students student = null;
			Books book = null;
			Borrows borrow = null;
			try {
				student = s_dao.getStudentById(s_id);
				book = b_dao.getBookById(b_id);
				borrow = bo_dao.getBorrowById(s_id,b_id);

				student.setAmount(student.getAmount() - 1);
				book.setAmount(book.getAmount() + 1);
				if(borrow.getAmount() - 1 == 0){
					bo_dao.deleteBorrow(borrow);
					response.getWriter().println("<script>" +
							"alert('归还图书成功!!!');" +
							"window.location.href=\"user/my_borrow.jsp\";" +
							"</script>");
				}else{
					borrow.setAmount(borrow.getAmount()-1);
				}
				if(s_dao.updateStudent(student) && b_dao.updateBook(book) && bo_dao.updateBorrow(borrow)){
					response.getWriter().println("<script>" +
							"alert('归还图书成功!!!');" +
							"window.location.href=\"user/my_borrow.jsp\";" +
							"</script>");
				}else{
					response.getWriter().println("<script>" +
							"alert('归还图书失败!!!');" +
							"window.location.href=\"user/my_borrow.jsp\";" +
							"</script>");
				}
			}catch (Exception e){

			}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request,response);
	}
}
