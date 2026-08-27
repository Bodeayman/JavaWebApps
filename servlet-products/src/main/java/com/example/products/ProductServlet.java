package com.example.products;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/products/*")
public class ProductServlet extends HttpServlet {

    private final ProductService service = new ProductService();
    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && !pathInfo.equals("/")) {
            String[] pathParts = pathInfo.split("/");
            if (pathParts.length == 2) {
                try {
                    Long id = Long.parseLong(pathParts[1]);
                    Product product = service.getById(id);
                    if (product != null) {
                        request.setAttribute("product", product);
                        request.setAttribute("categories", categoryService.getAll());
                        request.getRequestDispatcher("/product-details.jsp").forward(request, response);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    }
                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            List<Product> products = service.getAll();

            String search = request.getParameter("search");
            String category = request.getParameter("category");
            String minPrice = request.getParameter("minPrice");
            String maxPrice = request.getParameter("maxPrice");
            String sortBy = request.getParameter("sort");
            String sortOrder = request.getParameter("order");
            String pageStr = request.getParameter("page");
            String sizeStr = request.getParameter("size");

            if (search != null && !search.trim().isEmpty()) {
                products = service.search(search);
            }

            Long categoryId = null;
            if (category != null && !category.trim().isEmpty()) {
                try {
                    categoryId = Long.parseLong(category);
                } catch (NumberFormatException ignored) {}
            }

            Double minPriceVal = null;
            if (minPrice != null && !minPrice.trim().isEmpty()) {
                try {
                    minPriceVal = Double.parseDouble(minPrice);
                } catch (NumberFormatException ignored) {}
            }

            Double maxPriceVal = null;
            if (maxPrice != null && !maxPrice.trim().isEmpty()) {
                try {
                    maxPriceVal = Double.parseDouble(maxPrice);
                } catch (NumberFormatException ignored) {}
            }

            if (categoryId != null || minPriceVal != null || maxPriceVal != null) {
                products = service.filter(categoryId, minPriceVal, maxPriceVal);
            }

            if (sortBy != null && !sortBy.trim().isEmpty()) {
                products = service.sort(products, sortBy, sortOrder);
            }

            int page = 1;
            int size = 10;

            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                } catch (NumberFormatException ignored) {}
            }

            if (sizeStr != null && !sizeStr.trim().isEmpty()) {
                try {
                    size = Integer.parseInt(sizeStr);
                } catch (NumberFormatException ignored) {}
            }

            int totalProducts = products.size();
            int totalPages = (int) Math.ceil((double) totalProducts / size);

            products = service.paginate(products, page, size);

            request.setAttribute("products", products);
            request.setAttribute("categories", categoryService.getAll());
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", size);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);

            request.getRequestDispatcher("/products.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        try {
            switch (action == null ? "" : action) {

                case "update" ->
                    updateProduct(request);

                case "delete" ->
                    deleteProduct(request);

                default ->
                    addProduct(request);
            }

            response.sendRedirect(
                    request.getContextPath() + "/products"
            );
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number format");
        }
    }

    private void addProduct(HttpServletRequest request) {

        Long id = Long.parseLong(
                request.getParameter("id")
        );

        String name = request.getParameter("name");
        String description = request.getParameter("description");

        double price = Double.parseDouble(
                request.getParameter("price")
        );

        Long categoryId = null;
        String categoryIdStr = request.getParameter("categoryId");
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Long.parseLong(categoryIdStr);
            } catch (NumberFormatException ignored) {}
        }

        Product product = new Product(id, name, description, price, categoryId);

        service.add(product);
    }

    private void updateProduct(HttpServletRequest request) {

        Long id = Long.parseLong(
                request.getParameter("id")
        );

        String name = request.getParameter("name");
        String description = request.getParameter("description");

        double price = Double.parseDouble(
                request.getParameter("price")
        );

        Long categoryId = null;
        String categoryIdStr = request.getParameter("categoryId");
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Long.parseLong(categoryIdStr);
            } catch (NumberFormatException ignored) {}
        }

        Product updatedProduct
                = new Product(id, name, description, price, categoryId);

        service.update(id, updatedProduct);
    }

    private void deleteProduct(HttpServletRequest request) {

        Long id = Long.parseLong(
                request.getParameter("id")
        );

        service.delete(id);
    }
}
