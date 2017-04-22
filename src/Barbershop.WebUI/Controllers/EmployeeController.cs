namespace Barbershop.WebUI.Controllers
{
    using Barbershop.Mapping;
    using Barbershop.WebUI.Models;
    using Microsoft.AspNetCore.Mvc;

    public class EmployeeController : Controller
    {
        public EmployeeController()
        {

        }
        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public IActionResult SearchEmployee(SearchEmployeeModel model)
        {
            SearchEmployeeResultModel result = new SearchEmployeeResultModel
            {
                Employees = Employee.Find(model.SearchString)
            };
            
            return View(result);
        }
    }
}