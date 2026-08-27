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
            body {
                font-family: Arial, sans-serif;
                margin: 40px;
            }

            h1 {
                margin-bottom: 30px;
            }

            form {
                margin-bottom: 30px;
            }

            input {
                padding: 8px;
                margin-right: 8px;
            }

            button {
                padding: 8px 14px;
                cursor: pointer;
            }

            table {
                width: 100%;
                max-width: 800px;
                border-collapse: collapse;
            }

            th,
            td {
                padding: 12px;
                border: 1px solid #ccc;
                text-align: left;
            }

            th {
                background: #f4f4f4;
            }

            .actions {
                display: flex;
                gap: 8px;
            }
        </style>
    </head>

    <body>

        <h1>Products</h1>

        <!-- Add Product -->
        <h2>Add Product</h2>

        <form method="post" action="${pageContext.request.contextPath}/products">

            <input type="number" name="id" placeholder="ID" required>

            <input type="text" name="name" placeholder="Product name" required>

            <input type="number" name="price" placeholder="Price" step="0.01" required>

            <button type="submit">
                Add Product
            </button>

        </form>


        <!-- Product List -->
        <h2>Product List</h2>

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

                    <td>
                        <%= product.getPrice() %>
                    </td>

                    <td>

                        <div class="actions">

                            <!-- Update -->
                            <form method="post" action="<%= request.getContextPath() %>/products">

                                <input type="hidden" name="action" value="update">

                                <input type="hidden" name="id" value="<%= product.getId() %>">

                                <input type="text" name="name" value="<%= product.getName() %>" required>

                                <input type="number" name="price" value="<%= product.getPrice() %>" step="0.01"
                                    required>

                                <button type="submit">
                                    Update
                                </button>

                            </form>


                            <!-- Delete -->
                            <form method="post" action="<%= request.getContextPath() %>/products">

                                <input type="hidden" name="action" value="delete">

                                <input type="hidden" name="id" value="<%= product.getId() %>">

                                <button type="submit">
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
                    <td colspan="4">
                        No products available.
                    </td>
                </tr>

                <%
        }
    %>

            </tbody>

        </table>

    </body>

</html>