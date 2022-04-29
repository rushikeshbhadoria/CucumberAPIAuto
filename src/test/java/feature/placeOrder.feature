Feature: CSX Regression

 
  @PlaceGetDeleteOrder @Regression
  Scenario Outline: Verify place order , get order  and cancel order api
    Given Placing an order of type "<type>" side "<side>" instrument "<instrument>" quantityType "<quantityType>" quantity "<quantity>" limitPrice "<limitPrice>" username "<username>"
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
      | limit | BUY  | btc/inr    | quote        |    10000 |        102 | user1    |

  @UpdateOrder @Regression
  Scenario: Verify Update Order api
    Given Placing an order of type "limit" side "BUY" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "102" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Given Update an order of  instrument "btc/inr" quantityType "quote" quantity "103.5" limitPrice "103" username "user1" orderType "LIMIT"
    When Providing request PathUrl "PlaceOrder" with method "PATCH"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order updated successfully"
    #cancel all order from broker 1
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"

  @Add_Delete_IP @Regression
  Scenario: Verify Add IP and delete IP
    Given Add IP for a broker
    When Providing request PathUrl "AddIP" with method "POST"
    Then I verify the  "200" in step
    Then Extracting the data "data"
    When Providing request PathUrl "AddIP" with method "DELETE"
    Then I verify the  "200" in step
    And Verify key "message" of response "IP removed successfully"

  @CancelAllOrder @Regression
  Scenario: Verify CancelAllOrder
    #cancel all order from broker 1
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then I verify the  "200" in step
    And Verify key "message" of response "Orders cancellation in progress"
    #cancel all order from broker 2
    When For_Broker2_Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Then I verify the  "200" in step
    And Verify key "message" of response "Orders cancellation in progress"

  @GetAllOrder @Regression
  Scenario: Verify GetAllOrder
    When Providing request PathUrl "GetAllOrders" with method "GET"
    Then I verify the  "200" in step
    And Verify key "message" of response "Orders fetched successfully"

  @GetAllOrder @Regression
  Scenario: Verify GetAllOrder
    When Providing request PathUrl "GetAllOrders" with method "GET"
    Then I verify the  "200" in step
    And Verify key "message" of response "Orders fetched successfully"

  @GetAllIps @Regression
  Scenario: Verify GetAllIps
    When Providing request PathUrl "AddIP" with method "GET"
    Then I verify the  "200" in step
    And Verify key "message" of response "Listed IPs for the Broker"
