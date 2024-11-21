﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductDetails.aspx.cs" Inherits="GroceryApp.ProductDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form-container shadow-lg">
        <div class="m-4">
            <center>
                <h3 id="form-header" class="mb-3">Add new Product</h3>
            </center>
            <div class="form-group">
                <label class="mb-1" for="name">Name</label>
                <input type="text" class="form-control" id="name" required>
                <div class="invalid-feedback">
                    Please enter a valid product name.
                </div>
            </div>
            <div class="form-group">
                <label class="mb-1" for="price">Price</label>
                <input type="number" class="form-control" id="price" min="1" required minlength="6">
                <div class="invalid-feedback">
                    Price should be in positive.
                </div>
            </div>
            <div class="form-group">
                <label class="mb-1" for="stock">Stock</label>
                <input type="number" class="form-control" id="stock" min="1" required minlength="6">
                <div class="invalid-feedback">
                    Stock should be in positive.
                </div>
            </div>
            <div class="form-group">
                <label class="mb-1" for="imageUrl">ImageUrl</label>
                <input type="url" class="form-control" id="imageUrl" required>
                <div class="invalid-feedback">
                    ImageUrl should be valid.
                </div>
            </div>
            <div class="container">
                <div class="row mt-4">
                    <button type="button" class="btn btn-primary form-btn" onclick="onSubmit()">
                        Add
                        <span class="spinner-border-sm" role="status" aria-hidden="true"></span>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <style>
    div.form-container {
        width: 400px;
    }
    </style>
    <script>
        function setProduct(id) {
            const endpoint = `products/${id}`;
            const onOk = function (response) {
                const product = response.data;
                $("#name")[0].value = product.name;
                $("#price")[0].value = product.price;
                $("#stock")[0].value = product.stock;
                $("#imageUrl")[0].value = product.imageUrl;
            };
            const onError = function () { };
            send(HttpMethod.GET, endpoint, null, onOk, onError);
        }

        function onSubmit() {
            $(".needs-validation")[0].classList.add("was-validated");
            if ($("input:invalid").length > 0) {
                return;
            }
            var queryParameters = new URLSearchParams(window.location.search);
            const isEditMode = queryParameters.has("mode") && queryParameters.get("mode").toUpperCase() == "EDIT";
            toggleForm(true);
            const endpoint = `products${isEditMode ? '/' + queryParameters.get("productId").toString() : ''}`;
            const data = {
                name: $("#name")[0].value,
                price: parseInt($("#price")[0].value),
                stock: parseInt($("#stock")[0].value),
                imageUrl: $("#imageUrl")[0].value
            };

            const onOk = function (response) {
                setTimeout(() => {
                    $(".toast")[0].classList.remove("bg-danger");
                    $(".toast")[0].classList.add("show", "bg-success");
                    $(".toast-body")[0].innerText = `Product ${isEditMode ? 'updated' : 'added'} successfully.`;
                    $(".needs-validation")[0].classList.remove('was-validated');
                    if (!isEditMode) {
                        $(".needs-validation")[0].reset();
                    }
                    toggleForm(false);
                }, 5000);
            };
            const onError = function () {
                toggleForm(false);
                $(".toast")[0].classList.add('show');
            };
            send(isEditMode ? HttpMethod.PATCH : HttpMethod.POST, endpoint, isEditMode ? JSON.stringify(data) : data, onOk, onError);
        }
    </script>
</asp:Content>
