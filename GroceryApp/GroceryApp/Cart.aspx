<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="GroceryApp.Cart" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="empty-cart" class="hide-container form-container">
        <div class="container">
            <div class="row mt-3">
                <div class="col-2">
                    <img class="ms-2" src="./Assets/empty-cart.png" height="45" width="45" />
                </div>
                <div class="col-10 mt-2">
                    <p class="ms-4 ps-2" style="font-size: 20px;">Cart is empty</p>
                </div>
            </div>
        </div>
    </div>
    <div id="existing-cart" class="container hide-container mx-0">
        <div class="row justify-content-between">
            <div id="cart-container" class="col-9 p-0 border border-black bg-white">
                <div class="row px-4 pt-4 pb-2">
                    <div class="col">
                        <h3>Cart Details</h3>
                    </div>
                    <div class="col text-end">
                        <buton class="btn btn-danger rounded-pill" onclick="emptyCart()">Empty Cart</buton>
                    </div>
                </div>
                <div class="row ps-4">
                    <p id="deliver-to"></p>
                </div>
                <div class="row ps-4">
                    <p id="delivery-address"></p>
                </div>
                <div class="mx-4 overflow-y-scroll border" style="height: calc(100vh - 254px);">
                    <div id="products-under-cart" class="m-3">

                    </div>
                </div>
            </div>
            <div id="payment-container" class="col-3 border border-black bg-white px-0">
                <div class="m-4">
                    <h3 class="mb-4">Payment Details</h3>
                    <div class="container">
                        <div class="row">
                            <div class="col text-start px-0">
                                <p id="cart-item-count"></p>
                            </div>
                            <div class="col text-end px-0">
                                <p class="total-amount"></p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col text-start px-0">
                                <p>Delivery Fee</p>
                            </div>
                            <div class="col text-end px-0">
                                <p>Free</p>
                            </div>
                        </div>
                        <div class="row">
                            <hr />
                        </div>
                        <div class="row">
                            <div class="col text-start px-0">
                                <p>Total Amount</p>
                            </div>
                            <div class="col text-end px-0">
                                <p class="fw-bold total-amount"></p>
                            </div>
                        </div>
                        <div class="row mt-1">
                            <label for="payment-mode" class="px-0 mb-1">Payment Mode</label>
                            <select id="payment-mode" class="form-select" required>
                                <option value="" selected>Select a payment mode</option>
                                <option value="1">Cash On Delivery</option>
                                <option value="2">UPI</option>
                                <option value="3">Credit Card</option>
                                <option value="4">NEFT</option>
                                <option value="5">Wallet</option>
                            </select>
                            <div class="invalid-feedback px-0">
                                Please select a payment mode.
                            </div>
                        </div>
                        <div class="row mt-4">
                            <div class="col text-end px-0">
                                <button type="button" class="btn btn-primary rounded-pill" onclick="placeOrder()">Place Order</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <style>
        #cart-container {
            height: calc(100vh - 83px);
        }

        .hide-container {
            display: none;
        }

        .show-container {
            display: block;
        }

        #delivery-address {
            margin-top: -8px;
        }

        #empty-cart {
            height: 80px;
            width: 240px;
        }

        #existing-cart {
            max-width: 100%;
        }

        #payment-container {
            height: max-content;
            width: 24%;
        }
    </style>
    <script>
        let productDetails = [];
        let totalAmount;

        function emptyCart(redirect = false) {
            const endpoint = `users/${userId}/carts/${cartId}`;
            const onOk = function () {
                if (redirect) {
                    window.location.href = "Welcome";
                }
                else {
                    cartId = null;
                    productsUnderCart = [];
                    updateCartBadge();
                    isCartEmpty();
                }
            };
            const onError = function () { };
            send(HttpMethod.DELETE, endpoint, null, onOk, onError);
        }

        function isCartEmpty() {
            const emptyCart = $("#empty-cart")[0];
            const existingCart = $("#existing-cart")[0];
            if (productsUnderCart.length > 0) {
                emptyCart.classList.remove("show-container");
                emptyCart.classList.add("hide-container");
                existingCart.classList.add("show-container");
                existingCart.classList.remove("hide-container");
                $("#deliver-to")[0].innerText = `Deliver To: ${currentUser.firstName} ${currentUser.lastName}`;
                $("#delivery-address")[0].innerText = `Address: ${currentUser.address}`;
                const endpoint = `products?productIds=${productsUnderCart.join(",")}`;
                const onOk = function (response) {
                    productDetails = response.data;
                    showPaymentDetails();
                    const parser = new DOMParser();
                    const root = $("#products-under-cart")[0];
                    productsUnderCart.forEach(id => {
                        const product = productDetails.find(x => x.id == id);
                        const component = parser.parseFromString(`<div id="product-under-cart-${id}" class="container mb-3 border" style="border-radius: 10px; background-color: #f2f3f5;">
                                                                      <div class="row p-2">
                                                                          <div class="col-3 px-0">
                                                                              <div class="border border-1" style="background-image: url('${product.imageUrl}'); height: 130px; width: 130px; background-size: cover;"></div>
                                                                          </div>
                                                                          <div class="col-9 px-0" style="margin-left: -70px;">
                                                                            <div class="row" style="font-size: 17px; margin-top: 10px;">
                                                                                <p class="px-0">${product.name}</p>
                                                                            </div>
                                                                            <div class="row" style="font-size: 17px; margin-top: -3px;">
                                                                                <p class="px-0">Price - ${product.price}</p>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col px-0">
                                                                                    <button type="button" class="btn btn-danger btn-sm rounded-pill mt-0" onclick="modifyCart({id: ${product.id}, price: ${product.price}})">Remove</button>
                                                                                </div>
                                                                            </div>
                                                                          </div>
                                                                      </div>
                                                                  </div>`, 'text/html');
                        const node = component.getElementById(`product-under-cart-${id}`);
                        root.append(node);
                    });
                };
                const onError = function () { };
                send(HttpMethod.GET, endpoint, null, onOk, onError);
            }
            else {
                emptyCart.classList.remove("hide-container");
                emptyCart.classList.add("show-container");
                existingCart.classList.add("hide-container");
                existingCart.classList.remove("show-container");
            }
        }

        function showPaymentDetails() {
            totalAmount = 0;
            productsUnderCart.forEach(id => { totalAmount += productDetails.find(p => p.id == id).price; });
            $("#cart-item-count")[0].innerText = `Price (${productsUnderCart.length} ${productsUnderCart.length == 1 ? 'item' : 'items'})`;
            $(".total-amount")[0].innerText = totalAmount;
            $(".total-amount")[1].innerText = totalAmount;
        }

        function placeOrder() {
            $("form")[0].classList.add("needs-validation", "was-validated");
            if ($("select:invalid").length > 0) {
                return;
            }
            const endpoint = `users/${userId}/orders/place`;
            const data = {
                paymentRequest: {
                    amount: totalAmount,
                    paymentType: parseInt($("select")[0].value)
                },
                orderRequest: {
                    productIds: productsUnderCart
                }
            };
            const onOk = function () {
                localStorage.setItem("order_placed_successfully", "true");
                emptyCart(true);
            };
            const onError = function () { };
            send(HttpMethod.POST, endpoint, data, onOk, onError);
        }
    </script>
</asp:Content>
