using GroceryAppAPI.Enumerations;

namespace GroceryAppAPI.Models.Response
{
    public class PaymentResponse
    {
        public int Amount { get; set; }
        public PaymentType PaymentType { get; set; }
    }
}
