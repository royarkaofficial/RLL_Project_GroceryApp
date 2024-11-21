using GroceryAppAPI.Models.DbModels;
using GroceryAppAPI.Models.Request;

namespace GroceryAppAPI.Repository.Interfaces
{
    public interface IProductRepository
    {
        public IEnumerable<Product> GetAll(string conditions, object parameters);
        public Product Get(int id);
        public int Add(Product product);
        public void Update(string conditions, Product product);
        public void Delete(int id);
        public void UpdateStatusAsRemoved(int id);
    }
}
