package resource;

public enum APIResources {
	
	PlaceOrder("/api/v1/orders/"),
	GetOrder("/api/v1/orders/"),
	AddIP("/api/v1/me/ip/"),
	DeleteIP("/api/v1/me/ip/"),
	Getbalance("/api/v1/me/balance/"),
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
