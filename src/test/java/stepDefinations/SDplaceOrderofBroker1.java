package stepDefinations;

import static io.restassured.RestAssured.given;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import static io.restassured.RestAssured.given;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONObject;

import java.util.*;
import static org.junit.Assert.*;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.builder.ResponseSpecBuilder;
import io.restassured.filter.log.RequestLoggingFilter;
import io.restassured.filter.log.ResponseLoggingFilter;
import io.restassured.http.ContentType;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import io.restassured.specification.ResponseSpecification;
import resource.Utils;
import resource.APIResources;

public class SDplaceOrderofBroker1 extends Utils {

	RequestSpecification res, res1, res2, res3, res4, res5;
	ResponseSpecification resspec;
	Response response;
	// TestDataBuild data =new TestDataBuild();
	String placeOrderBody;
	String broker1;
	static String order_id;
	String ENUM;
	JSONObject post = new JSONObject();
	// JSONObject postb2 = new JSONObject();

//	public SDplaceOrderofBroker1() throws IOException {
//		//res1 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker1());
//		//res5 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker2());
//	}

	@Given("Placing an order for broker {string} of type {string} side {string} instrument {string} quantityType {string} quantity {string} limitPrice {string} username {string}")
	public void placing_an_order_of_type_side_instrument_quantity_type_quantity_limit_price_username(String broker,
			String orderType, String orderSide, String instruments, String quantityType, String quantity,
			String limitPrice, String username) throws IOException {
		broker1 = broker;

		placeOrderBody = "{\r\n" + "    \"type\": \"" + orderType + "\",\r\n" + "    \"side\": \"" + orderSide
				+ "\",\r\n" + "    \"instrument\": \"" + instruments + "\",\r\n" + "    \"quantityType\": \""
				+ quantityType + "\",\r\n" + "    \"quantity\": " + quantity + ",\r\n" + "  \"limitPrice\": "
				+ limitPrice + ",    \r\n" + "  \"username\": \"" + username + "\"\r\n" + "}";

		res2 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker1(broker)).body(placeOrderBody);
		res1 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker1(broker));
		// resspec = new
		// ResponseSpecBuilder().expectContentType(ContentType.JSON).build();
		resspec = new ResponseSpecBuilder().build();

	}

	@Given("loading the header for broker {string}")
	public void loading_the_header_for_broker_something(String broker) throws Throwable {
		res1 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker1(broker));
		// resspec = new
		// ResponseSpecBuilder().expectContentType(ContentType.JSON).build();
		resspec = new ResponseSpecBuilder().build();
	}

	@When("Providing request PathUrl {string} with method {string}")
	public void providing_request_path_url_with_method(String resource, String method) throws IOException {
		APIResources resourceAPI = APIResources.valueOf(resource);
		ENUM = resourceAPI.getResource();
		String Enum = ENUM;
		// System.out.println(resourceAPI.getResource());

//		String body="{\r\n" + "    \"URL\": \"" + Enum + "\",\r\n" + "    \"Method\": \"" + method
//				+ "\",\r\n" + "    \"Body\": \"" + placeOrderBody + "\",\r\n" + "    \"SecretKey\": \""
//				+ getGlobalValue("CSX-SIGNATURE"+broker1) + "\",\r\n" + "   }";
//	
//		System.out.println(body);
//		given()
//		.body(body)
//		.header("Content-Type","application/json")
//		.when()
//		.post("http://localhost:6969/generateSignature").		
//		then()
//		.log()
//		.all().statusCode(200);

		if (method.equalsIgnoreCase("POST")) {
			response = res2.when().post(resourceAPI.getResource());
		}

		else if (method.equalsIgnoreCase("GET"))
			response = res1.when().get(resourceAPI.getResource());
		else if (method.equalsIgnoreCase("PATCH"))
			response = res3.when().patch(ENUM + order_id);
		else if (resource.equalsIgnoreCase("CancelAllOrders"))
			response = res1.when().delete(ENUM);
		else if (method.equalsIgnoreCase("DELETE")) {
			response = res1.when().delete(ENUM + order_id);
		}

		System.out.println(response.asString());

	}

	@Then("I verify the  {string} in step")
	public void i_verify_the_in_step(String string) throws InterruptedException {
		int statuscode = response.getStatusCode();
		String code = Integer.toString(statuscode);
		assertEquals(code, string);
		// System.out.println(response.asString());

	}

	@Then("Verify key {string} of response {string}")
	public void verify_key_of_response(String string, String string2) throws InterruptedException {
		JsonPath js = response.jsonPath();
		String side = js.get(string).toString();
		assertEquals(side, string2);

	}

	@Then("Verify the {string} of response {string}")
	public void verify_the_of_response(String orderID, String pathOfAPI) throws IOException {

		order_id = getJsonPath(response, orderID);
		// System.out.println(order_id);
		APIResources resourceAPI = APIResources.valueOf(pathOfAPI);
		ENUM = resourceAPI.getResource();
		// System.out.println(resourceAPI.getResource());
		response = res1.when().get(ENUM + order_id);
		String actualName = getJsonPath(response, "data.orderID");
		assertEquals(actualName, order_id);
		System.out.println(response.asString());
	}

	@Given("Update an order for broker {string} of  instrument {string} quantityType {string} quantity {string} limitPrice {string} username {string} orderType {string}")
	public void update_an_order_of_instrument_quantity_type_quantity_limit_price_username(String broker,
			String instruments, String quantityType, String quantity, String limit_Price, String username,
			String orderType) throws IOException {
		String updateOrder = "{\r\n" + "    \"type\": \"" + orderType + "\",\r\n" + "    \"instrument\": \""
				+ instruments + "\",\r\n" + "    \"quantityType\": \"" + quantityType + "\",\r\n" + "    \"quantity\": "
				+ quantity + ",\r\n" + "  \"limit_Price\": " + limit_Price + ",    \r\n" + "  \"username\": \""
				+ username + "\"\r\n" + "}";
		res3 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker1(broker)).body(updateOrder);

	}

	@Given("Add IP for a broker {string}")
	public void add_ip_for_a_broker(String broker) throws IOException {
		java.util.Scanner s = new java.util.Scanner(new java.net.URL("https://api.ipify.org").openStream(), "UTF-8")
				.useDelimiter("\\A");
		res2 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker1(broker))
				.body("{\r\n" + "    \"Address\": \"" + s.next() + "\"}");
		res1 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker1(broker));

	}

	// method for extracting the data
	@Then("Extracting the data {string}")
	public void Extracting_the_data(String string) {
		JsonPath js = response.jsonPath();
		order_id = js.get(string).toString();

	}

	@Given("take balance of {string} with api {string} with name {string}")
	public void take_balance_of_with_api_with_name(String asset, String api, String name) throws IOException {
		APIResources resourceAPI = APIResources.valueOf(api);
		ENUM = resourceAPI.getResource();
		// System.out.println(resourceAPI.getResource());
		// providing_request_path_url_with_method(api, "GET");
		response = res1.when().get(ENUM + "?asset=" + asset);
		String actualName = getJsonPath(response, "data.balance");
		double balance = Double.parseDouble(actualName);

		post.put(name, balance);
		System.out.println(name + " = " + post.get(name));
	}

	@Then("Check fees {string} for same broker")
	public void calculate_fees_for_same_broker(String expectedfee) {

		double s1b1inr = (double) post.get("s1b1inr");
		double s3b1inr = (double) post.get("s3b1inr");
		double FEE = s1b1inr - s3b1inr;
		double s1b1btc = (double) post.get("s1b1btc");
		double s3b1btc = (double) post.get("s3b1btc");
		if (s1b1btc - s3b1btc == 0) {
			System.out.println("BTC is Same");
		} else {
			System.out.println("difference between BTC is found");
		}

		String stringFee = String.valueOf(FEE);
		assertSame(stringFee, expectedfee);

	}

	@Then("give sleep of {string}")
	public void give_sleep_of_something(String time) throws Throwable {
		long longSleep = Long.parseLong(time);
		Thread.sleep(longSleep);
	}

	@Then("Check fees {string} for diffrent broker")
	public void calculate_fees_for_diffrent_broker(String expectedfee) {
		System.out.println("-------------------------------------------------------------------------------------");
		// Deduction_of_INR_from_broker1
		double s1b1inr = (double) post.get("s1b1inr");
		double s3b1inr = (double) post.get("s3b1inr");
		double Deduction_of_INR_from_broker1 = s1b1inr - s3b1inr;
		System.out.println("Deduction_of_INR_from_broker1 = " + Deduction_of_INR_from_broker1);
		System.out.println("-------------------------------------------------------------------------------------");
		// Addition_of_INR_in_broker2
		double s3b2inr = (double) post.get("s3b2inr");
		double s1b2inr = (double) post.get("s1b2inr");
		double Addition_of_INR_in_broker2 = s3b2inr - s1b2inr;
		System.out.println("Addition_of_INR_in_broker2 = " + Addition_of_INR_in_broker2);
		System.out.println("-------------------------------------------------------------------------------------");
		// Addition_of_BTC_to_broker1
		double s3b1btc = (double) post.get("s3b1btc");
		double s1b1btc = (double) post.get("s1b1btc");
		double Addition_of_BTC_to_broker1 = s3b1btc - s1b1btc;
		System.out.println("Addition_of_BTC_to_broker1 = " + Addition_of_BTC_to_broker1);
		System.out.println("-------------------------------------------------------------------------------------");
		// Deduction_of_BTC_to_broker2
		double s1b2btc = (double) post.get("s1b2btc");
		double s3b2btc = (double) post.get("s3b2btc");
		double Deduction_of_BTC_to_broker2 = s1b2btc - s3b2btc;
		System.out.println("Deduction_of_BTC_to_broker2 = " + Deduction_of_BTC_to_broker2);
		System.out.println("-------------------------------------------------------------------------------------");
		// CSX FEE
		double Fee_for_diffrent_broker = Deduction_of_INR_from_broker1 - Addition_of_INR_in_broker2;
		System.out.println("Fee_for_diffrent_broker = " + Fee_for_diffrent_broker);
		System.out.println("-------------------------------------------------------------------------------------");
		String stringFee = String.valueOf(Fee_for_diffrent_broker);
		assertEquals(stringFee, expectedfee);
		String addBtcOfBroker1 = String.valueOf(Addition_of_BTC_to_broker1);
		String deductionBtcOfBroker2 = String.valueOf(Deduction_of_BTC_to_broker2);
		assertEquals(addBtcOfBroker1, deductionBtcOfBroker2);
	}

}
