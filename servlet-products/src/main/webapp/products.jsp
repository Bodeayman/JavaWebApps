<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.products.Product" %>

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

            <div class="card">
                <h2>Add Product</h2>

                <form method="post" action="${pageContext.request.contextPath}/products" class="add-form">

                    <input type="number" name="id" placeholder="ID" required>

                    <input type="text" name="name" placeholder="Product name" required>

                    <input type="number" name="price" placeholder="Price" step="0.01" required>

                    <button type="submit" class="add-btn">
                        + Add Product
                    </button>

                </form>
            </div>


            <div class="card">

                <h2>Products</h2>

                <table>

                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
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

                            <td class="price">
                                $<%= product.getPrice() %>
                            </td>

                            <td>

                                <div class="actions">

                                    <form method="post" action="<%= request.getContextPath() %>/products">

                                        <input type="hidden" name="action" value="update">

                                        <input type="hidden" name="id" value="<%= product.getId() %>">

                                        <input type="text" name="name" value="<%= product.getName() %>" required>

                                        <input type="number" name="price" value="<%= product.getPrice() %>" step="0.01"
                                            required>

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
                            <td colspan="4" class="empty">
                                No products available.
                            </td>
                        </tr>

                        <%
                }
            %>

                    </tbody>

                </table>

            </div>

        </div>

    </body>

</html>