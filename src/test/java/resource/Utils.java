package resource;

import static io.restassured.RestAssured.given;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.util.Properties;

import io.restassured.RestAssured;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.filter.log.RequestLoggingFilter;
import io.restassured.filter.log.ResponseLoggingFilter;
import io.restassured.http.ContentType;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;

public class Utils {

	public static RequestSpecification req,req1;
	public RequestSpecification requestSpecificationOfBroker1(String broker) throws IOException
	{
		long currentTimestamp = System.currentTimeMillis() / 1000;
		String StringCurrentTimestamp = Long.toString(currentTimestamp);
		
		String publickey=getGlobalValue("CSX-ACCESS-KEY"+broker);
		
		
		
		
		
		
		
		String signature=getGlobalValue("CSX-SIGNATURE"+broker);
//		System.out.println(publickey);
//		System.out.println(signature);
		
			PrintStream log = new PrintStream(new FileOutputStream("logging.txt"));
			req = new RequestSpecBuilder()
					.setBaseUri(getGlobalValue("baseUrl"))
					.addHeader("Content-Type", "application/json")
					.addHeader("CSX-ACCESS-KEY", publickey)
					.addHeader("CSX-SIGNATURE",signature)
							
					.addHeader("csx-access-timestamp", StringCurrentTimestamp).addHeader("Accept", "application/json")
					.addFilter(RequestLoggingFilter.logRequestTo(log)).addFilter(ResponseLoggingFilter.logResponseTo(log))
					.build();
		 return req;
		
		
		
	}
	
	
	
	public static String getGlobalValue(String key) throws IOException
	{
		Properties prop =new Properties();
		FileInputStream fis =new FileInputStream("C:\\Users\\Dell\\eclipse_csk\\CSXautomation2Optimision\\src\\test\\java\\resource\\global.properties");
		prop.load(fis);
		return prop.getProperty(key);
	
		
		
	}
	
	
	public String getJsonPath(Response response,String key)
	{
		  String resp=response.asString();
		JsonPath   js = new JsonPath(resp);
		return js.get(key).toString();
	}
}
