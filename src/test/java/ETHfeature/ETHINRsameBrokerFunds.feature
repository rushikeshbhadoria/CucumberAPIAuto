Feature: Verify funds for same broker

  @GetBalanceforSameBroker1 @Regression
  Scenario: Verify funds for same broker in fulfilled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
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
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    #cancel all order from broker 1
    Then give sleep of "4000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "2000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "2.939999997615814" for same broker

  @GetBalanceforSameBroker2 @Regression
  Scenario: Verify funds for same broker in partially fulfilled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
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
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "3500000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    #cancel all order from broker 1
    Then give sleep of "4000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "2000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "1.469999998807907" for same broker


  @GetBalanceforSameBroker3 @Regression
  Scenario: Verify funds for same broker in decremented case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
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
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    #cancel all order from broker 1
    Then give sleep of "4000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "2000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "0.0" for same broker

  @GetBalanceforSameBroker4 @Regression
  Scenario: Verify funds for same broker in cancelled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
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
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "3600000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    #cancel all order from broker 1
    Then give sleep of "4000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "2000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "0.0" for same broker

  @GetBalanceforSameBroker5 @Regression
  Scenario: Verify funds for same broker in price improvement case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
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
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "1750000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    #cancel all order from broker 1
    Then give sleep of "4000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "2000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "2.939999997615814" for same broker
    
    @BUYSELLBUYorders @Regression
  Scenario: Verify funds for same broker in BUYSELLBUY fulfilled case
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
    Then Check fees "3.0" for same broker