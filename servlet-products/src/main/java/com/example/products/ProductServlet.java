package com.example.products;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/products/*")
public class ProductServlet extends HttpServlet {

    private final ProductService service = new ProductService();
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        List<Product> products = service.getAll();

        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_OK);

        mapper.writeValue(response.getWriter(), products);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        Product product = mapper.readValue(
                request.getReader(),
                Product.class
        );

        service.add(product);

        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_CREATED);

        mapper.writeValue(response.getWriter(), product);
    }

    @Override
    protected void doPut(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        Long id = extractId(request);

        if (id == null) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Product ID is required"
            );
            return;
        }

        Product updatedProduct = mapper.readValue(
                request.getReader(),
                Product.class
        );

        boolean updated = service.update(id, updatedProduct);

        if (!updated) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Product not found"
            );
            return;
        }

        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_OK);

        mapper.writeValue(response.getWriter(), updatedProduct);
    }

    @Override
    protected void doDelete(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        Long id = extractId(request);

        if (id == null) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Product ID is required"
            );
            return;
        }

        boolean deleted = service.delete(id);

        if (!deleted) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Product not found"
            );
            return;
        }

        response.setStatus(HttpServletResponse.SC_NO_CONTENT);
    }

    private Long extractId(HttpServletRequest request) {
        String path = request.getPathInfo();

        if (path == null || path.equals("/")) {
            return null;
        }

        try {
            return Long.parseLong(path.substring(1));
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
