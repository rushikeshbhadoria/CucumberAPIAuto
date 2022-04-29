package resource;

public enum APIResources {
	
	PlaceOrder("/api/v1/orders/"),
	GetOrder("/api/v1/orders/"),
	AddIP("/api/v1/me/ip/"),
	DeleteIP("/api/v1/me/ip/"),
	Getbalance("/api/v1/me/balance/"),
	GetAllOrders("/api/v1/me/orders/?onlyOpen=false&type=limit&count=2&page=1"),
	GetRecentTrades("/api/v1/public/trades/?instrument=BTC/INR&page=1&count=1"),
	GetMarketDepth("/api/v1/public/depth/?instrument=BTC/INR&page=1&count=100"),
	HealthCheckReady("/api/v1/public/health/ready"),
	CancelAllOrders("/api/v1/me/orders/");
	private String resource;
	
	APIResources(String resource)
	{
		this.resource=resource;
	}
	
	public String getResource()
	{
		return resource;
	}
	

}
