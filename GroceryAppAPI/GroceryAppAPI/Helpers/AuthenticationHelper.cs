using GroceryAppAPI.Enumerations;
using GroceryAppAPI.Exceptions;
using GroceryAppAPI.Helpers.Interfaces;
using GroceryAppAPI.Models.DbModels;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace GroceryAppAPI.Helpers
{
    public class AuthenticationHelper : IAuthenticationHelper
    {
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _contextAccessor;

        public AuthenticationHelper(IConfiguration configuration, IHttpContextAccessor contextAccessor)
        {
            _configuration = configuration;
            _contextAccessor = contextAccessor;
        }

        public string GenerateAccessToken(User user)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["AppSettings:Authentication:Key"]));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);
            var userRole = (Role)user.Role;

            // Define claims for the token
            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, $"{user.FirstName} {user.LastName}"),
                new Claim(ClaimTypes.Role, userRole.ToString()),
                new Claim(ClaimTypes.Email, user.Email)
            };

            // Create and configure the JWT token
            var token = new JwtSecurityToken(_configuration["AppSettings:Authentication:Issuer"],
                _configuration["AppSettings:Authentication:Audience"],
                claims,
                expires: DateTime.Now.AddHours(1),
                signingCredentials: credentials);

            // Write and return the token as a string
            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        public bool ClaimUser(string email)
        {
            // Retrieve the claims associated with the current user identity.
            var identity = _contextAccessor.HttpContext.User.Claims;

            // Find the claim with the specified email.
            var identityClaim = identity.FirstOrDefault(id => id.Type == ClaimTypes.Email && id.Value == email);

            // If the claim is not found, throw an exception indicating denial of access.
            if (identityClaim is null)
            {
                throw new InvalidRequestException("User is denied access to the specified resource.");
            }

            // User successfully claimed.
            return true;
        }
    }
}
