Feature: Order

As a registered user, he/she can do the followings -
1. Can get the order history
2. Can place the order

Background:
Given I am a registered user

@order-history-retrived
Scenario:Order history retrieved successfully
When the user sends GET request to the 'users/1/orders' endpoint
Then the response status code should be 200
And the response body should be '{"data":[{"orderId":1,"productIds":[1,2]},{"orderId":2,"productIds":[1]}]}'

@order-history-retrived-failed
Scenario:Order history retrieve failed due to user not found
When the user sends GET request to the 'users/7/orders' endpoint
Then the response status code should be 400
And the response body should be '{"message":"User with id 7 is not found."}'

@order-placed-successfully
Scenario:Order placed successfully
When the user sends POST request to the 'users/1/orders/place' endpoint with the data '{"paymentRequest":{"amount":3000,"paymentType":1},"orderRequest":{ "productIds":[1,2]}}'
Then the response status code should be 200
And the response body should be '{"data":{"orderId":3,"paymentId":3}}'

@order-placing-failed
Scenario:Order placing failed due to user not found
When the user sends POST request to the 'users/20/orders/place' endpoint with the data '{"paymentRequest":{"amount":3000,"paymentType":1},"orderRequest":{ "productIds":[1,2]}}'
Then the response status code should be 400
And the response body should be '{"message":"User with id 20 is not found."}'

@order-placing-failed
Scenario:Order placing failed due to product not found
When the user sends POST request to the 'users/1/orders/place' endpoint with the data '{"paymentRequest":{"amount":3000,"paymentType":3},"orderRequest":{ "productIds":[]}}'
Then the response status code should be 400
And the response body should be '{"message":"ProductIds are either not given or invalid."}'

@order-placing-failed
Scenario:Order placing failed due to no products are passed
When the user sends POST request to the 'users/1/orders/place' endpoint with the data '{"payment":{"amount":3000,"paymentType":1},"order":{ "userId":1,"productIds":[]}}'
Then the response status code should be 400
And the response body should be '{"message":"Payment details are either not given or invalid."}'

@order-placing-failed
Scenario:Order placing failed due to invalid payment type
When the user sends POST request to the 'users/1/orders/place' endpoint with the data '{"paymentRequest":{"amount":3000,"paymentType":7},"orderRequest":{ "productIds":[1,2]}}'
Then the response status code should be 400
And the response body should be '{"message":"Payment failed for the order. Order cannot be placed. PaymentType is either not given or invalid."}'

@order-placing-failed
Scenario:Order placing failed due to less payment amount
When the user sends POST request to the 'users/1/orders/place' endpoint with the data '{"paymentRequest":{"amount":0,"paymentType":2},"orderRequest":{ "productIds":[1,2]}}'
Then the response status code should be 400
And the response body should be '{"message":"Payment failed for the order. Order cannot be placed. Payment amount is less than the total amount of the purchased items."}'