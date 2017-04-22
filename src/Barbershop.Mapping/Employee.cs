namespace Barbershop.Mapping
{
    using System.Collections.Generic;

    public class Employee
    {
        public int PersonId { get; set; }
        public int PersonTypeId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PhoneNumber { get; set; }
	    public string Email { get; set; }

        public static IEnumerable<Employee> Find(string searchString)
        {
            //IDataAccess dataAccess = new DataAccess();

            Mapper.Mapper mapper = new Mapper.Mapper();

            //IEnumerable<Employee> result = mapper.Map<Employee>(dataAccess.FindEmployee(searchString));
            IEnumerable<Employee> result = mapper.Map<Employee>(DACCache.SearchCache.Instance.FindEmployee(searchString));

            return result;
        }

    }
}
