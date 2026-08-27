package com.example.products;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;

@Path("/products")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ProductResource {

    @Inject
    ProductService service;

    @Inject
    CategoryService categoryService;

    @GET
    public Response getAll(
            @QueryParam("search") String search,
            @QueryParam("category") Long categoryId,
            @QueryParam("minPrice") Double minPrice,
            @QueryParam("maxPrice") Double maxPrice,
            @QueryParam("sort") String sortBy,
            @QueryParam("order") String sortOrder,
            @QueryParam("page") @DefaultValue("1") int page,
            @QueryParam("size") @DefaultValue("10") int size) {

        List<Product> products = service.getAll();

        if (search != null && !search.trim().isEmpty()) {
            products = service.search(search);
        }

        if (categoryId != null || minPrice != null || maxPrice != null) {
            products = service.filter(categoryId, minPrice, maxPrice);
        }

        if (sortBy != null && !sortBy.trim().isEmpty()) {
            products = service.sort(products, sortBy, sortOrder);
        }

        int totalProducts = products.size();
        int totalPages = (int) Math.ceil((double) totalProducts / size);

        products = service.paginate(products, page, size);

        return Response.ok()
                .entity(products)
                .header("X-Total-Count", totalProducts)
                .header("X-Total-Pages", totalPages)
                .header("X-Current-Page", page)
                .header("X-Page-Size", size)
                .build();
    }

    @GET
    @Path("/{id}")
    public Response getById(@PathParam("id") Long id) {
        Product product = service.getById(id);
        if (product == null) {
            return Response.status(Response.Status.NOT_FOUND).build();
        }
        return Response.ok(product).build();
    }

    @POST
    public Response add(Product product) {
        try {
            Product created = service.add(product);
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
            Product product) {

        try {
            boolean updated = service.update(id, product);

            if (!updated) {
                return Response
                        .status(Response.Status.NOT_FOUND)
                        .build();
            }

            return Response.ok(product).build();
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

        boolean deleted = service.delete(id);

        if (!deleted) {
            return Response
                    .status(Response.Status.NOT_FOUND)
                    .build();
        }

        return Response.noContent().build();
    }
}
