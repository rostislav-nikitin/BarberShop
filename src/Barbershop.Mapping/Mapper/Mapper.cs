namespace Barbershop.Mapper
{
    using System.Collections.Generic;
    using System.Reflection;

    using NReco.Data;

    public class Mapper
    {
        public IEnumerable<T> Map<T>(RecordSet recordset)
            where T:new()
        {
            IList<T> result = new List<T>();
            foreach (RecordSet.Row row in recordset)
            {
                T resultItem = CreateEntity<T>(recordset.Columns, row);

                result.Add(resultItem);
            }

            return result;
        }

        private T CreateEntity<T>(RecordSet.ColumnCollection columnsCollection, RecordSet.Row row)
            where T : new()
        {
            T result = new T();

            foreach (PropertyInfo propertyInfo in
                typeof(T).GetProperties(BindingFlags.Instance | BindingFlags.SetProperty | BindingFlags.Public))
            {
                if (columnsCollection.Contains(propertyInfo.Name))
                {
                    propertyInfo.SetValue(result, row[propertyInfo.Name]);
                }
            }

            return result;
        }
    }
}