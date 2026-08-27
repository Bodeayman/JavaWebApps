package com.example.products;

import java.util.ArrayList;
import java.util.List;

public class ProductService {

    private final List<Product> products = new ArrayList<>();

    public List<Product> getAll() {
        return products;
    }

    public void add(Product product) {
        products.add(product);
    }

    public void update(Long id, Product updatedProduct) {
        for (Product product : products) {
            if (product.getId().equals(id)) {
                product.setName(updatedProduct.getName());
                product.setPrice(updatedProduct.getPrice());
                return;
            }
        }
    }

    public void delete(Long id) {
        products.removeIf(product ->
                product.getId().equals(id)
        );
    }
}