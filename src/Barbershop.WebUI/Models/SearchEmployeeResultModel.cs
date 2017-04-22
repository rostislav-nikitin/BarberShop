using System.Collections.Generic;
using Barbershop.Mapping;

namespace Barbershop.WebUI.Models
{
    public class SearchEmployeeResultModel
    {
        public IEnumerable<Employee> Employees { get; internal set; }
    }
}