<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.products.Product" %>
<%@ page import="com.example.products.Category" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Products</title>

        <style>
            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background: #f4f7fb;
                color: #1f2937;
            }

            .container {
                width: 90%;
                max-width: 1100px;
                margin: 40px auto;
            }

            h1 {
                color: #4f46e5;
                margin-bottom: 30px;
            }

            .nav-link {
                color: #4f46e5;
                text-decoration: none;
                font-weight: bold;
                margin-right: 20px;
            }

            .nav-link:hover {
                text-decoration: underline;
            }

            .filter-section {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
                margin-bottom: 20px;
            }

            .pagination {
                display: flex;
                gap: 10px;
                margin-top: 20px;
                justify-content: center;
            }

            .pagination button {
                background: #6366f1;
            }

            .pagination button:hover {
                background: #4f46e5;
            }

            .pagination button:disabled {
                background: #d1d5db;
                cursor: not-allowed;
            }

            .pagination-info {
                text-align: center;
                margin-top: 10px;
                color: #6b7280;
            }

            h2 {
                color: #374151;
                margin-bottom: 15px;
            }

            .card {
                background: white;
                padding: 25px;
                margin-bottom: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            }

            .add-form {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            input {
                padding: 10px 12px;
                border: 1px solid #d1d5db;
                border-radius: 8px;
                font-size: 14px;
            }

            input:focus {
                outline: none;
                border-color: #6366f1;
                box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
            }

            button {
                border: none;
                border-radius: 8px;
                padding: 10px 16px;
                color: white;
                cursor: pointer;
                font-weight: bold;
            }

            .add-btn {
                background: #4f46e5;
            }

            .add-btn:hover {
                background: #4338ca;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                overflow: hidden;
                border-radius: 10px;
            }

            th {
                background: #4f46e5;
                color: white;
                padding: 14px;
                text-align: left;
            }

            td {
                padding: 14px;
                border-bottom: 1px solid #e5e7eb;
            }

            tr:nth-child(even) {
                background: #f9fafb;
            }

            tr:hover {
                background: #eef2ff;
            }

            .actions {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }

            .update-btn {
                background: #f59e0b;
            }

            .update-btn:hover {
                background: #d97706;
            }

            .delete-btn {
                background: #ef4444;
            }

            .delete-btn:hover {
                background: #dc2626;
            }

            .price {
                font-weight: bold;
                color: #059669;
            }

            .empty {
                text-align: center;
                padding: 25px;
                color: #6b7280;
            }
        </style>
    </head>

    <body>

        <div class="container">

            <h1>Product Management</h1>

            <div style="margin-bottom: 20px;">
                <a href="${pageContext.request.contextPath}/categories" class="nav-link">Manage Categories</a>
            </div>

            <div class="card">
                <h2>Add Product</h2>

                <form method="post" action="${pageContext.request.contextPath}/products" class="add-form">

                    <input type="number" name="id" placeholder="ID" required>

                    <input type="text" name="name" placeholder="Product name" required>

                    <input type="text" name="description" placeholder="Description">

                    <input type="number" name="price" placeholder="Price" step="0.01" required>

                    <select name="categoryId">
                        <option value="">No Category</option>
                        <%
                    List<Category> categories = (List<Category>) request.getAttribute("categories");
                    if (categories != null) {
                        for (Category category : categories) {
            %>
                        <option value="<%= category.getId() %>"><%= category.getName() %></option>
                        <%
                        }
                    }
            %>
                    </select>

                    <button type="submit" class="add-btn">
                        + Add Product
                    </button>

                </form>
            </div>

            <div class="card">
                <h2>Filter & Search</h2>

                <form method="get" action="${pageContext.request.contextPath}/products" class="filter-section">

                    <input type="text" name="search" placeholder="Search products..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">

                    <select name="category">
                        <option value="">All Categories</option>
                        <%
                    if (categories != null) {
                        for (Category category : categories) {
                            String selected = request.getParameter("category") != null && request.getParameter("category").equals(String.valueOf(category.getId())) ? "selected" : "";
            %>
                        <option value="<%= category.getId() %>" <%= selected %>><%= category.getName() %></option>
                        <%
                        }
                    }
            %>
                    </select>

                    <input type="number" name="minPrice" placeholder="Min Price" step="0.01" value="<%= request.getParameter("minPrice") != null ? request.getParameter("minPrice") : "" %>">

                    <input type="number" name="maxPrice" placeholder="Max Price" step="0.01" value="<%= request.getParameter("maxPrice") != null ? request.getParameter("maxPrice") : "" %>">

                    <select name="sort">
                        <option value="">Sort By</option>
                        <option value="name" <%= "name".equals(request.getParameter("sort")) ? "selected" : "" %>>Name</option>
                        <option value="price" <%= "price".equals(request.getParameter("sort")) ? "selected" : "" %>>Price</option>
                        <option value="id" <%= "id".equals(request.getParameter("sort")) ? "selected" : "" %>>ID</option>
                    </select>

                    <select name="order">
                        <option value="">Order</option>
                        <option value="asc" <%= "asc".equals(request.getParameter("order")) ? "selected" : "" %>>Ascending</option>
                        <option value="desc" <%= "desc".equals(request.getParameter("order")) ? "selected" : "" %>>Descending</option>
                    </select>

                    <button type="submit" class="add-btn">
                        Filter
                    </button>

                    <a href="${pageContext.request.contextPath}/products" class="nav-link">Clear Filters</a>

                </form>
            </div>


            <div class="card">

                <h2>Products</h2>

                <table>

                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Actions</th>
                        </tr>
                    </thead>

                    <tbody>

                        <%
                List<Product> products =
                        (List<Product>) request.getAttribute("products");

                if (products != null && !products.isEmpty()) {

                    for (Product product : products) {
            %>

                        <tr>

                            <td>
                                <%= product.getId() %>
                            </td>

                            <td>
                                <%= product.getName() %>
                            </td>

                            <td>
                                <%= product.getDescription() != null ? product.getDescription() : "" %>
                            </td>

                            <td>
                                <%
                    if (product.getCategoryId() != null && categories != null) {
                        for (Category category : categories) {
                            if (category.getId().equals(product.getCategoryId())) {
            %>
                                <%= category.getName() %>
                                <%
                            break;
                            }
                        }
                    } else {
            %>
                                -
                                <%
                    }
            %>
                            </td>

                            <td class="price">
                                $<%= product.getPrice() %>
                            </td>

                            <td>

                                <div class="actions">

                                    <a href="<%= request.getContextPath() %>/products/<%= product.getId() %>" class="nav-link">View</a>

                                    <form method="post" action="<%= request.getContextPath() %>/products">

                                        <input type="hidden" name="action" value="update">

                                        <input type="hidden" name="id" value="<%= product.getId() %>">

                                        <input type="text" name="name" value="<%= product.getName() %>" required>

                                        <input type="text" name="description" value="<%= product.getDescription() != null ? product.getDescription() : "" %>">

                                        <input type="number" name="price" value="<%= product.getPrice() %>" step="0.01" required>

                                        <select name="categoryId">
                                            <option value="">No Category</option>
                                            <%
                                            if (categories != null) {
                                                for (Category category : categories) {
                                                    String selected = product.getCategoryId() != null && product.getCategoryId().equals(category.getId()) ? "selected" : "";
            %>
                                            <option value="<%= category.getId() %>" <%= selected %>><%= category.getName() %></option>
                                            <%
                                                }
                                            }
            %>
                                        </select>

                                        <button type="submit" class="update-btn">
                                            Update
                                        </button>

                                    </form>


                                    <form method="post" action="<%= request.getContextPath() %>/products">

                                        <input type="hidden" name="action" value="delete">

                                        <input type="hidden" name="id" value="<%= product.getId() %>">

                                        <button type="submit" class="delete-btn">
                                            Delete
                                        </button>

                                    </form>

                                </div>

                            </td>

                        </tr>

                        <%
                    }

                } else {
            %>

                        <tr>
                            <td colspan="6" class="empty">
                                No products available.
                            </td>
                        </tr>

                        <%
                }
            %>

                    </tbody>

                </table>

                <%
                Integer currentPage = (Integer) request.getAttribute("currentPage");
                Integer totalPages = (Integer) request.getAttribute("totalPages");
                Integer totalProducts = (Integer) request.getAttribute("totalProducts");
                Integer pageSize = (Integer) request.getAttribute("pageSize");

                if (currentPage != null && totalPages != null && totalPages > 1) {
            %>

                <div class="pagination-info">
                    Showing <%= totalProducts %> products (Page <%= currentPage %> of <%= totalPages %>)
                </div>

                <div class="pagination">
                    <%
                    String currentParams = request.getQueryString();
                    String baseUrl = request.getContextPath() + "/products?";
                    if (currentParams != null && !currentParams.isEmpty()) {
                        baseUrl += currentParams;
                    }

                    if (currentPage > 1) {
            %>
                    <a href="<%= baseUrl.replace("page=" + currentPage, "page=" + (currentPage - 1)) %>" class="nav-link">Previous</a>
                    <%
                    }

                    for (int i = 1; i <= totalPages; i++) {
                        String pageClass = i == currentPage ? "nav-link" : "nav-link";
            %>
                    <a href="<%= baseUrl.replace("page=" + currentPage, "page=" + i) %>" class="<%= pageClass %>"><%= i %></a>
                    <%
                    }

                    if (currentPage < totalPages) {
            %>
                    <a href="<%= baseUrl.replace("page=" + currentPage, "page=" + (currentPage + 1)) %>" class="nav-link">Next</a>
                    <%
                    }
            %>
                </div>

                <%
                }
            %>

            </div>

        </div>

    </body>

</html>