Feature: Verify funds for diffrent broker

  @GetBalanceforDifferentBroker @Regression
  Scenario: Verify funds for diffrent broker in fulfilled case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    Then give sleep of "4000"
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    Given loading the header for broker "B2"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "4000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s3b2btc"
    Then Check fees "25.4" for diffrent broker

  Scenario: Verify funds for diffrent broker in partially fulfilled case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "btc/inr" quantityType "quote" quantity "5000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    Then give sleep of "4000"
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    Given loading the header for broker "B2"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "4000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s3b2btc"
    Then Check fees "12.9" for diffrent broker

  Scenario: Verify funds for diffrent broker in cancelled case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "3600000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    Then give sleep of "4000"
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    Given loading the header for broker "B2"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "4000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s3b2btc"
    Then Check fees "0.0" for diffrent broker

  Scenario: Verify funds for diffrent broker in price improvement case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "btc/inr" quantityType "quote" quantity "5000" limitPrice "1750000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    Then give sleep of "4000"
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #cancel all order from broker 2
    Given loading the header for broker "B2"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "4000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s3b2btc"
    Then Check fees "25.4" for diffrent broker
