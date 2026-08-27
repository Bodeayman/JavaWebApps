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

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = service.getAll();

        // Make products available to the JSP
        request.setAttribute("products", products);

        // Render JSP
        request.getRequestDispatcher("/products.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        switch (action == null ? "" : action) {

            case "update" ->
                updateProduct(request);

            case "delete" ->
                deleteProduct(request);

            default ->
                addProduct(request);
        }

        // Prevent form resubmission and return to product list
        response.sendRedirect(
                request.getContextPath() + "/products"
        );
    }

    private void addProduct(HttpServletRequest request) {

        Long id = Long.parseLong(
                request.getParameter("id")
        );

        String name = request.getParameter("name");

        double price = Double.parseDouble(
                request.getParameter("price")
        );

        Product product = new Product(id, name, price);

        service.add(product);
    }

    private void updateProduct(HttpServletRequest request) {

        Long id = Long.parseLong(
                request.getParameter("id")
        );

        String name = request.getParameter("name");

        double price = Double.parseDouble(
                request.getParameter("price")
        );

        Product updatedProduct
                = new Product(id, name, price);

        service.update(id, updatedProduct);
    }

    private void deleteProduct(HttpServletRequest request) {

        Long id = Long.parseLong(
                request.getParameter("id")
        );

        service.delete(id);
    }
}
