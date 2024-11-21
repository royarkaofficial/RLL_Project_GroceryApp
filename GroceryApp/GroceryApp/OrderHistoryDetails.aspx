<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderHistoryDetails.aspx.cs" Inherits="GroceryApp.OrderHistoryDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="empty-cart" class="hide-container form-container">
        <div class="container">
            <div class="row mt-3">
                <div class="col-2">
                    <img class="ms-2" src="./Assets/empty-cart.png" height="45" width="45" />
                </div>
                <div class="col-10 mt-2">
                    <p class="ms-4 ps-2" style="font-size: 20px;">No order found</p>
                </div>
            </div>
        </div>
    </div>
    <div id="existing-cart" class="container mx-0">
        <div class="row justify-content-between">
            <div id="cart-container" class="col-9 p-0 border border-black bg-white">
                <div class="row px-4 pt-4 pb-2">
                    <div class="col">
                        <h3>Cart Details</h3>
                    </div>
                </div>
                <div class="row ps-4">
                    <p id="deliver-to"></p>
                </div>
                <div class="row ps-4">
                    <p id="delivery-address"></p>
                </div>
                <div class="row ps-4" style="margin-top: -8px;">
                    <p id="delivery-ordered-at"></p>
                </div>
                <div class="mx-4 overflow-y-scroll border" style="height: calc(100vh - 286px);">
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
                            <select id="payment-mode" class="form-select" disabled>
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
        let order;

        function setOrderHistoryDetails() {
            const queryParameters = new URLSearchParams(window.location.search);
            const orderId = parseInt(queryParameters.get('orderId'));
            const endpoint = `users/${userId}/orders`;
            const onOk = function (response) {
                const orders = response.data;
                order = orders.find(o => o.id == orderId);
                $("#deliver-to")[0].innerText = `Delivered To: ${currentUser.firstName} ${currentUser.lastName}`;
                $("#delivery-address")[0].innerText = `Address: ${currentUser.address}`;
                $("#delivery-ordered-at")[0].innerText = `Ordered At: ${new Date(order.orderedAt).toDateString()}`;
                const endpoint = `products?productIds=${order.productIds.join(',')}`;
                const onOk = function (response) {
                    const products = response.data;
                    const root = $("#products-under-cart")[0];
                    showPaymentDetails(products);
                    const parser = new DOMParser();
                    products.forEach(product => {
                        const component = parser.parseFromString(`<div id="product-under-cart-${product.id}" class="container mb-3 border" style="border-radius: 10px; background-color: #f2f3f5;">
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
                                                      </div>
                                                  </div>
                                              </div>`, 'text/html');
                        const node = component.getElementById(`product-under-cart-${product.id}`);
                        root.append(node);
                    });
                };
                const onError = function () { };
                send(HttpMethod.GET, endpoint, null, onOk, onError);
            };
            const onError = function () { };
            send(HttpMethod.GET, endpoint, null, onOk, onError);
        }

        function showPaymentDetails(products) {
            totalAmount = 0;
            $("#cart-item-count")[0].innerText = `Price (${products.length} ${products.length == 1 ? 'item' : 'items'})`;
            $(".total-amount")[0].innerText = order.payment.amount;
            $(".total-amount")[1].innerText = order.payment.amount;
            $("select")[0].value = order.payment.paymentType;
        }
    </script>
</asp:Content>
