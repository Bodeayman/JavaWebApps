<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.products.Category" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Categories</title>

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

            input, textarea {
                padding: 10px 12px;
                border: 1px solid #d1d5db;
                border-radius: 8px;
                font-size: 14px;
            }

            textarea {
                resize: vertical;
                min-height: 40px;
            }

            input:focus, textarea:focus {
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

            .empty {
                text-align: center;
                padding: 25px;
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
        </style>
    </head>

    <body>

        <div class="container">

            <h1>Category Management</h1>

            <div style="margin-bottom: 20px;">
                <a href="${pageContext.request.contextPath}/products" class="nav-link">← Back to Products</a>
            </div>

            <div class="card">
                <h2>Add Category</h2>

                <form method="post" action="${pageContext.request.contextPath}/categories" class="add-form">

                    <input type="number" name="id" placeholder="ID" required>

                    <input type="text" name="name" placeholder="Category name" required>

                    <input type="text" name="description" placeholder="Description">

                    <button type="submit" class="add-btn">
                        + Add Category
                    </button>

                </form>
            </div>


            <div class="card">

                <h2>Categories</h2>

                <table>

                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Actions</th>
                        </tr>
                    </thead>

                    <tbody>

                        <%
                List<Category> categories =
                        (List<Category>) request.getAttribute("categories");

                if (categories != null && !categories.isEmpty()) {

                    for (Category category : categories) {
            %>

                        <tr>

                            <td>
                                <%= category.getId() %>
                            </td>

                            <td>
                                <%= category.getName() %>
                            </td>

                            <td>
                                <%= category.getDescription() != null ? category.getDescription() : "" %>
                            </td>

                            <td>

                                <div class="actions">

                                    <form method="post" action="<%= request.getContextPath() %>/categories">

                                        <input type="hidden" name="action" value="update">

                                        <input type="hidden" name="id" value="<%= category.getId() %>">

                                        <input type="text" name="name" value="<%= category.getName() %>" required>

                                        <input type="text" name="description" value="<%= category.getDescription() != null ? category.getDescription() : "" %>">

                                        <button type="submit" class="update-btn">
                                            Update
                                        </button>

                                    </form>


                                    <form method="post" action="<%= request.getContextPath() %>/categories">

                                        <input type="hidden" name="action" value="delete">

                                        <input type="hidden" name="id" value="<%= category.getId() %>">

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
                                No categories available.
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
