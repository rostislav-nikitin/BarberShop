namespace Barbershop.DAC
{
    using System.Data;
    using System.Data.SqlClient;

    using NReco.Data;

    public class DataAccess : IDataAccess
    {
        private const string ConnectionString = @"Data Source=(local)\SQLEXPRESS;Initial Catalog=Barbershop;Integrated Security=True";
        public RecordSet FindEmployee(string searchString)
        {
            DbFactory dbFactory = new DbFactory(SqlClientFactory.Instance);
            DbCommandBuilder builder = new DbCommandBuilder(dbFactory);

            using(SqlConnection connection = new SqlConnection(ConnectionString))
            {
                connection.Open();

                IDbCommand command = builder.GetSelectCommand
                (
                    new Query
                    (
                        new QTable("Person"),
                        QGroupNode.Or
                        (
                            new QConditionNode((QField)"FirstName", Conditions.Like, (QConst)$"{searchString}%"),
                            new QConditionNode((QField)"LastName", Conditions.Like, (QConst)$"{searchString}%")
                        )
                    )
                );

                DbDataAdapter adapter = new DbDataAdapter(connection, builder);

                return adapter.Select(command).ToRecordSet();
            }
        }


        /*using (SqlCommand command = connection.CreateCommand())
        {
        command.CommandText = string.Concat(
            "SELECT",
                    " [p].[PersonId], [p].[PersonTypeId], [pt].[Name] AS [PersonTypeName],",
                    " [p].[FirstName], [p].[LastName], [p].[PhoneNumber], [p].[Email]",
                " FROM [dbo].[Person] AS [p]",
                    " INNER JOIN [dbo].[PersonType] AS [ps] ON [ps].[PersonTypeId] = [p].[PersonTypeId]",
                " WHERE [p].[FirstName] LIKE '@SearchString%' OR [p].[LastName] LIKE '@SearchString%'");
        command.CommandType = CommandType.Text;
        command.Parameters.AddWithValue("@SearchString", searchString);

        SqlDataAdapter*/
    }
}