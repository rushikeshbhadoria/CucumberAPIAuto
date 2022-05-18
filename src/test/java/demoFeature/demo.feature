Feature: Verify funds for diffrent broker

  @BUYSELLBUYorders @Regression
  Scenario: Verify funds for same broker in fulfilled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "quote" quantity "5000.06" limitPrice "49" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "quote" quantity "10000.12" limitPrice "49" username "user"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    Then give sleep of "2000"
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "PARTIALLY_FULFILLED"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "quote" quantity "5000.06" limitPrice "49" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    #cancel all order from broker 1
    Then give sleep of "2000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "2000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "1.0" for same broker

  @UpdateOrder @Regression
  Scenario: Verify Update Order api
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Given Update an order for broker "B1" of  instrument "ETH/INR" quantityType "QUOTE" quantity "20000" limitPrice "1000" username "user1" orderType "LIMIT"
    When Providing request PathUrl "PlaceOrder" with method "PATCH"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order updated successfully"
    #cancel all order from broker 1
   # When Providing request PathUrl "CancelAllOrders" with method "DELETE"
