using GroceryAppAPI.Helpers.Interfaces;
using GroceryAppAPI.Models.DbModels;
using GroceryAppAPI.Repository.Interfaces;
using GroceryAppAPI.Services;
using Moq;
using Newtonsoft.Json;

namespace GroceryAppAPITests.Mocks
{
    /// <summary>
    /// Mocks the repositories used by <see cref="UserService"/>.
    /// </summary>
    public static class UserMock
    {
        private static string BasePath = Environment.CurrentDirectory + "/TestData/";
        public static Mock<IUserRepository> UserRepositoryMock = new Mock<IUserRepository>();
        public static Mock<IAuthenticationHelper> AuthenticationHelperMock = new Mock<IAuthenticationHelper>();

        /// <summary>
        /// Sets the mocks.
        /// </summary>
        public static void SetMocks()
        {
            MockUserRepository();
            MockAuthenticationHelper();
        }

        /// <summary>
        /// Mocks the implementation of <see cref="IUserRepository"/>.
        /// </summary>
        private static void MockUserRepository()
        {
            UserRepositoryMock.Setup(repo => repo.Get(It.IsAny<int>())).Returns((int id) =>
            {
                var fileContent = File.ReadAllText(BasePath + "users.json");
                var users = JsonConvert.DeserializeObject<IEnumerable<User>>(fileContent);
                return users.FirstOrDefault(user => user.Id == id);
            });

            UserRepositoryMock.Setup(repo => repo.Get(It.IsAny<string>())).Returns((string email) =>
            {
                var fileContent = File.ReadAllText(BasePath + "users.json");
                var users = JsonConvert.DeserializeObject<IEnumerable<User>>(fileContent);
                return users.FirstOrDefault(user => user.Email == email);
            });

            UserRepositoryMock.Setup(repo => repo.Update(It.IsAny<string>(), It.IsAny<User>()));
        }

        private static void MockAuthenticationHelper()
        {
            AuthenticationHelperMock.Setup(helper => helper.ClaimUser(It.IsAny<string>())).Returns(true);
        }
    }
}
