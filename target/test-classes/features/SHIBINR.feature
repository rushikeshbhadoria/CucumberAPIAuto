Feature: SHIBINR Regression

  @PlaceGetDeleteOrder @Regression @SHIB
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
      | limit | BUY  | SHIB/INR    | QUOTE        |    10000 |        1000 | user1    |

  @UpdateOrder @Regression @SHIB
  Scenario: Verify Update Order api
    Given Placing an order for broker "B2" of type "limit" side "BUY" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Given Update an order for broker "B2" of  instrument "SHIB/INR" quantityType "QUOTE" quantity "2000" limitPrice "103" username "user1" orderType "LIMIT"
    When Providing request PathUrl "PlaceOrder" with method "PATCH"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order updated successfully"
    #cancel all order from broker 1
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"

  @Add_Delete_IP @Regression @SHIB
  Scenario: Verify Add IP and delete IP
    Given Add IP for a broker "B2"
    When Providing request PathUrl "AddIP" with method "POST"
    Then I verify the  "200" in step
    Then Extracting the data "data"
    When Providing request PathUrl "AddIP" with method "DELETE"
    Then I verify the  "200" in step
    And Verify key "message" of response "IP removed successfully"

  @CancelAllOrder @Regression @SHIB
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
  @GetAllOrder @Regression @SHIB
  Scenario: Verify GetAllOrder
    Given loading the header for broker "B1"
    When Providing request PathUrl "GetAllOrders" with method "GET"
    Then I verify the  "200" in step
    And Verify key "message" of response "Orders fetched successfully"

  @GetAllIps @Regression @SHIB
  Scenario: Verify GetAllIps
    Given loading the header for broker "B1"
    When Providing request PathUrl "AddIP" with method "GET"
    Then I verify the  "200" in step
    And Verify key "message" of response "Listed IPs for the Broker"

  #Feature: Verify funds for diffrent broker
  @GetBalanceforDifferentBroker @Regression @SHIB
  Scenario: Verify funds for diffrent broker in fulfilled case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "0.003" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "0.003" username "user1"
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
    Given take balance of "SHIB" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s3b2btc"
    Then Check fees "2.939999997615814" for diffrent broker

  @SHIB
  Scenario: Verify funds for diffrent broker in partially fulfilled case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "0.003" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "SHIB/INR" quantityType "QUOTE" quantity "5000" limitPrice "0.003" username "user1"
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
    Given take balance of "SHIB" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s3b2btc"
    Then Check fees "1.4700000062584877" for diffrent broker

  @SHIB
  Scenario: Verify funds for diffrent broker in cancelled case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "0.003" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "3600000" username "user1"
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
    Given take balance of "SHIB" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s3b2btc"
    Then Check fees "0.0" for diffrent broker

  @SHIB
  Scenario: Verify funds for diffrent broker in price improvement case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "0.003" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "SHIB/INR" quantityType "QUOTE" quantity "5000" limitPrice "0.0015" username "user1"
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
    Given take balance of "SHIB" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s3b2btc"
    Then Check fees "2.9399999994784594" for diffrent broker

  #Feature: Verify funds for same broker
  @GetBalanceforSameBroker1 @Regression @SHIB
  Scenario: Verify funds for same broker in fulfilled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "0.003" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "0.003" username "user2"
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
    Given take balance of "SHIB" with api "Getbalance" with name "s3b1btc"
    Then Check fees "2.939999997615814" for same broker

  @GetBalanceforSameBroker2 @Regression @SHIB
  Scenario: Verify funds for same broker in partially fulfilled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "0.003" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "SHIB/INR" quantityType "QUOTE" quantity "5000" limitPrice "0.0015" username "user2"
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
    Given take balance of "SHIB" with api "Getbalance" with name "s3b1btc"
    Then Check fees "1.469999998807907" for same broker

  @GetBalanceforSameBroker3 @Regression @SHIB
  Scenario: Verify funds for same broker in decremented case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "0.003" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "0.003" username "user1"
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
    Given take balance of "SHIB" with api "Getbalance" with name "s3b1btc"
    Then Check fees "0.0" for same broker

  @GetBalanceforSameBroker4 @Regression @SHIB
  Scenario: Verify funds for same broker in cancelled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "0.003" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "0.004" username "user2"
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
    Given take balance of "SHIB" with api "Getbalance" with name "s3b1btc"
    Then Check fees "0.0" for same broker

  @GetBalanceforSameBroker5 @Regression @SHIB
  Scenario: Verify funds for same broker in price improvement case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "SHIB/INR" quantityType "QUOTE" quantity "10000" limitPrice "0.003" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "SHIB/INR" quantityType "QUOTE" quantity "5000" limitPrice "0.0015" username "user2"
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
    Given take balance of "SHIB" with api "Getbalance" with name "s3b1btc"
    Then Check fees "2.939999997615814" for same broker

  @BUYSELLBUYorders @Regression @SHIB
  Scenario: Verify funds for same broker in BUYSELLBUY fulfilled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "SHIB/INR" quantityType "quote" quantity "5000.06" limitPrice "0.003" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "SHIB" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "SHIB/INR" quantityType "quote" quantity "10000.12" limitPrice "0.0015" username "user"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    Then give sleep of "2000"
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "PARTIALLY_FULFILLED"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "SHIB/INR" quantityType "quote" quantity "5000.06" limitPrice "0.0015" username "user2"
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
    Given take balance of "SHIB" with api "Getbalance" with name "s3b1btc"
    Then Check fees "3.0" for same broker
