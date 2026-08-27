package com.example.products;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/categories/*")
public class CategoryServlet extends HttpServlet {

    private final CategoryService categoryService = new CategoryService();
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            List<Category> categories = categoryService.getAll();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/categories.jsp").forward(request, response);
        } else {
            String[] pathParts = pathInfo.split("/");
            if (pathParts.length == 2) {
                try {
                    Long id = Long.parseLong(pathParts[1]);
                    Category category = categoryService.getById(id);
                    if (category != null) {
                        request.setAttribute("category", category);
                        List<Product> categoryProducts = productService.getByCategory(id);
                        request.setAttribute("categoryProducts", categoryProducts);
                        request.getRequestDispatcher("/category.jsp").forward(request, response);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    }
                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        try {
            switch (action == null ? "" : action) {
                case "update" -> updateCategory(request);
                case "delete" -> deleteCategory(request);
                default -> addCategory(request);
            }

            response.sendRedirect(request.getContextPath() + "/categories");
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number format");
        }
    }

    private void addCategory(HttpServletRequest request) {
        Long id = Long.parseLong(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        Category category = new Category(id, name, description);
        categoryService.add(category);
    }

    private void updateCategory(HttpServletRequest request) {
        Long id = Long.parseLong(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        Category updatedCategory = new Category(id, name, description);
        categoryService.update(id, updatedCategory);
    }

    private void deleteCategory(HttpServletRequest request) {
        Long id = Long.parseLong(request.getParameter("id"));
        categoryService.delete(id);
    }
}
