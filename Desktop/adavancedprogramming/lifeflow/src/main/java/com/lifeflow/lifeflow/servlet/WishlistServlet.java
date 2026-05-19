package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.dao.WishlistDAO;
import com.lifeflow.lifeflow.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/addWishlist", "/removeWishlist"})
public class WishlistServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = currentUser.getUserId();
        int campId = Integer.parseInt(request.getParameter("campId"));
        WishlistDAO wishlistDAO = new WishlistDAO();
        String path = request.getServletPath();

        if ("/addWishlist".equals(path)) {
            if (!wishlistDAO.isWishlisted(userId, campId)) {
                wishlistDAO.addToWishlist(userId, campId);
                // FIX: Use "successMessage" key to match donationCamp.jsp
                request.getSession().setAttribute("successMessage", "Camp added to your wishlist!");
            } else {
                // FIX: Use "errorMessage" key to match donationCamp.jsp
                request.getSession().setAttribute("errorMessage", "Camp is already in your wishlist!");
            }
            // FIX: Redirect back to donationCamp.jsp instead of searchBlood.jsp
            response.sendRedirect(request.getContextPath() + "/donationCamp.jsp");
        } else {
            wishlistDAO.removeFromWishlist(userId, campId);
            response.sendRedirect(request.getContextPath() + "/wishlist.jsp");
        }
    }
}
