package com.example.products;

import java.io.IOException;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/products/*")
public class ProductServlet extends HttpServlet {

    private final ProductService service = new ProductService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        Product product = new Product(1L, "Laptop", 50000);
        service.add(product);

        response.setContentType("application/json");

        ObjectMapper mapper = new ObjectMapper();

        mapper.writeValue(
                response.getWriter(),
                service.getAll()
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

    }

    @Override
    protected void doPut(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

    }

    @Override
    protected void doDelete(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

    }
}
