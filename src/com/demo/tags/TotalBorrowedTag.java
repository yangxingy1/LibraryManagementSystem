package com.demo.tags;

import com.demo.dao.BorrowDAO;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;

/**
 * 标签 1: 显示总共已借出的书籍数量
 */
public class TotalBorrowedTag extends SimpleTagSupport {

    @Override
    public void doTag() throws JspException, IOException {
        BorrowDAO dao = new BorrowDAO();
        JspWriter out = getJspContext().getOut();
        try {
            int count = dao.getTotalApprovedCount();
            out.print(count); // 直接将数字输出到页面
        } catch (Exception e) {
            e.printStackTrace();
            out.print("Error"); // 出错时显示
        }
    }
}