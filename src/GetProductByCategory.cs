using System.Net;
using System.Text.Json;
using Ecommerce.Products;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace MyEcommerce.Products
{
    public class GetProductByCategory
    {
        private readonly ILogger _logger;

        public GetProductByCategory(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<GetProductByCategory>();
        }

        [Function("Products/GetProductByCategory")]
        public HttpResponseData Run([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req, 
        
        [CosmosDBInput(databaseName: "%DatabaseName%",
                        containerName: "%ContainerName%",
                        Connection = "CosmosDBConnectionString",
                        SqlQuery = "SELECT * FROM c where c.Category = {category} and c.Deleted = false",
                        PartitionKey ="{paritionKey}")] List<ProductDTO> products
        )
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "text/plain; charset=utf-8");

            var jsonString = JsonSerializer.Serialize(products);

            response.WriteString(jsonString);

            return response;
        }
    }
}
