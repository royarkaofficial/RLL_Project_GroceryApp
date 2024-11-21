using Microsoft.AspNetCore.Authentication;
using System.Security.Claims;

namespace GroceryAppAPI.Helpers
{
    public class TestAuthenticationOptions : AuthenticationSchemeOptions
    {
        public virtual ClaimsIdentity Identity { get; } = new ClaimsIdentity(new Claim[]
        {
            new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier", Guid.NewGuid().ToString())
        }, "test");
    }
}
