Feature: ETHINR Regression

  @PlaceGetDeleteOrder @Regression @ETH
  Scenario Outline: Verify place order , get order  and cancel order api
    Given Placing an order for broker "B2" of type "<type>" side "<side>" instrument "<instrument>" quantityType "<quantityType>" quantity "<quantity>" limitPrice "<limitPrice>" username "<username>"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "data.side" of response "<side>"
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    When Providing request PathUrl "PlaceOrder" with method "DELETE"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order cancelled"
    #cancel all order from broker 1
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"

    Examples: 
      | type  | side | instrument | quantityType | quantity | limitPrice | username |
      | limit | BUY  | ETH/INR    | QUOTE        |    10000 |       1000 | user1    |

  @UpdateOrde123r @Regression @ETH
  Scenario: Verify Update Order api
    Given Placing an order for broker "B2" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Given Update an order for broker "B2" of  instrument "ETH/INR" quantityType "QUOTE" quantity "2000" limitPrice "103" username "user1" orderType "LIMIT"
    When Providing request PathUrl "PlaceOrder" with method "PATCH"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order updated successfully"
    #cancel all order from broker 1
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"

  @Add_Delete_IP @Regression @ETH
  Scenario: Verify Add IP and delete IP
    Given Add IP for a broker "B2"
    When Providing request PathUrl "AddIP" with method "POST"
    Then I verify the  "200" in step
    Then Extracting the data "data"
    When Providing request PathUrl "AddIP" with method "DELETE"
    Then I verify the  "200" in step
    And Verify key "message" of response "IP removed successfully"

  @CancelAllOrder @Regression @ETH
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
  @GetAllOrder @Regression @ETH
  Scenario: Verify GetAllOrder
    Given loading the header for broker "B1"
    When Providing request PathUrl "GetAllOrders" with method "GET"
    Then I verify the  "200" in step
    And Verify key "message" of response "Orders fetched successfully"

  @GetAllIps @Regression @ETH
  Scenario: Verify GetAllIps
    Given loading the header for broker "B1"
    When Providing request PathUrl "AddIP" with method "GET"
    Then I verify the  "200" in step
    And Verify key "message" of response "Listed IPs for the Broker"

  #Feature: Verify funds for diffrent broker
  @GetBalanceforDifferentBrokerfulfilledcase @Regression @ETH
  Scenario: Verify funds for diffrent broker in fulfilled case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
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
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b2btc"
    Then Check fees "4" for diffrent broker

  @ETH
  Scenario: Verify funds for diffrent broker in partially fulfilled case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
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
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b2btc"
    Then Check fees "2" for diffrent broker

  @ETH
  Scenario: Verify funds for diffrent broker in cancelled case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "3600000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
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
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b2btc"
    Then Check fees "0.0" for diffrent broker

  @ETH
  Scenario: Verify funds for diffrent broker in price improvement case
    #takeout balance before placing the order
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s1b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b2btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s2b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b2btc"
    Given Placing an order for broker "B2" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "5000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
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
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Given loading the header for broker "B2"
    Given take balance of "INR" with api "Getbalance" with name "s3b2inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b2btc"
    Then Check fees "4" for diffrent broker

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
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #update order
    Given Update an order for broker "B1" of  instrument "ETH/INR" quantityType "BASE" quantity "1" limitPrice "10000" username "user1" orderType "LIMIT"
    When Providing request PathUrl "PlaceOrder" with method "PATCH"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order updated successfully"
    Then Extracting the data "data"
    And Verify the "data.orderId" of response "GetOrder"
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
    And Verify the "data.orderId" of response "GetOrder"
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
    And Verify the "data.orderId" of response "GetOrder"
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
    And Verify the "data.orderId" of response "GetOrder"
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

  @GetBalanceforDifferentBrokerDF12 @Regression @ETH
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
    And Verify the "data.orderId" of response "GetOrder"
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
    And Verify the "data.orderId" of response "GetOrder"
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

  @GetBalanceforDifferentBrokerPFPD12 @Regression @ETH
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
    And Verify the "data.orderId" of response "GetOrder"
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
    And Verify the "data.orderId" of response "GetOrder"
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

  @GetBalanceforDifferentBrokerUOM12 @Regression @ETH
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
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #update order
    Given Update an order for broker "B1" of  instrument "ETH/INR" quantityType "BASE" quantity "1" limitPrice "10000" username "user1" orderType "LIMIT"
    When Providing request PathUrl "PlaceOrder" with method "PATCH"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order updated successfully"
    Then Extracting the data "data"
    And Verify the "data.orderId" of response "GetOrder"
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
    And Verify the "data.orderId" of response "GetOrder"
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
    And Verify the "data.orderId" of response "GetOrder"
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
    And Verify the "data.orderId" of response "GetOrder"
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
    And Verify the "data.orderId" of response "GetOrder"
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
    And Verify the "data.orderId" of response "GetOrder"
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
    And Verify the "data.orderId" of response "GetOrder"
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
    And Verify the "data.orderId" of response "GetOrder"
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

  #Feature: Verify funds for same broker
  @GetBalanceforSameBroker1 @Regression @ETH
  Scenario: Verify funds for same broker in fulfilled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "10000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    #cancel all order from broker 1
    Then give sleep of "4000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "2000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "3" for same broker

  @GetBalanceforSameBroker2 @Regression @ETH
  Scenario: Verify funds for same broker in partially fulfilled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "10000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    #cancel all order from broker 1
    Then give sleep of "4000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "2000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "1.5" for same broker

  @GetBalanceforSameBroker3 @Regression @ETH
  Scenario: Verify funds for same broker in decremented case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    #cancel all order from broker 1
    Then give sleep of "4000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "2000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "0.0" for same broker

  @GetBalanceforSameBroker4SBCC @Regression @ETH
  Scenario: Verify funds for same broker in cancelled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
     When Providing request PathUrl "PlaceOrder" with method "DELETE"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order cancelled"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "3600000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
     When Providing request PathUrl "PlaceOrder" with method "DELETE"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order cancelled"
    #cancel all order from broker 1
    
   # When Providing request PathUrl "CancelAllOrders" with method "DELETE"
   
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "0.0" for same broker

  @GetBalanceforSameBrokerSBPIC5 @Regression @ETH
  Scenario: Verify funds for same broker in price improvement case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "10000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "5000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    #cancel all order from broker 1
    Then give sleep of "4000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "2000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "3" for same broker

  @BUYSELLBUYordersBSBFC @Regression @ETH
  Scenario: Verify funds for same broker in BUYSELLBUY fulfilled case
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "quote" quantity "5000" limitPrice "50" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "quote" quantity "10000" limitPrice "50" username "user"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    Then give sleep of "2000"
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "PARTIALLY_FULFILLED"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "quote" quantity "5000" limitPrice "50" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    #cancel all order from broker 1
    Then give sleep of "2000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "2000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "3.0" for same broker

  @GetBalanceforSameBroker1PSSBUC @Regression @ETH
  Scenario: (placing sell order first)Verify funds while Updating the order and matching it with two counter orders
     #cancel all order from broker 1 before executing the testcase
    Given loading the header for broker "B1"
    Then give sleep of "000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "1001" limitPrice "100" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Given Update an order for broker "B1" of  instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1" orderType "LIMIT"
    When Providing request PathUrl "PlaceOrder" with method "PATCH"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order updated successfully"
    Then Extracting the data "data"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "2000" limitPrice "1000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "8000" limitPrice "1000" username "user3"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "3.0" for same broker



  @GetBalanceforSameBroker1PSOPFF @Regression @ETH
  Scenario: (placing sell order first)Verify funds while when order moves in (open--->partially_fulfilled--->fulfilled) for same broker
    #cancel all order from broker 1 before executing the testcase
    Given loading the header for broker "B1"
    Then give sleep of "000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "2000" limitPrice "1000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "8000" limitPrice "1000" username "user3"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "3.0" for same broker
 

  @GetBalanceforSameBroker152SPOPDD @Regression @ETH
  Scenario: (placing sell order first)Verify funds while when order moves in (open--->partially_decrement--->decrement) for same broker
     #cancel all order from broker 1 before executing the testcase
    Given loading the header for broker "B1"
    Then give sleep of "000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "0.0" for same broker


  @GetBalanceforSameBroker1PSODPF @Regression @ETH
  Scenario: (placing sell order first)Verify funds while when order moves in (open--->partially_decrement--->partially_fulfilled(fulfilled)) for same broker
    #cancel all order from broker 1 before executing the testcase
    Given loading the header for broker "B1"
    Then give sleep of "000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "1000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "1.5" for same broker
  

  @GetBalanceforSameBroker1SPOPFPB @Regression @ETH
  Scenario: (placing sell order first)Verify funds while when order moves in (open--->partially_fulfilled--->partially_decrement(fulfilled)) for same broker
     #cancel all order from broker 1 before executing the testcase
    Given loading the header for broker "B1"
    Then give sleep of "000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "1000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "1.5" for same broker



  @GetBalanceforSameBroker1 @Regression @ETH
  Scenario: (placing sell order first)Verify funds while when order moves in (open--->partially_decrement--->cancel(partially_cancelled)) for same broker
    #cancel all order from broker 1 before executing the testcase
    Given loading the header for broker "B1"
    Then give sleep of "000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    Then give sleep of "000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
  
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "0.0" for same broker


  @GetBalanceforSameBroker1 @Regression @ETH
  Scenario: (placing buy order first)Verify funds while Updating the order and matching it with two counter orders
    #cancel all order from broker 1 before executing the testcase
    Given loading the header for broker "B1"
    Then give sleep of "000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "1001" limitPrice "100" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Given Update an order for broker "B1" of  instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1" orderType "LIMIT"
    When Providing request PathUrl "PlaceOrder" with method "PATCH"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order updated successfully"
    Then Extracting the data "data"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "2000" limitPrice "1000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "8000" limitPrice "1000" username "user3"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "3.0" for same broker
   

  @GetBalanceforSameBroker1PSOPFF1 @Regression @ETH
  Scenario: (placing buy order first)Verify funds while when order moves in (open--->partially_fulfilled--->fulfilled) for same broker
    #cancel all order from broker 1 before executing the testcase
    Given loading the header for broker "B1"
    Then give sleep of "000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "2000" limitPrice "1000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "8000" limitPrice "1000" username "user3"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "3.0" for same broker
  

  @GetBalanceforSameBroker1SMPSOPDD1 @Regression @ETH
  Scenario: (placing buy order first)Verify funds while when order moves in (open--->partially_decrement--->decrement) for same broker
    #cancel all order from broker 1 before executing the testcase
    Given loading the header for broker "B1"
    Then give sleep of "000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "2000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "8000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "0.0" for same broker
  

  @GetBalanceforSameBroker1SBPBPODPF @Regression @ETH
  Scenario: (placing buy order first)Verify funds while when order moves in (open--->partially_decrement--->partially_fulfilled(fulfilled)) for same broker
     #cancel all order from broker 1 before executing the testcase
    Given loading the header for broker "B1"
    Then give sleep of "000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "1000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "1.5" for same broker
    

  @GetBalanceforSameBroker1SBOFPD @Regression @ETH
  Scenario: (placing buy order first)Verify funds while when order moves in (open--->partially_fulfilled--->partially_decrement(fulfilled)) for same broker
      #cancel all order from broker 1 before executing the testcase
    Given loading the header for broker "B1"
    Then give sleep of "000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "1000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "1.5" for same broker
    

  @GetBalanceforSameBroker1SBPBOPDPC @Regression @ETH
  Scenario: (placing buy order first)Verify funds while when order moves in (open--->partially_decrement--->cancel(partially_cancelled)) for same broker
    #cancel all order from broker 1 before executing the testcase
    Given loading the header for broker "B1"
    Then give sleep of "000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s1b1btc"
    Given Placing an order for broker "B1" of type "limit" side "BUY" instrument "ETH/INR" quantityType "QUOTE" quantity "10000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderId" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    #take balance
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order for broker "B1" of type "limit" side "SELL" instrument "ETH/INR" quantityType "QUOTE" quantity "5000" limitPrice "1000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    Then give sleep of "000"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then give sleep of "000"
    Given loading the header for broker "B1"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "ETH" with api "Getbalance" with name "s3b1btc"
    Then Check fees "0.0" for same broker
    
