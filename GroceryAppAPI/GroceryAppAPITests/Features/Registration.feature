Feature:Registration

As a new user, he/she tries to register.

Background:
Given I am a registered user

@valid-registration
Scenario:User registered successfully
When the user sends POST request to the 'registration' endpoint with the data '{"firstName":"Arkadeep","lastName":"Roy","email":"roy@gmail.com","password":"Arka123","address":"Serampore","Gender":1,"Role":1}'
Then the response status code should be 200
And the response body should be '{"message":"User registered successfully."}'

@invalid-registration
Scenario:User registration fails due to blank firstname
When the user sends POST request to the 'registration' endpoint with the data '{"firstName":" ","lastName":"Roy","email":"roy1@gmail.com","password":"Arka123", "address":"Serampore","Gender":1,"Role":1}'
Then the response status code should be 400
And the response body should be '{"message":"FirstName is either not given or invalid."}'

@invalid-registration
Scenario:User registration fails due to blank lastname
When the user sends POST request to the 'registration' endpoint with the data '{"firstName":"Arkadeep","lastName":" ","email":"roy2@gmail.com","password":"Arka123","address":"Serampore","Gender":1,"Role":1}'
Then the response status code should be 400
And the response body should be '{"message":"LastName is either not given or invalid."}'

@invalid-registration
Scenario:User registration fails due to blank email
When the user sends POST request to the 'registration' endpoint with the data '{"firstName":"Arkadeep","lastName":"Roy","email":" ","password":"Arka123","address":"Serampore","Gender":1,"Role":1}'
Then the response status code should be 400
And the response body should be '{"message":"Email is either not given or invalid."}'

@invalid-registration
Scenario:User registration fails due to blank password
When the user sends POST request to the 'registration' endpoint with the data '{"firstName":"Arkadeep","lastName":"Roy","email":"roy3@gmail.com","password":"","address":"Serampore","Gender":1,"Role":1}'
Then the response status code should be 400
And the response body should be '{"message":"Password is either not given or invalid."}'

@invalid-registration
Scenario:User registration fails due to blank address
When the user sends POST request to the 'registration' endpoint with the data '{"firstName":"Arkadeep","lastName":"Roy","email":"roy3@gmail.com","password":"Arka123","address":"","Gender":1,"Role":1}'
Then the response status code should be 400
And the response body should be '{"message":"Address is either not given or invalid."}'

@invalid-registration
Scenario:User registration fails due to invalid gender
When the user sends POST request to the 'registration' endpoint with the data '{"firstName":"Arkadeep","lastName":"Roy","email":"roy3@gmail.com","password":"Arka123","address":"Serampore","Gender":3,"Role":1}'
Then the response status code should be 400
And the response body should be '{"message":"Gender is either not given or invalid."}'

@invalid-registration
Scenario:User registration fails due to invalid role
When the user sends POST request to the 'registration' endpoint with the data '{"firstName":"Arkadeep","lastName":"Roy","email":"roy3@gmail.com","password":"Arka123","address":"Serampore","Gender":1,"Role":3}'
Then the response status code should be 400
And the response body should be '{"message":"Role is either not given or invalid."}'
