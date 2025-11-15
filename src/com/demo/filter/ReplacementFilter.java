package com.demo.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ReplacementFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // (不需要初始化)
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        // 1. 创建我们的响应包装器，"包裹"住原始的 response 对象
        MyResponseWrapper wrapper = new MyResponseWrapper((HttpServletResponse) response);

        // 2. 【关键】将 *包装器* 传递给链中的下一个 (即 Servlet 或 JSP)
        // Servlet/JSP 会把HTML写入到我们的 wrapper 中，而不是直接写入 response
        chain.doFilter(request, wrapper);

        // 3. Servlet/JSP 执行完毕后，代码返回到这里.
        // 从包装器中获取JSP生成的原始HTML内容
        String originalContent = wrapper.getCapturedContent();

        // 4. (新功能) 执行我们的业务逻辑：替换关键词
        String modifiedContent = originalContent.replace("图书馆", "西北工业大学图书馆");

        // 5. 最后，获取 *真正* 的 response 对象,
        // 并将我们 *修改后* 的内容写入，发送给浏览器.

        // (重要) 在写回之前，设置正确的响应头，特别是编码和内容长度
        // 我们的 CharacterFilter 应该已经设置了UTF-8，这里我们再次确保
        response.setContentType("text/html;charset=UTF-8");
        // 必须设置新的内容长度，否则浏览器可能会截断内容
        response.setContentLength(modifiedContent.getBytes("UTF-8").length);

        response.getWriter().write(modifiedContent);
    }

    @Override
    public void destroy() {
        // (不需要销毁)
    }
}