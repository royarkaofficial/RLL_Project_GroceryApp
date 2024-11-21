using GroceryAppAPI.Enumerations;
using GroceryAppAPI.Exceptions;
using GroceryAppAPI.Helpers;
using GroceryAppAPI.Helpers.Interfaces;
using GroceryAppAPI.Models.DbModels;
using GroceryAppAPI.Models.Request;
using GroceryAppAPI.Models.Response;
using GroceryAppAPI.Repository.Interfaces;
using GroceryAppAPI.Services.Interfaces;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace GroceryAppAPI.Services
{
    // Service for handling user authentication
    public class AuthenticationService : IAuthenticationService
    {
        private readonly IUserRepository _userRepository;
        private readonly IAuthenticationHelper _jwtTokenHelper;

        // Constructor with dependency injection for IUserRepository and IConfiguration
        public AuthenticationService(IUserRepository userRepository, IAuthenticationHelper jwtTokenHelper)
        {
            _userRepository = userRepository;
            _jwtTokenHelper = jwtTokenHelper;
        }

        // Method for user login
        public LoginResponse Login(LoginRequest loginRequest)
        {
            // Validate login request
            if (string.IsNullOrWhiteSpace(loginRequest.Email)) { throw new InvalidRequestDataException("Username is either not given or invalid."); }
            if (string.IsNullOrWhiteSpace(loginRequest.Password)) { throw new InvalidRequestDataException("Password is either not given or invalid."); }

            // Retrieve user by email
            var user = _userRepository.Get(loginRequest.Email);
            if (user is null) { throw new EntityNotFoundException("User with the given username not found."); }

            // Validate password
            var actualHash = user.Password;
            var expectedHash = EncodingHelper.HashPassword(loginRequest.Password);
            if (actualHash != expectedHash) { throw new InvalidRequestException("Password is incorrect."); }

            // Generate and return access token
            var accessToken = _jwtTokenHelper.GenerateAccessToken(user);
            return new LoginResponse()
            {
                UserId = user.Id,
                AccessToken = accessToken,
                Role = (Role)user.Role
            };
        }
    }
}
