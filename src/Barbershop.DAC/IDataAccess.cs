namespace Barbershop.DAC
{
    using NReco.Data;
    public interface IDataAccess
    {
        RecordSet FindEmployee(string searchString);
    }
}
