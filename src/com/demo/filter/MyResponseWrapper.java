package com.demo.filter;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import java.io.PrintWriter;
import java.io.StringWriter;

/**
 * 这是一个响应包装器.
 * 它的工作是"欺骗"Servlet，让Servlet不把HTML直接写入到浏览器,
 * 而是写入到我们内部的一个StringWriter(字符串缓冲区)中,
 * 以便我们稍后可以获取这些内容并进行修改.
 */
public class MyResponseWrapper extends HttpServletResponseWrapper {

    // 内部缓冲区，用于捕获所有写入的内容
    private StringWriter stringWriter;
    private PrintWriter printWriter;

    public MyResponseWrapper(HttpServletResponse response) {
        super(response);
        // 初始化缓冲区
        stringWriter = new StringWriter();
        printWriter = new PrintWriter(stringWriter);
    }

    /**
     * 【关键】重写 getWriter() 方法.
     * 当Servlet (如JSP) 调用 response.getWriter() 时,
     * 我们不再返回指向浏览器的 writer, 而是返回我们自己的、指向内部缓冲区的 writer.
     */
    @Override
    public PrintWriter getWriter() {
        return printWriter;
    }

    /**
     * (新功能) 允许过滤器获取我们捕获到的所有HTML内容.
     * @return 缓冲区中的完整字符串
     */
    public String getCapturedContent() {
        printWriter.flush(); // 确保所有内容都已写入
        stringWriter.flush();
        return stringWriter.toString();
    }
}