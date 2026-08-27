package com.example.products;

import java.util.ArrayList;
import java.util.List;

public class CategoryService {

    private final List<Category> categories = new ArrayList<>();

    public List<Category> getAll() {
        return categories;
    }

    public Category getById(Long id) {
        for (Category category : categories) {
            if (category.getId().equals(id)) {
                return category;
            }
        }
        return null;
    }

    public void add(Category category) {
        validateCategory(category);
        categories.add(category);
    }

    public boolean update(Long id, Category updatedCategory) {
        validateCategoryForUpdate(updatedCategory, id);
        for (Category category : categories) {
            if (category.getId().equals(id)) {
                category.setName(updatedCategory.getName());
                category.setDescription(updatedCategory.getDescription());
                return true;
            }
        }
        return false;
    }

    public boolean delete(Long id) {
        return categories.removeIf(category -> category.getId().equals(id));
    }

    private void validateCategory(Category category) {
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Category name is required");
        }
        for (Category c : categories) {
            if (c.getId().equals(category.getId())) {
                throw new IllegalArgumentException("Category with ID " + category.getId() + " already exists");
            }
        }
    }

    private void validateCategoryForUpdate(Category category, Long currentId) {
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Category name is required");
        }
        for (Category c : categories) {
            if (c.getId().equals(category.getId()) && !c.getId().equals(currentId)) {
                throw new IllegalArgumentException("Category with ID " + category.getId() + " already exists");
            }
        }
    }
}
