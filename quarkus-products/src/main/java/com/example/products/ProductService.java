package com.example.products;

import jakarta.enterprise.context.ApplicationScoped;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@ApplicationScoped
public class ProductService {

    private final List<Product> products = new ArrayList<>();

    public List<Product> getAll() {
        return products;
    }

    public Product getById(Long id) {
        for (Product product : products) {
            if (product.getId().equals(id)) {
                return product;
            }
        }
        return null;
    }

    public List<Product> getByCategory(Long categoryId) {
        return products.stream()
                .filter(p -> p.getCategoryId() != null && p.getCategoryId().equals(categoryId))
                .collect(Collectors.toList());
    }

    public List<Product> search(String query) {
        if (query == null || query.trim().isEmpty()) {
            return products;
        }
        String lowerQuery = query.toLowerCase();
        return products.stream()
                .filter(p -> (p.getName() != null && p.getName().toLowerCase().contains(lowerQuery)) ||
                           (p.getDescription() != null && p.getDescription().toLowerCase().contains(lowerQuery)))
                .collect(Collectors.toList());
    }

    public List<Product> filter(Long categoryId, Double minPrice, Double maxPrice) {
        return products.stream()
                .filter(p -> categoryId == null || p.getCategoryId() != null && p.getCategoryId().equals(categoryId))
                .filter(p -> minPrice == null || p.getPrice() >= minPrice)
                .filter(p -> maxPrice == null || p.getPrice() <= maxPrice)
                .collect(Collectors.toList());
    }

    public List<Product> sort(List<Product> productList, String sortBy, String sortOrder) {
        Comparator<Product> comparator = switch (sortBy) {
            case "price" -> Comparator.comparing(Product::getPrice);
            case "name" -> Comparator.comparing(Product::getName);
            default -> Comparator.comparing(Product::getId);
        };

        if ("desc".equalsIgnoreCase(sortOrder)) {
            comparator = comparator.reversed();
        }

        return productList.stream()
                .sorted(comparator)
                .collect(Collectors.toList());
    }

    public List<Product> paginate(List<Product> productList, int page, int size) {
        if (page < 1) page = 1;
        if (size < 1) size = 10;

        int fromIndex = (page - 1) * size;
        if (fromIndex >= productList.size()) {
            return new ArrayList<>();
        }

        int toIndex = Math.min(fromIndex + size, productList.size());
        return productList.subList(fromIndex, toIndex);
    }

    public Product add(Product product) {
        validateProduct(product);
        products.add(product);
        return product;
    }

    public boolean update(Long id, Product updatedProduct) {
        validateProductForUpdate(updatedProduct, id);
        for (Product product : products) {
            if (product.getId().equals(id)) {
                product.setName(updatedProduct.getName());
                product.setDescription(updatedProduct.getDescription());
                product.setPrice(updatedProduct.getPrice());
                product.setCategoryId(updatedProduct.getCategoryId());
                return true;
            }
        }

        return false;
    }

    public boolean delete(Long id) {
        return products.removeIf(
                product -> product.getId().equals(id)
        );
    }

    private void validateProduct(Product product) {
        if (product.getName() == null || product.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Product name is required");
        }
        if (product.getPrice() < 0) {
            throw new IllegalArgumentException("Price cannot be negative");
        }
        for (Product p : products) {
            if (p.getId().equals(product.getId())) {
                throw new IllegalArgumentException("Product with ID " + product.getId() + " already exists");
            }
        }
    }

    private void validateProductForUpdate(Product product, Long currentId) {
        if (product.getName() == null || product.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Product name is required");
        }
        if (product.getPrice() < 0) {
            throw new IllegalArgumentException("Price cannot be negative");
        }
        for (Product p : products) {
            if (p.getId().equals(product.getId()) && !p.getId().equals(currentId)) {
                throw new IllegalArgumentException("Product with ID " + product.getId() + " already exists");
            }
        }
    }
}
