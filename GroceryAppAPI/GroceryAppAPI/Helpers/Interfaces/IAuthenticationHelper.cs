using GroceryAppAPI.Models.DbModels;

namespace GroceryAppAPI.Helpers.Interfaces
{
    public interface IAuthenticationHelper
    {
        public string GenerateAccessToken(User user);

        public bool ClaimUser(string email);
    }
}
