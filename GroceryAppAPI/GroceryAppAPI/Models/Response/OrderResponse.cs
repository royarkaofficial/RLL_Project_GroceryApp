namespace GroceryAppAPI.Models.Response
{
    // Represents the order response.
    public class OrderResponse
    {
        public int Id { get; set; }
        public IEnumerable<int>? ProductIds { get; set; }

        public DateTime OrderedAt { get; set; }

        public PaymentResponse Payment { get; set; }
    }
}
