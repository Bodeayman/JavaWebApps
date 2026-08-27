package com.example.products;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;

@Path("/categories")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CategoryResource {

    @Inject
    CategoryService categoryService;

    @Inject
    ProductService productService;

    @GET
    public Response getAll() {
        List<Category> categories = categoryService.getAll();
        return Response.ok(categories).build();
    }

    @GET
    @Path("/{id}")
    public Response getById(@PathParam("id") Long id) {
        Category category = categoryService.getById(id);
        if (category == null) {
            return Response.status(Response.Status.NOT_FOUND).build();
        }
        return Response.ok(category).build();
    }

    @GET
    @Path("/{id}/products")
    public Response getProductsByCategory(@PathParam("id") Long id) {
        Category category = categoryService.getById(id);
        if (category == null) {
            return Response.status(Response.Status.NOT_FOUND).build();
        }
        List<Product> products = productService.getByCategory(id);
        return Response.ok(products).build();
    }

    @POST
    public Response add(Category category) {
        try {
            Category created = categoryService.add(category);
            return Response
                    .status(Response.Status.CREATED)
                    .entity(created)
                    .build();
        } catch (IllegalArgumentException e) {
            return Response
                    .status(Response.Status.BAD_REQUEST)
                    .entity(e.getMessage())
                    .build();
        }
    }

    @PUT
    @Path("/{id}")
    public Response update(
            @PathParam("id") Long id,
            Category category) {

        try {
            boolean updated = categoryService.update(id, category);

            if (!updated) {
                return Response
                        .status(Response.Status.NOT_FOUND)
                        .build();
            }

            return Response.ok(category).build();
        } catch (IllegalArgumentException e) {
            return Response
                    .status(Response.Status.BAD_REQUEST)
                    .entity(e.getMessage())
                    .build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response delete(@PathParam("id") Long id) {

        boolean deleted = categoryService.delete(id);

        if (!deleted) {
            return Response
                    .status(Response.Status.NOT_FOUND)
                    .build();
        }

        return Response.noContent().build();
    }
}
