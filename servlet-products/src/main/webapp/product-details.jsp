<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.products.Product" %>
<%@ page import="com.example.products.Category" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Product Details</title>

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

            .price {
                font-weight: bold;
                color: #059669;
                font-size: 1.2em;
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
        </style>
    </head>

    <body>

        <div class="container">

            <h1>Product Details</h1>

            <div style="margin-bottom: 20px;">
                <a href="${pageContext.request.contextPath}/products" class="nav-link">← Back to Products</a>
            </div>

            <%
                Product product = (Product) request.getAttribute("product");
                List<Category> categories = (List<Category>) request.getAttribute("categories");

                if (product != null) {
            %>

            <div class="card">

                <div class="detail-row">
                    <div class="detail-label">ID:</div>
                    <div class="detail-value"><%= product.getId() %></div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Name:</div>
                    <div class="detail-value"><%= product.getName() %></div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Description:</div>
                    <div class="detail-value"><%= product.getDescription() != null ? product.getDescription() : "No description" %></div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Price:</div>
                    <div class="detail-value price">$<%= product.getPrice() %></div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Category:</div>
                    <div class="detail-value">
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
                                    No category assigned
                        <%
                            }
                        %>
                    </div>
                </div>

            </div>

            <%
                } else {
            %>

            <div class="card">
                <div class="empty">Product not found.</div>
            </div>

            <%
                }
            %>

        </div>

    </body>

</html>
