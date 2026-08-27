<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.products.Category" %>
<%@ page import="com.example.products.Product" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Category Details</title>

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

            .card {
                background: white;
                padding: 25px;
                margin-bottom: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            }

            .detail-row {
                margin-bottom: 15px;
            }

            .detail-label {
                font-weight: bold;
                color: #374151;
                margin-bottom: 5px;
            }

            .detail-value {
                color: #6b7280;
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

            .empty {
                text-align: center;
                padding: 25px;
                color: #6b7280;
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

            .price {
                font-weight: bold;
                color: #059669;
            }
        </style>
    </head>

    <body>

        <div class="container">

            <h1>Category Details</h1>

            <div style="margin-bottom: 20px;">
                <a href="${pageContext.request.contextPath}/categories" class="nav-link">← Back to Categories</a>
            </div>

            <%
                Category category = (Category) request.getAttribute("category");

                if (category != null) {
            %>

            <div class="card">

                <div class="detail-row">
                    <div class="detail-label">ID:</div>
                    <div class="detail-value"><%= category.getId() %></div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Name:</div>
                    <div class="detail-value"><%= category.getName() %></div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Description:</div>
                    <div class="detail-value"><%= category.getDescription() != null ? category.getDescription() : "No description" %></div>
                </div>

            </div>

            <%
                } else {
            %>

            <div class="card">
                <div class="empty">Category not found.</div>
            </div>

            <%
                }
            %>

            <%
                List<Product> categoryProducts = (List<Product>) request.getAttribute("categoryProducts");
                if (categoryProducts != null && !categoryProducts.isEmpty()) {
            %>

            <div class="card">
                <h2>Products in this Category</h2>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Price</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Product product : categoryProducts) {
                        %>
                        <tr>
                            <td><%= product.getId() %></td>
                            <td><%= product.getName() %></td>
                            <td class="price">$<%= product.getPrice() %></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <%
                } else if (category != null) {
            %>

            <div class="card">
                <div class="empty">No products in this category.</div>
            </div>

            <%
                }
            %>

        </div>

    </body>

</html>
