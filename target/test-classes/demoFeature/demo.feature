Feature: Verify funds for diffrent broker

  @GetBalanceforDifferentBroker12 @Regression @ETH
  Scenario: (placing BUY order first)Verify funds while Updating the order and matching it with two counter orders with diffrent brokers
    #cancelling the previous order
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    Given loading the header for broker "B2"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "BASE" quantity "1" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #update order
    Given Update an order for broker "B1" of  instrument "ETH/INR" quantityType "BASE" quantity "1" limitPrice "10000" username "user1" orderType "LIMIT"
    When Providing request PathUrl "PlaceOrder" with method "PATCH"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order updated successfully"
    Then Extracting the data "data"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user3"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    Then give sleep of "000"
    Then give sleep of "1000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b2btc"
    Then Check fees "4" for diffrent broker
    Then give sleep of "1000"

  @GetBalanceforDifferentBroker @Regression @ETH
  Scenario: (placing BUY order first)Verify funds while when order moves in (open--->partially_fulfilled--->fulfilled) for diffrent brokers
    #cancelling the previous order
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    Given loading the header for broker "B2"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "BASE" quantity "1" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user3"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    Then give sleep of "000"
    Then give sleep of "1000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b2btc"
    Then Check fees "4" for diffrent broker
    Then give sleep of "1000"

  @GetBalanceforDifferentBroker @Regression @ETH
  Scenario: (placing BUY order first)Verify funds while when order moves in (open--->partially_decrement--->partially_fulfilled(fulfilled)) for diffrent brokers
    #cancelling the previous order
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    Given loading the header for broker "B2"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "BASE" quantity "1" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user3"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    Then give sleep of "000"
    Then give sleep of "1000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b2btc"
    Then Check fees "2" for diffrent broker
    Then give sleep of "1000"

  @GetBalanceforDifferentBroker @Regression @ETH
  Scenario: (placing BUY order first)Verify funds while when order moves in (open--->partially_fulfilled--->partially_decrement(fulfilled)) for diffrent brokers
    #cancelling the previous order
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    Given loading the header for broker "B2"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "BASE" quantity "1" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    Then give sleep of "000"
    Then give sleep of "1000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b2btc"
    Then Check fees "2" for diffrent broker
    Then give sleep of "1000"
    
    
     @GetBalanceforDifferentBroker @Regression @ETH
  Scenario: (placing sell order first)Verify funds while Updating the order and matching it with two counter orders with diffrent brokers
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "BASE" quantity "1" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #update order
    Given Update an order for broker "B1" of  instrument "ETH/INR" quantityType "BASE" quantity "1" limitPrice "10000" username "user1" orderType "LIMIT"
    When Providing request PathUrl "PlaceOrder" with method "PATCH"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order updated successfully"
    Then Extracting the data "data"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "BUY" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B2" of type "limit" side "BUY" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user3"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    Then give sleep of "000"
  
    Then give sleep of "1000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b2btc"
    Then Check fees "4" for diffrent broker
    Then give sleep of "1000"
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    Given loading the header for broker "B2"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"

  @GetBalanceforDifferentBroker @Regression @ETH
  Scenario: (placing sell order first)Verify funds while when order moves in (open--->partially_fulfilled--->fulfilled) for diffrent brokers
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "BASE" quantity "1" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "BUY" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B2" of type "limit" side "BUY" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user3"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    Then give sleep of "000"

    Then give sleep of "1000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b2btc"
    Then Check fees "4" for diffrent broker
    Then give sleep of "1000"
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    Given loading the header for broker "B2"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    
      @GetBalanceforDifferentBroker @Regression @ETH
 Scenario: (placing sell order first)Verify funds while when order moves in (open--->partially_decrement--->partially_fulfilled(fulfilled)) for diffrent brokers
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "BASE" quantity "1" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B2" of type "limit" side "BUY" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user3"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    Then give sleep of "000"

    Then give sleep of "1000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b2btc"
    Then Check fees "2" for diffrent broker
    Then give sleep of "1000"
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    Given loading the header for broker "B2"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    
    
     @GetBalanceforDifferentBroker @Regression @ETH
 Scenario: (placing sell order first)Verify funds while when order moves in (open--->partially_fulfilled--->partially_decrement(fulfilled)) for diffrent brokers
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "BASE" quantity "1" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "BUY" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "BASE" quantity "0.5" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    Then give sleep of "000"

    Then give sleep of "1000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b2btc"
    Then Check fees "2" for diffrent broker
    Then give sleep of "1000"
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    Given loading the header for broker "B2"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    
