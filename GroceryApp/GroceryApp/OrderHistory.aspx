<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderHistory.aspx.cs" Inherits="GroceryApp.OrderHistory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="empty-order-history" class="hide-container form-container">
        <div class="container pe-0">
            <div class="row mt-3">
                <div class="col-2">
                    <img class="ms-2" src="./Assets/empty-cart.png" height="45" width="45" />
                </div>
                <div class="col-10 mt-2">
                    <p style="font-size: 20px;">No orders are placed</p>
                </div>
            </div>
        </div>
    </div>
    <div id="order-history-container" class="hide-container">
        <div id="page-header" class="p-3 bg-white">
            <b>Order History</b>
        </div>
        <div id="order-history-subcontainer">
            <!-- Orders will be auto injected here by the script -->
        </div>
    </div>
    <style>
    #page-header {
        font-size: 22px;
    }

    .order-history-card {
        background-color: #f2f3f5;
    }

    #order-history-subcontainer {
        height: calc(100vh - 160px);
        overflow-x: hidden;
        overflow-y: scroll;
        border-radius: 5px;
        border: 1px solid #000000;
        background: #ffffff;
    }

    .order-history-card-container {
        padding: 20px;
    }

    .product-preview {
        height: 150px;
        width: 150px;
        background-size:cover;
        border-radius: 8px;
        border: 1px solid #000000;
    }

    .order-preview-info {
        font-size: 18px;
    }

    .col-2 {
        width: max-content;
    }

    img {
        aspect-ratio: auto;
    }

    .hide-container {
        display: none;
    }

    .show-container {
        display: block;
    }

    #empty-order-history {
        height: 80px;
        width: 335px;
    }

    #empty-order-history p {
        margin-left: 68px;
        margin-top: -42px;
    }
    </style>
    <script>
        let orders;
        function setOrderHistory() {
            const endpoint = `users/${userId}/orders`;
            const onOk = function (response) {
                orders = response.data;
                if (orders.length == 0) {
                    $("#empty-order-history")[0].classList.add("show-container");
                    $("#empty-order-history")[0].classList.remove("hide-container");
                    $("#order-history-container")[0].classList.add("hide-container");
                    $("#order-history-container")[0].classList.remove("show-container");
                    return;
                }
                else {
                    $("#empty-order-history")[0].classList.add("hide-container");
                    $("#empty-order-history")[0].classList.remove("show-container");
                    $("#order-history-container")[0].classList.add("show-container");
                    $("#order-history-container")[0].classList.remove("hide-container");
                }
                const endpoint = `products?productIds=${orders.map(o => o.productIds).flat().join(',')}`;
                const onOk = function (response) {
                    const products = response.data;
                    orders.forEach(order => {
                        let root = document.getElementById("order-history-subcontainer");
                        var parser = new DOMParser();
                        let componentHtml =
                            `<div class="order-history-card m-3" style="border: 1px solid #000000;">
                                <div class="order-history-card-container">
                                    <div class="row">
                                        <div class="col-2 px-0">
                                            <div class="product-preview ms-3" style="background-image:url('${products.find(p => p.id == order.productIds[0]).imageUrl}');"></div>
                                        </div>
                                        <div class="col-10 my-3 order-preview-info">
                                            <div class="row mb-3 ms-2">${order.productIds.length} items were ordered</div>
                                            <div class="row mb-3 ms-2">Ordered at ${new Date(order.orderedAt).toDateString()}</div>
                                            <div class="row ms-2"><a class="ps-0" href="OrderHistoryDetails?orderId=${order.id}">Check details here</a></div>
                                        </div>
                                    </div>
                                </div>
                            </div>`;
                        var component = parser.parseFromString(componentHtml, "text/html");
                        var node = component.getElementsByClassName('order-history-card')[0];
                        root.appendChild(node);
                    });
                };
                const onError = function () { };
                send(HttpMethod.GET, endpoint, null, onOk, onError);
            };
            const onError = function () { };
            send(HttpMethod.GET, endpoint, null, onOk, onError);
        }
    </script>
</asp:Content>