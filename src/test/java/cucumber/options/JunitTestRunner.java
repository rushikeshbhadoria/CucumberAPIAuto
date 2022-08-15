package cucumber.options;

import org.junit.runner.RunWith;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;

import org.junit.runner.RunWith;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
@RunWith(Cucumber.class)
@CucumberOptions(features="src/test/java/features/USDTINR.feature",plugin ="json:target/jsonReports/cucumber-report.json"    ,glue= {"stepDefinations"})
public class JunitTestRunner {
	//,tags= ("@GetBalanceforDifferentBroker12") 
	//ETHfeature
	//demoFeature/demo.feature
	///CSXautomation2Optimision/src/test/java/demoFeature/example.feature
	
}
