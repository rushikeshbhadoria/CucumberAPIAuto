Feature: Verify funds for diffrent broker

  @GetBalanceforDifferentBroker @Regression
  Scenario: Verify funds for diffrent broker in fulfilled case
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given For_Broker2_take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given For_Broker2_take balance of "BTC" with api "Getbalance" with name "s1b2btc"
    Given Placing an order of type "limit" side "BUY" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    Given For_Broker2_take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given For_Broker2_take balance of "BTC" with api "Getbalance" with name "s2b2btc"
    Given For_Broker2_Placing an order of type "limit" side "SELL" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "3500000" username "user1"
    When For_Broker2_Providing request PathUrl "PlaceOrder" with method "POST"
    Then For_Broker2_I verify the  "200" in step
    And For_Broker2_Verify key "message" of response "Order placed successfully"
    And For_Broker2_Verify the "data.orderID" of response "GetOrder"
    #cancel all order from broker 1
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    When For_Broker2_Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Given For_Broker2_take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given For_Broker2_take balance of "BTC" with api "Getbalance" with name "s3b2btc"
    Then Check fees "2" for diffrent broker
    
    Scenario: Verify funds for diffrent broker in partially fulfilled case
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given For_Broker2_take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given For_Broker2_take balance of "BTC" with api "Getbalance" with name "s1b2btc"
    Given Placing an order of type "limit" side "BUY" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    Given For_Broker2_take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given For_Broker2_take balance of "BTC" with api "Getbalance" with name "s2b2btc"
    Given For_Broker2_Placing an order of type "limit" side "SELL" instrument "btc/inr" quantityType "quote" quantity "5000" limitPrice "3500000" username "user1"
    When For_Broker2_Providing request PathUrl "PlaceOrder" with method "POST"
    Then For_Broker2_I verify the  "200" in step
    And For_Broker2_Verify key "message" of response "Order placed successfully"
    And For_Broker2_Verify the "data.orderID" of response "GetOrder"
    #cancel all order from broker 1
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    When For_Broker2_Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Given For_Broker2_take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given For_Broker2_take balance of "BTC" with api "Getbalance" with name "s3b2btc"
    Then Check fees "1" for diffrent broker
    
    Scenario: Verify funds for diffrent broker in cancelled case
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given For_Broker2_take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given For_Broker2_take balance of "BTC" with api "Getbalance" with name "s1b2btc"
    Given Placing an order of type "limit" side "BUY" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    Given For_Broker2_take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given For_Broker2_take balance of "BTC" with api "Getbalance" with name "s2b2btc"
    Given For_Broker2_Placing an order of type "limit" side "SELL" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "3600000" username "user1"
    When For_Broker2_Providing request PathUrl "PlaceOrder" with method "POST"
    Then For_Broker2_I verify the  "200" in step
    And For_Broker2_Verify key "message" of response "Order placed successfully"
    And For_Broker2_Verify the "data.orderID" of response "GetOrder"
    #cancel all order from broker 1
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    When For_Broker2_Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Given For_Broker2_take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given For_Broker2_take balance of "BTC" with api "Getbalance" with name "s3b2btc"
    Then Check fees "0" for diffrent broker
    
    Scenario: Verify funds for diffrent broker in price improvement case
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given For_Broker2_take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given For_Broker2_take balance of "BTC" with api "Getbalance" with name "s1b2btc"
    Given Placing an order of type "limit" side "BUY" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    Given For_Broker2_take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given For_Broker2_take balance of "BTC" with api "Getbalance" with name "s2b2btc"
    Given For_Broker2_Placing an order of type "limit" side "SELL" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "1750000" username "user1"
    When For_Broker2_Providing request PathUrl "PlaceOrder" with method "POST"
    Then For_Broker2_I verify the  "200" in step
    And For_Broker2_Verify key "message" of response "Order placed successfully"
    And For_Broker2_Verify the "data.orderID" of response "GetOrder"
    #cancel all order from broker 1
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    When For_Broker2_Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Given For_Broker2_take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given For_Broker2_take balance of "BTC" with api "Getbalance" with name "s3b2btc"
    Then Check fees "2" for diffrent broker
    
