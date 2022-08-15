Feature: BTCINR Regression

  @PlaceGetDeleteOrder @Regression @BTC
  Scenario Outline: Verify place order , get order  and cancel order api
    Given Placing an order for broker "B2" of type "<type>" side "<side>" instrument "<instrument>" quantityType "<quantityType>" quantity "<quantity>" limitPrice "<limitPrice>" username "<username>"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "data.side" of response "<side>"
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    When Providing request PathUrl "PlaceOrder" with method "DELETE"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order cancelled"
    #cancel all order from broker 1
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"

    Examples: 
      | type  | side | instrument | quantityType | quantity | limitPrice | username |
      | limit | BUY  | BTC/INR    | QUOTE        |    10000 |        102 | user1    |

  @UpdateOrder @Regression @BTC
  Scenario: Verify Update Order api
    Given Placing an order for broker "B2" of type "limit" side "BUY" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "102" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Given Update an order for broker "B2" of  instrument "BTC/INR" quantityType "QUOTE" quantity "103.5" limitPrice "103" username "user1" orderType "LIMIT"
    When Providing request PathUrl "PlaceOrder" with method "PATCH"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order updated successfully"
    #cancel all order from broker 1
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"

  @Add_Delete_IP @Regression @BTC
  Scenario: Verify Add IP and delete IP
    Given Add IP for a broker "B2"
    When Providing request PathUrl "AddIP" with method "POST"
    Then I verify the  "200" in step
    Then Extracting the data "data"
    When Providing request PathUrl "AddIP" with method "DELETE"
    Then I verify the  "200" in step
    And Verify key "message" of response "IP removed successfully"

  @CancelAllOrder @Regression @BTC
  Scenario: Verify CancelAllOrder
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #Then I verify the  "200" in step
    #And Verify key "message" of response "Orders cancellation in progress"
    #cancel all order from broker 2
    Given loading the header for broker "B2"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"

  #Then I verify the  "200" in step
  #And Verify key "message" of response "Orders cancellation in progress"
  @GetAllOrder @Regression @BTC
  Scenario: Verify GetAllOrder
    Given loading the header for broker "B1"
    When Providing request PathUrl "GetAllOrders" with method "GET"
    Then I verify the  "200" in step
    And Verify key "message" of response "Orders fetched successfully"

  @GetAllIps @Regression @BTC
  Scenario: Verify GetAllIps
    Given loading the header for broker "B1"
    When Providing request PathUrl "AddIP" with method "GET"
    Then I verify the  "200" in step
    And Verify key "message" of response "Listed IPs for the Broker"

  #Feature: Verify funds for diffrent broker
  @GetBalanceforDifferentBroker @Regression @BTC
  Scenario: Verify funds for diffrent broker in fulfilled case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
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
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
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
    Then Check fees "2.939999997615814" for diffrent broker

  @BTC
  Scenario: Verify funds for diffrent broker in partially fulfilled case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
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
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "BTC/INR" quantityType "QUOTE" quantity "5000" limitPrice "3500000" username "user1"
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
    Then Check fees "1.4700000062584877" for diffrent broker

  @BTC
  Scenario: Verify funds for diffrent broker in cancelled case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
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
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "3600000" username "user1"
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

  @BTC
  Scenario: Verify funds for diffrent broker in price improvement case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
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
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "BTC/INR" quantityType "QUOTE" quantity "5000" limitPrice "1750000" username "user1"
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
    Then Check fees "2.9399999994784594" for diffrent broker

  #Feature: Verify funds for same broker
  @GetBalanceforSameBroker1 @Regression @BTC
  Scenario: Verify funds for same broker in fulfilled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user2"
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
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Then Check fees "2.939999997615814" for same broker

  @GetBalanceforSameBroker2 @Regression @BTC
  Scenario: Verify funds for same broker in partially fulfilled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "BTC/INR" quantityType "QUOTE" quantity "5000" limitPrice "3500000" username "user2"
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
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Then Check fees "1.469999998807907" for same broker

  @GetBalanceforSameBroker3 @Regression @BTC
  Scenario: Verify funds for same broker in decremented case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
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
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Then Check fees "0.0" for same broker

  @GetBalanceforSameBroker4 @Regression @BTC
  Scenario: Verify funds for same broker in cancelled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "3600000" username "user2"
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
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Then Check fees "0.0" for same broker

  @GetBalanceforSameBroker5 @Regression @BTC
  Scenario: Verify funds for same broker in price improvement case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "BTC/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "BTC/INR" quantityType "QUOTE" quantity "5000" limitPrice "1750000" username "user2"
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
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Then Check fees "2.939999997615814" for same broker

  @BUYSELLBUYorders @Regression @BTC
  Scenario: Verify funds for same broker in BUYSELLBUY fulfilled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "BTC/INR" quantityType "quote" quantity "5000.06" limitPrice "49" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "BTC/INR" quantityType "quote" quantity "10000.12" limitPrice "49" username "user"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    Then give sleep of "2000"
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "PARTIALLY_FULFILLED"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "BTC/INR" quantityType "quote" quantity "5000.06" limitPrice "49" username "user2"
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
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Then Check fees "3.0" for same broker
