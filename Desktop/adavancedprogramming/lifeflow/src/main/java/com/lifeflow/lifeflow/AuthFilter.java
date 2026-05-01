package com.lifeflow.lifeflow;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        HttpSession session = httpRequest.getSession(false);

        // Pages everyone can access without login
        boolean isPublicPage = uri.contains("/login") ||
                uri.contains("/register") ||
                uri.contains("/index.jsp") ||
                uri.contains("/lifeflow_war_exploded/") && uri.endsWith("/") ||
                uri.contains(".css") ||
                uri.contains(".js") ||
                uri.contains(".png") ||
                uri.contains(".jpg") ||
                uri.contains(".webp") ||
                uri.contains("/images/");

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isPublicPage || isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }

    public void init(FilterConfig filterConfig) throws ServletException {}
    public void destroy() {}
}